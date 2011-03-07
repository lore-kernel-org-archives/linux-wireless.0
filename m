Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58696 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1CGWhF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 17:37:05 -0500
Received: by qwd7 with SMTP id 7so3538478qwd.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2011 14:37:03 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 7 Mar 2011 23:37:03 +0100
Message-ID: <AANLkTikky+cwYO+S_QSebnyQRV9TftbeNZDzVN8EAT_7@mail.gmail.com>
Subject: SSB bus driver documentation?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Cc: b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I spent few hours trying to understand/track ssb code and I'm giving
up now. I can not understand basic code flow.

We have some ssb_modinit, but I don't see it performing scanning bus
at all. For some reason this function is aware of b43 bridge and gige
driver. GigE driver doesn't seem to be module, while b43 seems to be.
gige uses pci_device_id, while b43 uses ssb_device_id. I have no idea
what b43 PCI bridge is. Flow seems to be ugly, at ssb_modinit we call
ssb_gige_init which calls out ssb_driver_register. There is some magic
"ssb_attach_queued_buses", which sounds like SSB (which is bus)
attaching... buses.

I wanted to at least understand when scanning of cores is done. I
found "ssb_bus_scan", it is called from "ssb_bus_register". This
function is called from code for every host, for example:
ssb_bus_pcibus_register. This one seems to be called from
ssb_pcihost_probe, however pcihost_wrapper is not module itself, it
does not contains any devices table. This function seems to be
registered with pci_register_driver from ssb_pcihost_register. That
one gets called b43_pci_ssb_bridge_init. But damn, I don't remember
anymore where I was 5 step ago. Not to mention whole code path.


OK, I wrote all that to show you my confusion. I don't think asking
any single questions will help understanding that. Is there any
documentation I could read to get any basic understanding of ssb?


P.S.
Even one more thing: try to guess by function's name what can it be
responsible for: "ssb_bus_ssbbus_register". It is used by some
/arch/mips/bcm47xx/setup.c, but I can not image digging into next
driver to understand whole architecture :|

-- 
Rafał
