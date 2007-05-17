Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57779 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbXEQIw7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2007 04:52:59 -0400
Date: Thu, 17 May 2007 09:52:54 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Michael Wu <flamingice@sourmilk.net>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
Message-ID: <20070517085254.GA27058@infradead.org>
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200705162151.32910.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 16, 2007 at 09:51:28PM -0400, Michael Wu wrote:
> On Wednesday 16 May 2007 17:45, James Ketrenos wrote:
> > This patch adds the iwlwifi project directory and sources needed to
> > build the mac80211 based wireless drivers for the Intel PRO/Wireless
> > 3945ABG/BG Network Connection and Intel Wireless WiFi Link AGN adapters.
> >
> Looks much better than when I last checked. A few comments:
> 
> - The enter/leave stuff should be removed.
> - Many of the in_interrupt() checks are unnecessary. Jiri recently documented 
> which callbacks need to be atomic - the ones that don't need to be atomic 
> definitely won't be called in an interrupt.

Actually not some but all.  Drivers should never use in_interrupt().

