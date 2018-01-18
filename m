Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33243 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932124AbeARPRv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 10:17:51 -0500
Received: by mail-io0-f178.google.com with SMTP id n7so8722193iob.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jan 2018 07:17:51 -0800 (PST)
From: Kyle Evans <kvans32@gmail.com>
Date: Thu, 18 Jan 2018 12:50:24 -0500
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kyle Evans <kvans32@gmail.com>, linux-wireless@vger.kernel.org
Subject: sdio failure to initialize on warm boot.
Message-ID: <20180118172804.GA1170@localhost.localdomain> (sfid-20180118_161805_608081_9D86A826)
References: <7c73dc36-5b7a-729e-4656-b45839c1360d@gmail.com>
 <5A55D325.60805@broadcom.com>
 <3842a299-cd14-65db-1222-6849bc95ef74@gmail.com>
 <5A59CF17.6040706@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A59CF17.6040706@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Arend van Spriel <arend.vanspriel@broadcom.com>:
> On 1/12/2018 9:18 PM, Kyle Evans wrote:
> > 2) After reboot I get this nasty error...
> > [    0.000000] Kernel command line: console=tty0 selinux=0
> > video=1280x800 root=/dev/mmcblk1p1 brcmfmac.bebug=0x20000
> > [    2.269750] mmc0: Invalid maximum block size, assuming 512 bytes
> > [    2.330010] mmc0: SDHCI controller on c8000000.sdhci [c8000000.sdhci]
> > using ADMA
> > [    2.645242] mmc0: error -110 whilst initialising SDIO card
> 
> Ok. I suppose you mean a warm reboot. So I suppose the card is not 
> properly power cycled. If your SDHCI controller driver (is it 
> sdhci-acpi?) is loaded as a module, you could try to unload it and load 
> it again. Let me know if that works for you to confirm my guess.

Your guess is correct. The following brings up wifi after failure to do 
so during warm boot.

modprobe -r sdhci-tegra; modprobe sdhci-tegra;

-Kyle
