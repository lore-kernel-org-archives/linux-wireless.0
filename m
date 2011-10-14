Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:27855 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab1JNPLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 11:11:20 -0400
Date: Fri, 14 Oct 2011 11:11:03 -0400
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
Message-ID: <20111014111103.5658d4aa@mj> (sfid-20111014_171124_075652_0278EA9B)
In-Reply-To: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 08 Oct 2011 17:28:42 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> +static inline void htol16_buf(u16 *buf, unsigned int size)
> +{
> +	size /= 2;
> +	while (size--)
> +		*(__le16 *)(buf + size) = cpu_to_le16(*(buf + size));
>  }

I'm not not sure compilers would optimize it out on little-endian
systems.  Perhaps you want a define that uses this code on
big-endian systems and does nothing on little endian systems.

Also, it would be nice to have a compile-time check that size is even.
Or maybe size should be the number of 16-bit words, but then it would be
better to call the argument "count" or something like that.

-- 
Regards,
Pavel Roskin
