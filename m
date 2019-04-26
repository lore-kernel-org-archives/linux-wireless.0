Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF2EC43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 13:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 600CC206E0
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 13:45:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IRdqI1ub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfDZNpM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 09:45:12 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45210 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfDZNpM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 09:45:12 -0400
Received: by mail-qt1-f196.google.com with SMTP id b3so4051258qtc.12
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2019 06:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ux5ikJOCxQmKgLDE3SOWwTg3wjwO+m8Zs+TtIBn8U0=;
        b=IRdqI1ub7TCPzDPJuueMR2jzrwDnZ5crcnVOoYw7SY1TW63RWfFGp6R9i7Ynem7rxq
         P398xi3Jr6GarwN03PBCGkGwqRQHRX1pzJiHYT+nA3HhJz0TSF3V5DX4tcClTA560ooC
         g/vhjaIwK6Ln38H45z41A9ed4mHlOlzN8XMK74ONN7LXosIDV3lxifXpF0PaJw0RdO6M
         ULzGizjX81je2PAZgIvXTiLsUBILhIo4FNQKyW95tOqESVrgOhggXkQhWTEOc8uymB4e
         6bwNc8reB3kgQxerVxaRt1XLnoAiErw79jj3xL25x9oyocTGPjElMri2lyohmREimLMr
         1ReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ux5ikJOCxQmKgLDE3SOWwTg3wjwO+m8Zs+TtIBn8U0=;
        b=WFDQQ2Cd1ifJaY2Awah+bWplwdO7m6rL9rgz8I/Ax25jFBnwqcvaIMI4fl7yTPY3q5
         S/SUxha9eW6Z4khnO9IOQK2wqbFxfvAACI2O0VgyjXXNGMRE1ibt+ObFCesVnN0vvSCd
         vfro8EjeCDTNCEktfsPYykY1D2zg5YBm/qiBGh+UEumTh54xdmWtx5Ry4wzTfBEsM/Hv
         lDXeZio7fT1fcrseR4ImRUMce2rZaVi1m7DsTr/UHLgdRjCf733khRoXJAnMVuShpd/m
         zIz1ShMc5SrCSh1cUXadNf7z0eOGVaRkKr1Git6WmYAS5EhAVrbEbfwG6kZGg9ErQfh8
         XNVQ==
X-Gm-Message-State: APjAAAVVV8i1P2GIDXx94yor2/of2t2EYEEAkTL4V1DRGBx5Plm9Vhr5
        9ilaqJbv/O8B6RebsVYLY0NwxyLodpWDMHpEJVQ=
X-Google-Smtp-Source: APXvYqxwoqTNa3Ma1CQ/4X/q6oflTVxhYmN1NMh3t7BHMqp23+2Ai3+HGvCpiCV8yBqzHRYO2MJlFXGPEDCPLEDErH8=
X-Received: by 2002:a0c:9d02:: with SMTP id m2mr26830605qvf.32.1556286311398;
 Fri, 26 Apr 2019 06:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <1556283505-29539-1-git-send-email-vnaralas@codeaurora.org>
In-Reply-To: <1556283505-29539-1-git-send-email-vnaralas@codeaurora.org>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Fri, 26 Apr 2019 15:44:59 +0200
Message-ID: <CABvG-CVxmnm=JsSsgYQqEzHHYU8RJDxqCZJn4Rzy=zPLtKY1hA@mail.gmail.com>
Subject: Re: [PATCHv2] ath10k: Add wrapper function to ath10k debug
To:     Venkateswara Naralasetty <vnaralas@codeaurora.org>
Cc:     ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Kan Yan <kyan@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 26 Apr 2019 at 14:58, Venkateswara Naralasetty
<vnaralas@codeaurora.org> wrote:
>
> ath10k_dbg() is called in ath10k_process_rx() with huge set of arguments
> which is causing CPU overhead even when debug_mask is not set.
> Good improvement was observed in the receive side performance when call
> to ath10k_dbg() is avoided in the RX path.
[...]

> +/* Avoid calling __ath10k_dbg() if debug_mask is not set and tracing
> + * disabled.
> + */
> +#define ath10k_dbg(ar, dbg_mask, fmt, ...)                     \
> +do {                                                           \
> +       if ((ath10k_debug_mask & dbg_mask) ||                   \
> +           trace_ath10k_log_dbg_enabled())                     \
> +               __ath10k_dbg(ar, dbg_mask, fmt, ##__VA_ARGS__); \
> +} while (0)

Did you consider using jump labels (see include/linux/jump_label.h)?
It's what tracing uses under the hood. I wonder if you could squeeze
out a bit more performance with that? I guess you'd need to add
`struct static_key ath10k_dbg_mask_keys[ATH10K_DBG_MAX]` and re-do
ath10k_debug_mask enum a bit.


Michal
