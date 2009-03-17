Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 8bytes.org ([88.198.83.132]:39084 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbZCQIIz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 04:08:55 -0400
Date: Tue, 17 Mar 2009 08:45:02 +0100
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mcgrof@gmail.com, iommu@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: AMD Quad core - PCI-DMA: Out of IOMMU space on > 4 GB RAM
Message-ID: <20090317074501.GQ2125@8bytes.org> (sfid-20090317_090858_969543_576E6784)
References: <43e72e890903161215u343cbb19v6d6cbf36794e252a@mail.gmail.com> <20090317093445G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090317093445G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 17, 2009 at 09:35:45AM +0900, FUJITA Tomonori wrote:
> From a quick look, ath9k doesn't call pci_unmap_single for rx
> buffers. Though I might be wrong because I don't know anything about
> the driver.

In any case. This error description sounds very much like a dma memory
leak on module unload. So its very likely a driver issue.

Joerg

