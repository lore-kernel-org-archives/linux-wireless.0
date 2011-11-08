Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47625 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab1KHWis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 17:38:48 -0500
Received: by pzk2 with SMTP id 2so2843619pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 14:38:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320152097-2711-4-git-send-email-ilane@ti.com>
References: <1320152097-2711-1-git-send-email-ilane@ti.com>
	<1320152097-2711-4-git-send-email-ilane@ti.com>
Date: Tue, 8 Nov 2011 19:38:47 -0300
Message-ID: <CAK3JMAbtL1wmsY3d9phV+nCKRnH8sFdpPgKybxcAKmsfu1DDSA@mail.gmail.com> (sfid-20111108_233851_482461_F2E609AF)
Subject: Re: [PATCH v3 3/3] NFC: Check if NCI data flow control is used
From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
To: ilanelias78@gmail.com
Cc: aloisio.almeida@openbossa.org, samuel@sortiz.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ilan Elias <ilane@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/1  <ilanelias78@gmail.com>:
> From: Ilan Elias <ilane@ti.com>
>
> Check if NCI data flow control is used in nci_tx_work.
>
> Signed-off-by: Ilan Elias <ilane@ti.com>
> ---
>  net/nfc/nci/core.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
> index 9d0b530..056cd37 100644
> --- a/net/nfc/nci/core.c
> +++ b/net/nfc/nci/core.c
> @@ -722,7 +722,9 @@ static void nci_tx_work(struct work_struct *work)
>                if (!skb)
>                        return;
>
> -               atomic_dec(&ndev->credits_cnt);
> +               /* Check if data flow control is used */
> +               if (atomic_read(&ndev->credits_cnt) != 0xff)
> +                       atomic_dec(&ndev->credits_cnt);

It would be better to replace the 0xff by a define.

Lauro
