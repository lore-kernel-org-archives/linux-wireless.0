Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42750 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab1BYDVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 22:21:46 -0500
Received: by pwi15 with SMTP id 15so293478pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Feb 2011 19:21:46 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19815.8349.58361.632340@gargle.gargle.HOWL>
Date: Fri, 25 Feb 2011 08:53:09 +0530
To: Jay Davidson <jdiq123@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: [ath9k-devel] [Help Appreciated] Minstrel/Ath9k Rate control mechanism and Video delivery recognition
In-Reply-To: <AANLkTiktAwpCE_2LhveOn2LvkiEi7uG4SN8xZ1x1Nm5D@mail.gmail.com>
References: <AANLkTiktAwpCE_2LhveOn2LvkiEi7uG4SN8xZ1x1Nm5D@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jay Davidson wrote:
> Dear all,
> 
> I have a few questions regarding Minstrel HT/Ath9k Rate control mechanism, and regarding video delivery recognition.
> 
> 1) Does minstrel or ATH9k RA change anything other than the MCS, e.g. frame aggregation size, retry limit, contention window, channel bandwidth etc. For example if I
> initiate my AP with a 40 Mhz channel bandwidth, does it ever switch between 20 Mhz channel if its better or does it remain at 40 Mhz until its manually changed?. Any
> documentation available for the RC/RA is appreciated.

* Channel Width Management is not supported by ath9k or mac80211, for that matter,
  so dynamic switching between 20/40 Mhz will not happen.
* Frame aggregation size will automatically change based on the rate.
* Retry limits are fixed.

> 2) what parameter do I need to change to modify the contention window (can use debugfs if hard coded).

For AP mode, the CWMIN/CWMAX values are configurable in hostapd.

> 3) How to set the rate at runtime(modify the MCS) aka. is it possible via iwconfig or iw. If not what parameters to change in order to port it via DebugFs.

Fixed rate setting for MCS rates is currently not supported.
hostapd has some knobs for limiting the rateset in 11g mode, IIRC.

> 4) what parameter do I need to change to modify the number of subframes in an aggregate, from what I know Atheros' defualt is set to 32 and max is 64 subframes.

You have to hack the driver, check
max_tx_aggregation_subframes/max_rx_aggregation_subframes in mac80211.h

> and finally:
> 5) When I stream Video using VLC via RTP(UDP) protocol, the debug counters(access category) show it as Best effort and NOT "VI" which is what it should be. Any advice
> suggestions reasoning, and/or a fix for this would be great.

If it is so, it is a bug.

Sujith
