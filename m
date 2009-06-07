Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:24598 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbZFGPLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 11:11:32 -0400
Message-ID: <4A2BD8A5.4040302@hartkopp.net>
Date: Sun, 07 Jun 2009 17:11:33 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-06-04
References: <20090604152011.GC2839@tuxdriver.com> <20090607.033751.191866033.davem@davemloft.net> <4A2BCC41.1060508@hartkopp.net> <20090607145830.GA2736@tuxdriver.com>
In-Reply-To: <20090607145830.GA2736@tuxdriver.com>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Sun, Jun 07, 2009 at 04:18:41PM +0200, Oliver Hartkopp wrote:
>> David Miller wrote:
>>> From: "John W. Linville" <linville@tuxdriver.com>
>>> Date: Thu, 4 Jun 2009 11:20:11 -0400
>>>
>>>> Hopefully this is (almost?) the last wireless pull request for
>>>> non-bugfix patches intended for 2.6.31...
>>>>
>> (..)
>>
>>>> Please let me know if there are problems!
>>> Pulled into net-next-2.6 and I'll push it back out to kernel.org
>>> after some build testing.
>> Hi John,
>>
>> after pulling the latest net-next-2.6 i got this warning which is probably
>> caused by CONFIG_RFKILL=m in my config:
>>
>> hartko@vwagwolkf320:~/net-next-2.6$ make oldconfig
>> scripts/kconfig/conf -o arch/x86/Kconfig
>> .config:614:warning: symbol value 'm' invalid for RFKILL_INPUT
> 
> That functionality is no longer available as a module.  If you need
> it, then select Y.

Just some additional nitpicking:

You should update net/rfkill/Kconfig as it still allows a tristate selection
for RFKILL and the comment "To compile this driver as a module ..." should be
removed also.

Regards,
Oliver

