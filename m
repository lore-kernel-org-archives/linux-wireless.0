Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55009 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbIIJKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 05:10:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bob Copeland <me@bobcopeland.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 3/3] ath10k: implement mesh support
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
	<1440673024-13696-4-git-send-email-me@bobcopeland.com>
	<87oahc9g9h.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 9 Sep 2015 12:10:38 +0300
In-Reply-To: <87oahc9g9h.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Wed, 09 Sep 2015 10:57:30 +0300")
Message-ID: <87fv2o9cvl.fsf@kamboji.qca.qualcomm.com> (sfid-20150909_111053_841401_014079CC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Bob Copeland <me@bobcopeland.com> writes:
>
>> Add support for mesh to ath10k.  We simply use an AP virtual interface
>> in the firmware in order to enable beaconing without TSF adoption, and
>> use the raw (802.11) transmit mode.
>>
>> Due to firmware limitations, the firmware must operate in raw
>> (non-native 802.11) mode.  As this is configured at firmware init time,
>> a new "rawmode" modparam is added, and mesh interfaces are available
>> only if rawmode=true.  The firmware must advertise support for rawmode
>> (tested successfully with firmware 10.2.4.70-2).
>>
>> When loaded with rawmode=1, ath10k can operate an open mesh STA via
>> something like the following:
>>
>>     ip link set wlan0 down
>>     iw dev wlan0 set type mp
>>     ip link set wlan0 up
>>     iw dev wlan0 set freq 5745 80 5775
>>     iw dev wlan0 mesh join mesh-vht
>>
>> Signed-off-by: Bob Copeland <me@bobcopeland.com>
>
> I did a quick smoke test and saw the splat below. It's this warning from
> cfg80211:
>
> 			/*
> 			 * Don't advertise an unsupported type
> 			 * in a combination.
> 			 */
> 			if (WARN_ON((wiphy->interface_modes & types) != types))
> 				return -EINVAL;

Forgot to mention that this was with 10.2.4.70.6-2 (which has the raw
feature bit set, will push it soon) but rawmode modparam not set. And I
had applied your patches on top of ath.git master branch (commit
d89281c7d6bb9).

-- 
Kalle Valo
