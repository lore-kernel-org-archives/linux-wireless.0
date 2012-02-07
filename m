Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765Ab2BGIWh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 03:22:37 -0500
Date: Tue, 7 Feb 2012 09:22:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 4/4] iwlwifi: use writeb,writel,readl directly
Message-ID: <20120207082232.GD2246@redhat.com> (sfid-20120207_092240_998257_3FF8630D)
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
 <1328544564-8696-4-git-send-email-sgruszka@redhat.com>
 <1328545972.14547.15.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1328545972.14547.15.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 06, 2012 at 08:32:52AM -0800, wwguy wrote:
> I believe iwl driver were use readl/writel before switch to
> ioread32/iowrite32 (long time ago)
> 
> http://www.gossamer-threads.com/lists/linux/kernel/960145
>
> also, AFAIK, the readl/writel IO functions still works but their use in
> new code is discouraged.
I do not think so, we have tons of drivers that use readl/writel.
PCI express devices can not use port-based IO, they will be
incredible slow then.

I think confusion come from a fact that iwlwifi use pci_ioremp() for
mapping registers, which can also maps port-based IO areas. Simply
changing that into pci_ioremap_bar(), and make driver depend on
CONFIG_HAS_IOMEM will remove that inconsistency.

Stanislaw 
