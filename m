Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29246 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab3H0Teg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 15:34:36 -0400
Date: Tue, 27 Aug 2013 12:34:33 -0700
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
To: Joe Perches <joe@perches.com>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<e1000-devel@lists.sourceforge.net>,
	<linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
	<users@rt2x00.serialmonkey.com>, jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next] drivers:net: Convert
 dma_alloc_coherent(...__GFP_ZERO) to dma_zalloc_coherent
Message-ID: <20130827123433.00002cb7@unknown> (sfid-20130827_213500_008450_FA624A5E)
In-Reply-To: <1377582323.2658.10.camel@joe-AO722>
References: <dbbfc5e66dba7d2b63549d218407fb0c4031f2ed.1363367992.git.joe@perches.com>
	<1377582323.2658.10.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 26 Aug 2013 22:45:23 -0700
Joe Perches <joe@perches.com> wrote:

> __GFP_ZERO is an uncommon flag and perhaps is better
> not used.  static inline dma_zalloc_coherent exists
> so convert the uses of dma_alloc_coherent with __GFP_ZERO
> to the more common kernel style with zalloc.
> 
> Remove memset from the static inline dma_zalloc_coherent
> and add just one use of __GFP_ZERO instead.
> 
> Trivially reduces the size of the existing uses of
> dma_zalloc_coherent.
> 
> Realign arguments as appropriate.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

e1000 and ixgb bits:

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
