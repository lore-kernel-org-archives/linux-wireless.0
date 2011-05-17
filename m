Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39780 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab1EQTdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 15:33:36 -0400
Received: by bwz15 with SMTP id 15so785448bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 12:33:35 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 May 2011 15:33:34 -0400
Message-ID: <BANLkTim-XdEJNfSS1UtP7Yf1UZVaPonvQA@mail.gmail.com> (sfid-20110517_213346_295509_668F20FF)
Subject: [BUG] ath9k_htc: new devices get name wlan%d if not in rules
From: George Nychis <gnychis@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I haven't narrowed it down to the exact build date where this breaks,
but I know that it works in compat-wireless-2011-05-01, and not in
compat-wireless-2011-05-11+ (including last night's build).  I had
trouble building compat-wireless-2011-05-04/05 so it was hard for me
to narrow it down.

However, if there is no udev rule already in
/etc/udev/rules.d/70-persistent-net.rules for the USB device's MAC
address (e.g., ATTR{address}=="4c:e6:76:12:ce:48") ... then the
interface comes up as wlan%d and does not get successfully renamed.
If it has an entry in 70-persistent-net.rules, then it will
successfully rename it.

In compat-wireless-2011-05-01 and earlier, if the device does not
exist in 70-persistent-net.rules, it gets a name and then it is added
to the rules file (e.g., as wlan0).

These are my results from an x86 Ubuntu 10.04 machine.

- George
