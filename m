Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:63499 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaDNCT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 22:19:56 -0400
MIME-Version: 1.0
In-Reply-To: <31741678.fEkJSmnf5n@daeseok-laptop.cloud.net>
References: <31741678.fEkJSmnf5n@daeseok-laptop.cloud.net>
Date: Mon, 14 Apr 2014 11:19:56 +0900
Message-ID: <CAHb8M2Bt2+MD_ZKmA89j4bSmmJ--ut-uvXCWj1_1Q2xaKvLEkQ@mail.gmail.com> (sfid-20140414_042007_427967_E9C0F89A)
Subject: Re: [PATCH 2/2] nfc: remove unneeded nfc_put_device() calls
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: David Miller <davem@davemloft.net>, lauro.venancio@openbossa.org
Cc: aloisio.almeida@openbossa.org, sameo@linux.intel.com,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Can you review this patch?

Thanks.
Daeseok Youn

2014-04-02 16:56 GMT+09:00 Daeseok Youn <daeseok.youn@gmail.com>:
>
> If local is NULL, nfs_put_device() is called twice.
> So nfs_put_device() in "if (!local)" is removed.
>
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  net/nfc/netlink.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
> index b2ad570..3e0a676 100644
> --- a/net/nfc/netlink.c
> +++ b/net/nfc/netlink.c
> @@ -1038,7 +1038,6 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
>
>         local = nfc_llcp_find_local(dev);
>         if (!local) {
> -               nfc_put_device(dev);
>                 rc = -ENODEV;
>                 goto exit;
>         }
> --
> 1.7.4.4
>
>
