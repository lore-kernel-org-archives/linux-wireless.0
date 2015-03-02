Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49302 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbbCBJQ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 04:16:29 -0500
Message-ID: <1425287785.1906.0.camel@sipsolutions.net> (sfid-20150302_101633_797520_DE8205BA)
Subject: Re: [PATCH 2/3] ath10k: always save/restore pci config space
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Mon, 02 Mar 2015 10:16:25 +0100
In-Reply-To: <1425287344-30594-2-git-send-email-michal.kazior@tieto.com> (sfid-20150302_101036_254852_C8CA7C94)
References: <1425287344-30594-1-git-send-email-michal.kazior@tieto.com>
	 <1425287344-30594-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150302_101036_254852_C8CA7C94)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-02 at 10:09 +0100, Michal Kazior wrote:
> The check isn't really necessary and couldn't even
> work because becase pci_restore_state() restores
> only first 64 bytes of PCI configuration space.
> 
> This is necessary for future WoWLAN support.

> +	pci_save_state(pdev);
> +	pci_disable_device(pdev);

I believe the whole thing isn't necessary at all since the kernel's PCIe
layer will take care of it.

johannes

