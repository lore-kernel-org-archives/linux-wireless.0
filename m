Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.182]:45032 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbYEEOxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 10:53:47 -0400
Received: by el-out-1112.google.com with SMTP id n30so713480elf.21
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 07:53:46 -0700 (PDT)
Message-ID: <cb0375e10805050753q4d35e873pf3748d196a6555c2@mail.gmail.com> (sfid-20080505_165307_012774_794E84A5)
Date: Mon, 5 May 2008 10:53:46 -0400
From: "Andrew Lutomirski" <luto@myrealbox.com>
To: linux-wireless@vger.kernel.org
Subject: rfkill_input without driver-supported rfkill (ath5k in particular)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I finally got my WLAN button working (i.e. generating key events --
thanks Eric Piel!).  Now I'd like it to kill my RF :)

The problem seems to be that ath5k (at least the version in
2.6.25-rc9) doesn't support rfkill.  It would be nice if that could be
added, but it seems to me that, if ath5k really has no rfkill
mechanism, then there should be some kind of emulation.  This would
mean:

1. mac80211 creates a fake rfkill switch for devices that don't
otherwise have one and handles it by turning off the device the same
way that ip link set ... down does but still showing them to userspace
however they were before.

or

2. Some userspace component (HAL or NetworkManager) should notice the
KEY_WLAN event and the presence of an rfkill-less device and turn it
off.

In either case, presumably I should be able to set an led trigger on
my ath5k device so it could control an LED.

(As background, I have an Acer C300, and I replaced the old Intel
MiniPCI card with an Atheros 5213 card.  The BIOS doesn't recognize my
card at all, so the "hardware" rfkill does nothing at all, but I still
have a WLAN button and LED.)

Thoughts?

Thanks,
Andy
