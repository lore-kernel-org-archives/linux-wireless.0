Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8559C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 15:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B6D52084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 15:26:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QIQbz/89"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfDIP0r (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 11:26:47 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35025 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfDIP0r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 11:26:47 -0400
Received: by mail-oi1-f194.google.com with SMTP id j132so13913645oib.2
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 08:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=wU9CYVybnr03bB70fIZz8OH7tJiWKwVxIOLZY4v6yHA=;
        b=QIQbz/89youb3DUX6iCU7xPY8WlcCP/vgX1+M4gfVXnh3arfvJoQAv/wXcFaAT0ygI
         pq+1c9LPcRHdJVzfOa4qGAtVLFx6v4+OQa7WUOlXsl0bbMLaG1I5mHALzVgv0+yzG1D7
         Kwb4HNZYTlMRYtu8oKYF1yJ29zPRPfbZPnbhFXKdlMgaH3ZjBhZMdq7SGgnitqPT27kR
         tjqskAKtUR5sd6VVehy34X7j8Qc9TF9++Ky4dwz3chu/KPmWnuFQFyfZjJB5hSmTeJN6
         ewIbsmGcTbkfa0zUlNo81nPflg1dkBRXZrXOIokEnXUq1Anj3jpn5Q/sjtR9LBFh+mh9
         D2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=wU9CYVybnr03bB70fIZz8OH7tJiWKwVxIOLZY4v6yHA=;
        b=jUrlHOD64l/K7sm4fR4j9TRlfhQ4QAVPHDdIw9NVsn3zNxDirQmWF0CELEKN4up1Xz
         94ESNx9z1lkSB4qmKOI7msoDR0GxPiH8rs9uGoYfU1A8qeTr4Wa5imRpkhj3NQt7FF4t
         JTHmOqDhi4wgazHMEb4PBZMqgAX1hlH0ZQhBCCQcs47CWN1Xr2qPelvpBEvUrkAfPkwI
         utM5w2P0m2VtE4sFc48rFfnJbwGBgSTUofrjmEM9tlx5CvUAS9+U1kssL29lpXbx9477
         1rO33GA0zgonaiHHpGvVeMDhanup12j545Cdigxot9Lezpe/EXHgvL03Q56xR5wcfPP0
         obHQ==
X-Gm-Message-State: APjAAAVpT+AstWakaYuYF4EVzy1qEqS6D3l/e+zR7AVKDaL1wc6cjBbn
        /8extc7SuZi4s15EXEboy2hYUCeZpFRZzBIORlg=
X-Google-Smtp-Source: APXvYqzv8/AfZotyUavSjOdOBsxdLifTRy71KPCNoml3itVXlrG/QuCKQzUFxVM5Hkyfevt7Yzz8QCE7f8BnmKEFq2U=
X-Received: by 2002:aca:5bd7:: with SMTP id p206mr20593795oib.128.1554823606783;
 Tue, 09 Apr 2019 08:26:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:628c:0:0:0:0:0 with HTTP; Tue, 9 Apr 2019 08:26:46 -0700 (PDT)
In-Reply-To: <1554809828-13500-16-git-send-email-sgruszka@redhat.com>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com> <1554809828-13500-16-git-send-email-sgruszka@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Tue, 9 Apr 2019 17:26:46 +0200
Message-ID: <CAKR_QVJtwmpEK2a5br2YEKPsAF0GHXwny5YbCTFoO_mgD+fVJw@mail.gmail.com>
Subject: Re: [PATCH 15/21] rt2x00: rt2800lib: hardcode txmixer gain values to
 zero for RT3883
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 09/04/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> From: Gabor Juhos <juhosg@openwrt.org>
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 0687bef990e1..4ea94c62d439 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -9128,7 +9128,8 @@ static u8 rt2800_get_txmixer_gain_24g(struct
> rt2x00_dev *rt2x00dev)
>  {
>  	u16 word;
>
> -	if (rt2x00_rt(rt2x00dev, RT3593))
> +	if (rt2x00_rt(rt2x00dev, RT3593) ||
> +	    rt2x00_rt(rt2x00dev, RT3883))
>  		return 0;
>
>  	word = rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG);
> @@ -9142,7 +9143,8 @@ static u8 rt2800_get_txmixer_gain_5g(struct rt2x00_dev
> *rt2x00dev)
>  {
>  	u16 word;
>
> -	if (rt2x00_rt(rt2x00dev, RT3593))
> +	if (rt2x00_rt(rt2x00dev, RT3593) ||
> +	    rt2x00_rt(rt2x00dev, RT3883))
>  		return 0;
>
>  	word = rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_A);
> --
> 2.7.5
>
>

Did someone actually verified this is correct?
