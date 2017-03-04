Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:55590 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751820AbdCDJLI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Mar 2017 04:11:08 -0500
Date: Sat, 4 Mar 2017 11:10:36 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC] mac80211_hwsim: report survey data for scanned channels
Message-ID: <20170304091036.GA5388@w1.fi> (sfid-20170304_101114_564352_521720F6)
References: <20170221103118.18441-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170221103118.18441-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 21, 2017 at 11:31:18AM +0100, Johannes Berg wrote:
> Currently, hwsim is reporting survey data (only a fake noise floor)
> for the current channel. This breaks when the multi-channel support
> is enabled since then there's no current channel.
> 
> Make the dummy implementation closer to a real one and only report
> data while scanning, for all the scanned channels. At other times,
> no survey data might be available (in real hardware) due to power-
> save for example.

> Had this lying around - is it useful for anyone?

Yes, it seems to make the ap_acs hwsim test cases in hostap.git quite a
bit more useful in hitting proper acs.c coverage in hostapd.. And also
allow having to have hacks to force previous AP instance on the same
band just to be able to hit any of this code.

> -	survey->filled = SURVEY_INFO_NOISE_DBM;
> +	survey->filled = SURVEY_INFO_NOISE_DBM |
> +			 SURVEY_INFO_CHANNEL_TIME |
> +			 SURVEY_INFO_CHANNEL_TIME_BUSY;

This is pretty old, though.. :)  Had to remove the "CHANNEL_" part
here..

> +	survey->channel_time =
> +	survey->channel_time_busy = survey->channel_time/8;

.. and "channel_" in these to make this compile. Anyway, with those
trivial changes, the hwsim test cases did start looking more
interesting, so it would seem reasonable to get this applied.

-- 
Jouni Malinen                                            PGP id EFC895FA
