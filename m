Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38057 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbZLXGY6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 01:24:58 -0500
Subject: Re: iwlwifi
From: Zhu Yi <yi.zhu@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20091223.215221.191412308.davem@davemloft.net>
References: <20091223.210818.02262058.davem@davemloft.net>
	 <1261633567.6037.1.camel@debian>
	 <20091223.215221.191412308.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Dec 2009 14:24:56 +0800
Message-ID: <1261635896.6037.26.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-12-24 at 13:52 +0800, David Miller wrote:
> From: Zhu Yi <yi.zhu@intel.com>
> Date: Thu, 24 Dec 2009 13:46:07 +0800
> 
> > I'm trying allmodconfig on wireless-testing now. It takes some time to
> > finish make. But a simple running "make M=drivers/net/wireless/" twice
> > doesn't show this issue.
> > 
> 
> It's the include of generated/utsrelease.h by iwl-core.h that causes
> the rebuild.

Thanks. It was first introduced by below commit. And was later changed
to use generated/utsrelease.h. I'm wondering if we should really use
linux/utsrelease.h (or linux/version.h) or remove the kernel version
totally from the driver version (driver compile tag can be remained).
Any suggestions?

Thanks,
-yi

commit 900bb717424e5df12b1ef7ebb017be2a8915b806
Author: Reinette Chatre <reinette.chatre@intel.com>
Date:   Wed Dec 2 12:53:01 2009 -0800

    iwlwifi: driver version track kernel version
    
    The driver version number is a remnant from when there was an out-of-tree
    iwlwifi driver. Now that the driver forms part of kernel source we do not
    need a separate driver version. Instead, we now use the kernel version as
    driver version. We maintain the previous tags used to indicate which
    components the driver has been compiled with.


