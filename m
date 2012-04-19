Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1930 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259Ab2DSVMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 17:12:18 -0400
Message-ID: <1334869564.25074.35.camel@t41.thuisdomein> (sfid-20120419_234809_527572_8442B51C)
Subject: ath5k phy0: failed to warm reset the MAC Chip
From: Paul Bolle <pebolle@tiscali.nl>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Thu, 19 Apr 2012 23:06:04 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

0) In the logs of a laptop I use I've found error pairs like this error
pair:
    <3>[13053.997856] ath5k phy0: failed to warm reset the MAC Chip
    <3>[13053.997871] ath5k phy0: can't reset hardware (-5)

The logs show it for a v3.3 based kernel and for the v3.4-rc2 kernel. I
can't say whether or not preceding kernels also triggered it.

1) I only noticed these errors because I tend to check these logs for
errors: I cannot link these errors to drops in (the quality of) wireless
connectivity.

2) The call chain involved should be:

drivers/net/wireless/ath/ath5k/base.c:
2737 ath5k_reset(...)
     {
2765         ret = ath5k_hw_reset(...);
2766         if (ret) {
2767                 ATH5K_ERR(ah, "can't reset hardware (%d)\n", ret);
2768                 goto err;
2769         }
     }

drivers/net/wireless/ath/ath5k/base.c:
1144 ath5k_hw_reset(...)
     {
1296         ret = ath5k_hw_nic_wakeup(...);
1297         if (ret)
1298                 return ret;
     }

 667 ath5k_hw_nic_wakeup(...)
     {
 728                 ret = ath5k_hw_nic_reset(...);
 729 
 730         if (ret) {
 731                 ATH5K_ERR(ah, "failed to warm reset the MAC Chip\n");
 732                 return -EIO;
 733         }
     }

 395 ath5k_hw_nic_reset(...)
     {
 421         ret = ath5k_hw_register_timeout(...);
     }

  65 ath5k_hw_register_timeout(...)
     {
  80         return (i <= 0) ? -EAGAIN : 0;
     }

Note that the -EAGAIN returned by ath5k_hw_register_timeout() and
ath5k_hw_nic_reset() is transformed to -EIO by ath5k_hw_nic_wakeup().

3) Do these message really indicate errors? Or can they perhaps be
downgraded to (say) KERN_INFO level (ie, <6> prefix)?


Paul Bolle

