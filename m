Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbbKZNye (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 08:54:34 -0500
Date: Thu, 26 Nov 2015 14:52:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] rt2x00: type bug in _rt2500usb_register_read()
Message-ID: <20151126135241.GA3111@redhat.com> (sfid-20151126_145453_611270_D6CEBFC6)
References: <20151126115523.GD10556@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151126115523.GD10556@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 26, 2015 at 02:55:23PM +0300, Dan Carpenter wrote:
> This code causes a static checker bug.
> 
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c:232 _rt2500usb_register_read()
> warn: passing casted pointer 'value' to 'rt2500usb_register_read()' 32 vs 16.
> 
> If the low 16 bits were initialized to zero then this code would only be
> a problem on big endian systems.  But in this case this is case the low
> 16 bits are never initialized.  This is called from a function which is
> created using a macro:
> 
> RT2X00DEBUGFS_OPS(csr, "0x%.8x\n", u32);
> 
> We end up copying uninitialized data to the user which is bogus and an
> information leak.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

> ---
> Not tested.  Perhaps we should just remove this code since it has never
> worked.

It is used for debugfs interface and I would like to keep it.

Stanislaw
