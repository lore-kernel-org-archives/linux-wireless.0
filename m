Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:36195 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964927AbbJ0TQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 15:16:17 -0400
Received: by obcqt19 with SMTP id qt19so178991928obc.3
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 12:16:17 -0700 (PDT)
MIME-Version: 1.0
From: Chris Kuethe <chris.kuethe@gmail.com>
Date: Tue, 27 Oct 2015 12:15:57 -0700
Message-ID: <CAGHP0pK5452ixOHr0uWY=o2S2JvgoqVx8X7r6ZnQ=ezxqNg1UA@mail.gmail.com> (sfid-20151027_201620_728553_4D5C16E1)
Subject: problems with mwifiex_usb, hangs under load, firmware in bad state
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Like others, I'm having problems with mwifiex_usb on a Surface 2 Pro,
with the latest firmware "driver_version = mwifiex 1.0 (14.68.29.p38)"
and the latest release candidate kernel (4.3.0rc7)

Every 5-10 seconds, even while idle, I'll get a kernel message:
    usb 1-2: Rx of mgmt packet failed

Under load (a big scp or a couple of kernel source tarballs will do
the trick), I get a huge amount of log spam, one message per packet:
    usb 1-2: data: -ENOSR is returned

Occasionally I'll also see
    usb 1-2: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed

After a while, I get the dreaded firmware bad state and the only fix
is to power cycle the machine. Suspend doesn't reset the hardware, and
attempting to rmmod/modprobe mwifiex_usb will crash my machine.

 usb 1-2: mwifiex_cmd_timeout_func: Timeout cmd id = 0x6, act = 0x3
 usb 1-2: num_data_h2c_failure = 0
 usb 1-2: num_cmd_h2c_failure = 0
 usb 1-2: is_cmd_timedout = 1
 usb 1-2: num_tx_timeout = 0
 usb 1-2: last_cmd_index = 0
 usb 1-2: last_cmd_id: 06 00 28 00 28 00 28 00 28 00
 usb 1-2: last_cmd_act: 03 00 13 00 13 00 13 00 13 00
 usb 1-2: last_cmd_resp_index = 4
 usb 1-2: last_cmd_resp_id: 28 80 28 80 28 80 28 80 28 80
 usb 1-2: last_event_index = 3
 usb 1-2: last_event: 37 00 33 00 37 00 33 00 33 00
 usb 1-2: data_sent=0 cmd_sent=0
 usb 1-2: ps_mode=0 ps_state=0
 usb 1-2: Ignore scan. Card removed or firmware in bad state
 usb 1-2: scan failed: -14
 usb 1-2: Ignore scan. Card removed or firmware in bad state
 usb 1-2: scan failed: -14
 usb 1-2: Ignore scan. Card removed or firmware in bad state
 usb 1-2: scan failed: -14
 usb 1-2: Ignore scan. Card removed or firmware in bad state
 usb 1-2: scan failed: -14
 usb 1-2: Ignore scan. Card removed or firmware in bad state
 usb 1-2: scan failed: -14
 usb 1-2: Ignore scan. Card removed or firmware in bad state
 usb 1-2: scan failed: -14
 usb 1-2: Ignore scan. Card removed or firmware in bad state
 usb 1-2: scan failed: -14
 usb 1-2: PREP_CMD: FW is in bad state
 usb 1-2: PREP_CMD: FW is in bad state
 IPv6: ADDRCONF(NETDEV_UP): wlx281878fd2432: link is not ready
 usb 1-2: PREP_CMD: FW is in bad state

This is reproducible all the way up to 4.3.0-rc7 which includes the patch from
http://www.spinics.net/lists/netdev/msg334367.html

that was suggested as a fix in
http://www.spinics.net/lists/linux-wireless/msg139095.html

I was able to reproduce this with after turning up debugging (echo
0xffffffff > /sys/kernel/debug/mwifiex/mlan0/debug_mask) - the
resulting trace is 1.4GB. Interested parties can contact me for a
link, or tell me what I should grep for...

-- 
GDB has a 'break' feature; why doesn't it have 'fix' too?
