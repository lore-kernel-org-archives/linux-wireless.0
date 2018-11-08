Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1F3C0044C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 00:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB53920883
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 00:36:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YOYCXnQa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB53920883
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbeKHKIw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 05:08:52 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:36639 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbeKHKIw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 05:08:52 -0500
Received: by mail-it1-f194.google.com with SMTP id w7-v6so25678912itd.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Nov 2018 16:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RqiqsUXQ2XYKhb/LGF6y7wDfwmyjotHTaRzbtJvRLxA=;
        b=YOYCXnQafm84nw0OqQCPvn0h+acJ4/FjLnThz5G/foZVvHZ5EnzYQ96kKZsAn91q0N
         rp7i6Gb9UzEk44rljVnbz0zqggg1Upor4jBszqUfycDGwkj6LNJ3lGNNiV12gyCqdX4P
         o3VOJSki9LAhXpAKSCQ2qB7Ndsn3238UCBtw8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RqiqsUXQ2XYKhb/LGF6y7wDfwmyjotHTaRzbtJvRLxA=;
        b=egMvnZd09CMxW1FbHHXfugcki4Yp7dWF+i6aUxLhI1U5X7691Rzzv4N125UtqLlNE1
         6ZB5FPyKNjKwopFd4kL0NQS2ZnNv2zp938TwjumFRWzueSFWd5Z/UdZT3EHf9npdPLFF
         0reQXnr1Xm5hR8S5hfaI6ribvavWhSSQvMGR1oz7BbcZ7l2QKkjvxfxf+9yF69OspCY7
         eThbQYublfSflqTg/0Eex2pZb9+BbY03KDh/nQlBoQcOOXWD5jwrzZZvjq+irevACi27
         MM1hXKQ0ptqjako8xRqFuRBbE0hsdBlfXcoZNuOkuWmJr6onwASKxseNdwSOBuiDRluh
         r12A==
X-Gm-Message-State: AGRZ1gImuWQri9P6E7qbXuiufWnabOQcUJW0QAHXno/axl0EuFSnEc6Q
        Iirw0UtMS4pzTDJ5KDChY4/mpbrr0kA=
X-Google-Smtp-Source: AJdET5d/j2j4tkvHSQuCd6NDclTlpq7PQJ9syiopeKRL6fXbVhFAFm+Ygq3lioHNHZEHRXuc2oH7jw==
X-Received: by 2002:a24:c647:: with SMTP id j68-v6mr2158624itg.118.1541637360376;
        Wed, 07 Nov 2018 16:36:00 -0800 (PST)
Received: from mail-it1-f174.google.com (mail-it1-f174.google.com. [209.85.166.174])
        by smtp.gmail.com with ESMTPSA id q23-v6sm965758ioj.68.2018.11.07.16.35.58
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Nov 2018 16:35:58 -0800 (PST)
Received: by mail-it1-f174.google.com with SMTP id v11so19518322itj.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Nov 2018 16:35:58 -0800 (PST)
X-Received: by 2002:a24:b204:: with SMTP id u4-v6mr2086042ite.33.1541637358093;
 Wed, 07 Nov 2018 16:35:58 -0800 (PST)
MIME-Version: 1.0
References: <1538989363-12386-1-git-send-email-wgong@codeaurora.org>
In-Reply-To: <1538989363-12386-1-git-send-email-wgong@codeaurora.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 7 Nov 2018 16:35:46 -0800
X-Gmail-Original-Message-ID: <CA+ASDXNxA2jrn2M=MjcnVV72UCfcFUvSvdcvBCd2kY+d12=wKg@mail.gmail.com>
Message-ID: <CA+ASDXNxA2jrn2M=MjcnVV72UCfcFUvSvdcvBCd2kY+d12=wKg@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Add peer flush in ath10k_flush for STATION
To:     wgong@codeaurora.org, Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 8, 2018 at 2:03 AM Wen Gong <wgong@codeaurora.org> wrote:
>
> In the noisy environment, if there are packets in the queue and can't
> send out, the suspend timing will be more than 5 seconds due to the wait,
> flush the queue to optimize the suspend timing, and let the upper layer to
> retry the packets after resume.
>
> Tested with QCA6174 PCI with firmware
> WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI.
> It's not a regression with new firmware releases.
>
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
>  drivers/net/wireless/ath/ath10k/mac.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 97548f9..8df3cec 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -6814,9 +6814,20 @@ static void ath10k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>                          u32 queues, bool drop)
>  {
>         struct ath10k *ar = hw->priv;
> -
> -       if (drop)
> +       struct ath10k_vif *arvif;
> +       u32 bitmap;
> +
> +       if (drop) {
> +               if (vif->type == NL80211_IFTYPE_STATION) {

'vif' may be NULL. It is trivially easy for me to crash a system on
v4.20-rc1 by suspending the system while not connected.

I'll send a patch to fix this.

Brian

> +                       bitmap = ~(1 << WMI_MGMT_TID);
> +                       list_for_each_entry(arvif, &ar->arvifs, list) {
> +                               if (arvif->vdev_type == WMI_VDEV_TYPE_STA)
> +                                       ath10k_wmi_peer_flush(ar, arvif->vdev_id,
> +                                                             arvif->bssid, bitmap);
> +                       }
> +               }
>                 return;
> +       }
>
>         mutex_lock(&ar->conf_mutex);
>         ath10k_mac_wait_tx_complete(ar);
> --
> 1.9.1
>
