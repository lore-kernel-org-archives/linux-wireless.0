Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4431 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbbJTEvE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 00:51:04 -0400
Date: Tue, 20 Oct 2015 06:50:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	kernel-janitors@vger.kernel.org,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] NFC: delete null dereference
Message-ID: <20151020045058.GG9764@zurbaran.home> (sfid-20151020_065322_411085_452FC03F)
References: <1445074340-21955-1-git-send-email-Julia.Lawall@lip6.fr>
 <1445074340-21955-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445074340-21955-2-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julia,

On Sat, Oct 17, 2015 at 11:32:19AM +0200, Julia Lawall wrote:
> The exit label performs device_unlock(&dev->dev);, which will fail when dev
> is NULL, and nfc_put_device(dev);, which is not useful when dev is NULL, so
> just exit the function immediately.
> 
> Problem found using scripts/coccinelle/null/deref_null.cocci
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  net/nfc/netlink.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
