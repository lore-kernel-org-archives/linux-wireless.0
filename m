Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:65349 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965722AbZLHVmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 16:42:24 -0500
Message-ID: <4B1EC842.7040407@gmail.com>
Date: Tue, 08 Dec 2009 22:42:26 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	linux-wireless@vger.kernel.org, Tim Blechmann <tim@klingt.org>,
	rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
 in 	2.6.32
References: <20091204233202.GA13658@basil.fritz.box> <4B1BB44E.90706@gmail.com>	 <200912080006.28892.s.L-H@gmx.de>	 <20091208095755.GT18989@one.firstfloor.org> <14add3d10912080219u17c65cbemf6d56290a8f12efd@mail.gmail.com>
In-Reply-To: <14add3d10912080219u17c65cbemf6d56290a8f12efd@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070108010107060809070206"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070108010107060809070206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/08/09 11:19, Gertjan van Wingerde wrote:
> On Tue, Dec 8, 2009 at 10:57 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>> This patch doesn't seem to change this particular issue, disabling
>>> powersaving however makes rt62pci work again.
>>
>> Yes confirmed here. Haven't seen it in a day or so with disabled power
>> saving.
>>
>> However I haven't tried the patch with power saving enabled.
> 
> OK.
> I think Stefan said that the patch didn't help for this issue.
> 
> However, I've got an other hunch (based on the Ralink driver). Maybe
> we shouldn't go to sleep when still TX entries are present. I'll cook
> up a patch tonight.
> 

OK. Please try again with the attached patch. Basically it disables going
to sleep when there are still unacknowledged frames in the TX queues.
This mirrors the behavior of the Ralink provided drivers.

---
Gertjan.

--------------070108010107060809070206
Content-Type: text/plain;
 name="2.6.32-powersave-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="2.6.32-powersave-fix.diff"

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 687e17d..77b2575 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -947,9 +947,17 @@ static void rt61pci_config_ps(struct rt2x00_dev *rt2x00dev,
 	enum dev_state state =
 	    (libconf->conf->flags & IEEE80211_CONF_PS) ?
 		STATE_SLEEP : STATE_AWAKE;
+	struct data_queue *queue;
 	u32 reg;
 
 	if (state == STATE_SLEEP) {
+		/*
+		 * Don't go to sleep when the TX queues aren't empty.
+		 */
+		tx_queue_for_each(rt2x00dev, queue)
+			if (!rt2x00queue_empty(queue)) {
+				return;
+
 		rt2x00pci_register_read(rt2x00dev, MAC_CSR11, &reg);
 		rt2x00_set_field32(&reg, MAC_CSR11_DELAY_AFTER_TBCN,
 				   rt2x00dev->beacon_int - 10);

--------------070108010107060809070206--
