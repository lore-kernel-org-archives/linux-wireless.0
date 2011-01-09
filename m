Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1AIJrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 04:47:21 -0500
Subject: Re: [PATCH] mwifiex: remove linked list implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1294449014-15078-1-git-send-email-bzhao@marvell.com>
References: <1294449014-15078-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Jan 2011 10:47:17 +0100
Message-ID: <1294566437.5345.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-07 at 17:10 -0800, Bing Zhao wrote:

> +	tx_ba_tsr_tbl = (struct mwifiex_tx_ba_stream_tbl *)
> +					priv->tx_ba_stream_tbl_ptr.next;

Don't do that. Always use list_first_entry() etc, because otherwise the
struct list_head must be the first member in the struct, which is very
non-ideomatic and everybody who is used to the kernel will get it wrong
when modifying your driver.

Treat struct list_head as completely opaque -- never look into it. There
are macros for any kind of manipulation with it.

Also, all your loops are open coded -- use list_for_each_entry() instead
of doing that (even the code I quoted above is from an open coded loop)

johannes

