Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D624CC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A9E520868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:52:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TOGl6/sh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A9E520868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbeJLSYF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 14:24:05 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40584 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727640AbeJLSYF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 14:24:05 -0400
Received: by mail-ot1-f65.google.com with SMTP id w67so11960005ota.7
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=TJ408YDoeIhPpUqSEht28AjOR1MyZlUXca2NfERKRjw=;
        b=TOGl6/shGb20PU3/y3QTfxde4N94ewWdeHLP2pt1pawTAdWZLlb+j96UJZxUobfPpN
         uz+GqtaL+l3GDY6GRlqEXd0Y188J+DfnuSUq238ebsg0btOPqOn+wkwrmhTLHeH6eCHh
         WNVE9cZNwlo5lhRKC/Mg1ntzFNpMYuwjr8cB6k2AbyB+67rI+nwoyZozmcpwl2f4kr88
         lqqRK/yDZ5w0wYrow+DCyY8lKh/zjNmXK3jXVyinZGLtUs85U6TBXSo+AYlVatc8FKqT
         0IlVKmz7aMw4yanfUYbtOIYXvfZfmv/P60FZQmMmBTWNZ/4SM2ddAljY/VlxcR2RfO2v
         S7Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=TJ408YDoeIhPpUqSEht28AjOR1MyZlUXca2NfERKRjw=;
        b=hBCCE+WPC9Uwxgec40jKETHKOwfIF07OdW3YIsjB+8D5YE21TYsWf93d8JRTzImzYF
         Yd7WbNqOEkFJIj3Elu8Pa0hXaG8bByaeBuFPNfyy561mwS2YvfQsKc6efY4WgmKHe5xJ
         1iA//xHcYUEqQn+Na5J93JjijIQjH8cLYAp430Z7N6p0ZxEvpv56gos4uqVtqQAOK7g0
         NadAk1V8bIA7CNFjR/sOTjzPFoqEnPT0TJb9evE9VYPyLtH56gW3AAEFC18ovbLRRnz6
         LyZkGFQGocyYjmTmfJNf7R+JZCXrkriB6Jts3Ga8lZLt5NxttJhkhOmDIQ10aFhiELfC
         XI4Q==
X-Gm-Message-State: ABuFfogGPLnBo3sK9K0ZhjfMusZ/mAwuiXEb10evfnBTTxo7Zd/s+RRk
        WqnJZiIJit0M1Omi4l/J9oNU8chJWihkJZ94cGdrrPGn
X-Google-Smtp-Source: ACcGV636p1It1+DgkYf+9yIZNr1DaDmvz7+RI9njMstIzOVcb+NRbKYEqPcKlyaOE/vv6DkoDM1BKwK8Vg4bFWgUDME=
X-Received: by 2002:a9d:ec:: with SMTP id 41mr3336234otk.322.1539341533982;
 Fri, 12 Oct 2018 03:52:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Fri, 12 Oct 2018 03:52:13
 -0700 (PDT)
In-Reply-To: <1539334591-9965-7-git-send-email-sgruszka@redhat.com>
References: <1539334591-9965-1-git-send-email-sgruszka@redhat.com> <1539334591-9965-7-git-send-email-sgruszka@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Fri, 12 Oct 2018 12:52:13 +0200
Message-ID: <CAKR_QVKvy8MEg+L4x_MzeBAdwZJCfczmmkU83qzstU1ExzescQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] rt2800: enable TX_PIN_CFG_RFRX_EN only for MT7620
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

is there some specific reason to read TX_PIN_CFG register on RT6352,
rather than just null it before programming in tx values like in other
chips?

On 12/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> The TX_PIN_CFG_RFRX_EN bit was not set on other devices than MT7620,
> restore old behavaviour since setting this bit maight not be
> correct for older devices.
>
> Fixes: 41977e86c984 ("rt2x00: add support for MT7620")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index bf0d12c5b2db..d0af0d9d2550 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -3856,10 +3856,12 @@ static void rt2800_config_channel(struct rt2x00_dev
> *rt2x00dev,
>  	if (rt2x00_rt(rt2x00dev, RT3572))
>  		rt2800_rfcsr_write(rt2x00dev, 8, 0);
>
> -	if (rt2x00_rt(rt2x00dev, RT6352))
> +	if (rt2x00_rt(rt2x00dev, RT6352)) {
>  		tx_pin = rt2800_register_read(rt2x00dev, TX_PIN_CFG);
> -	else
> +		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_RFRX_EN, 1);
> +	} else {
>  		tx_pin = 0;
> +	}
>
>  	switch (rt2x00dev->default_ant.tx_chain_num) {
>  	case 3:
> @@ -3914,7 +3916,6 @@ static void rt2800_config_channel(struct rt2x00_dev
> *rt2x00dev,
>
>  	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_RFTR_EN, 1);
>  	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_TRSW_EN, 1);
> -	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_RFRX_EN, 1); /* mt7620 */
>
>  	rt2800_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
>
> --
> 2.7.5
>
>
