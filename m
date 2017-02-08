Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45036 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753587AbdBHMvP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 07:51:15 -0500
Message-ID: <1486556665.24745.6.camel@sipsolutions.net> (sfid-20170208_135215_784335_45E65081)
Subject: Re: KASAN+netlink, was: [PATCH] [net-next?] hns: avoid stack
 overflow with CONFIG_KASAN
From: Johannes Berg <johannes@sipsolutions.net>
To: Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        nikolay@cumulusnetworks.com, nicolas.dichtel@6wind.com,
        adobriyan@gmail.com,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 08 Feb 2017 13:24:25 +0100
In-Reply-To: <4910112.l20yySyWnA@wuerfel> (sfid-20170208_130733_449950_64BEF84C)
References: <20170203163607.3488037-1-arnd@arndb.de>
         <20170206.120318.1268240226202516488.davem@davemloft.net>
         <4910112.l20yySyWnA@wuerfel> (sfid-20170208_130733_449950_64BEF84C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-08 at 13:03 +0100, Arnd Bergmann wrote:
> 
> - Moving nla_put_{u8,u16,u32} out of line is probably uncontroversial
> and
>   it helps enough with br_netlink.c, but nl820211 is worse and needs
> some
>   additional fiddling.

Why would that not be sufficient by itself for nl80211?

Btw, what's causing this to start with? Can't the compiler reuse the
stack places?

johannes
