Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pfepa.post.tele.dk ([195.41.46.235]:33063 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbZFGGX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 02:23:27 -0400
Date: Sun, 7 Jun 2009 08:25:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Sergey Lapin <slapin@ossfans.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
	David Miller <davem@davemloft.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 2/5] net: add IEEE 802.15.4 socket family implementation
Message-ID: <20090607062543.GA10730@uranus.ravnborg.org>
References: <cover.1244337432.git.slapin@ossfans.org> <47c250c4bb2069d4faa2d6c5217d1aae15a5bc34.1244337432.git.slapin@ossfans.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47c250c4bb2069d4faa2d6c5217d1aae15a5bc34.1244337432.git.slapin@ossfans.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> --- /dev/null
> +++ b/net/ieee802154/Makefile
> @@ -0,0 +1,4 @@
> +obj-$(CONFIG_IEEE802154) +=	af_802154.o
> +af_802154-objs		:= af_ieee802154.o raw.o dgram.o
> +
> +EXTRA_CFLAGS += -Wall -DDEBUG

Please change this to following style:
> +obj-$(CONFIG_IEEE802154) +=  af_802154.o
> +af_802154-y               := af_ieee802154.o raw.o dgram.o
> +
> +ccflags-y += -Wall -DDEBUG


	Sam
