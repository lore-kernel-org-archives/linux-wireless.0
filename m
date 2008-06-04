Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38587 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbYFDO0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 10:26:36 -0400
Subject: Re: [PATCH] wireless.h: improve userland include-ability
From: David Woodhouse <dwmw2@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080604142307.GA22903@localhost.localdomain>
References: <1212515497-21578-1-git-send-email-linville@tuxdriver.com>
	 <20080603.120515.193703574.davem@davemloft.net>
	 <1212587529.32207.82.camel@pmac.infradead.org>
	 <20080604142307.GA22903@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 15:26:31 +0100
Message-Id: <1212589591.32207.91.camel@pmac.infradead.org> (sfid-20080604_162641_904513_05259BB5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-04 at 17:23 +0300, Kirill A. Shutemov wrote:
> What do you think about hack like this:
> 
> #include <linux/types.h>                /* for __u* and __s* typedefs */
> #if defined(__KERNEL__) || !defined(_SYS_SOCKET_H)
> #include <linux/socket.h>               /* for "struct sockaddr" et al  */
> #endif
> #if defined(__KERNEL__) || !defined(_NET_IF_H)
> #include <linux/if.h>                   /* for IFNAMSIZ and co... */
> #endif
> 
> It avoids conflict between glibc's and kernel's headers if glibc's headers 
> include first.

Anything which is dependent on ordering just makes matters worse, imho.

-- 
dwmw2

