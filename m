Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36729 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab3GDFfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 01:35:13 -0400
Received: by mail-ob0-f173.google.com with SMTP id wc20so1161603obb.32
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 22:35:13 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 4 Jul 2013 01:35:13 -0400
Message-ID: <CAKb7UvjVyZuOjuD3oFT_jxx5T=DNamHA_YiV_yGWcmePHHd-UQ@mail.gmail.com> (sfid-20130704_073518_906356_C8E04496)
Subject: Constant network assoc/disassoc loop with rtl8192cu usb adapter
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I recently got a RTL8188CUS usb adapter (which uses the rtl8192cu
driver). I'm having trouble getting it to stay associated:

[601369.845916] wlan0: associated
[601377.106440] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try
to reconnect now
[601383.867706] wlan0: associated
[601391.120270] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try
to reconnect now
[601397.910678] wlan0: associated
[601405.141764] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try
to reconnect now

and so on. A different usb adapter (Ralink RT2573) has no trouble
associating to that AP (but it keeps hanging and the kernel isn't
always able to reset it properly). The network in question is using
WPA2-PSK.

Is there some setting I could adjust so that it would wait longer
before deciding that the AP is off? Or something else I can do?

This is on a 3.10-rc6 kernel + the __queue_work warning fix patch at
https://git.kernel.org/cgit/linux/kernel/git/linville/wireless-testing.git/patch/?id=1621c9466099faf21ad19738d54a7d1845a29b32.

Thanks,

  -ilia
