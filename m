Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:16087 "EHLO
	viefep22-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753278AbYBSLtb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 06:49:31 -0500
Message-ID: <47BAC206.5070304@trash.net> (sfid-20080219_114933_737805_3FD2CF41)
Date: Tue, 19 Feb 2008 12:48:22 +0100
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: joe@perches.com, bruno@thinktube.com, netdev@vger.kernel.org,
	jgarzik@pobox.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] net/8021q/vlan_dev.c - Use print_mac
References: <20080218.125525.192686382.davem@davemloft.net>	<47B9F5E7.3020905@trash.net>	<20080218.164305.67586867.davem@davemloft.net> <20080218.165036.218650084.davem@davemloft.net>
In-Reply-To: <20080218.165036.218650084.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 18 Feb 2008 16:43:05 -0800 (PST)
> 
>> I think we can fix this easily by using __attribute_const_
>> on the print_mac() declaration.  Let me play with that.
> 
> Actually it seems the 'pure' attribute is more important
> here.  Although it's not semantically a perfect match,
> what we need to tell the compiler is basically that:
> 
> 1) the return value depends upon the inputs
> 2) if the input is not used, it's safe to avoid the call
> 
> and 'pure' accomplishes that without any unwanted side-effects.
> 
> I think this will not result in any unwanted over-optimization.
> Because if the inputs change in any way GCC has to emit the
> call.
> 
> Any objections?


This seems fine to me, thanks Dave.
