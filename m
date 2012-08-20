Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:31942 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757011Ab2HTPN4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 11:13:56 -0400
Date: Mon, 20 Aug 2012 11:13:21 -0400
From: Pavel Roskin <proski@gnu.org>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Per sta interfaces in WDS (4-address) mode
Message-ID: <20120820111321.71c6f07e@mj> (sfid-20120820_171404_008520_6E0C8191)
In-Reply-To: <CAHNKnsRVh_BXqW0CLfxO5WZCJ8UH7O=cHN-zh7AuM_pQj0xUqg@mail.gmail.com>
References: <CAHNKnsRVh_BXqW0CLfxO5WZCJ8UH7O=cHN-zh7AuM_pQj0xUqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 19 Aug 2012 21:51:27 +0400
Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:

> Hello dear all,
> 
> please tell me, why in the WDS mode, the stack creates a new interface
> for each WDS station, and this interface hostapd adds to the parent AP
> interface bridge? Why we couldn't simply pass this frames via AP
> interface?

You may want to use a completely different IP address and netmask on the
WDS interface.  Using the AP interface would take away that option.

hostapd is not a part of the kernel.  It should be possible not to add
WDS interfaces to the bridge.

-- 
Regards,
Pavel Roskin
