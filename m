Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8867DC43441
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 23:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CC87214C4
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 23:27:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F993AAsE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CC87214C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725757AbeJJGqv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 02:46:51 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37425 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725748AbeJJGqv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 02:46:51 -0400
Received: by mail-ot1-f67.google.com with SMTP id o14so3513656oth.4
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2018 16:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MGmCc08bqptVb74pVMtKIhIJ6LkhHr+3sQbE2oS9Gxs=;
        b=F993AAsEhbjnnufkz2hO6CHWEn2/5M1tHLNXEMqpr9aUPBwLKjFOraHlaBuOR1tJQl
         NlUd5+FNNggrv4yaa/Ck/yHCrtronkWaFSqhqYxM/YZcuT/5CtkpC2376L3oTQM4s5Ut
         5lYxle4TyIyBVRzyW53G2Lk78h0TU7XQ/80OWYghbmT95MiFco3kr+O00lEISCWW978o
         0ajJXMDKz4l+BisA3Fv3yGJQ+eeLZqPHK4QBg3IY7q5kE197CcNmbc6LTJG9KuHRTk7y
         hxXw5WqaATQII6nzGTlukXgeWCjtS5NzjWTgpEjKI6dW6vJTRmwygBnWEgtlRoZ9BwmW
         A4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MGmCc08bqptVb74pVMtKIhIJ6LkhHr+3sQbE2oS9Gxs=;
        b=nvEopudxa/fTBy3Ox37od8IxMtPFRgX72c11Q6YeryGqJcYtEAgxTzFWuN2LUgCVSI
         1q2GL4Hpo4mW63liPR6j1GUv52aZXiaGSnijPjIu6qfiFlPhPxzwTj2rkzwBc1V0fdRE
         fDFXQpmDD1CSByQBgxlynZDWrQZS4M0E3sQuYteUMthoVGHK4vqL5H9uPgq/k8EB5x9d
         OuIY29XautkaAU+oC6sP9biFHBhzPFKWhSQG9FnQ3IVGoKYsLdhDrqo2EdziC9kVe4ck
         5l6B/u43oMfw8O4rTRIeZLJFO3sfNo4qUnv7EfzuwSOHbG9n11AepItHoqCijr9GN2hd
         pORQ==
X-Gm-Message-State: ABuFfoiDVAgSV1SsXW+MG/aNK9SGBtiLkU809n1WW78GsH0eTbvl0Owt
        5WaLWX21yYhpS6iCOUQGSUA1X7993KhiZDEnyWM=
X-Google-Smtp-Source: ACcGV61v348rHB0tMH1B2XnBwTn5NLDB89zNDYvXzrSefRUjfi7mpONfiOsPcbCMUxrUwRw7nqlHsOqGUuW3CNT4gps=
X-Received: by 2002:a9d:7347:: with SMTP id l7mr11971423otk.270.1539127651938;
 Tue, 09 Oct 2018 16:27:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Tue, 9 Oct 2018 16:27:31 -0700 (PDT)
In-Reply-To: <1539086170-32528-4-git-send-email-sgruszka@redhat.com>
References: <1539086170-32528-1-git-send-email-sgruszka@redhat.com> <1539086170-32528-4-git-send-email-sgruszka@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 10 Oct 2018 01:27:31 +0200
Message-ID: <CAKR_QV+0z-5ee=sbEawFSnEF2ngvJSUPpNUoY_oPK1Cfk9P0iA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] rt2800: fix registers init for MT7620
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 09/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> There is dupliceted 'if (rt2x00_rt(rt2x00dev, RT6352))' entry that couses
> we do not perform proper register initaliztion for RT6352 (MT7620 SOCs).
>
> Reported-by: Tomislav Po=C5=BEega <pozega.tomislav@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index daf20d7424ac..170e7c87f7bc 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -5451,8 +5451,7 @@ static int rt2800_init_registers(struct rt2x00_dev
> *rt2x00dev)
>  					      0x00000000);
>  		}
>  	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
> -		   rt2x00_rt(rt2x00dev, RT5392) ||
> -		   rt2x00_rt(rt2x00dev, RT6352)) {
> +		   rt2x00_rt(rt2x00dev, RT5392)) {
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
> --
> 2.7.5
>
>


have you got chance to test
https://github.com/psyborg55/linux/commit/24b46d482590a87553df1de0b5c8032f3=
63cb7cf
 ?

 using this code to determine 7620 soc

 if (rt =3D=3D RT5390 && rt2x00_is_soc(rt2x00dev))
         rt =3D RT6352;

 somehow did not work in rt2800_init_registers routine. i could verify
 that by removing tx_sw_cfg registers from rt6352 and the wifi would
 still work, unless removed them from rt5390 also
