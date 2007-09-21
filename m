Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27240 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbXIUB1e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 21:27:34 -0400
Subject: Re: Please pull 'iwlwifi' branch of wireless-2.6
From: Zhu Yi <yi.zhu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net,
	jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070919101326.GA32432@infradead.org>
References: <20070918185040.GF4940@tuxdriver.com>
	 <20070919101326.GA32432@infradead.org>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 09:20:30 +0800
Message-Id: <1190337630.5718.136.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-09-19 at 11:13 +0100, Christoph Hellwig wrote:
> it really needs to be moved into a directory of it's own.

It used to be... John?

> The useless per-file CFLAGS need to go most places can trivially
> be made unconditional anyway.

OK.

> The depends on m for CONFIG_IWL4965 and CONFIG_IWL3945 needs to go,
> we don't put drivers int that need to be modular. 

Since we splited the code base for 3945 and 4965 by a simple "fork" of
file iwl-base.c, some non-static functions names remain the same. Make
the two drivers build into vmlinux at the same time will cause conflict.
So to make them depend on m is a current workaround for .24. We will
abstract a common iwl-core.ko and make driver specific iwl3945.ko and
iwl4965.ko depend on it in .25 time frame.

Thanks,
-yi
