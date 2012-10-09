Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab2JISqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 14:46:22 -0400
Message-ID: <1349808418.4683.19.camel@jlt4.sipsolutions.net> (sfid-20121009_204636_032072_7DAA3E34)
Subject: Re: [PATCH v3 1/7] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Tue, 09 Oct 2012 20:46:58 +0200
In-Reply-To: <CAK80WHYAH3FdoTDGQh54NdLkYMpv7heGsNjn7venC9fHj65RFw@mail.gmail.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	 <1344426823-1795-2-git-send-email-victorg@ti.com>
	 <1347274394.4272.8.camel@jlt4.sipsolutions.net>
	 <CAK80WHYAH3FdoTDGQh54NdLkYMpv7heGsNjn7venC9fHj65RFw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-03 at 15:53 +0200, Goldenshtein, Victor wrote:

> >> + * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
> >
> > How will you know what kind of radar detection is supported? That is, HT
> > 20, HT 40, in the future VHT80/160/80+80?
> >
> 
> only 20 Mhz is supported at first stage, do you prefer to rename it to
> something like: NL80211_FEATURE_20MHZ_DFS

no idea, maybe that, or maybe have some other field that lists the
channel widths that are supported?

> >> +int cfg80211_start_radar_detection(struct cfg80211_registered_device *rdev,
> >> +                                struct net_device *dev,
> >> +                                struct ieee80211_channel *chan)
> >> +{
> >> +     int err;
> >> +
> >> +     if (!rdev->ops->start_radar_detection)
> >> +             return -EOPNOTSUPP;
> >> +
> >> +     err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, chan);
> >> +     if (!err)
> >> +             chan->radar_detect_timeout = jiffies +
> >> +                     msecs_to_jiffies(IEEE80211_DFS_MIN_CAC_TIME_MS);
> >> +     else {
> >> +             chan->radar_detect_timeout = 0;
> >> +             chan->cac_type = 0;
> >> +     }
> >
> > You're not setting cac_type in the good case, and also
> > radar_detect_timeout can actually be 0 in the good case due to jiffies
> > wrap. How is that handled?
> >
> 
> I'm using time_is_after_jiffies() in nl80211_dfs_en_tx() which AFAIK
> can handle jiffies wrap.

yeah but if you need to set radar_detect_timeout=0 here, then it looks
like you're also using the 0 value as a special value to indicate
"nothing in progress"?


> right, since NOHT is 0 we probably need additional flag something like
> "chan->cac_started"

yes

> alternatively we can add "__NL80211_CHAN_INVALID" at index 0  to the
> enum nl80211_channel_type.

no
nl80211 is abi :)

johannes

