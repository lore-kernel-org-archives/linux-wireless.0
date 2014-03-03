Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:46084 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaCCN0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 08:26:43 -0500
Received: by mail-ea0-f170.google.com with SMTP id g15so4467000eak.15
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2014 05:26:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393850234.13669.98.camel@dubbel>
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
Date: Mon, 3 Mar 2014 14:26:42 +0100
Message-ID: <CA+BoTQ=QOexS1YyGOP9_Pt+EawArBPrBCncw2PZEL8B=t7PkQA@mail.gmail.com> (sfid-20140303_142701_084225_8DF6515F)
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

On 3 March 2014 13:37, Luca Coelho <luca@coelho.fi> wrote:
> On Mon, 2014-03-03 at 11:38 +0100, Michal Kazior wrote:
>> On 3 March 2014 10:57, Luca Coelho <luca@coelho.fi> wrote:
>> > Using the reservation:
>> >
>> > 1. unassign the vif from the old chanctx (old.refcount == 1,
>> > new.refcount == 1);
>> > 2. we decrease the refcount of the new chanctx (new.refcount == 0,
>> > old.refcount == 0);
>> > 3. if (old.refcount == 0) means we were the only user, change channel;
>> > 4. we assign ourselves to the new chanctx (new.refcount == 1 again);
>>
>> I didn't really consider unassigning vif from chanctx like that (since
>> the original single-channel channel non-chanctx hw doesn't do that).
>> If you assume it is safe to unassign the vif then the logic seems
>> plausible. I like it.
>
> I think in theory it should be okay.  I don't know if any driver does
> something funny with it, though.
>
> For drivers that don't implement the unassign_vif_chanctx op (like
> non-chanctx drivers), it should not be a problem.
>
> I think I could probably get rid of the
> IEEE80211_HW_CHANGE_RUNNING_CHANCTX flag I was going to introduce as
> well.

We could actually get rid of the CHANNEL_CHANGED for chanctx
altogether. All it takes is "wait until refcount drops to 0, free
chanctx, create new chanctx, start assigning vifs that had
chanctx_reserved set". This would probably be seamless for non-chanctx
drivers too.


>> > If more vifs came and are changing the chanctx at the same time, it will
>> > be fine too because the channel will only change when the last reserver
>> > uses the reservation.
>> >
>> > Does this make sense?
>>
>> Does the following match your idea of multi-vif reservation with the
>> refcount idea?
>>
>> [2 vifs on chanctx->refcount==2]
>> * vif1 reserve (refcount==3)
>> * vif2 reserve (refcount==4)
>> * vif1 use reservation: (refcount==3)
>>   * stop queues
>>   * unassign vif (refcount==2)
>>   * since refcount!=0 do nothing more
>> * vif3 use reservation: (refcount==1)
>>   * unassign vif (refcount==0)
>>   * since refcount==0 do:
>>     * chanctx channel change
>>     * vif1 assign (refcount==1)
>>     * vif2 assign (refcount==2)
>>     * wake queues
>
> Right, this is a good idea (better than what I wrote in my previous
> reply).  I just need to iterate all the vifs and assign the ones with
> matching reserved_chanctx (and no assigned chanctx) to this chanctx when
> refcount reaches 0.

Yes. In theory you can even handle cases where ctx->refcount is still
>0 if you have multi-channel hw. Consider the following:

hw: 2 channels max
ctx1 (chan 1): vif1
ctx2 (chan 2): vif2 vif3

* vif2 wants to switch to chan 3, but can't create new chanctx so use
current one for "in place" hoping vif3 will also switch soon enough
* vif1 decides it wants to follow vif2 to chan 3
* vif3 doesn't want to do anything
* vif1 and vif2 both call use_reserved (order doesn't matter if you
perform checks properly)
* ctx1 should be freed now since vif1 has been unassigned
* ctx2->refcount > 0, but num_chanctx < max_num_chanctx, so create new
ctx1 for chan3
* assign vif1 and vif2 to ctx1 on chan 3

(this would depend on my ieee80211_max_num_channels() patch)


>> Additionally you'd have to check after each "use reservation": if all
>> vifs with matching reserved_chanctx have no assigned chanctx but the
>> reserved_chanctx->refcount > 0, then disconnect all vifs with the
>> matching reserved_chanctx.
>
> I'm not sure I understood this part.  I think that when refcount reaches
> 0 I should disconnect the ones that are still using this chanctx, right?
> All the ones that wanted to switch together, will have already done so
> (since the refcount reached 0).  If there's any remaining vif in the
> chanctx we want to change, disconnect them.

There are two approaches here:
 a) first use_reservation implies actual channel change
 b) last use_reservation implies actual channel change

You probably keep model (a) in mind, while I use (b).

I prefer (b) for a couple of reasons:
 * it also allows to retain the current behavior easily: if you have
many vifs use a chanctx and some of them want to CSA, then disconnect
those who want CSA
 * it should be more resilient to timing because you wait on the
channel until last vif is "done"
 * you can re-create chanctx and remove chanctx "channel change"


Michał
