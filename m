Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6]:46919 "EHLO
        smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753532AbcLORy5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 12:54:57 -0500
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: "'Ben Greear'" <greearb@candelatech.com>,
        "'Jouni Malinen'" <j@w1.fi>
Cc: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
References: <004a01d24fe2$94da8dc0$be8fa940$@acksys.fr> <20161214195805.GA15022@w1.fi> <00f501d256e7$0f8d5380$2ea7fa80$@acksys.fr> <5852C5AC.6090408@candelatech.com>
In-Reply-To: <5852C5AC.6090408@candelatech.com>
Subject: RE: ath10k firmware sends probes on DFS channels without radar detection
Date: Thu, 15 Dec 2016 18:53:47 +0100
Message-ID: <00fd01d256fc$2f780db0$8e682910$@acksys.fr> (sfid-20161215_185501_608452_D99D2836)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Message d'origine-----
> De : Ben Greear [mailto:greearb@candelatech.com]
> Envoyé : jeudi 15 décembre 2016 17:33
> À : Jean-Pierre Tosoni; 'Jouni Malinen'
> Cc : linux-wireless@vger.kernel.org; ath10k@lists.infradead.org
> Objet : Re: ath10k firmware sends probes on DFS channels without radar
> detection
> 
> On 12/15/2016 07:22 AM, Jean-Pierre Tosoni wrote:
> > Jouni,
> >
> > Thanks for the suggestion, I already tried something like this in
> > wmi.c, with the same result:
> >
> > - Before patching the firmware scans DFS channels actively (with
> probes).
> >
> > - After patching, the firmware scans DFS channels passively *until*
> > any beacon is received on the DFS channel. When *any* beacon is seen,
> > the firmware decides to scan actively on its own, without any new
> > IR/RADAR info from the driver.
> >
> > So, your patch is required but not sufficient.
> >
> > Somehow I was able to overcome this by reloading the regulation domain
> > in the radio card before each scan request:
> >
> > ////// awful patch ahead ////////
> >
> > --- a/drivers/net/wireless/ath/ath10k/mac.c
> > +++ b/drivers/net/wireless/ath/ath10k/mac.c
> > @@ -2842,7 +2842,9 @@ static int ath10k_update_channel_list(st
> >   			ch->chan_radar =
> >   				!!(channel->flags & IEEE80211_CHAN_RADAR);
> >
> > -			passive = channel->flags & IEEE80211_CHAN_NO_IR;
> > +			passive = channel->flags & (IEEE80211_CHAN_NO_IR |
> > +						    IEEE80211_CHAN_RADAR);
> 
> So, should we add a new flag in firmware and driver that means 'really-no-
> IR', or should the NO_IR flag here just always make the firmware never do
> IR when probing regardless of whether it has seen beacons or not?

The distinction between NO_IR and CHAN_RADAR is not very clear to me.
NO_IR appears only in the world regulatory domain so it's not relevant here.

I'd say
 "the CHAN_RADAR flag should always make the firmware never do IR when
probing"
...maybe, except if the channel is the operating channel. (this should
exclude
unassociated stations)

I am out of office for the next week.
Regards,
Jean-Pierre
> 
> Thanks,
> Ben
> 
> > +
> >   			ch->passive = passive;
> >
> >   			ch->freq = channel->center_freq;
> > @@ -3548,6 +3550,9 @@ static int ath10k_start_scan(struct ath1
> >
> >   	lockdep_assert_held(&ar->conf_mutex);
> >
> > +	if (ar->state == ATH10K_STATE_ON)
> > +		ath10k_regd_update(ar);
> > +
> >   	ret = ath10k_wmi_start_scan(ar, arg);
> >   	if (ret)
> >   		return ret;
> >
> > ////////////////////////////////////////
> >
> > ...But this sets a terrible penalty on performance when applied to
> > background scan.
> >
> >
> > On 12/14/16 20:58 Jouni Malinen wrote:
> >>
> >> On Tue, Dec 06, 2016 at 06:02:52PM +0100, Jean-Pierre Tosoni wrote:
> >>> This follows on the previous discussion
> >>> 	"Client station sends probes on DFS channels"
> >>>
> >>> Problem:
> >>> The combination of QCA988X firmware v10.2.4.70-2 + ath10k +
> >>> wpa_supplicant do not comply with the norm ETSI/EN 301-893 section
> >>> 4.7; because they can send probes for 600s when no AP is around.
> >>>
> >>> Analysis:
> >>> The problem seems to lie in the firmware, which regards the presence
> >>> of *any* beacon as a proof that the channel is radar-clean for 600s.
> >>
> >> I don't think this is really firmware, but cfg80211 regulatory code
> >> and how it interacts with ath10k..
> >>
> >>> - there is no obvious fix working in ath10k.
> >>> - the issue does not show up with other mac80211 devices like ath9k.
> >>> - wpa_supplicant considers this is a kernel issue [2]
> >>
> >> There seems to be a difference between ath9k (mac80211-based Probe
> >> Request frame sending) and ath10k (firmware) in this area for active
> scanning.
> >> mac80211 uses IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_RADAR while
> >> ath10k uses IEEE80211_CHAN_NO_IR. I'd assume this difference results
> >> in ath10k using cfg80211 beacon hints (etc.) to update the NO_IR flag
> >> and that might be behind the difference you see.
> >>
> >> Could you check whether the following change gets you the behavior
> >> you want to see here? I have not had a chance to test this yet, but
> >> based on code review, it looks like something that brings the same
> >> behavior to ath10k that ath9k has for this through mac80211.
> >>
> >>
> >> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
> >> b/drivers/net/wireless/ath/ath10k/mac.c
> >> index aa545a1..758dbbd 100644
> >> --- a/drivers/net/wireless/ath/ath10k/mac.c
> >> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> >> @@ -2973,7 +2973,8 @@ static int ath10k_update_channel_list(struct
> >> ath10k
> >> *ar)
> >>   			ch->chan_radar =
> >>   				!!(channel->flags & IEEE80211_CHAN_RADAR);
> >>
> >> -			passive = channel->flags & IEEE80211_CHAN_NO_IR;
> >> +			passive = channel->flags & (IEEE80211_CHAN_NO_IR |
> >> +						    IEEE80211_CHAN_RADAR);
> >>   			ch->passive = passive;
> >>
> >>   			ch->freq = channel->center_freq;
> >>
> >> --
> >> Jouni Malinen                                            PGP id
> EFC895FA
> >>
> >> _______________________________________________
> >> ath10k mailing list
> >> ath10k@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/ath10k
> >
> 
> 
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
