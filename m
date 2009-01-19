Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway08.websitewelcome.com ([69.56.236.29]:33406 "HELO
	gateway08.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751439AbZASRiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 12:38:19 -0500
Received: from 96-26-216-101.sea.clearwire-dns.net ([96.26.216.101]:43301 helo=Hydra.darkmatter.org)
	by solstice.websitewelcome.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <Info@delphi-real-estate.com>)
	id 1LOxxO-0006cO-E1
	for linux-wireless@vger.kernel.org; Mon, 19 Jan 2009 11:30:38 -0600
From: Delphi Real Estate <Info@delphi-real-estate.com>
To: linux-wireless@vger.kernel.org
Subject: Kernel Compile Fail with 2.6.26 Drivers
Date: Mon, 19 Jan 2009 09:30:11 -0800
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901190930.11401.Info@delphi-real-estate.com> (sfid-20090119_183825_089043_C11CD1EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Can anyone tell me what I'm doing wrong?  I know that 'n' has problems in later drivers than in kernel 2.6.26, so I am trying to graft the 2.6.26 drivers into the 2.6.27 kernel.  Source:
http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=summary

I moved the regular Ubuntu kernel 2.6.27.10's iwlwifi directory elsewhere, and copied in Reinette's.  But it will not compile, inexplicably:
...
  CC [M]  drivers/pci/hotplug/cpcihp_generic.o
  LD [M]  drivers/pci/hotplug/pciehp.o
  LD [M]  drivers/pci/hotplug/shpchp.o
  CC [M]  drivers/pci/hotplug/fakephp.o
  LD      drivers/pci/hotplug/pci_hotplug.o
  LD [M]  drivers/media/video/uvc/uvcvideo.o
  LD [M]  drivers/pci/hotplug/acpiphp.o
  LD      drivers/pci/hotplug/built-in.o
  LD      drivers/media/built-in.o
  LD      drivers/pci/built-in.o
make: *** [drivers] Error 2
#

This kernel does compile with its normal iwlwifi directory.  In configuring I only set the iwlwifi driver to be a module, disabled the 4965, and enabled the 5000.  I can't use the git kernel because I need the Ubuntu patches.

Is there any other way to get 5GHz 'n'?


