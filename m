Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54080 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab2GQTZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 15:25:02 -0400
Date: Tue, 17 Jul 2012 12:24:59 -0700 (PDT)
Message-Id: <20120717.122459.2240133900020140698.davem@davemloft.net> (sfid-20120717_212512_792572_69B7A257)
To: john.r.fastabend@intel.com
Cc: mark.d.rustad@intel.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: That's pretty much it for 3.5.0
From: David Miller <davem@davemloft.net>
In-Reply-To: <5005B881.8010505@intel.com>
References: <DD369258-0958-4965-8E75-F6939892072D@intel.com>
	<5005B643.2080009@intel.com>
	<5005B881.8010505@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John Fastabend <john.r.fastabend@intel.com>
Date: Tue, 17 Jul 2012 12:09:53 -0700

> although we don't have an early_init hook for netprio_cgroup so this
> is probably not correct.

The dependency is actually on net_dev_init (a subsys_initcall) rather
than a pure_initcall.

net_dev_init is what registers the netdev_net_ops, which in turn
initializes the netdev list in namespaces such as &init_net
