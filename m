Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:39496 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbCQIeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 04:34:17 -0400
Date: Tue, 17 Mar 2015 09:34:14 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [1/3] rt2x00usb: initialize the read value in case of failure
Message-ID: <20150317083414.GA1276@linutronix.de> (sfid-20150317_093424_627344_F998E2F5)
References: <1426170946-13918-1-git-send-email-bigeasy@linutronix.de>
 <20150316160652.789B313FBE6@smtp.codeaurora.org>
 <20150316164100.GA6208@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20150316164100.GA6208@linutronix.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Sebastian Andrzej Siewior | 2015-03-16 17:41:00 [+0100]:

Just an update:
…
>|ieee80211 phy0: rt2800usb_write_firmware: Info - Firmware loading not required - NIC in AutoRun mode
>|IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>|IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>switch to AP mode done.
>
>And this should be where it switches back to managed mode
>|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x3200 with error -110 val: 0 type 40
>|ieee80211 phy0: rt2800usb_write_firmware: Info - Firmware is written.

so the difference is that I don't see "NIC in AutoRun mode". So
rt2800usb_autorun_detect() does not return 1 for some reason but 0
instead and whatever comes next kills the stick. Maybe it was tired of
of the wpa <-> hostapd mode switch for no reason.

So I told rt2800usb_autorun_detect() to always return 1 and not to care
what the stick says. The stick now runs for 12.5h in test without a
problem (that means it is able to connect to the AP and hostapd does not
complain, too). After around 11h I saw the message that it would write
the firmware (but it got ignored instead). So the workaround seems to
work.

I have no idea what AutoRun mode is (it seems that the stick already
has a firmware and is happy with it) and I have no clue why the firmware
decides to lie about it. I looked at the vendor driver I found at github
(which seems to be from 2012-10-22, DPO_RT5572_LinuxSTA_2.6.1.3) and
well, I look again if someone says it is worth looking… They seem to do
some kind "firmware is comming" magic which might be already done in the
current driver at a different spot but I think the main question is why
request is answered wrong. I *think* the vendor driver sends the
USB_MODE_AUTORUN request only once but it is hard to tell…

>>Kalle Valo

Sebastian
