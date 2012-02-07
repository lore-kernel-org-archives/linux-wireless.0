Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53513 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973Ab2BGPbB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 10:31:01 -0500
Subject: Re: [RFC 4/4] iwlwifi: use writeb,writel,readl directly
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20120207082232.GD2246@redhat.com>
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
	 <1328544564-8696-4-git-send-email-sgruszka@redhat.com>
	 <1328545972.14547.15.camel@wwguy-ubuntu> <20120207082232.GD2246@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Feb 2012 06:22:48 -0800
Message-ID: <1328624568.7290.52.camel@wwguy-huron> (sfid-20120207_163124_243672_D232338E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-07 at 09:22 +0100, Stanislaw Gruszka wrote:
> On Mon, Feb 06, 2012 at 08:32:52AM -0800, wwguy wrote:
> > I believe iwl driver were use readl/writel before switch to
> > ioread32/iowrite32 (long time ago)
> > 
> > http://www.gossamer-threads.com/lists/linux/kernel/960145
> >
> > also, AFAIK, the readl/writel IO functions still works but their use in
> > new code is discouraged.
> I do not think so, we have tons of drivers that use readl/writel.
> PCI express devices can not use port-based IO, they will be
> incredible slow then.

Agree

> I think confusion come from a fact that iwlwifi use pci_ioremp() for
> mapping registers, which can also maps port-based IO areas. Simply
> changing that into pci_ioremap_bar(), and make driver depend on
> CONFIG_HAS_IOMEM will remove that inconsistency.
> 
> Stanislaw 


