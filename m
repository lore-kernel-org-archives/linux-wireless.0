Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BF2C433FE
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Oct 2022 22:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiJHWgL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 8 Oct 2022 18:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJHWgL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Oct 2022 18:36:11 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4047E100E;
        Sat,  8 Oct 2022 15:36:08 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1665268565; bh=UBsfIk1cg7jUe/HvO/iyiK7+egJdhm8BQh0pnKAGs5E=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=YqyQ0OmiGn9gsYcMYCYt4ZsBV5huzThrVCX01QS04vaAaf/NC7TJJXZIvcz1MranD
         8+Sq4/PRR7B9MIx+jbhaYNPM6DzkvNpLU/TtzAMoRqhJBwLXymGHjx1/5YPkrdtpaC
         Dj/iKDnuhlc2VUxpbGsOjedQO7ZFz9eJ3FJBEMfQN+ad8tUXL2y/urtZXxYeEuHl2n
         h7dcvnfYcXv5rn04P0+ZatvVBLbpg938HCUVy6zyzwOZEmB3OBLD8zWoOaZqiVhbam
         G3ZHVHXZm05lxDqmLQIxMOW7SFv2sxDMdaQKVG/hI9jjzgBunJYUi62n3sao3uBMTL
         5ghPMw85Ew44A==
To:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] ath9k: hif_usb: Fix use-after-free in
 ath9k_hif_usb_reg_in_cb()
In-Reply-To: <20221008114917.21404-1-pchelkin@ispras.ru>
References: <20221008114917.21404-1-pchelkin@ispras.ru>
Date:   Sun, 09 Oct 2022 00:36:05 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87pmf2rlii.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> It is possible that skb is freed in ath9k_htc_rx_msg(), then
> usb_submit_urb() fails and we try to free skb again. It causes
> use-after-free bug. Moreover, if alloc_skb() fails, urb->context becomes
> NULL but rx_buf is not freed and there can be a memory leak.
>
> The patch removes unnecessary nskb and makes skb processing more clear: it
> is supposed that ath9k_htc_rx_msg() either frees old skb or passes its
> managing to another callback function.
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Fixes: 3deff76095c4 ("ath9k_htc: Increase URB count for REG_IN pipe")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
