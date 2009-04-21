Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49376 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbZDUOAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 10:00:55 -0400
Date: Tue, 21 Apr 2009 09:57:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rami Rosen <roszenrami@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	Johannes Berg <johannes@sipsolutions.net>, buytenh@marvell.com
Subject: Re: [PATCH ] [RESEND] mwl8: fix build warning.
Message-ID: <20090421135716.GJ17805@tuxdriver.com> (sfid-20090421_160059_150069_912C4084)
References: <b25312890904210622v3b84eb45pdef0cb3bce253ba0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b25312890904210622v3b84eb45pdef0cb3bce253ba0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 21, 2009 at 04:22:01PM +0300, Rami Rosen wrote:
> This patch fixes a build warning in mwl8.c.
> (Marvell TOPDOG wireless driver)
> 
> The warning it fixes is: "large integer implicitly truncated to unsigned type."
> 
> The rx_ctrl member of the mwl8k_rx_desc struct is 8 bit (__u8 ), whereas trying
> to assign it a 32 bit value (which is returned from  cpu_to_le32())
> causes the compiler to issue
> a truncation warning.
> 
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Oh, duh...I should have looked for the obvious answer... :-)

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
