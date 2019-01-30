Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498F1C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 15:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11DF520989
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 15:25:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="IxsFY/D7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731437AbfA3PZq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 10:25:46 -0500
Received: from sonic309-24.consmr.mail.ir2.yahoo.com ([77.238.179.82]:39802
        "EHLO sonic309-24.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbfA3PZq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 10:25:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1548861944; bh=9RxO7x6mthyd/YJOcw5eaXI1EKQhxA95JGtdea6n19o=; h=Date:From:Reply-To:To:Cc:Subject:References:From:Subject; b=IxsFY/D7ZX8Nvv9mRHf1VlA9ZkAAW8YooDoqKajtkEB+ElKd/7VJ8jLOMqa3BpVSAMlGSrN0jYExoANxLQzAyKslI9wQKiVixYE0CjcK75iupYmQh3G5BAVQsjnrJ49ueGFmzlXwbqIfpebEXiiKAXf/qz3xysugmmFqsAR6SI/npzom4ITY/XANm7JapIdLNcRepdtGEqdkCG507DMoWeONU3Skkic1ZW/8rLSSYA8FJPrUIGcSo45s4wZHB6vK9UhQ5m0rJoIeD7Q2pp3Yl9v6veD4lsFy7z+Qqvchj9uAnqbCC1d7+lFgmIJsE+gR4PnR4ASpnW8YdkeUxNt1jg==
X-YMail-OSG: 3isxlxEVM1lPBd3XPx7n0WmOZfBCKn3zyc7vGAL3s9mwA263FGPXRU7vRINEyyr
 QpBbn77HvyfJ2htLy_HCro4W6A9Pu_UYx8BEAFDjkW3xkCqx4JETyrVWRh0hJjeybrC0Qsqu___i
 TG8HUd8Edv9hqAT0OkEhJIA5uV1Xa1Bb7MTKpqgs.AtwRXrb9iOcFu9VgwU6O2K.eEKsMSYulG_c
 QANXz7QtDiJO5OKCWAJMdPjBVpvlikIBZ_iXgRaeEENeA1PnhFyKuzpd_DLrjAZdikH1GmmU6EKr
 .6_ioCvz2g4WQ6oK1q03QdqhMKgyhrobjbYyGmMyVSw0lhPBfFnFua0GmeNAlBRceQ64bJwju3U.
 RnUUYPE8nUdA4WEP8ahmvz2tWx.dhTsy0dt8WwdrgQ0wCOVXm1V2gX18A2tc6Y_D72MLCb_fWdLw
 vssc0fCjgrOftRlekh2kMy1H9IqnvJE7k9k_bjeMZdsEsPuHtlWbAWKDcGhrmk5vBQY3Vmw7Et7U
 K3.jZKCrit7DFmWVN8FQVpMRbSlLj0XWUBI87yvuV_dQb.4gREfSo.dFlEY.IPKfl8TokkAXfLon
 Zu__CeGkLU8ioHWgu6r.jGjMHd.o4ILsV.3xl0rlCgaZPLBZdyRxE7wJYQ3vb27GvxKaM32QTYvr
 8uQfJdIa_T5eMmrOgt4IQ3EPL29kd4pj8Y5NENcjX_5FQBhS3VH91d8.pXgC1U5ZRsMyv3nRZSJF
 uoE3AXH54PCVOzjo5xsx1j8otVG7DdTgcgxlDcVCAcLNFn2SQYrct28FX0P.w2XuuklE9.tWux.q
 58MrX6qlX0qmrm_6ihRxHTSuT16U.6Jhh5h9xsbaqqsKqYMF22cvH5f.EfQ6MH25qdKl75qw4hXp
 NvThBaA.U7h2EfddVyfhHakeo1fMgs_SL3tF8U255FCHo8X9FaR3RRGAEQ5zRCztekcSA56Rn45_
 w.Ol.Ko7Yhw8hzkCu3kKkHNvKwVyd9u3fkzsl35EOs4vNxVC80NlEbjm5GU3Yyq93tcHYrG9IuKg
 PHepUlw.4sMbHA.xl6_y17OgVqfZ9qflHMT.a8kd1zf63jxygLlyICLQSyv.m7u4c0hsgLjDPCON
 ubw9crNK9633Nt87T0MDJyp39R9I02Lmc6qdETPXhkVnXKw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ir2.yahoo.com with HTTP; Wed, 30 Jan 2019 15:25:44 +0000
Date:   Wed, 30 Jan 2019 15:25:42 +0000 (UTC)
From:   Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: Hin-Tak Leung <htl10@users.sourceforge.net>
To:     Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     <netdev@vger.kernel.org>, Larry Finger <Larry.Finger@lwfinger.net>,
        <linux-kernel@vger.kernel.org>
Message-ID: <883460220.650537.1548861942189@mail.yahoo.com>
Subject: Re: [PATCH] net: wireless: prefix header search paths with
 $(srctree)/
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <883460220.650537.1548861942189.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.13027 YahooMailBasic Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/71.0.3578.98 Chrome/71.0.3578.98 Safari/537.36
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--------------------------------------------
On Fri, 25/1/19, Masahiro Yamada <yamada.masahiro@socionext.com> wrote:
=20
> Currently, the Kbuild core manipulates header
> search paths in a crazy
> way [1].
=20
> To fix this mess, I want all Makefiles
> to add explicit $(srctree)/ to
> the search paths in the srctree. Some
> Makefiles are already written in
> that way, but not all. The goal of this
> work is to make the notation
> consistent, and finally get rid of the
> gross hacks.
=20
> Having whitespaces after -I does not
> matter since commit 48f6e3cf5bc6
> ("kbuild: do not drop -I without
> parameter").
=20
> I also removed one header search path
> in:
=20
 =C2=A0
> drivers/net/wireless/broadcom/brcm80211/brcmutil/Makefile
=20
> I was able to compile without it.
=20
> [1]: https://patchwork.kernel.org/patch/9632347/
=20
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Looks okay for the rtl818x parts.
