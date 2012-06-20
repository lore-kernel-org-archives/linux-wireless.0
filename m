Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:57723 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757076Ab2FTQmw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 12:42:52 -0400
Received: by eabm6 with SMTP id m6so3029154eab.13
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 09:42:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340181600.4655.34.camel@jlt3.sipsolutions.net>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	<1340181600.4655.34.camel@jlt3.sipsolutions.net>
Date: Wed, 20 Jun 2012 19:42:49 +0300
Message-ID: <CAK80WHZ+JBP2C8vCpYTcbr15wnNCxaS5piG1znjFgzS2n7Mouw@mail.gmail.com> (sfid-20120620_184259_567402_FE7F2A97)
Subject: Re: [PATCH v2 1/7] nl80211/cfg80211: add radar detection command/event
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2012 at 11:40 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-06-19 at 16:10 +0300, Victor Goldenshtein wrote:
>
>> +     NL80211_CMD_RADAR_DETECT,
>
> Is there no need to ever stop radar detection?
>

no, it should be always enable for DFS channels.

>> + * @radar_detect_timeout: this timeout indicates the end of the channel
>> + *   availability check for radar channels, only after this period the
>> + *   user may initiate the tx on the channel.
>
> units? internal use, or for use by drivers? should it really be stored
> in the global channel struct that could be shared for multiple devices?

will add the units.
Yes, IMHO it should be saved in the channel struct, the radar
detection is per channel so it seems very natural place, also we will
need it here for the MC.

>
>>  /**
>> + * cfg80211_radar_detected - radar detection event
>> + * @dev: network device
>> + * @freq: radar detected on this channel frequency (in MHz)
>> + * @gfp: context flags
>> + *
>> + * This function is called when a radar is detected on the current channel.
>> + */
>> +void cfg80211_radar_detected(struct net_device *dev, u16 freq, gfp_t gfp);
>
> Better to pass the channel pointer?
>
>> +u16 cfg80211_calculate_bitrate(struct rate_info *rate);
>
> ??
>

sorry.. :)


>> +void cfg80211_radar_detected(struct net_device *dev, u16 freq, gfp_t gfp)
>> +{
>> +     struct wireless_dev *wdev = dev->ieee80211_ptr;
>> +     struct wiphy *wiphy = wdev->wiphy;
>> +     struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
>> +     struct ieee80211_channel *chan;
>> +
>> +     chan = ieee80211_get_channel(&rdev->wiphy, freq);
>> +     if (chan)
>> +             chan->radar_detect_timeout = 0;
>
> So how do you distinguish between having ever done radar detection and
> never even having started it? Also, jiffies + ... can return 0.
>

will add additional flag.

>
> How do you intend to handle HT40?
>

At this point we don't have such intention, but as Zefir suggested
lets first implement HT20.
To protect from transmitting on HT40 , while CAC was performed only
for HT20, will add additional check in enable_tx to validate that
we're on NL80211_CHAN_HT20 channel, otherwise will return -EINVAL.
Also, will add NL80211_ATTR_WIPHY_CHANNEL_TYPE to the
ap_channel_switch command.

-- 
Thanks,
Victor.
