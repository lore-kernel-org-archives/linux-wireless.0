Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:23279 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZKBSBr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 13:01:47 -0500
Message-ID: <4AEF1E7F.50306@oracle.com>
Date: Mon, 02 Nov 2009 10:01:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: linux-next: Tree for November 2 (wireless/wl1271)
References: <20091102173845.210d1c57.sfr@canb.auug.org.au>
In-Reply-To: <20091102173845.210d1c57.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20091030:


wl1271 build fails when CONFIG_INET=n.
Should this driver depend on INET?

Why does this driver, unlike all other wireless drivers,
want to use register_inetaddr_notifier()?

wl1271_main.c:(.text+0x271052): undefined reference to `unregister_inetaddr_notifier'
wl1271_main.c:(.text+0x2714d7): undefined reference to `register_inetaddr_notifier'

-- 
~Randy
