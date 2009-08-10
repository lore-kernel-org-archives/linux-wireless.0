Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:45169 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbZHJR3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 13:29:10 -0400
Message-ID: <4A8058D7.7070106@hartkopp.net>
Date: Mon, 10 Aug 2009 19:28:55 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
CC: netdev@vger.kernel.org, linux-zigbee-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, Sergey Lapin <slapin@ossfans.org>,
	Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] ieee802154: add virtual loopback driver
References: <1249913800-10176-1-git-send-email-dbaryshkov@gmail.com> <1249913800-10176-2-git-send-email-dbaryshkov@gmail.com> <1249913800-10176-3-git-send-email-dbaryshkov@gmail.com>
In-Reply-To: <1249913800-10176-3-git-send-email-dbaryshkov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dmitry Eremin-Solenikov wrote:
> fakelb is a virtual loopback driver implementing one or several
> interconnected radios. 

> +
> +static int radios = 3;
> +module_param(radios, int, 0444);
> +MODULE_PARM_DESC(radios, "Number of simulated radios");
> +


> +
> +	for (i = 0; i < radios; i++) {
> +		err = ieee802154fake_add_priv(&pdev->dev, priv);
> +		if (err < 0)
> +			goto err_slave;
> +	}
> +

Hi Dimtry,

creating software networking devices like this is IMO not state-of-the-art for
 kernel inclusion.

Please use the NETLINK interface for creating the virtual loopback drivers,
like e.g. the virtual CAN driver (drivers/net/can/vcan.c) does.

Regards,
Oliver
