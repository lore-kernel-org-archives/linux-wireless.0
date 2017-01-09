Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39502 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965058AbdAILFO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 06:05:14 -0500
Message-ID: <1483959910.17582.25.camel@sipsolutions.net> (sfid-20170109_120811_069826_645D8E3C)
Subject: Re: SIOCSIWFREQ while in NL80211_IFTYPE_STATION
From: Johannes Berg <johannes@sipsolutions.net>
To: Jorge Ramirez <jorge.ramirez-ortiz@linaro.org>,
        netdev@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 09 Jan 2017 12:05:10 +0100
In-Reply-To: <f8e8b557-3e7b-cc1a-c31a-91f9d754e683@linaro.org> (sfid-20170105_153832_371808_8A30C9BF)
References: <685811c3-6247-77fd-8c70-617951886451@linaro.org>
         <1483616301.4394.6.camel@sipsolutions.net>
         <92e60cb2-8bb4-df03-3434-4a055f575df0@linaro.org>
         <1483625204.4394.23.camel@sipsolutions.net>
         <f8e8b557-3e7b-cc1a-c31a-91f9d754e683@linaro.org>
         (sfid-20170105_153832_371808_8A30C9BF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-05 at 15:38 +0100, Jorge Ramirez wrote:

> do you mean this?
> 
> [jramirez@igloo ~ (debian-qcom-dragonboard410c-16.09-local $)]$ git
> diff
> diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
> index a4e8af3..c56bac5 100644
> --- a/net/wireless/wext-sme.c
> +++ b/net/wireless/wext-sme.c
> @@ -106,30 +106,7 @@ int cfg80211_mgd_wext_siwfreq(struct net_device
> *dev,
>                          goto out;
>          }
> 
> -
>          wdev->wext.connect.channel = chan;
> -
> -   /*
> -    * SSID is not set, we just want to switch monitor channel,
> -    * this is really just backward compatibility, if the SSID
> -    * is set then we use the channel to select the BSS to use
> -    * to connect to instead. If we were connected on another
> -    * channel we disconnected above and reconnect below.
> -    */
> -   if (chan && !wdev->wext.connect.ssid_len) {
> -           struct cfg80211_chan_def chandef = {
> -                   .width = NL80211_CHAN_WIDTH_20_NOHT,
> -                   .center_freq1 = freq,
> -           };
> -
> -           chandef.chan = ieee80211_get_channel(&rdev->wiphy, freq);
> -           if (chandef.chan)
> -                   err = cfg80211_set_monitor_channel(rdev,
> &chandef);
> -           else
> -                   err = -EINVAL;
> -           goto out;
> -   }
> -
>          err = cfg80211_mgd_wext_connect(rdev, wdev);
>    out:
>          wdev_unlock(wdev);

Yeah. Frankly, I don't even understand that comment anymore - if the
interface is in managed mode, why set the monitor channel, it's not
monitoring? And if it's not in managed mode we don't get here.

> 
> 
> I tested the change above: we can now modify the channel/frequency
> when 
> the SSID is not set in managed mode.
> When the SSID is set however iwconfig does not report any error but 
> channel/frequency doesn't change.
> 
> if you think this is acceptable I can submit a patch

I think it looks fine, though writing the commit message may be tricky
:)

johannes
