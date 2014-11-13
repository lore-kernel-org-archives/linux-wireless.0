Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296AbaKMUbc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 15:31:32 -0500
Message-ID: <1415910648.27937.72.camel@ul30vt.home> (sfid-20141113_213136_750389_DD52B0E4)
Subject: Qualcomm Atheros AR93xx reset behavior
From: Alex Williamson <alex.williamson@redhat.com>
To: ath9k-devel@qca.qualcomm.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@venema.h4ckr.net,
	Andreas Hartmann <andihartmann@freenet.de>,
	linux-pci <linux-pci@vger.kernel.org>
Date: Thu, 13 Nov 2014 13:30:48 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a question not about the wireless properties of the Atheros
AR93xx, but about the PCIe bus reset behavior.  We have a user reporting
errors with a TP-LINK TL-WDN4800 and I've acquired the same card and
have been able to reproduce the error on two systems.  The problem is
that if we attempt to do a secondary bus reset or link down from the
parent bridge of these devices, the card will throw errors like Surprise
Down and never seems to return to a working state, sometimes throwing
machine checks if we attempt to access config space again.

The reason for attempting bus resets is that we want to use PCI device
assignment to attach the device to a virtual machine.  Performing a bus
reset puts the device in a known state for the VM and clears any guest
state from the device when returning it to the host.  For most devices
this works quite well, especially when the device does not support FLR.
In this case we need to figure out if we need a blacklist mechanism to
avoid bus resets for this device or whether there's a procedure we can
use to create a device specific reset in place of a standard bus reset.

The specific device is:

xx:xx.x Network controller [0280]: Qualcomm Atheros AR93xx Wireless Network Adapter [168c:0030] (rev 01)
        Subsystem: Qualcomm Atheros Device [168c:3112]

Is there anyone with access to hardware specs for this device that can
help?  Perhaps there's an errata on the PCIe interface that might
explain it or some specific steps we can take to make the device behave
for reset.  Thanks!

Alex

