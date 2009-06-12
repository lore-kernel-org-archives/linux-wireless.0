Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([204.127.217.105]:45580 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbZFLOe0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 10:34:26 -0400
Message-ID: <4A326771.6030301@lwfinger.net>
Date: Fri, 12 Jun 2009 09:34:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Fabio A. Correa" <facorread@gmail.com>
CC: bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: 4311 not detected at all
References: <ec2083b20906120654j370e5bdo724a7c3b6d505a6c@mail.gmail.com>
In-Reply-To: <ec2083b20906120654j370e5bdo724a7c3b6d505a6c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fabio A. Correa wrote:
> Hello there, you are a great team and I thank you for bringing this
> excellent piece of software to us. Keep the work up.
> 
> Given the features that you report in the source code, I am anxious to
> give it a try under linux-2.6.30. I have been working with ndiswrapper
> in the past, because bcm43xx did not fit my needs. I have compiled the
> 2.6.30 kernel tens of times with different settings for PHY, SSB and
> B43. However, PHY and SSB do not show signs of life and B43 only show
> its presentation line in the syslog.
> 
> Would you please help me find a cause for this silence? Thank you very much.

There are three areas in your dmesg output that attracted my attention:

ACPI: BIOS bug: multiple APIC/MADT found, using 0
ACPI: If "acpi_apic_instance=2" works better, notify
linux-acpi@vger.kernel.org

Have you tested this boot parameter?

Later there is this output:

pci 0000:00:1c.0: BAR 7: can't allocate resource
pci 0000:00:1c.0: BAR 8: can't allocate resource
pci 0000:00:1c.1: BAR 7: can't allocate resource
pci 0000:00:1c.1: BAR 8: can't allocate resource
pci 0000:00:1c.2: BAR 7: can't allocate resource
pci 0000:00:1c.2: BAR 8: can't allocate resource
pci 0000:06:00.0: BAR 0: can't allocate resource

and later:

b43-pci-bridge 0000:06:00.0: device not available because of BAR 0
[0x000000-0x003fff] collisions
b43-pci-bridge: probe of 0000:06:00.0 failed with error -22

So, the BAR problem is preventing ssb from loading, thus b43 cannot
function. If the "acpi_apic_instance=2" option does not fix the
problem, then you need to post this problem on the Linux Kernel
Mailing List.

The bottom line is that a BIOS error is likely the problem with BAR
allocation on your machine. Have you checked to see if an updated one
is available?

Larry

