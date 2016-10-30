Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35953 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbcJ3JII (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Oct 2016 05:08:08 -0400
Received: by mail-wm0-f50.google.com with SMTP id p190so94251759wmp.1
        for <linux-wireless@vger.kernel.org>; Sun, 30 Oct 2016 02:08:08 -0700 (PDT)
Received: from localhost.localdomain (127.7.150.83.ftth.as8758.net. [83.150.7.127])
        by smtp.gmail.com with ESMTPSA id e5sm18450138wma.10.2016.10.30.02.08.06
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Oct 2016 02:08:06 -0700 (PDT)
Subject: Re: compex wle900vx (ath10k) problem on 4.4.24 / armv7
References: <em1c0906d6-d30a-4f2c-bafb-bfec0d18a58d@nb-mak>
 <386d6f28-9a13-51cc-27ae-0028d517cf27@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Oliver Zemann <oliver.zemann@gmail.com>
Message-ID: <6445d07d-d935-9671-b4fb-5ca7e2b38724@gmail.com> (sfid-20161030_100830_525803_1C0D7234)
Date: Sun, 30 Oct 2016 10:08:06 +0100
MIME-Version: 1.0
In-Reply-To: <386d6f28-9a13-51cc-27ae-0028d517cf27@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



 >> I (naively) went through pci/pm git log and found the following was
 >> applied on 4.7-rc2 (i.e. prior to 4.7 release):
 >>
 >>  commit 006d44e49a259b39947366728d65a873a19aadc0
 >>  Author: Mika Westerberg <mika.westerberg@linux.intel.com>
 >>  Date:   Thu Jun 2 11:17:15 2016 +0300
 >>
 >>      PCI: Add runtime PM support for PCIe ports
 >>
 >> From reading the commit log it seems to me like it could be it.
 >>
 >> ath10k tries to wake up the device during probing before it starts
 >> talking to it and it does so through MMIO/PCI config space. If it's
 >> not mapped properly then driver will not be able to wake it up and
 >> will timeout waiting for it.
 >>
 >> Can you try cherry-picking it into your 4.4.24 and see if it helps?
 >>
 >>
 > Thanks for the help!
 >
 > Until now I did not compile a kernel for the board.
 > I will give it a try and come back with the results ...
 >
 >
 > Best regards,
 > Matthias
 >
  good news, just got a message from the support with a quote from one 
of their developers:
  Have the customer that needs support for the ath cards to use this 
branch. https://github.com/SolidRun/linux-stable/tree/linux-4.4.y-marvell
  note that the device-tree is board specific and for now they should 
create a symlink from their board file to armada-388-clearfog.dtb

  when i look at the change, 
https://github.com/SolidRun/linux-stable/commit/e12aa24ca56ca773b5c59a3cc2915b4e82e6be18 
this looks exactly like the problem we had :)

  I will try this today.

  Regards
  Oli
