Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E92DECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 07:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41E1B21526
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 07:33:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SDjzy7m4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41E1B21526
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbeJQP2M (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 11:28:12 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44870 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbeJQP2M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 11:28:12 -0400
Received: by mail-pl1-f193.google.com with SMTP id p25-v6so12246960pli.11
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2018 00:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:to:from:in-reply-to:cc
         :references:message-id:user-agent:subject:date;
        bh=hCE0ZcZdwgZvtFE0zbl/Eo1rYMv4l6e4nGtVlRuQEOk=;
        b=SDjzy7m4GXEC4sE0OnPI/ao1SvPUzTL4COpSknDCaPFSJiWa9fSNQjfbm2d5IdldFN
         jirezX2XXOdRCLbqIZcDMMXIgMjt64wW5ie+t7L9U+nTgWY5y2U1hITz087zYY04XYLB
         VIAKcWtkzxcRvMRsbo8XReaFQUUZGmTO9kUlE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding:to:from
         :in-reply-to:cc:references:message-id:user-agent:subject:date;
        bh=hCE0ZcZdwgZvtFE0zbl/Eo1rYMv4l6e4nGtVlRuQEOk=;
        b=er0VT7beYhxulOhhFJIoyBN8q6gCLmF6YBX9M11cwV/5hQT3URjbJU3AgAgLwVEyNv
         x4mLNWMN6idySMwLupCtnM0UzhHKbpW3We+uFg7imqfgGwF2TZ8r3LvXYZGJEL/XHJTt
         Z/t+BO7nQDP1ALlV0nLRW8zxjOJNVXbrmAEPDL2sUDIV8TIOPDMdnbGBwiYBFa4bn5tF
         6ropnjbm2EM4R0FuOwAemHrNHlj9umbBx6t7FReUQMpiy42XN9N/zNrN42GXVcvhEg0/
         cbyqFA3fIrRUZSznRE7/OeXHNWIJeD1uHW7oQMAJ/WR9PW23whjnfQzvynziiGinw0el
         o6fg==
X-Gm-Message-State: ABuFfoinf9f/HZdXgnCAcqV64KN8hqZ7Yh7Kbef0l5PuzbnoV8y+4wsT
        26XUf1ftSPc8BNuzjST1/kDRZQ==
X-Google-Smtp-Source: ACcGV62l2exbH/0mN9A19UJQarFjJZygTcIHpiPQC+YXSE38ryK8K+kGHyOI9d9TRx1xt/3mwpDMUQ==
X-Received: by 2002:a17:902:ab8a:: with SMTP id f10-v6mr25019336plr.203.1539761630747;
        Wed, 17 Oct 2018 00:33:50 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:fed3:9637:a13a:6c15])
        by smtp.gmail.com with ESMTPSA id s2-v6sm21640860pfk.133.2018.10.17.00.33.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Oct 2018 00:33:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To:     Govind Singh <govinds@codeaurora.org>, andy.gross@linaro.org,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-wireless@vger.kernel.org, robh+dt@kernel.org
From:   Stephen Boyd <swboyd@chromium.org>
In-Reply-To: <1539172376-19269-3-git-send-email-govinds@codeaurora.org>
Cc:     Govind Singh <govinds@codeaurora.org>
References: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
 <1539172376-19269-3-git-send-email-govinds@codeaurora.org>
Message-ID: <153976162862.5275.4810472671573539341@swboyd.mtv.corp.google.com>
User-Agent: alot/0.7
Subject: Re: [PATCH v3 2/3] dts: arm64/sdm845: Add WCN3990 WLAN module device node
Date:   Wed, 17 Oct 2018 00:33:48 -0700
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Quoting Govind Singh (2018-10-10 04:52:55)
> @@ -1403,5 +1408,26 @@
>                                 status =3D "disabled";
>                         };
>                 };
> +
> +               wifi: wifi@18800000 {
> +                       compatible =3D "qcom,wcn3990-wifi";
> +                       status =3D "disabled";
> +                       reg =3D <0x18800000 0x800000>;
> +                       reg-names =3D "membase";
> +                       memory-region =3D <&wlan_msa_mem>;
> +                       interrupts =3D
> +                               <0 413 0 /* CE0 */ >,

Please specify these as GIC_SPI and give trigger types (level high I
guess?). I'd also drop the comment and add interrupt-names to match the
comment. It's self documenting that way.

> +                               <0 414 0 /* CE1 */ >,
> +                               <0 415 0 /* CE2 */ >,
> +                               <0 416 0 /* CE3 */ >,
> +                               <0 417 0 /* CE4 */ >,
> +                               <0 418 0 /* CE5 */ >,
> +                               <0 420 0 /* CE6 */ >,
> +                               <0 421 0 /* CE7 */ >,
> +                               <0 422 0 /* CE8 */ >,
> +                               <0 423 0 /* CE9 */ >,
> +                               <0 424 0 /* CE10 */ >,
> +                               <0 425 0 /* CE11 */ >;
