Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2020 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760135AbZJNVPC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 17:15:02 -0400
Subject: Re: Error Installing 'iw'
From: Pavel Roskin <proski@gnu.org>
To: Pramono Tunggul <Pramono.tunggul@infi-nity.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4AD4CC94.1030407@infi-nity.com>
References: <4AD4CC94.1030407@infi-nity.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Oct 2009 17:14:17 -0400
Message-Id: <1255554857.3031.5.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-10-14 at 01:53 +0700, Pramono Tunggul wrote:
> Guyz, when I try to start airmon-ng, it said that I have to install iw,
> so I download and install iw but I have never succeed to install iw,
> 
> PACKAGE_CONFIG_PATH=/usr/lib
> export PACKAGE_CONFIG_PATH

Maybe you meant to set PKG_CONFIG_PATH, as described in README?

> make
> 
> CC iw.o
> In file included from /usr/local/include/netlink/netlink.h:23,
> from /usr/include/netlink/genl/genl.h:15,
> from iw.c:17:
> /usr/local/include/netlink/netlink-kernel.h:222: error: expected 
> specifier-qualifier-list before ‘__u32’

First of all, libnl is still found in /usr/local/lib, not in /usr/lib,
in case it was your intention.

There is no line 222 in netlink-kernel.h from libnl 1.1.  Perhaps you
are using an old version of libnl?  I suggest that you try version 1.1.

-- 
Regards,
Pavel Roskin
