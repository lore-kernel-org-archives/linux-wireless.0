Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbbCRNPK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 09:15:10 -0400
Date: Wed, 18 Mar 2015 14:11:25 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [1/3] rt2x00usb: initialize the read value in case of failure
Message-ID: <20150318131124.GA11724@redhat.com> (sfid-20150318_141516_235339_4B423290)
References: <1426170946-13918-1-git-send-email-bigeasy@linutronix.de>
 <20150316160652.789B313FBE6@smtp.codeaurora.org>
 <20150316164100.GA6208@linutronix.de>
 <20150317083414.GA1276@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20150317083414.GA1276@linutronix.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 17, 2015 at 09:34:14AM +0100, Sebastian Andrzej Siewior wrote:
> I have no idea what AutoRun mode is (it seems that the stick already
> has a firmware and is happy with it) and I have no clue why the firmware
> decides to lie about it. I looked at the vendor driver I found at github
> (which seems to be from 2012-10-22, DPO_RT5572_LinuxSTA_2.6.1.3) and
> well, I look again if someone says it is worth looking… They seem to do
> some kind "firmware is comming" magic which might be already done in the
> current driver at a different spot but I think the main question is why
> request is answered wrong. I *think* the vendor driver sends the
> USB_MODE_AUTORUN request only once but it is hard to tell…

Does the below patch solve the issue ?

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9a2f44a..3a6cae8 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -293,6 +293,7 @@ static int rt2800usb_write_firmware(struct rt2x00_dev *rt2x00dev,
 	if (retval) {
 		rt2x00_info(rt2x00dev,
 			    "Firmware loading not required - NIC in AutoRun mode\n");
+		__clear_bit(REQUIRE_FIRMWARE, &rt2x00dev->cap_flags);
 	} else {
 		rt2x00usb_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
 					      data + offset, length);

