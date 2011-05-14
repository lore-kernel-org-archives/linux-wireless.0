Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35388 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab1ENKXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 06:23:17 -0400
Date: Sat, 14 May 2011 06:23:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, Roland Vossen <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 02/32] staging: brcm80211: new Kconfig item to enable IO
 reordering fix
Message-ID: <20110514102315.GA6842@infradead.org> (sfid-20110514_122320_955761_98156058)
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
 <1305280792-9475-2-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1305280792-9475-2-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 11:59:22AM +0200, Arend van Spriel wrote:
> From: Roland Vossen <rvossen@broadcom.com>
> 
> bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
> transactions. As a fix, a read after write is performed on certain places
> in the code. Older chips and the newer 5357 family don't require this fix.

Is this issue specific to the wireless cores?  It sounds like this is
a general issue with the PCI(e) support on these SOCs, and probably
should be worked around in the architecture specific PCI code.

