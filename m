Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49901 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbZHQKYC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 06:24:02 -0400
Date: Mon, 17 Aug 2009 13:23:54 +0300
From: Jouni Malinen <j@w1.fi>
To: Christian Felsing <hostmaster@taunusstein.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Multiple BSSID problem with hostapd
Message-ID: <20090817102354.GA19258@jm.kir.nu>
References: <4A73F9CB.8000606@taunusstein.net> <4A75333D.9070100@taunusstein.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A75333D.9070100@taunusstein.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 02, 2009 at 08:33:33AM +0200, Christian Felsing wrote:
> After investigating source code following function caused my problem:
> 
> static int i802_bss_add(void *priv, const char *ifname, const u8 *bssid)
> {
>         int ifidx;
> 
>         /*
>          * The kernel supports that when the low-level driver does,
>          * but we currently don't because we need per-BSS data that
>          * currently we can't handle easily.
>          */
>         return -1;

Some more investigation would show that this does not exist in the
hostapd development branch..

> Obviously hostapd does not support multiple SSIDs because that function
> returns always an error.

That is the case for hostapd 0.6.9. In any case, there are number of new
kernel features that may not be fully supported by the 0.6.x branch and
checking the current development branch (0.7.x) would be a good idea
when advanced AP functionality is desired.

-- 
Jouni Malinen                                            PGP id EFC895FA
