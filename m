Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:43701 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750753Ab1JHWif (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 18:38:35 -0400
Message-ID: <1318113514.1844.34.camel@Joe-Laptop> (sfid-20111009_003838_681033_2E95E7F8)
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Sat, 08 Oct 2011 15:38:34 -0700
In-Reply-To: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-10-08 at 17:28 -0500, Larry Finger wrote:
> The kernel now contains library routines to establish crc8 tables and
> to calculate the appropriate sums. Use them for ssb.
[]
> --- wireless-testing-new.orig/drivers/ssb/pci.c
[]
> +static inline void ltoh16_buf(u16 *buf, unsigned int size)

Perhaps a rename and use le16_to_cpup?

> +static inline void htol16_buf(u16 *buf, unsigned int size)

and cpu_to_le16p?


