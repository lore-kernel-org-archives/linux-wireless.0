Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:48901 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab2CSVv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 17:51:59 -0400
Date: Mon, 19 Mar 2012 21:51:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>
Message-ID: <20120319215154.GA18508@srcf.ucam.org> (sfid-20120319_225203_372020_0F7C1537)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bcc: 
Subject: brcmsmac hangs machine if loaded after busmastering disabled
Reply-To: 

I'm dealing with a platform with some buggy system firmware that enables 
DMA on the wireless card and leaves it running even after OS handover, 
triggering memory corruption. I'm working around that by disabling bus 
mastering on the device in the bootloader, but that results in the 
system hanging during brcmsmac init. pci_set_master() is being called in 
the bcma code, so it's nothing that straghtforward. Any idea what might 
be going wrong here?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
