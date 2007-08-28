Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3987 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbXH1HbI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 03:31:08 -0400
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
From: Zhu Yi <yi.zhu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <20070827131026.GA21137@infradead.org>
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070827131026.GA21137@infradead.org>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 15:25:44 +0800
Message-Id: <1188285945.13078.242.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-08-27 at 14:10 +0100, Christoph Hellwig wrote:
> Btw, strong NACK from me until you sort out the mess with the common
> files. Including C files with cpp symbols defined or not is not how we
> do driver development in Linux.  Please split out really common code
> into common files, and build driver specific code into files of it's
> own.  Having a slight amount of duplicated code is much better than
> having such a mess for maintaince.

It's not a "slight amount" of duplicated code.

$ expr `grep -e '^{$' iwl-base.c |wc -l` - ` sed -e '/^{$/,/^}$/{/#if
IWL == /,/^}$/d}' iwl-base.c |grep -e '^}$' |wc -l`
34

Additional 34 functions have to be splited out from iwl-base.c into
their own hardware specific files. If you look at the code, most of
these functions are only with little difference which are caused by the
difference of the hardware. In the future, when we add new hardware
support for iwlwifi, it's more maintainable to extend the current
functions with new hardware difference than copy all the 34 functions
into a new file and only make slight changes to each of them.

I know the method is not common used in the Linux drivers, but this is
decided by the hardware layout. For 3945 and 4965, 90% of the
hardware/firmware layout are the same and only 10% are different. This
makes it possible to support two slightly differs hardwares in one
driver. If the hardwares differ a lot (i.e 2100 and 2200), I won't even
think about to do it in this way.

Thanks,
-yi
