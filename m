Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58079C07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 16:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A6132084E
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 16:10:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cObSKwxD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A6132084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbeLKQKh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 11:10:37 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:36754 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728457AbeLKPvW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 10:51:22 -0500
Received: by mail-io1-f67.google.com with SMTP id m19so12188058ioh.3;
        Tue, 11 Dec 2018 07:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=doSo541dmf4Ksq9pcZk6S75TouJI5vzyUJe2I4bzACQ=;
        b=cObSKwxDpFh6F4KAOU0BnKl+VY5yUgE+jdDZOSebjzfN7M0n/cI9XPKkoirdoTgcnd
         CH32tMlcKKpzZCCe9Ii1s2hI+8DdnDtxkmZMhnjFmaBOKqL9sXggZvLNO/I6Waq3Eqk2
         TFtRYOn4YjuPbNFxLtNL5WgMKwdQ9FfDEGh0eswySEaz2+ZfPoyOjJq0n9o9rE3ei9HE
         SLxLsfQ+WODPCsDDiSu7vyM11G5pREL+THwzszqlG9iVNfMB0D2Sv5JcigRDr6Kkd66i
         3noG+9niQg9IpyIwIKlQ2TkQwLQgShUVneicH9m+RmW3gQ0QR7fiJQ0iFTLI35RTUKlx
         ulBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=doSo541dmf4Ksq9pcZk6S75TouJI5vzyUJe2I4bzACQ=;
        b=qpy0t6ghhYT+qHwyEVCb9ecgzPgHuEmkzatrPsMXjwJSeonr9+j3sREtNVhOBhy5o0
         nTDExgblBkCIaJyzv73OG8yy7UMwoljbbM9WBFxfgnJBpLfjTLvBWSS/JFxhvcgRkPwm
         zhWHs0TUmeKUrPSMPdjx3ol1gRQVcJtnWEXcE+VYIgV21F6bX1hq3Iva+kzDUNsOCJE/
         pm3E1Zv+2ZOutfcNwYRjZir4zJ+R69FMF5KH9LHTNBUgyLyGT3eKcdeuyASs4TIukYj2
         6UDcIg1041yTFmgDF1gueKcWGe+WFSeIP+eITlvur5My37JrZnkUaK6tF1RscYjjhGTL
         sguA==
X-Gm-Message-State: AA+aEWY0IahSAA0zxT84N7LnkJ08NqHrM81YL3nkDi7ge/KKbAZYEAEB
        Hl/YRbqsdX/xtKSeHIiT/lkrpPmQLlOr7yUmjx0=
X-Google-Smtp-Source: AFSGD/W3hfDjmD8P/osBuSsX+JKDGyZOhxTg0qiaok0fAnaIdm3ChhSw9ydpn5mFvDl5g1eShlLcE9U4ZBVlPCrfEtU=
X-Received: by 2002:a5e:8b46:: with SMTP id z6mr13231655iom.7.1544543481707;
 Tue, 11 Dec 2018 07:51:21 -0800 (PST)
MIME-Version: 1.0
References: <20181203132557.12269-1-tiny.windzz@gmail.com> <874lbug2fr.fsf@codeaurora.org>
 <CAEExFWtc2vRm7k2YpoNae+tOtnusSbVnapU-Wmo7kR-WfY+dzQ@mail.gmail.com>
 <CAEExFWtqn=-0bq6u_YWhn2YtwVL-eoEEUFkXSU-G5wc4UE=MXg@mail.gmail.com> <87ftv412wb.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87ftv412wb.fsf@kamboji.qca.qualcomm.com>
From:   Frank Lee <tiny.windzz@gmail.com>
Date:   Tue, 11 Dec 2018 23:51:10 +0800
Message-ID: <CAEExFWuubkuEE57+DPVbwFTw9st6Re72dqtg-JHwQJsxkVF_UA@mail.gmail.com>
Subject: Re: [PATCH] wireless/wil6210: convert to DEFINE_SHOW_ATTRIBUTE
To:     kvalo@codeaurora.org
Cc:     merez@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 11, 2018 at 11:47 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Frank Lee <tiny.windzz@gmail.com> writes:
>
> > On Mon, Dec 3, 2018 at 9:36 PM Frank Lee <tiny.windzz@gmail.com> wrote:
> >>
> >> On Mon, Dec 3, 2018 at 9:33 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> >> >
> >> > Yangtao Li <tiny.windzz@gmail.com> writes:
> >> >
> >> > > Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> >> > >
> >> > > Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
> >> >
> >> > The prefix for the title should be just "wil6210:", I can fix that.
> > Hi Kalle:
> > Why I can't find it in ath.git?
>
> Because I haven't reviewed and applied it yet. BTW, you can reduce email
> by checking the status from patchwork yourself:
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork
Thanks.I hope my email didn't bother you.

MBR,
Yangtao
>
> --
> Kalle Valo
