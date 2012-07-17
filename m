Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21868 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab2GQUuR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 16:50:17 -0400
Message-ID: <5005D008.6060103@intel.com> (sfid-20120717_225022_820682_6DE252D7)
Date: Tue, 17 Jul 2012 13:50:16 -0700
From: John Fastabend <john.r.fastabend@intel.com>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mark.d.rustad@intel.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: That's pretty much it for 3.5.0
References: <DD369258-0958-4965-8E75-F6939892072D@intel.com> <5005B643.2080009@intel.com> <5005B881.8010505@intel.com> <20120717.122459.2240133900020140698.davem@davemloft.net>
In-Reply-To: <20120717.122459.2240133900020140698.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/17/2012 12:24 PM, David Miller wrote:
> From: John Fastabend <john.r.fastabend@intel.com>
> Date: Tue, 17 Jul 2012 12:09:53 -0700
>
>> although we don't have an early_init hook for netprio_cgroup so this
>> is probably not correct.
>
> The dependency is actually on net_dev_init (a subsys_initcall) rather
> than a pure_initcall.
>
> net_dev_init is what registers the netdev_net_ops, which in turn
> initializes the netdev list in namespaces such as &init_net
>

Ah right thanks sorry for the thrash. I guess we need to check if the
netdev list in the init_net namespace is initialized.
