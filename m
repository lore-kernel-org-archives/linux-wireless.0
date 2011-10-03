Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55863 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476Ab1JCS0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 14:26:25 -0400
Received: by qyk7 with SMTP id 7so3953160qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Oct 2011 11:26:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317637758-11907-5-git-send-email-zefir.kurtisi@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <1317637758-11907-5-git-send-email-zefir.kurtisi@neratec.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 3 Oct 2011 11:26:04 -0700
Message-ID: <CAB=NE6XxW_kMnWLkC4dy4naUKaTk_hZi0_F86LNyuk3RNyqNQA@mail.gmail.com> (sfid-20111003_202638_764083_A931250C)
Subject: Re: [RFC 4/6] ath9k: add DFS build parameter
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> ---
>  drivers/net/wireless/ath/ath9k/Kconfig  |    7 +++++++
>  drivers/net/wireless/ath/ath9k/Makefile |    2 ++
>  2 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
> index d9c08c6..adddcca 100644
> --- a/drivers/net/wireless/ath/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> @@ -58,6 +58,13 @@ config ATH9K_RATE_CONTROL
>          Say Y, if you want to use the ath9k specific rate control
>          module instead of minstrel_ht.
>
> +config ATH9K_DFS
> +       bool "Atheros ath9k DFS support"
> +       depends on ATH9K
> +       default y

At this point selecting y does nothing. Leave this patch out until
selecting "y" means something.

Default should be n, and in particular Atheros itself can only likely
commit to supporting DFS for AR9003 when it finds resources to do so
as well as properly test it, so DFS support kconfig should state this.
If someone wants to step up to completely support all bugs for older
families that is their prerogative but we cannot commit to it, due to
the regulatory considerations though unless this happens this cannot
and should not be enabled for older families in code.

  Luis
