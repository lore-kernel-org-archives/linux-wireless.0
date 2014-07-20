Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:39502 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbaGTLuB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 07:50:01 -0400
Received: from localhost (localhost [127.0.0.1])
	by arrakis.dune.hu (Postfix) with ESMTP id 5B7FC284244
	for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 13:47:45 +0200 (CEST)
Received: from mail-qg0-f43.google.com (mail-qg0-f43.google.com [209.85.192.43])
	by arrakis.dune.hu (Postfix) with ESMTPSA id 6D800280787
	for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 13:47:35 +0200 (CEST)
Received: by mail-qg0-f43.google.com with SMTP id a108so4519095qge.2
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 04:49:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405854022-11833-2-git-send-email-zajec5@gmail.com>
References: <1405854022-11833-1-git-send-email-zajec5@gmail.com> <1405854022-11833-2-git-send-email-zajec5@gmail.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sun, 20 Jul 2014 13:49:29 +0200
Message-ID: <CAOiHx=mi0jJQycjJSNjJ3rXrjQEB2N6JP3yg6vqcDN82tZHjzg@mail.gmail.com> (sfid-20140720_135006_439713_BB76BADE)
Subject: Re: [PATCH 2/2] b43: N-PHY: support setting custom TX power
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 20, 2014 at 1:00 PM, Rafał Miłecki <zajec5@gmail.com> wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This is based on top of
> [PATCH 7/7] b43: enable radio 0x2057 rev 14 support (AKA BCM43217)
> (not sure if applies cleanly otherwise)
> ---
>  drivers/net/wireless/b43/b43.h   |  1 +
>  drivers/net/wireless/b43/phy_n.c | 88 ++++++++++++++++++++++++++++++++++------
>  drivers/net/wireless/b43/phy_n.h |  3 ++
>  3 files changed, 80 insertions(+), 12 deletions(-)
>

(snip)

> diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
> index 30bec81..252d843 100644
> --- a/drivers/net/wireless/b43/phy_n.h
> +++ b/drivers/net/wireless/b43/phy_n.h
> @@ -967,6 +967,9 @@ struct b43_phy_n {
>         struct b43_phy_n_txpwrindex txpwrindex[2];
>         struct b43_phy_n_pwr_ctl_info pwr_ctl_info[2];
>         struct b43_chanspec txiqlocal_chanspec;
> +       struct b43_ppr *tx_pwr_max_ppr;

Why not just make this a struct member? As far as I can tell, it will
always be allocated, and you would lose one alloc/free call, and
probably one pointer dereference.

> +       u16 tx_pwr_last_recalc_freq;
> +       int tx_pwr_last_recalc_limit;
>
>         u8 txrx_chain;
>         u16 tx_rx_cal_phy_saveregs[11];
> --
> 1.8.4.5


Jonas
