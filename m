Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64796 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZFOKxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 06:53:20 -0400
Message-ID: <4A362893.2060607@tuffmail.co.uk>
Date: Mon, 15 Jun 2009 11:55:15 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: linux-pm@lists.linux-foundation.org
CC: ath5k-devel@lists.ath5k.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-pci@vger.kernel.org
Subject: PCI hotplug v.s. suspend
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I triggered a WARNING while hacking on eeepc-laptop's 
rfkill-by-pci-hotplug.  I saw "Trying to free already-free IRQ" in 
ath5k_pci_remove(), because the IRQ was already freed by 
ath5k_pci_suspend().  My changes to eeepc-laptop had allowed the PCI 
device to be removed while suspended.

Are PCI drivers supposed to handle remove() while suspended?

Thanks
Alan
