Return-Path: <SRS0=y/91=EK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C919C2D0A3
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Nov 2020 02:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA8602242C
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Nov 2020 02:00:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QcxJ8vUU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgKDCA0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Nov 2020 21:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgKDCAZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Nov 2020 21:00:25 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21045C061A4D
        for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2020 18:00:25 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id v6so24933092lfa.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2020 18:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C4VM48gSNaeD9caCaQYAOR6M4cliDtpQba3b+Hfm5ZQ=;
        b=QcxJ8vUUI66o1zpuprQfCvrglqnNCE9JevoogB1Bzs15ej14lX4D4bbu8FIzDy+HPl
         TG/BQ096/4p/DHJvrxYn+E2QXYob+o1/pKk1CZtdvnC3ltMqN7XqyBVo4+Y7NGAGNUMy
         Da5IY5Ditvr/XnXh7wwGnr8W+cd7MPyUmg21w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C4VM48gSNaeD9caCaQYAOR6M4cliDtpQba3b+Hfm5ZQ=;
        b=mu9qjVMHd5lPSmL5+9RJedjPnqmlGT2VmK4/v6m7cEFty00nLrGjgl7YRj+VSqeYeD
         1LfRyMifkWxaeXCKV7OpdLa+52ju3jxGRbWNAyUQQXJYS4X2U6eoUyLQNwxjn79fO0E1
         0/y7P+NnB49Q1GqGHPwfJnJnnS8h6wRZUnspz38vcqUEVAx2Ut9iL/NN392kFAEggo6j
         83hMrXTRTm+v0FDK65A0wxndjrmdVk22nUJBCrxbLAHrMe5c6xZivT0dV4d4WWWO6q9v
         RxNshsjZbcGpD9wFYuvU55ju2tny4aOY0HLJwASu/nNzkmCeJ6Rh7oIu+DXgh7LAdj5P
         PkdA==
X-Gm-Message-State: AOAM5309hnMqqWpm6aODe4myvCo/ho05gBwFz93o+++Y/WNqH+9HVbQc
        tOZiwjWPFRpn1ThA0zp1QsgRRZlzTpbs4w==
X-Google-Smtp-Source: ABdhPJzZSsnNRhObHuKq33UK9NhyoL+sTGaSp1ceEppTfUKrn8ltvWOgJ+2yAvzni5B/YhygrFzAaA==
X-Received: by 2002:ac2:5102:: with SMTP id q2mr617288lfb.391.1604455223242;
        Tue, 03 Nov 2020 18:00:23 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id u28sm156952lfi.182.2020.11.03.18.00.21
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 18:00:22 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id i6so25024164lfd.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2020 18:00:21 -0800 (PST)
X-Received: by 2002:a19:a40c:: with SMTP id q12mr8290047lfc.541.1604455221556;
 Tue, 03 Nov 2020 18:00:21 -0800 (PST)
MIME-Version: 1.0
References: <1600753017-4614-1-git-send-email-cjhuang@codeaurora.org>
In-Reply-To: <1600753017-4614-1-git-send-email-cjhuang@codeaurora.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 3 Nov 2020 18:00:07 -0800
X-Gmail-Original-Message-ID: <CA+ASDXM7TcF-zfbktbdSu-fDBuGe0LAgFq3Qt2zaq6efbWJ=sA@mail.gmail.com>
Message-ID: <CA+ASDXM7TcF-zfbktbdSu-fDBuGe0LAgFq3Qt2zaq6efbWJ=sA@mail.gmail.com>
Subject: Re: [RFC 1/2] nl80211: add common API to configure SAR power limitations.
To:     Carl Huang <cjhuang@codeaurora.org>
Cc:     ath11k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Sep 21, 2020 at 10:37 PM Carl Huang <cjhuang@codeaurora.org> wrote:
> +/**
> + * struct cfg80211_sar_capa - sar limit capability
> + * @type: it's set via power in 0.25dbm or other types
> + * @num_freq_ranges: number of frequency ranges
> + * @chan_ranges: memory to hold the channel ranges.
> + */
> +struct cfg80211_sar_capa {
> +       enum nl80211_sar_type type;
> +       u8 num_freq_ranges;
> +       const struct cfg80211_sar_freq_ranges *freq_ranges;
> +};
...
>         u8 max_data_retry_count;
>
> +       const struct cfg80211_sar_capa *sar_capa;
> +
>         char priv[] __aligned(NETDEV_ALIGN);
>  };

What are the ABI guarantees around a given driver/chip's 'sar_capa'?
Do we guarantee that if the driver supports N ranges of certain bands,
that it will always continue to support those bands? What if, for
instance, ath10k grows a new set of subbands, supporting sub-sections
of the 5GHz band -- does it still need to support both a contiguous
[5, 5 + X] and a split [5, 5 + X/2], [5 + X/2, 5 + X]? Basically, do
we intend to put the burden on user space to figure out how to map its
power tables to the supported frequency band(s), or on the kernel, to
support a backwards-compatible set of frequency ranges? The latter
doesn't really work if you expect user space to always specify all
ranges in a SET command.

To be clear, I'm not as worried about differences between chips or
drivers (I expect that different driver or chips may have different
range support); just about stability for a given chip.

Brian
