Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62985 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab2BGHEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 02:04:25 -0500
Received: by werb13 with SMTP id b13so4793919wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 23:04:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120206223447.GE31938@ubuntu-macmini>
References: <20120203222818.GA3749@ubuntu-mba>
	<4F2D0C07.1010704@broadcom.com>
	<20120204142502.GA10858@ubuntu-mba>
	<CACna6ryR2xm2EAJaV4vCO8WebR5pXCyFknEMrf8ynVF+HYrxTw@mail.gmail.com>
	<20120206173757.GC31938@ubuntu-macmini>
	<4F302647.2070102@hauke-m.de>
	<20120206223447.GE31938@ubuntu-macmini>
Date: Tue, 7 Feb 2012 08:04:24 +0100
Message-ID: <CACna6rx7E9tM82iyYP=eRnTU+QZA1rMfdk8vNnX5k1_jbc5DqQ@mail.gmail.com> (sfid-20120207_080429_512263_451DCFE6)
Subject: Re: BCM4331 fails to associate after suspend
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Arend van Spriel <arend@broadcom.com>,
	Scott Sanbar <scott.sanbar@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/2/6 Seth Forshee <seth.forshee@canonical.com>:
> On Mon, Feb 06, 2012 at 08:13:11PM +0100, Hauke Mehrtens wrote:
>> According to the Broadcom SDK for SoCs bcma_pcicore_serdes_workaround()
>> should be called when coming out of standby/hibernate.
>> The code wl uses to do the same thing as bcma does is open source. You
>> find it in the GPL package of many Broadcom based Wifi Routers.
>
> Thanks for the suggestion. Unfortunately calling
> bcma_pcicore_serdes_workaround() during resume doesn't help. I'll look
> at the wl code to see if I can learn anything there.

Can you try


diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index febbc0a..a097a26 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -267,6 +267,13 @@ int bcma_bus_resume(struct bcma_bus *bus)
                bcma_core_chipcommon_init(&bus->drv_cc);
        }

+       /* Init PCIE core */
+       core = bcma_find_core(bus, BCMA_CORE_PCIE);
+       if (core) {
+               bus->drv_pci.setup_done = false;
+               bcma_core_pci_init(&bus->drv_pci);
+       }
+
        list_for_each_entry(core, &bus->cores, list) {
                struct device_driver *drv = core->dev.driver;
                if (drv) {
