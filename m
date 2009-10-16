Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f216.google.com ([209.85.217.216]:52092 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbZJPLUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 07:20:06 -0400
Received: by gxk8 with SMTP id 8so2059179gxk.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 04:19:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910161255.54644.IvDoorn@gmail.com>
References: <200910152137.58164.IvDoorn@gmail.com> <200910152204.16407.IvDoorn@gmail.com>
	<200910161149.11661.sturmflut@lieberbiber.de> <200910161255.54644.IvDoorn@gmail.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Fri, 16 Oct 2009 13:12:32 +0200
Message-ID: <ee588a540910160412x27ad2a37i6b80526dfd99f7ea@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2x00: Implement support for
	rt2800pci
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: users@rt2x00.serialmonkey.com,
	Simon Raffeiner <sturmflut@lieberbiber.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 16, 2009 at 12:55, Ivo van Doorn <ivdoorn@gmail.com> wrote:

> Well the main PCI and DEVICE id's should be listed in the PCI_DEVICE table,
> the SUBSYS ID should only be added in case there can be different drivers
> based on that ID.
>
> As far as the ID 1432:7728, that one was send by Xose who got the ID from
> the Windows driver, I don't know if he has mistakenly grabbed the subsystem ID or not...
> Xose, could you give an update about this?

It came from ralink linux driver.
See 2009_0918_RT2860_Linux_STA_v2.2.0.0/os/linux/pci_main_dev.c:

        {PCI_DEVICE(NIC_PCI_VENDOR_ID, NIC2860_PCI_DEVICE_ID)},
 //RT28602.4G
        {PCI_DEVICE(NIC_PCI_VENDOR_ID, NIC2860_PCIe_DEVICE_ID)},
        {PCI_DEVICE(NIC_PCI_VENDOR_ID, NIC2760_PCI_DEVICE_ID)},
        {PCI_DEVICE(NIC_PCI_VENDOR_ID, NIC2790_PCIe_DEVICE_ID)},
        {PCI_DEVICE(VEN_AWT_PCI_VENDOR_ID, VEN_AWT_PCIe_DEVICE_ID)},
        {PCI_DEVICE(EDIMAX_PCI_VENDOR_ID, 0x7708)},
->>>>>    {PCI_DEVICE(EDIMAX_PCI_VENDOR_ID, 0x7728)},
        {PCI_DEVICE(EDIMAX_PCI_VENDOR_ID, 0x7758)},
        {PCI_DEVICE(EDIMAX_PCI_VENDOR_ID, 0x7727)},
        {PCI_DEVICE(EDIMAX_PCI_VENDOR_ID, 0x7738)},
        {PCI_DEVICE(EDIMAX_PCI_VENDOR_ID, 0x7748)},
        {PCI_DEVICE(EDIMAX_PCI_VENDOR_ID, 0x7768)},

regards,
-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»
