Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51281 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbYETNDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 09:03:44 -0400
Subject: Re: [PATCH 1/2] Extend MESH_CONFIG command to access non-volatile
	configuration.
From: David Woodhouse <dwmw2@infradead.org>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	carrano@laptop.org, dilinger@queued.net
In-Reply-To: <48324220.1997600a.4f22.35be@mx.google.com>
References: <48324220.1997600a.4f22.35be@mx.google.com>
Content-Type: text/plain
Date: Tue, 20 May 2008 14:03:41 +0100
Message-Id: <1211288621.21380.211.camel@pmac.infradead.org> (sfid-20080520_150349_081137_3B04F888)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-05-17 at 00:55 -0700, Javier Cardona wrote:
> This patch is based on a patch from Shailendra Govardhan and Brian Cavagnolo.
> It extends the MESH_CONFIG command to configure non-volatile parameters on
> libertas devices that support them (e.g. OLPC Active Antenna).
> 
> This patch only implements the driver/firmware interface.
> 
> See http://dev.laptop.org/ticket/6823 for minimal testing results and known
> issues.

Thanks. That looks much better, modulo a few cosmetic things which I'll
fix up, and this (which I'll also fix):

+               cmd.length = sizeof(struct mrvl_meshie_val);

Sparse would have told you about that, if you built with
'C=2 CF=-D__CHECK_ENDIAN__':

drivers/net/wireless/libertas/cmd.c:1052:14: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/cmd.c:1052:14:    expected restricted unsigned short [addressable] [assigned] [usertype] length
drivers/net/wireless/libertas/cmd.c:1052:14:    got unsigned int 

I'd recommend always testing on a big-endian box, too. Sparse is good,
but no substitute for the real thing.

-- 
dwmw2

