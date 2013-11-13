Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:52873 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3KMFE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 00:04:26 -0500
Received: by mail-ob0-f172.google.com with SMTP id wm4so7148023obc.31
        for <linux-wireless@vger.kernel.org>; Tue, 12 Nov 2013 21:04:25 -0800 (PST)
Message-ID: <52830858.80907@lwfinger.net> (sfid-20131113_060428_972280_2C1E943B)
Date: Tue, 12 Nov 2013 23:04:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alexandre Demers <alexandre.f.demers@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging r8712u: Remove useless netdev_info slowly polluting
 dmesg
References: <1384318582-10486-1-git-send-email-alexandre.f.demers@gmail.com>
In-Reply-To: <1384318582-10486-1-git-send-email-alexandre.f.demers@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2013 10:56 PM, Alexandre Demers wrote:
> Remove useless netdev_info slowly flooding dmesg.
> Fixes bug https://bugzilla.kernel.org/show_bug.cgi?id=64231
>
> Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>
> ---
>   drivers/staging/rtl8712/rtl871x_mlme.c | 3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
> index 6596154..7e29f48 100644
> --- a/drivers/staging/rtl8712/rtl871x_mlme.c
> +++ b/drivers/staging/rtl8712/rtl871x_mlme.c
> @@ -1043,9 +1043,6 @@ void r8712_got_addbareq_event_callback(struct _adapter *adapter, u8 *pbuf)
>   	struct	sta_priv *pstapriv = &adapter->stapriv;
>   	struct	recv_reorder_ctrl *precvreorder_ctrl = NULL;
>
> -	netdev_info(adapter->pnetdev, "%s: mac = %pM, seq = %d, tid = %d\n",
> -		    __func__, pAddbareq_pram->MacAddress,
> -	    pAddbareq_pram->StartSeqNum, pAddbareq_pram->tid);
>   	psta = r8712_get_stainfo(pstapriv, pAddbareq_pram->MacAddress);
>   	if (psta) {
>   		precvreorder_ctrl =
>

Congratulations. That one applied.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

