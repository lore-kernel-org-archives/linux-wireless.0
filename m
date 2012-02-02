Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39098 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab2BBMf2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 07:35:28 -0500
Message-ID: <4F2A830A.8000905@openwrt.org> (sfid-20120202_133531_921954_868E1421)
Date: Thu, 02 Feb 2012 13:35:22 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: CTS timeout issue with AR9285
References: <20120202042521.GA20635@ubuntu-macmini>
In-Reply-To: <20120202042521.GA20635@ubuntu-macmini>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-02 5:25 AM, Seth Forshee wrote:
> I recently updated a machine with AR9285 wireless from kernel version
> 3.0 to 3.2 and saw that wireless had become slow and unreliable. It
> seems that the problem is extremely frequent CTS timeouts, which began
> happening with commit adb5066 (ath9k_hw: do not apply the 2.4 ghz ack
> timeout workaround to cts). Restoring the CTS timeout to the value prior
> to this commit on top of 3.2 gets performance back to what it was with
> 3.0.
> 
> I don't have any other ath9k cards lying around, but various other cards
> are working fine with this router. Any ideas what's wrong here?
Please try this patch:

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1061,13 +1061,16 @@ void ath9k_hw_init_global_settings(struc
 
 	/*
 	 * Workaround for early ACK timeouts, add an offset to match the
-	 * initval's 64us ack timeout value.
+	 * initval's 64us ack timeout value. Use 48us for the CTS timeout.
 	 * This was initially only meant to work around an issue with delayed
 	 * BA frames in some implementations, but it has been found to fix ACK
 	 * timeout issues in other cases as well.
 	 */
-	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ)
+	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ) {
 		acktimeout += 64 - sifstime - ah->slottime;
+		ctstimeout += 48 - sifstime - ah->slottime;
+	}
+
 
 	ath9k_hw_set_sifs_time(ah, sifstime);
 	ath9k_hw_setslottime(ah, slottime);

