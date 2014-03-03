Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:55533 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbaCCN5I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 08:57:08 -0500
Received: by mail-ea0-f178.google.com with SMTP id a15so4453216eae.23
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2014 05:57:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393854126.13669.112.camel@dubbel>
References: <1393512081-31453-1-git-send-email-luca@coelho.fi>
	<1393512081-31453-4-git-send-email-luca@coelho.fi>
	<CA+BoTQ=yoYAcg8Jo2zoV76gmXe9UU1=wSi1CVWfwiRpqC7yr6w@mail.gmail.com>
	<1393589841.13669.32.camel@dubbel>
	<CA+BoTQmaF+johnB5ia+ez5dFKYPWWwk7E=482Q3hzLv=YvZAvQ@mail.gmail.com>
	<1393594886.13669.47.camel@dubbel>
	<CA+BoTQkafvtCDU5LkDcyVonO2T=koaBCWABzSQmnDOXJh=AvDA@mail.gmail.com>
	<1393597923.13669.65.camel@dubbel>
	<CA+BoTQk=YLd+bur3HkJ5jwrT-EYKMF8+nzJSX+bJP_psesuE5g@mail.gmail.com>
	<5cdea7fa-8919-48b0-898a-a03cbd26123d@email.android.com>
	<1393840630.13669.82.camel@dubbel>
	<CA+BoTQ=TL6my5F7RCME08ZgGw6dGGmyqmn4W-LB7WyVD7VPUOQ@mail.gmail.com>
	<1393850234.13669.98.camel@dubbel>
	<CA+BoTQ=QOexS1YyGOP9_Pt+EawArBPrBCncw2PZEL8B=t7PkQA@mail.gmail.com>
	<1393854126.13669.112.camel@dubbel>
Date: Mon, 3 Mar 2014 14:57:07 +0100
Message-ID: <CA+BoTQ=yDhfUH8k-MwJR3CSVr3KSBLXbNpCBtXSXRcu2ouRz_Q@mail.gmail.com> (sfid-20140303_145717_416596_EBF779B4)
Subject: Re: [RFC v2 3/4] mac80211: allow reservation of a running chanctx
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 March 2014 14:42, Luca Coelho <luca@coelho.fi> wrote:
> On Mon, 2014-03-03 at 14:26 +0100, Michal Kazior wrote:
>> On 3 March 2014 13:37, Luca Coelho <luca@coelho.fi> wrote:
>> > On Mon, 2014-03-03 at 11:38 +0100, Michal Kazior wrote:
>> >> On 3 March 2014 10:57, Luca Coelho <luca@coelho.fi> wrote:

[...]

>> >> > If more vifs came and are changing the chanctx at the same time, it will
>> >> > be fine too because the channel will only change when the last reserver
>> >> > uses the reservation.
>> >> >
>> >> > Does this make sense?
>> >>
>> >> Does the following match your idea of multi-vif reservation with the
>> >> refcount idea?
>> >>
>> >> [2 vifs on chanctx->refcount==2]
>> >> * vif1 reserve (refcount==3)
>> >> * vif2 reserve (refcount==4)
>> >> * vif1 use reservation: (refcount==3)
>> >>   * stop queues
>> >>   * unassign vif (refcount==2)
>> >>   * since refcount!=0 do nothing more
>> >> * vif3 use reservation: (refcount==1)
>> >>   * unassign vif (refcount==0)
>> >>   * since refcount==0 do:
>> >>     * chanctx channel change
>> >>     * vif1 assign (refcount==1)
>> >>     * vif2 assign (refcount==2)
>> >>     * wake queues
>> >
>> > Right, this is a good idea (better than what I wrote in my previous
>> > reply).  I just need to iterate all the vifs and assign the ones with
>> > matching reserved_chanctx (and no assigned chanctx) to this chanctx when
>> > refcount reaches 0.
>>
>> Yes. In theory you can even handle cases where ctx->refcount is still
>> >0 if you have multi-channel hw. Consider the following:
>>
>> hw: 2 channels max
>> ctx1 (chan 1): vif1
>> ctx2 (chan 2): vif2 vif3
>>
>> * vif2 wants to switch to chan 3, but can't create new chanctx so use
>> current one for "in place" hoping vif3 will also switch soon enough
>> * vif1 decides it wants to follow vif2 to chan 3
>> * vif3 doesn't want to do anything
>> * vif1 and vif2 both call use_reserved (order doesn't matter if you
>> perform checks properly)
>> * ctx1 should be freed now since vif1 has been unassigned
>> * ctx2->refcount > 0, but num_chanctx < max_num_chanctx, so create new
>> ctx1 for chan3
>> * assign vif1 and vif2 to ctx1 on chan 3
>>
>> (this would depend on my ieee80211_max_num_channels() patch)
>
> Sounds good! But where do the channel combinations come in here? I think
> instead of just checking for max_num_channels we should do a full
> combination check.

The channel counting uses combination checks. It simply iterates over
all *matching* ifcombs and picks the greatest max_num_channels. CSA
doesn't change iftype and regular ifcomb checks (with your patch) is
protected by chanctx_mtx, so it should be safe enough.


>> >> Additionally you'd have to check after each "use reservation": if all
>> >> vifs with matching reserved_chanctx have no assigned chanctx but the
>> >> reserved_chanctx->refcount > 0, then disconnect all vifs with the
>> >> matching reserved_chanctx.
>> >
>> > I'm not sure I understood this part.  I think that when refcount reaches
>> > 0 I should disconnect the ones that are still using this chanctx, right?
>> > All the ones that wanted to switch together, will have already done so
>> > (since the refcount reached 0).  If there's any remaining vif in the
>> > chanctx we want to change, disconnect them.
>>
>> There are two approaches here:
>>  a) first use_reservation implies actual channel change
>>  b) last use_reservation implies actual channel change
>>
>> You probably keep model (a) in mind, while I use (b).
>
> Actually I was thinking about (b) as well.
>
> My question here is how do we discern vifs that are still in the channel
> but didn't want to change (and thus we should disconnect)? We can't rely
> on refcount.

They simply will have a NULL reserved_chanctx.

The only thing missing (while including your patches) is a boolean
per-sdata that will indicate whether use_reserved() was already called
or not so you can check if all vifs with the same reserved_chanctx
have "synchronized" and if that chanctx is suitable to use (i.e.
refcount==0 when switching in-place, or it's possible to create a new
chanctx which wasn't possible when original reservation was done).


Michał
