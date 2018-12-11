Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB4EC5CFFE
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 15:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 337D520849
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 15:28:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pLU3kRYu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 337D520849
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbeLKP2Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:28:24 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:35724 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbeLKP2Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 10:28:24 -0500
Received: by mail-it1-f193.google.com with SMTP id p197so4440719itp.0;
        Tue, 11 Dec 2018 07:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZeJc5Z78+KJYPgloZolaLvpWqpzYOghx8A6swgFWMQw=;
        b=pLU3kRYuNQoPQ92GOoCjw+KjnykhzkRHYKCkmJkFse74MD7IwZ61bfl5Nnp7+DnuP8
         7IS8fhcjAlVwc0WwPQjfZRVZXqOAasC0+HehanFiLQeq2Lp4FstM/B2edJa1nxCGQOG9
         uXyQM6FQl5heo2TXt/IKIWaZiOUNJ3fR7+d+2u+ASIlKlu/atMg3PuTdRezQaaYDtWGs
         zXsuXXwrIkdJ1WjWNe5jRJst6iKqeRmyhWGAXotbCSbhCyoo6nemeVpKOOv6BILTnrFu
         roUE2pHSfgFs3/Aw30oJv2OfxlwDK95FWKnzORaz+/8bLDyVff2JhMthXAWI/kjMj5pF
         rvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZeJc5Z78+KJYPgloZolaLvpWqpzYOghx8A6swgFWMQw=;
        b=i2eumcqglFQ0yDROPdHQtBSGczKfpZHMCLBQoQbWCszgE68ZsFA0E+pyKng73WslGM
         Hsu06mAj8wgzpsHEATPkg2UuZqIACoxAW+ztOubNV+5Lv0oO4+hW8JFCVj6akkfPnvTe
         Eo0RsbgNmbKUrK0LIZ78DUdhf4CG1fjdQ/L8MCfsPlzZMT06lBRXkgd2loqeMhFk5YDa
         zpIRx8vYi7AN8zEpn+z5mJjJGrBfMyhUWIr2xm6maJ7pmC9KZs/oB8Bi1hSYphlxdw/c
         fWw2eNczECcP2Vkn3aV2OBodQoVl8lo030dx4qmSsSVLyMQ4ygawNRFOQlQSd/zdY5ZJ
         +oHw==
X-Gm-Message-State: AA+aEWaGsmOJnujg9YGqH9fvbIvZGW8gRDWAKy7i7U0EIuBzafTnU9dd
        qjjIGWGbhYyxPac9nFsvnFagcMgbLv9Qi5iLwiA=
X-Google-Smtp-Source: AFSGD/VUeVT7kfAFBxv2idN/ljN2u2mDAr5eePFr/YtbQumBlmEQy2og8SpCKhzHmNHU5OWi4ZjOcQRFjjYGvFNwe48=
X-Received: by 2002:a02:6c90:: with SMTP id w138mr15498863jab.60.1544542103671;
 Tue, 11 Dec 2018 07:28:23 -0800 (PST)
MIME-Version: 1.0
References: <20181203132557.12269-1-tiny.windzz@gmail.com> <874lbug2fr.fsf@codeaurora.org>
 <CAEExFWtc2vRm7k2YpoNae+tOtnusSbVnapU-Wmo7kR-WfY+dzQ@mail.gmail.com>
In-Reply-To: <CAEExFWtc2vRm7k2YpoNae+tOtnusSbVnapU-Wmo7kR-WfY+dzQ@mail.gmail.com>
From:   Frank Lee <tiny.windzz@gmail.com>
Date:   Tue, 11 Dec 2018 23:28:13 +0800
Message-ID: <CAEExFWtqn=-0bq6u_YWhn2YtwVL-eoEEUFkXSU-G5wc4UE=MXg@mail.gmail.com>
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

On Mon, Dec 3, 2018 at 9:36 PM Frank Lee <tiny.windzz@gmail.com> wrote:
>
> On Mon, Dec 3, 2018 at 9:33 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> >
> > Yangtao Li <tiny.windzz@gmail.com> writes:
> >
> > > Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> > >
> > > Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
> >
> > The prefix for the title should be just "wil6210:", I can fix that.
Hi Kalle:
Why I can't find it in ath.git?

Thanks,
Yangtao
> >
> > --
> > Kalle Valo
> Okay.
>
> Yours,
> Yangtao
