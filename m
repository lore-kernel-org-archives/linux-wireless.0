Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab0HaPy4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 11:54:56 -0400
Subject: Re: [RFC 0/3] mac80211: new API for handling broadcast / multicast
 on sw scan
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com, Matt Smith <Matt.Smith@atheros.com>,
	Kevin Hayes <kevin@atheros.com>
In-Reply-To: <AANLkTi=yRnMwTBq1ze8LaMCO521YutrtxJpBS0rGuvhJ@mail.gmail.com>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
	 <1283177949.3691.72.camel@jlt3.sipsolutions.net>
	 <AANLkTinOzTHn4okTdm=321sdAKy8z1ji_1K_SsDd_dH2@mail.gmail.com>
	 <1283183279.3691.82.camel@jlt3.sipsolutions.net>
	 <AANLkTi=bVRaDs6z6EavxCLFdMeNRhB=85yKtaHr-_hL-@mail.gmail.com>
	 <1283191837.3694.13.camel@jlt3.sipsolutions.net>
	 <AANLkTin9KBUTZSkiL-qMnToaMjXS9S3j3PzV-AZWa_9U@mail.gmail.com>
	 <1283265399.3733.18.camel@jlt3.sipsolutions.net>
	 <AANLkTi=yRnMwTBq1ze8LaMCO521YutrtxJpBS0rGuvhJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 17:54:52 +0200
Message-ID: <1283270092.3733.41.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-31 at 08:30 -0700, Luis R. Rodriguez wrote:

> > We're not even really going to sleep, when we scan. It would be
> > interesting to try to be back on the channel in time, but I believe we
> > can either make it easily, or for passive scanning basically always miss
> > it if the DTIM period is 1.
> 
> What do you mean by always miss if the DTIM period is 1?

Well if the DTIM period is 1, and the beacon interval is, say, 100, then
there's no way you can do a passive scan without missing a DTIM beacon,
I'd say.

> >> I haven't yet considered how we can guarantee we will be awake at the
> >> right time though. If you think about it the driver wait constraint
> >> callback I provide simply prevents us from scanning off channel when
> >> our driver knows we should not soon. That soon is obviously relative
> >> to where and how the ath9k wait flags are set.
> >
> > I still don't quite believe that. The wait flags seem to be mostly
> > related to powersave,
> 
> This is true, but why would they not be important for going off
> channel ? The TSF sync seems just as important as waiting for the ACK
> for the nullfunc from the AP.

Why? It doesn't seem important to me?

> >> The TSF synch will help us more accurately set the other flags though,
> >> if we ignore it by the time we come back to our home channel we likely
> >> would be out of synch with the AP's beacons. It makes sense to me to
> >> wait to be in synch with the AP's beacons before going off channel,
> >> otherwise our other wait constraints would be off. Let alone
> >> calculating the time we do need to be awake for.
> >
> > I don't think I can parse this. But does it matter? If we're going to
> > wait for a DTIM beacon in mac80211, we should have TSF sync anyway. And
> > after you go back to the operating channel, it seems likely that you'd
> > want to re-sync anyway.
> 
> I don't understand, you first say it doesn't matter and then you end
> up suggesting to actually do a TSF sync prior to going off channel and
> then when coming back. It seems to me you do get it.

No, I don't understand the need for a TSF sync. And the time we need to
be awake for doesn't seem like it's determined by the wait constraints
or the beacon ... you're not going to get it perfect anyway.

> >> It is a good question, can we be relying on on ACK from the AP other
> >> than PS-poll data after coming out of sleep? I am not sure.
> >
> > ?
> > The AP will ACK the nullfunc frame when you wake up, that should be
> > sufficient to know that the AP knows you've woken up. Or returned to the
> > operating channel, in the context of this discussion.
> 
> Yes, but my point was that right now we don't check for this in
> mac80211 but that code does exist in ath9k to wait for an ACK from the
> AP. I was explaining when I see PS_WAIT_FOR_TX_ACK used, I noted that
> ath9k has code that checks for an ACK from the AP prior to letting us
> go to sleep, we force this upon ourselves when first frame we send out
> to the AP is not a PS-POLL. I was wondering when this could possibly
> happen.

Oh, dunno.

> > Like for example just implementing waiting for
> > DTIM (traffic), that should be simple -- at the beginning of scan you
> > just wake up the HW, wait for a (any) beacon, calculate if you can fit
> > off-channel time before DTIM, and either wait for DTIM beacon+traffic or
> > squeeze off-channel time before it... Seems simple enough?
> 
> And I'm saying its not. To wait for the DTIM you need to know the DTIM
> count, and you could also miss a few DTIM beacons. 

What do you mean by "need to know the DTIM count"? You just need to look
at every received beacon.

> Then you also need
> to keep track of the mcast / bcast data after the DTIM beacon. I noted
> how ath9k already does all this and we use flags to annotate these
> things to help avoid putting our chip to sleep. My patches make use of
> these flags from ath9k to prevent us from going offchannel, and what
> I'd like to do is to start offloading some of these flags one by one
> to mac80211 to make them generic for all mac80211 drivers that use sw
> scan.

Right right, I understand, but I guess I believe that the problem isn't
hard enough or pressing enough to warrant the additional churn needed,
since it's not just as you did it now, but it really needs to be
asynchronous with event callbacks, and error handling is also more
complex in the mac80211/driver interaction case (what if the driver
never returns the event in the timeout? then mac80211 asks for the next
channel, but the driver _then_ returns the event? etc.)

johannes

