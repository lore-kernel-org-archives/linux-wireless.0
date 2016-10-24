Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from obi-wan.optimeas.de ([82.165.198.204]:57851 "EHLO
        obi-wan.optimeas.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757347AbcJXMIx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 08:08:53 -0400
From: "Matthias Klein" <matthias.klein@optimeas.de>
To: "Michal Kazior" <michal.kazior@tieto.com>
Subject: Re[2]: compex wle900vx (ath10k) problem on 4.4.24 / armv7
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 24 Oct 2016 12:08:50 +0000
Message-Id: <em1c0906d6-d30a-4f2c-bafb-bfec0d18a58d@nb-mak> (sfid-20161024_140856_158970_8F6D26DE)
In-Reply-To: <CA+BoTQkXtEcL9yk8_rYb3Z=CBkzs5R1LyMZfVCbGrsH_3Lx7eg@mail.gmail.com>
Reply-To: "Matthias Klein" <matthias.klein@optimeas.de>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>I (naively) went through pci/pm git log and found the following was
>applied on 4.7-rc2 (i.e. prior to 4.7 release):
>
>  commit 006d44e49a259b39947366728d65a873a19aadc0
>  Author: Mika Westerberg <mika.westerberg@linux.intel.com>
>  Date:   Thu Jun 2 11:17:15 2016 +0300
>
>      PCI: Add runtime PM support for PCIe ports
>
>From reading the commit log it seems to me like it could be it.
>
>ath10k tries to wake up the device during probing before it starts
>talking to it and it does so through MMIO/PCI config space. If it's
>not mapped properly then driver will not be able to wake it up and
>will timeout waiting for it.
>
>Can you try cherry-picking it into your 4.4.24 and see if it helps?
>
>
Thanks for the help!

Until now I did not compile a kernel for the board.
I will give it a try and come back with the results ...


Best regards,
Matthias
