Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C528C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 16:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 477222084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 16:30:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XtfNJa7U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfDIQap (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 12:30:45 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:44070 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbfDIQap (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 12:30:45 -0400
Received: by mail-vs1-f65.google.com with SMTP id j184so10160489vsd.11
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 09:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5bSi6KbE8Pk9RuCYTPgITspTMM1nkuTpfW7nb1CrSbw=;
        b=XtfNJa7UEnVWxz8Hu3HBCaw4Djlx23xSTXXl7GOQGQrEePRnNbLEWuWTYRrjm9iumw
         1AkOmChoOrdttuxBS5ZGMiwZ0Fa+Htp0Acw/A1xlO8kkzBO875MKV5gcTh5jYW9grLti
         QTe25q6VxDmwjPaNgolfsoy/Qzgm4jwEUMYm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5bSi6KbE8Pk9RuCYTPgITspTMM1nkuTpfW7nb1CrSbw=;
        b=Ozlz/VE2YblelinHQlOGPfiTAs7QrVP4PblGPYJUraQBHAvjraUSmg7d1FfkA0EDPz
         /MaK21ReN+ue5u3YGPB44ut4mXQFHBsIPy6Mtiyc/4MYMBL/8JozlUbeIZhKM7X92ptd
         GHVMpj7hn0+wFN05IbnX54R/4cO/DsuRalI5FgOHo7VLNO8mP3RQaJr4HtkVgIN3nrPi
         TooOFHIL+uXFtsyk1CYHRWHZjUE3PHVzFeSwGWyP8XEaU6V/J7OvHgVXKKCl1MGNRxCo
         t2xvLaV0U3IdaXOxWXgQfCKI9Dy26faswuevOKbdqiCAKj/1MRbbKZo1sbvZQNlKNdgZ
         SJ4Q==
X-Gm-Message-State: APjAAAW+SBgvJzvuHZaKJg5u2o5kUyKZj1fqXe4kNlsSF5jj2ZPg+fqf
        jVTgfC6FLKXMKl1WJocM2712lCsyAeg=
X-Google-Smtp-Source: APXvYqxeCT3H8N96CPG47NPYAOYiOwxS1/smjO9O1laZwBWqUEMJrCLKdDnB/NBtx3u30xAXKPpjPw==
X-Received: by 2002:a67:82c8:: with SMTP id e191mr20699574vsd.24.1554827443747;
        Tue, 09 Apr 2019 09:30:43 -0700 (PDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id w184sm15985218vkd.0.2019.04.09.09.30.42
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2019 09:30:42 -0700 (PDT)
Received: by mail-vs1-f43.google.com with SMTP id n4so10182828vsm.3
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 09:30:42 -0700 (PDT)
X-Received: by 2002:a67:f04e:: with SMTP id q14mr21108873vsm.133.1554827442297;
 Tue, 09 Apr 2019 09:30:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190212173902.GA6829@embeddedor>
In-Reply-To: <20190212173902.GA6829@embeddedor>
From:   Kees Cook <keescook@chromium.org>
Date:   Tue, 9 Apr 2019 09:30:30 -0700
X-Gmail-Original-Message-ID: <CAGXu5jJDjM6=wLLuj3rxwc9uVttG27Ux7UaszAkV=YTTWYDsyg@mail.gmail.com>
Message-ID: <CAGXu5jJDjM6=wLLuj3rxwc9uVttG27Ux7UaszAkV=YTTWYDsyg@mail.gmail.com>
Subject: Re: [PATCH] NFC: st21nfca: Fix a couple of fall-through warnings
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 12, 2019 at 9:39 AM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> In preparation to enabling -Wimplicit-fallthrough, mark switch
> cases where we are expecting to fall through.
>
> This patch fixes the following warnings by adding a missing break
> and a fall-through annotation:
>
> drivers/nfc/st21nfca/dep.c: In function =E2=80=98st21nfca_tm_event_send_d=
ata=E2=80=99:
> drivers/nfc/st21nfca/dep.c:391:3: warning: this statement may fall throug=
h [-Wimplicit-fallthrough=3D]
>    switch (cmd1) {
>    ^~~~~~
> drivers/nfc/st21nfca/dep.c:404:2: note: here
>   default:
>   ^~~~~~~
> In file included from ./include/linux/kernel.h:15,
>                  from ./include/linux/skbuff.h:17,
>                  from ./include/net/nfc/hci.h:21,
>                  from drivers/nfc/st21nfca/dep.c:17:
> drivers/nfc/st21nfca/dep.c: In function =E2=80=98st21nfca_im_recv_dep_res=
_cb=E2=80=99:
> ./include/linux/printk.h:303:2: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]
>   printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/nfc/st21nfca/dep.c:622:4: note: in expansion of macro =E2=80=98pr=
_err=E2=80=99
>     pr_err("Received a ACK/NACK PDU\n");
>     ^~~~~~
> drivers/nfc/st21nfca/dep.c:623:3: note: here
>    case ST21NFCA_NFC_DEP_PFB_I_PDU:
>    ^~~~
>
> Warning level 3 was used: -Wimplicit-fallthrough=3D3
>
> This patch is part of the ongoing efforts to enable
> -Wimplicit-fallthrough.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

--=20
Kees Cook
