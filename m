Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:34655 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758251Ab0JFCf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 22:35:56 -0400
Received: from vs3010.wh2.ocn.ne.jp (125.206.180.173)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0838592554
	for <linux-wireless@vger.kernel.org>; Wed,  6 Oct 2010 11:35:54 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>, vasanth@atheros.com
Subject: Re: [PATCH 4/5] nl80211/mac80211: Add channel utilization to survey
Date: Wed, 6 Oct 2010 11:35:57 +0900
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
References: <20101005095510.3083.46174.stgit@tt-desk> <20101005095526.3083.82322.stgit@tt-desk> <AANLkTim62JuNJMHNB=-_mTXyXVr84cqptrqnD8QgtT7F@mail.gmail.com>
In-Reply-To: <AANLkTim62JuNJMHNB=-_mTXyXVr84cqptrqnD8QgtT7F@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010061135.57102.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed October 6 2010 07:36:30 Luis R. Rodriguez wrote:
> On Tue, Oct 5, 2010 at 2:55 AM, Bruno Randolf <br1@einfach.org> wrote:
> > This adds three new values to the survey results:
> > 
> >  * BUSY - percentage of time the channel was busy
> >  * BUSY_TX - percentage of time spent transmitting frames
> >  * BUSY_RX - percentage of time spent receiving frames
> > 
> > They are defined to be a percentage of time, normalized to 255. That way
> > they match the Channel Utilization of the BSS Load IE of 802.11-2007,
> > chapter 7.3.2.28, in case we want to use that later.
> > 
> > I admit that these three values are ath[59]k centric - it's what is
> > available there, and i don't know if other chipsets have similar
> > information.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > ---
> >  include/linux/nl80211.h |   10 ++++++++++
> >  include/net/cfg80211.h  |    6 ++++++
> >  net/wireless/nl80211.c  |    9 +++++++++
> >  3 files changed, 25 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> > index f0518b0..2cc74a2 100644
> > --- a/include/linux/nl80211.h
> > +++ b/include/linux/nl80211.h
> > @@ -1400,6 +1400,13 @@ enum nl80211_reg_rule_flags {
> >  * @__NL80211_SURVEY_INFO_INVALID: attribute number 0 is reserved
> >  * @NL80211_SURVEY_INFO_FREQUENCY: center frequency of channel
> >  * @NL80211_SURVEY_INFO_NOISE: noise level of channel (u8, dBm)
> > + * @NL80211_SURVEY_INFO_BUSY: channel busy ratio (u8, percentage of
> > time, + *     normalized to 255 so it matches Channel Utilization of the
> > BSS Load IE + *     of 802.11-2007 chapter 7.3.2.28)
> 
> Neat, so this could be used to help with roaming it seems.. Now as you
> noted this is defined pretty specifically on 802.11-2007 chapter
> 7.3.2.28.
> 
> > + * @NL80211_SURVEY_INFO_BUSY_TX: percentage of time spent transmitting
> > frames + *     (u8, percent 0-255, see above)
> 
> But here you say look above, can you be more specific how this relates
> to 802.11-2007 chapter 7.3.2.28 ?

hmm, i guess it doesn't. i was just refering to above for the range, but 
802.11 doesn't have separate values for TX or RX. i'd better rephrase that.

bruno
