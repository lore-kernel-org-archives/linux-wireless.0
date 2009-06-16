Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13238 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897AbZFPBDk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 21:03:40 -0400
Subject: Re: net: fix network drivers ndo_start_xmit() return values (part
 3)
From: Zhu Yi <yi.zhu@intel.com>
To: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Netdev List <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <4A326142.8030905@trash.net>
References: <4A326142.8030905@trash.net>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 09:03:39 +0800
Message-Id: <1245114219.8560.10.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-06-12 at 22:08 +0800, Patrick McHardy wrote:
> commit 1fd73a30c86a658fdc61710b187fda8d6b914ced
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Fri Jun 12 16:02:08 2009 +0200
> 
>     net: fix network drivers ndo_start_xmit() return values (part 3)
>     
>     Fix up wireless drivers that return an errno value to
> qdisc_restart(), causing
>     qdisc_restart() to print a warning an requeue/retransmit the skb.
>     
>     - airo: transmission not implemented for chip, intention is to
> free and abort
>     - ipw2200: transmission not implemented for promiscous mode,
> intention is to
>                drop
>     - prism54: intention is to drop
>     - wl3501_cs: intention appears to be to drop
>     - zd1201: error counter indicates intention is to drop
>     
>     All drivers compile tested.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

ACK for ipw2200 part.

Thanks,
-yi

