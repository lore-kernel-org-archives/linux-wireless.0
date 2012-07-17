Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:44383 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab2GQX1z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 19:27:55 -0400
Message-ID: <5005F4F9.6010208@intel.com> (sfid-20120718_012806_776942_3F476D02)
Date: Tue, 17 Jul 2012 16:27:53 -0700
From: John Fastabend <john.r.fastabend@intel.com>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mark.d.rustad@intel.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: That's pretty much it for 3.5.0
References: <5005D008.6060103@intel.com> <20120717.140241.1599386555723262095.davem@davemloft.net> <5005E390.7020706@intel.com> <20120717.151832.1306978935355646723.davem@davemloft.net>
In-Reply-To: <20120717.151832.1306978935355646723.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/17/2012 3:18 PM, David Miller wrote:
> From: John Fastabend <john.r.fastabend@intel.com>
> Date: Tue, 17 Jul 2012 15:13:36 -0700
>
>> Perhaps the easiest way is to check net->count this should be zero
>> until setup_net is called.
>>
>> if (!atomic_read(&init_net.count))
>> 	return ret;
>>
>
> Won't work, setup_net() runs via a pure_initcall().
>

Why not must have missed something? cgroup_init() and
cgroup_early_init() both run before _initcall() routines are
called via kernel_init() so this will stop the update in
netprio from occurring.

And I don't see any race elsewhere for this.
