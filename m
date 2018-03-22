Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36714 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752527AbeCVBng (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 21:43:36 -0400
Received: by mail-qk0-f178.google.com with SMTP id d206so7637026qkb.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2018 18:43:36 -0700 (PDT)
MIME-Version: 1.0
From: Mohamed Khalfella <khalfella@gmail.com>
Date: Wed, 21 Mar 2018 19:43:35 -0600
Message-ID: <CAMaOPvZCg0YMzhR2KR7dMTkuphV2T-mDtyageaJPr+cB5jGbCQ@mail.gmail.com> (sfid-20180322_024345_303463_BED30831)
Subject: Intel Corporation Wireless 8260 [8086:24f3] (rev 3a) - Hardware error
 in PCI passthrough
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am working in pci passthrough for qemu under SmartOS. My test
machine is Intel NUC Kit NUC6i3SYH BOXNUC6I3SYH which comes with Intel
Wireless 8260 [8086:24f3]. So far the guest OS recognize the PCI
device and the driver, iwlwifi reports an error when it tries to
initialize the device.

Here is what I see in linux guest console https://pastebin.com/cCzEUgGz.
lspci from the guest OS https://pastebin.com/pPS7c1HT
lspci from the host OS, running the same iso image
https://pastebin.com/xLTpw9fz. Host OS regencies the device perfectly.

I did mmio tracing and here are the results
https://docs.google.com/spreadsheets/d/1GFW1JTA9Q5OVh4CQMYYHSQ378j45nP078juewogBIp0/edit?usp=sharing.
For some reason, which I don't know, the guest gets different result
when it reads register 3C. I don't know why does that happen.

My implementation doesn't present PCI extended capabilities, I am not
sure if this is stopping the device to work or not.

Unfortunately, I don't have the device specification to dig deeper
into the issue. The code I am working on is accessible in upci branch
in

upci driver https://github.com/khalfella/illumos-gate
qemu https://github.com/khalfella/illumos-kvm-cmd

Appreciate any hints or ideas.


Thanks,
Mohamed A. Khalfella
