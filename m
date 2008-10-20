Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:25919 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYJTJBx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 05:01:53 -0400
Received: by yx-out-2324.google.com with SMTP id 8so266052yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 02:01:52 -0700 (PDT)
Message-ID: <43e72e890810200201l49eea95h2f67615b536311aa@mail.gmail.com> (sfid-20081020_110202_752511_D9A3A5BA)
Date: Mon, 20 Oct 2008 02:01:52 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Re-enable aggregation
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
In-Reply-To: <1224493038.18024.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <43e72e890810200135o1581c904i456a35298f8a56a9@mail.gmail.com>
	 <1224492335.18024.34.camel@johannes.berg>
	 <18684.17816.702853.44986@gargle.gargle.HOWL>
	 <43e72e890810200155wbe01660xe3f53de80dc7357d@mail.gmail.com>
	 <1224493038.18024.36.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 1:57 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-10-20 at 01:55 -0700, Luis R. Rodriguez wrote:
>> On Mon, Oct 20, 2008 at 1:47 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
>> > Johannes Berg wrote:
>> >  > On Mon, 2008-10-20 at 01:35 -0700, Luis R. Rodriguez wrote:
>> >  >
>> >  > > >> + *   @is_part_ampdu: set to indicate that the wireless core should should
>> >  > > >> + *           treat this frame as part of an AMPDU
>> >  > > >
>> >  > > > I thought we said we could keep the flag instead of moving to the skb
>> >  > > > here?
>> >  > >
>> >  > > That was just because the changes required to add this was too much
>> >  > > for 2.6.27 but since we don't care about this fix in 2.6.27 we can do
>> >  > > whatever is needed to fix this properly.
>> >  >
>> >  > Right, but adding random stuff into skb isn't really "properly" imho.
>> >  > And we don't really need this afaict.
>> >  >
>> >
>> > Sorry, just saw that Tomas had fixed it by setting the flag in ieee80211_tx_h_sequence().
>> > Will fix that.
>>
>> No that was a hack too, this was to minimize code changes for 2.6.27 as well.
>
> Well the fact that it's in tx_h_sequence is a bit weird, but we should
> be able to get around not using an extra bit in skb I think. Especially
> for this since it's only really between the driver and mac80211, and
> after a requeue the ampdu status might actually change.

Good point. I failed to see that. So in that case it should be as
sujith had it before my suggestion and just handle it as he had it in
the tx handlers. The problem though is that the RC algorithm should be
the one to determine if an skb is part of an ampdu for aggregation or
not IMHO. Actually this is the real question and hot topic.

When should we aggregate and should mac80211 decide that or be left to the RC.

  Luis
