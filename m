Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:61341 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285Ab0CaSqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 14:46:38 -0400
Message-ID: <4BB3988C.40902@gmail.com>
Date: Wed, 31 Mar 2010 20:46:36 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] [RFC] rt2500pci: fix powersaving
References: <201003290956.54234.linux@rainbow-software.org> <201003301433.55355.linux@rainbow-software.org> <20100330125620.GA2173@katherina.student.utwente.nl> <201003302209.23334.linux@rainbow-software.org> <20100331174138.GE21160@katherina.student.utwente.nl> <4BB396B4.8090005@gmail.com>
In-Reply-To: <4BB396B4.8090005@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070101090101000206070904"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070101090101000206070904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 03/31/10 20:38, Gertjan van Wingerde wrote:
> On 03/31/10 19:41, Matthijs Kooijman wrote:
>> Hi Ondrej,
>>
>>> phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state 1 (-16).
>> I've been running with your patches (applied to 2.6.32.7) for a day of normal
>> work, and the steady stream of these errors has stopped. During the entire
>> day, I've seen the error once, perhaps a corner case here or there?
>>
>> Overall, I have the feeling that connectivity is a bit more unstable with
>> these two patches, however. On a few occasions, my SSH connections would hang
>> for a bit. Sometimes pinging would be ok (and sometimes it wouldn't), so I
>> haven't quite figured out if these problems were actually caused by the
>> driver, or some other cause). Once I seemd to solve the problem by turning off
>> powersaving, but that might have been a coincidence. Other times the problems
>> went away by themselves.
>>
>> Is there anything else I can do at the moment I'm seeing connection problems?
>> Make a register dump or check some command?
>>
>> I'll do some more testing, tonight on another (probably more stable)
>> connection.
> 
> Could you try the attached patch on top of Ondrej's?
> 
> The legacy Ralink drivers do not go to sleep when there are still active entries
> in the TX queues. This patch mimics that behavior by refusing to go to sleep if
> there still are active entries in any of the TX queues.

Sorry, I got confused on which driver we were working on. Find attached the correct
patch, now for the rt2500pci driver instead of the rt2500usb driver.

---
Gertjan

--------------070101090101000206070904
Content-Type: text/plain;
 name="patch2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch2"

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index b0c9502..a0441fa 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -558,9 +558,17 @@ static void rt2500pci_config_ps(struct rt2x00_dev *rt2x00dev,
 	enum dev_state state =
 	    (libconf->conf->flags & IEEE80211_CONF_PS) ?
 		STATE_SLEEP : STATE_AWAKE;
+	struct data_queue *queue;
 	u32 reg;
 
 	if (state == STATE_SLEEP) {
+		/*
+		 * Don't go to sleep when the TX queues are not empty.
+		 */
+		tx_queue_for_each(rt2x00dev, queue)
+			if (!rt2x00queue_empty(queue))
+				return;
+
 		rt2x00pci_register_read(rt2x00dev, CSR20, &reg);
 		rt2x00_set_field32(&reg, CSR20_DELAY_AFTER_TBCN,
 				   (rt2x00dev->beacon_int - 20) * 16);

--------------070101090101000206070904--
