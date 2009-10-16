Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:40179 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZJPK4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 06:56:33 -0400
Received: by ewy4 with SMTP id 4so1447314ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 03:55:56 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2x00: Implement support for rt2800pci
Date: Fri, 16 Oct 2009 12:55:54 +0200
Cc: Simon Raffeiner <sturmflut@lieberbiber.de>,
	linux-wireless@vger.kernel.org,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <200910152137.58164.IvDoorn@gmail.com> <200910152204.16407.IvDoorn@gmail.com> <200910161149.11661.sturmflut@lieberbiber.de>
In-Reply-To: <200910161149.11661.sturmflut@lieberbiber.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910161255.54644.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I was comparing rt2800pci and the INF file of the original RT2860 windows 
> driver out curiosity. The original INF file contains 108 PCI id entries, 
> rt2800pci.c only 20. At first I thought that an entry like 
> 
> PCI\VEN_1814&DEV_0601&SUBSYS_77281432
> 
> (Edimax card) in the INF file will be automatically matched by rt2800pci for 
> the "1814:0601" vendor/device id, but then I found an additional entry for 
> "1432:7728" (the susbsystem id) in the rt2800pci pci_device_id table. 
> 
> I am a bit confused: Should every entry from the INF file have a PCI_DEVICE() 
> counterpart in our driver (resulting in 108 entries), or is this a special 
> case where the Manufacturer (Edimax) produces cards that actually have 
> "1432:7728" as vendor/device id.
> 
> You can probably tell that I don't have much experience developing kernel 
> drivers, but I am willing to get it right.

Well the main PCI and DEVICE id's should be listed in the PCI_DEVICE table,
the SUBSYS ID should only be added in case there can be different drivers
based on that ID.

As far as the ID 1432:7728, that one was send by Xose who got the ID from
the Windows driver, I don't know if he has mistakenly grabbed the subsystem ID or not...
Xose, could you give an update about this?

Ivo
