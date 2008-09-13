Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46067 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbYIMNY1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2008 09:24:27 -0400
Message-ID: <20080913092425.9yzzmpzysoc0ggkc-cebfxv@webmail.spamcop.net> (sfid-20080913_152436_113967_534859E3)
Date: Sat, 13 Sep 2008 09:24:25 -0400
From: Pavel Roskin <proski@gnu.org>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, jt@hpl.hp.com,
	simon@thekelleys.org.uk, jussi.kivilinna@mbnet.fi
Subject: Re: [PATCH] wireless: Read scan flags correctly on x86-64
References: <1221304925-13057-1-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1221304925-13057-1-git-send-email-kilroyd@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting David Kilroy <kilroyd@googlemail.com>:

> The SIOCSIWSCAN handler is passed data in an iw_point structure. Some
> drivers erronously use an iw_param instead.
>
> On 32 bit architectures the difference isn't noticed as the flags
> parameter tends to be the only one used by scan handlers and is at the
> same offset.
>
> On 64 bit architectures the pointer in the iw_point structure means the
> flag parameter is at different offsets in these structures.
>
> Thanks to Jean Tourrilhes for tracking this down for orinoco, and Pavel
> Roskin for confirming the fix and identifying other suspect handlers.
>
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>

Acked-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
