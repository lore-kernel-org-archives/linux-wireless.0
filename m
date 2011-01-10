Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41254 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab1AJQCq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 11:02:46 -0500
Subject: Re: [PATCH] wl12xx: fix some sparse warnings
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1293017932-9806-1-git-send-email-eliad@wizery.com>
References: <1293017932-9806-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 18:02:50 +0200
Message-ID: <1294675370.1992.142.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 12:38 +0100, Eliad Peller wrote:
> Note that wl1271_write32() calls cpu_to_le32() by itself, so calling
> wl1271_write32(addr, cpu_to_le32(val)) is in fact a bug on BE systems.
> 
> Fix the following sparse warnings:
> 
> drivers/net/wireless/wl12xx/cmd.c:662:16: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/wl12xx/cmd.c:662:16:    expected unsigned short [unsigned] [addressable] [usertype] llc_type
> drivers/net/wireless/wl12xx/cmd.c:662:16:    got restricted __be16 [usertype] <noident>
> drivers/net/wireless/wl12xx/cmd.c:674:17: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/wl12xx/cmd.c:674:17:    expected unsigned int [unsigned] [addressable] [usertype] sender_ip
> drivers/net/wireless/wl12xx/cmd.c:674:17:    got restricted __be32 [usertype] ip_addr
> drivers/net/wireless/wl12xx/rx.c:202:4: warning: incorrect type in argument 3 (different base types)
> drivers/net/wireless/wl12xx/rx.c:202:4:    expected unsigned int [unsigned] [usertype] val
> drivers/net/wireless/wl12xx/rx.c:202:4:    got restricted __le32 [usertype] <noident>
> drivers/net/wireless/wl12xx/acx.c:1247:23: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/wl12xx/acx.c:1247:23:    expected restricted __le32 [usertype] ht_capabilites
> drivers/net/wireless/wl12xx/acx.c:1247:23:    got unsigned long
> drivers/net/wireless/wl12xx/acx.c:1250:24: warning: invalid assignment: |=
> drivers/net/wireless/wl12xx/acx.c:1250:24:    left side has type restricted __le32
> drivers/net/wireless/wl12xx/acx.c:1250:24:    right side has type unsigned long
> drivers/net/wireless/wl12xx/acx.c:1253:24: warning: invalid assignment: |=
> drivers/net/wireless/wl12xx/acx.c:1253:24:    left side has type restricted __le32
> drivers/net/wireless/wl12xx/acx.c:1253:24:    right side has type unsigned long
> drivers/net/wireless/wl12xx/acx.c:1256:24: warning: invalid assignment: |=
> drivers/net/wireless/wl12xx/acx.c:1256:24:    left side has type restricted __le32
> drivers/net/wireless/wl12xx/acx.c:1256:24:    right side has type unsigned long
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thank you!


-- 
Cheers,
Luca.

