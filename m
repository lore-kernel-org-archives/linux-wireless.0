Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40947 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932674AbcJYFxV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 01:53:21 -0400
Received: by mail-wm0-f67.google.com with SMTP id b80so254275wme.7
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 22:53:20 -0700 (PDT)
Subject: Re: compex wle900vx (ath10k) problem on 4.4.24 / armv7
To: Matthias Klein <matthias.klein@optimeas.de>,
        Michal Kazior <michal.kazior@tieto.com>
References: <em1c0906d6-d30a-4f2c-bafb-bfec0d18a58d@nb-mak>
 <45bffe7d-8f27-ef26-b7f9-78709e52652f@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Oliver Zemann <oliver.zemann@gmail.com>
Message-ID: <8e1e3a02-9997-390c-8373-c6e1943c9013@gmail.com> (sfid-20161025_075342_755263_2FA4AA15)
Date: Tue, 25 Oct 2016 07:53:18 +0200
MIME-Version: 1.0
In-Reply-To: <45bffe7d-8f27-ef26-b7f9-78709e52652f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I created a patch which should work for 4.4.24 (at least for arch 
> linux arm it applied successful)
>
> Just compiling the kernel... lets see what happens
Did not work. First, there was a + which was wrong, guess i have this 
simply overseen. After fixing that i got:

drivers/pci/pcie/portdrv_pci.c: In function 'pcie_port_runtime_suspend':
drivers/pci/pcie/portdrv_pci.c:98:24: error: 'struct pci_dev' has no 
member named 'bridge_d3'
   return to_pci_dev(dev)->bridge_d3 ? 0 : -EBUSY;
                         ^~
drivers/pci/pcie/portdrv_pci.c: In function 'pcie_port_runtime_idle':
drivers/pci/pcie/portdrv_pci.c:113:24: error: 'struct pci_dev' has no 
member named 'bridge_d3'
   return to_pci_dev(dev)->bridge_d3 ? 0 : -EBUSY;
                         ^~
drivers/pci/pcie/portdrv_pci.c:114:1: warning: control reaches end of 
non-void function [-Wreturn-type]
  }
  ^
drivers/pci/pcie/portdrv_pci.c: In function 'pcie_port_runtime_suspend':
drivers/pci/pcie/portdrv_pci.c:99:1: warning: control reaches end of 
non-void function [-Wreturn-type]
  }
  ^
make[3]: *** [scripts/Makefile.build:259: 
drivers/pci/pcie/portdrv_pci.o] Error 1
make[2]: *** [scripts/Makefile.build:403: drivers/pci/pcie] Error 2
make[1]: *** [scripts/Makefile.build:403: drivers/pci] Error 2
make: *** [Makefile:959: drivers] Error 2
==> ERROR: A failure occurred in build().
     Aborting...

A simple cherry pick does not work in that case.
