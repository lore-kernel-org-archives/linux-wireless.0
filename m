Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58264 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2EONaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 09:30:10 -0400
Received: by eeit10 with SMTP id t10so1959691eei.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 06:30:09 -0700 (PDT)
Date: Tue, 15 May 2012 15:29:51 +0200
From: Anisse Astier <anisse@astier.eu>
To: <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: rtl8192ce : freeze after connecting to network with FW Power Save
 on
Message-ID: <20120515152951.7cc4f84b@destiny.ordissimo> (sfid-20120515_153016_329584_A407CE20)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

With the rtl8192ce driver, I get freezes a few seconds after connecting
to a network. (see PCI id below) Machine is unusable after hang. I'm
using the linville/wireless-next git tree.

I've been playing with the different options, and noticed that setting
fwlps=0 fixes the issue.

I've tried to get more messages with netconsole, but once the lockup
happens I'm unable to get any debug message (regardless of the log level
of the driver).

Regards,

Anisse


06:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
	Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:8212]
	Flags: bus master, fast devsel, latency 0, IRQ 17
	I/O ports at 3000 [size=256]
	Memory at f0200000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Capabilities: [160] Device Serial Number 01-91-81-fe-ff-4c-e0-00
	Kernel driver in use: rtl8192ce
