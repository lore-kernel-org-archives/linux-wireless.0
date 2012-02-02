Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:44843 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab2BBQGU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 11:06:20 -0500
Received: by mail-ww0-f49.google.com with SMTP id dt13so2151535wgb.30
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 08:06:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F277E8D.5040809@sipsolutions.net>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-2-git-send-email-victorg@ti.com>
	<4F277E8D.5040809@sipsolutions.net>
Date: Thu, 2 Feb 2012 18:06:19 +0200
Message-ID: <CAK80WHbh13duicPjTEWpTpbjiCiJUu6R_ZArYce5D7wUu1PnMA@mail.gmail.com> (sfid-20120202_170624_366675_58E2DB6C)
Subject: Re: [RFC 1/9] nl80211/cfg80211: add radar detection command/event
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2012 at 7:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Why DFS & radar detection? I mean, why not just call it CMD_RADAR_DETECT or
> so?
>

will rename it to CMD_RADAR_DETECT

>> + *
>> + * @dfs_start_radar_detection: Start radar detection in the driver.
>
>
> ditto here

will rename it to start_radar_detection

>
>
>> @@ -3216,6 +3221,17 @@ void cfg80211_cqm_rssi_notify(struct net_device
>> *dev,
>>                              gfp_t gfp);
>>
>>  /**
>> + * cfg80211_radar_detected_notify - radar detection event
>
>
> The _notify suffix seems useless, maybe remove it?
>

most of the function here use this suffix, but I don't mind to remove it ..

>
>> + * @dev: network device
>> + * @freq: radar detected on this channel frequency
>
>
> unit?
>

ok

>
>> +static int nl80211_dfs_start_radar_detection(struct sk_buff *skb,
>> +                                            struct genl_info *info)
>> +{
>> +       struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> +       struct net_device *dev = info->user_ptr[1];
>> +
>> +       ASSERT_RDEV_LOCK(rdev);
>
>
> That assert isn't really worth much here.
>

will remove it also from: nl80211_dfs_en_tx, nl80211_ap_channel_switch

>
> How do you *end* radar detection? What channel does it apply to? Any channel
> you're on? The channel you were on when it was enabled?

Once we start radar detection, it should continuously monitor for
radar until we switch from this channel. The command applies to
current operational channel.


-- 
Thanks,
Victor.
