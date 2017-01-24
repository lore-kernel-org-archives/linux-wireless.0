Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:35716 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdAXSMZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 13:12:25 -0500
Received: by mail-pg0-f43.google.com with SMTP id 194so56788731pgd.2
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2017 10:12:20 -0800 (PST)
Date: Tue, 24 Jan 2017 10:12:15 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Linus =?UTF-8?B?TMO8c3Npbmc=?= <linus.luessing@c0d3.blue>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next v5] bridge: multicast to unicast
Message-ID: <20170124101215.4e3017b2@xeon-e3> (sfid-20170124_191229_855228_3C3D27F5)
In-Reply-To: <20170121200133.1864-1-linus.luessing@c0d3.blue>
References: <20170121200133.1864-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 21 Jan 2017 21:01:32 +0100
Linus L=C3=BCssing <linus.luessing@c0d3.blue> wrote:

> +static bool br_port_group_equal(struct net_bridge_port_group *p,
> +				struct net_bridge_port *port,
> +				const unsigned char *src)
> +{
> +	if (p->port !=3D port)
> +		return false;
> +
> +	if (!(port->flags & BR_MULTICAST_TO_UNICAST))
> +		return true;
> +
> +	return ether_addr_equal(src, p->eth_addr);
> +}
> +

I prefer that argument to functions like this be const.
