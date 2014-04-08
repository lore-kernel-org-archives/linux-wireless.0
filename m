Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:44987 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaDHGxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 02:53:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: refactor monitor code
References: <1396610305-5229-1-git-send-email-michal.kazior@tieto.com>
	<87y4zgmifa.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 8 Apr 2014 09:53:10 +0300
In-Reply-To: <87y4zgmifa.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Tue, 08 Apr 2014 09:42:01 +0300")
Message-ID: <87ob0cmhwp.fsf@kamboji.qca.qualcomm.com> (sfid-20140408_085320_079982_29CEFE32)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> It was possible to create/delete/start/stop
>> monitor vdev from a few places that were not
>> exclusively protected against each other. This
>> resulted in monitor vdev being stopped/removed by
>> one call origin while another one was expecting it
>> to continue running.
>>
>> For example if CAC was started and interface's
>> promiscuous mode was toggled monitor vdev was
>> removed from the driver meaning no radar would be
>> detected. In additional a warning would be printed
>> upon CAC completion complaining it tried to stop
>> non-running monitor vdev.
>>
>> The patch simplifies monitor code by removing
>> IEEE80211_HW_WANT_MONITOR_VIF (which wasn't really
>> ever needed) and improves state tracking. It also
>> unifies prints.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Thanks, applied.

Actually there were two checkpatch warnings which I had missed:

drivers/net/wireless/ath/ath10k/mac.c:2587: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/mac.c:2852: WARNING: line over 80 characters

I amended it like this:

--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2584,7 +2584,8 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
                        ar->monitor = true;
                        ret = ath10k_monitor_start(ar);
                        if (ret) {
-                               ath10k_warn("failed to start monitor (config): %d\n", ret);
+                               ath10k_warn("failed to start monitor (config): %d\n",
+                                           ret);
                                ar->monitor = false;
                        }
                } else if (!(conf->flags & IEEE80211_CONF_MONITOR) &&
@@ -2849,7 +2850,8 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
                ar->promisc = true;
                ret = ath10k_monitor_start(ar);
                if (ret) {
-                       ath10k_warn("failed to start monitor (promisc): %d\n", ret);
+                       ath10k_warn("failed to start monitor (promisc): %d\n",
+                                   ret);
                        ar->promisc = false;
                }
        } else if (!(ar->filter_flags & FIF_PROMISC_IN_BSS) && ar->promisc) {

-- 
Kalle Valo
