Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12161 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab0HaQ7j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 12:59:39 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 31 Aug 2010 09:59:34 -0700
Date: Tue, 31 Aug 2010 09:59:31 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Matt Smith <Matt.Smith@Atheros.com>,
	Kevin Hayes <kevin@Atheros.com>,
	David Quan <David.Quan@atheros.com>
Subject: Re: [RFC 0/3] mac80211: new API for handling broadcast / multicast
 on sw scan
Message-ID: <20100831165931.GC15752@tux>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
 <1283177949.3691.72.camel@jlt3.sipsolutions.net>
 <AANLkTinOzTHn4okTdm=321sdAKy8z1ji_1K_SsDd_dH2@mail.gmail.com>
 <1283183279.3691.82.camel@jlt3.sipsolutions.net>
 <AANLkTi=bVRaDs6z6EavxCLFdMeNRhB=85yKtaHr-_hL-@mail.gmail.com>
 <1283191837.3694.13.camel@jlt3.sipsolutions.net>
 <AANLkTin9KBUTZSkiL-qMnToaMjXS9S3j3PzV-AZWa_9U@mail.gmail.com>
 <1283265399.3733.18.camel@jlt3.sipsolutions.net>
 <AANLkTi=yRnMwTBq1ze8LaMCO521YutrtxJpBS0rGuvhJ@mail.gmail.com>
 <1283270092.3733.41.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1283270092.3733.41.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 31, 2010 at 08:54:52AM -0700, Johannes Berg wrote:
> On Tue, 2010-08-31 at 08:30 -0700, Luis R. Rodriguez wrote:
> 
> > > We're not even really going to sleep, when we scan. It would be
> > > interesting to try to be back on the channel in time, but I believe we
> > > can either make it easily, or for passive scanning basically always miss
> > > it if the DTIM period is 1.
> > 
> > What do you mean by always miss if the DTIM period is 1?
> 
> Well if the DTIM period is 1, and the beacon interval is, say, 100,

And this seems to be the standard configuration I find being used on APs.

> then there's no way you can do a passive scan without missing a DTIM beacon,
> I'd say.

Ah, yes, I see. Good point.

> > >> I haven't yet considered how we can guarantee we will be awake at the
> > >> right time though. If you think about it the driver wait constraint
> > >> callback I provide simply prevents us from scanning off channel when
> > >> our driver knows we should not soon. That soon is obviously relative
> > >> to where and how the ath9k wait flags are set.
> > >
> > > I still don't quite believe that. The wait flags seem to be mostly
> > > related to powersave,
> > 
> > This is true, but why would they not be important for going off
> > channel ? The TSF sync seems just as important as waiting for the ACK
> > for the nullfunc from the AP.
> 
> Why? It doesn't seem important to me?

How else could you possibly do a reliable calculation for the computation of the
next DTIM?

> > >> The TSF synch will help us more accurately set the other flags though,
> > >> if we ignore it by the time we come back to our home channel we likely
> > >> would be out of synch with the AP's beacons. It makes sense to me to
> > >> wait to be in synch with the AP's beacons before going off channel,
> > >> otherwise our other wait constraints would be off. Let alone
> > >> calculating the time we do need to be awake for.
> > >
> > > I don't think I can parse this. But does it matter? If we're going to
> > > wait for a DTIM beacon in mac80211, we should have TSF sync anyway. And
> > > after you go back to the operating channel, it seems likely that you'd
> > > want to re-sync anyway.
> > 
> > I don't understand, you first say it doesn't matter and then you end
> > up suggesting to actually do a TSF sync prior to going off channel and
> > then when coming back. It seems to me you do get it.
> 
> No, I don't understand the need for a TSF sync.

        /*
         * Pull nexttbtt forward to reflect the current
         * TSF and calculate dtim+cfp state for the result.
         */
        tsf = ath9k_hw_gettsf64(ah);
        tsftu = TSF_TO_TU(tsf>>32, tsf) + FUDGE;

        num_beacons = tsftu / intval + 1;
        offset = tsftu % intval;
        nexttbtt = tsftu - offset;
        if (offset)
                nexttbtt += intval;

        /* DTIM Beacon every dtimperiod Beacon */
        dtim_dec_count = num_beacons % dtimperiod;
        /* CFP every cfpperiod DTIM Beacon */
        cfp_dec_count = (num_beacons / dtimperiod) % cfpperiod;
        if (dtim_dec_count)
                cfp_dec_count++;

        dtimcount -= dtim_dec_count;
        if (dtimcount < 0)
                dtimcount += dtimperiod;

        cfpcount -= cfp_dec_count;
        if (cfpcount < 0)
                cfpcount += cfpperiod;

        bs.bs_intval = intval;
        bs.bs_nexttbtt = nexttbtt;
        bs.bs_dtimperiod = dtimperiod*intval;
        bs.bs_nextdtim = bs.bs_nexttbtt + dtimcount*intval;
        bs.bs_cfpperiod = cfpperiod*bs.bs_dtimperiod;
        bs.bs_cfpnext = bs.bs_nextdtim + cfpcount*bs.bs_dtimperiod;
        bs.bs_cfpmaxduration = 0;

We then set the beacon miss stuff:

        /*
         * Calculate the number of consecutive beacons to miss* before taking
         * a BMISS interrupt. The configuration is specified in TU so we only
         * need calculate based on the beacon interval.  Note that we clamp the
         * result to at most 15 beacons.
         */
        if (sleepduration > intval) {
                bs.bs_bmissthreshold = conf->listen_interval *
                        ATH_DEFAULT_BMISS_LIMIT / 2;
        } else {
                bs.bs_bmissthreshold = DIV_ROUND_UP(conf->bmiss_timeout, intval);
                if (bs.bs_bmissthreshold > 15)
                        bs.bs_bmissthreshold = 15;
                else if (bs.bs_bmissthreshold <= 0)
                        bs.bs_bmissthreshold = 1;
        }

For more details see ath_beacon_config_sta().

So we do the TSF synch to more reliably know when we will get a DTIM and also
adjust our beacon miss interrupt. For offchannel operation know the DTIM
more accurately will help in our computation when going off channel.

> And the time we need to
> be awake for doesn't seem like it's determined by the wait constraints
> or the beacon ... you're not going to get it perfect anyway.

Correct, only that waiting for proper DTIM calculation is important though,
and there are wait constraints that relate to ensuring we update the DTIM
calculation more accurately.

The ath9k wait constraint are checked for prior go going to power save and since
we use power save for offchannel operation we should also avoid going to power
save for the same wait constraints. That was the logic I followed. Granted I
do believe more of this should go into mac80211 but until then these wait
constraints are the only thing I have to resolve these issues.

> > >> It is a good question, can we be relying on on ACK from the AP other
> > >> than PS-poll data after coming out of sleep? I am not sure.
> > >
> > > ?
> > > The AP will ACK the nullfunc frame when you wake up, that should be
> > > sufficient to know that the AP knows you've woken up. Or returned to the
> > > operating channel, in the context of this discussion.
> > 
> > Yes, but my point was that right now we don't check for this in
> > mac80211 but that code does exist in ath9k to wait for an ACK from the
> > AP. I was explaining when I see PS_WAIT_FOR_TX_ACK used, I noted that
> > ath9k has code that checks for an ACK from the AP prior to letting us
> > go to sleep, we force this upon ourselves when first frame we send out
> > to the AP is not a PS-POLL. I was wondering when this could possibly
> > happen.
> 
> Oh, dunno.

I'll check.. Wonder if this is just leftoever cruft code.

> > > Like for example just implementing waiting for
> > > DTIM (traffic), that should be simple -- at the beginning of scan you
> > > just wake up the HW, wait for a (any) beacon, calculate if you can fit
> > > off-channel time before DTIM, and either wait for DTIM beacon+traffic or
> > > squeeze off-channel time before it... Seems simple enough?
> > 
> > And I'm saying its not. To wait for the DTIM you need to know the DTIM
> > count, and you could also miss a few DTIM beacons. 
> 
> What do you mean by "need to know the DTIM count"? You just need to look
> at every received beacon.

The DTIM count on the TIM information element tells stations how many beacons
must be transmitted before receiving the next DTIM. The DTIM count will be 0
when we've reached a DTIM.

http://wireless.kernel.org/en/developers/Documentation/ieee80211/power-savings

If you do not know the DTIM count at which beacon will we get the DTIM?

> > Then you also need
> > to keep track of the mcast / bcast data after the DTIM beacon. I noted
> > how ath9k already does all this and we use flags to annotate these
> > things to help avoid putting our chip to sleep. My patches make use of
> > these flags from ath9k to prevent us from going offchannel, and what
> > I'd like to do is to start offloading some of these flags one by one
> > to mac80211 to make them generic for all mac80211 drivers that use sw
> > scan.
> 
> Right right, I understand, but I guess I believe that the problem isn't
> hard enough or pressing enough to warrant the additional churn needed,

It is a subjective matter, I agree, it depends how reliable you want
to claim mac80211 is for broadcast and multicast traffic when drivers
use sw scan. One key item that is more important though is if we are
only trying to be on our home channel when doing offchannel operation
for bg scanning then we must also send a PS-POLL to get our own buffered
unicast frames after DTIM. I am not sure if we take care of this right
now and the wait constraints in ath9k might actually be helping with
this.

> since it's not just as you did it now, but it really needs to be
> asynchronous with event callbacks,

In case of firmware timeouts? Or what?

> and error handling is also more
> complex in the mac80211/driver interaction case (what if the driver
> never returns the event in the timeout? then mac80211 asks for the next
> channel, but the driver _then_ returns the event? etc.)

So I am not sure what you are referring to here. Are you referring to
timeouts for calls we make on the driver for wait constraints or
are you referring to possible endless wait constraints?

If the first, then I do not follow.

If the later, then I think it shouldn't happen often enough *if* we
actually end up dealing with most constraints properly in mac80211.

Or maybe I just completely misunderstood this last point.

Worst case scenerio we will just have to review this in more detail next week
in person on Thursday or Friday during the wireless summit.

  Luis
