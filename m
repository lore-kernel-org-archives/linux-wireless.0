Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39329 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab0F2PVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 11:21:48 -0400
MIME-Version: 1.0
In-Reply-To: <1277793487-9071-1-git-send-email-rmanoharan@atheros.com>
References: <1277793487-9071-1-git-send-email-rmanoharan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 29 Jun 2010 08:21:28 -0700
Message-ID: <AANLkTikLB4nxUzUAlVeKDC3owHYCIqmBba-JbsFkrIJn@mail.gmail.com>
Subject: Re: [PATCH] compat: Fix panic caused by NULL pointer derefence in
	rtnl_fill_ifinfo
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 28, 2010 at 11:38 PM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> get stats netdev ops is blindy called for older kernels (< 2.6.29) and
> so assigning a NULL pointer from netdev_attach_ops causes a NULL pointer
> dereference.
>
> By default, netdev alloc provides an internal stats reference. So fill
> this only if ndo_get_stats is defined.
>
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> ---
>  compat/compat-2.6.29.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/compat/compat-2.6.29.c b/compat/compat-2.6.29.c
> index f94aed8..2e7e623 100644
> --- a/compat/compat-2.6.29.c
> +++ b/compat/compat-2.6.29.c
> @@ -35,7 +35,8 @@ void netdev_attach_ops(struct net_device *dev,
>        dev->change_mtu = ops->ndo_change_mtu;
>        dev->set_mac_address = ops->ndo_set_mac_address;
>        dev->tx_timeout = ops->ndo_tx_timeout;
> -       dev->get_stats = ops->ndo_get_stats;
> +       if (ops->ndo_get_stats)
> +               dev->get_stats = ops->ndo_get_stats;

If ops->ndo_get_stats is NULL then dev->get_stats will be set to NULL.
Do you know for sure this fixes something? If so can you explain how?
I used to have a macro that checked for not NULL and if true set the
callback but then later realized after Johannes poked me that this is
silly given that if the op is NULL you are just setting it to NULL.

I don't see the potential crash here.

  Luis
