Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out25.alice.it ([85.33.2.25]:2770 "EHLO
	smtp-out25.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbXF2T1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 15:27:23 -0400
From: Matteo Croce <rootkit85@yahoo.it>
To: Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [PATCH 0/5] airo fixes (take 3)
Date: Fri, 29 Jun 2007 21:27:11 +0200
References: <20070629131841.6658.76381.stgit@localhost.localdomain>
In-Reply-To: <20070629131841.6658.76381.stgit@localhost.localdomain>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200706292127.11418.rootkit85@yahoo.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 29 June 2007 15:33:25 you wrote:
> Hi,
>
> here are some fixes for the airo driver:
>
> airo: disable the PCI device when unloading module
> airo: delay some initialization until the netdev is up
> airo: fix a race causing initialization failures
> airo: simpler calling convention for enable_MAC()
> airo: start with radio off
>
> I don't think my "take 2" series ever made it to the list or to any of you.
> I had some email problems. That series did not include the last patch,
> because Matteo Croce reported problems with it. I believe I fixed it now.
>
> Special note for Matteo:
>  You had a problem applying patches included in email bodies instead of
>  attachments...
>  I see that you are using KMail. I believe in KMail you can right-click on
> a message, choose "Save As..." and save the whole email in mbox format and
> treat the resulting file as a patch. The patch program should be clever
> enough to ignore the text preceding the patch itself.
>
> Michal

Thanks, it works very well even when loading another driver before:

forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
airo(): Probing for PCI adapters
eth0: forcedeth.c: subsystem: 0147b:1c12 bound to 0000:00:0a.0
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
ACPI: PCI Interrupt 0000:05:08.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:05:08.0 to 64
airo(): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
airo(): Doing fast bap_reads
airo(): WPA is supported.
airo(eth0): MAC enabled 0:d:29:4f:c:be
airo(): Finished probing for PCI adapters

Cheers,
Matteo Croce
