Return-Path: <SRS0=gxms=5U=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D54C2BA19
	for <linux-wireless@archiver.kernel.org>; Sat,  4 Apr 2020 12:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5997B206CC
	for <linux-wireless@archiver.kernel.org>; Sat,  4 Apr 2020 12:40:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mxt+EiXA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgDDMkW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 4 Apr 2020 08:40:22 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:44357 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgDDMkW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Apr 2020 08:40:22 -0400
Received: by mail-il1-f193.google.com with SMTP id j69so10091461ila.11;
        Sat, 04 Apr 2020 05:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DMilp5Y8BVH6if/NI1zbNV6UkhCq+PZvwGLDckXQ+Lg=;
        b=mxt+EiXAOgBg88WxmamGd2DGA+6EmZAdD0YHaU9QzHAthMaPTFPsAPqOj9eU4zVuxT
         Qk1OWO1k+CZBQKnrVz/TFSbDh0NVGr0I9UBESDONH+alxceGmd8iHNP2N4i0hWEFfrrs
         32P+tHGLAvWf/G0XgOsIKAsAZxmmN/yIpkxPObLU4xRT1htH2UZNxYTfsbrqyp6pvZ9N
         aV+LDIs19dQ3BM2ukvXVHoXe/Pft9huPmlIvNc7dcapqlctICXg9UAhVkrKGEz7iXmCw
         nTKLTQgkJ3Sf080zmdxt9xG34HPqwVl7e2IQ3vqINR/U9IdKqzRRdgLfrwZ1e8y98YAN
         5Lsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DMilp5Y8BVH6if/NI1zbNV6UkhCq+PZvwGLDckXQ+Lg=;
        b=lQrnJE2nED+oAf4mnYgHOQexK4VXQp+ALHWafLohcievTotkHXQWnhHlo5s3G8EOjW
         mwiIqa/nKTSw9ruqD0nm3lrZB0cWxv7ocgLfbIHCxxqQSQTpXd5cNe9fuj4gAAdVc7qd
         AHYHptEnMvHDJGKqW5te9XfWYbw5bzkU3HIiw8K5yzfN6EEWpEeWNFp/wTlc4wTlIlo8
         CbrAK3K3Y7w3DJ9Z+7uR4PsQ4afAAKH1uVIN6bOQTctuPkdr8m+g7QTchrrNhfnQ5WkP
         N9T3s97ufvaHLwrZx0DxR2sK7rMXHbayilB+K0ON8mafL8bhIS3iws8sij1PONBa6aS2
         Q3Tw==
X-Gm-Message-State: AGi0PuaEDh3ooj8NOo4kqFGdAAPYOwHMU1ENS6vmgOAepUqlDp23/OjR
        4vxabRXpqDI4e/1tHwf3XOdzhMdf6Qr8RzCQhhA=
X-Google-Smtp-Source: APiQypJc8wnPB72gDUO7oZZxGy5r8IChq9Qttgki0bofvkwMl4ZKF1p6w/OsEZbzDJOk7aVab5v1EYqCtEgVia89p6s=
X-Received: by 2002:a92:5b56:: with SMTP id p83mr13413183ilb.70.1586004021422;
 Sat, 04 Apr 2020 05:40:21 -0700 (PDT)
MIME-Version: 1.0
References: <d3083092-bb87-daa4-673c-06f935285254@web.de>
In-Reply-To: <d3083092-bb87-daa4-673c-06f935285254@web.de>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Sat, 4 Apr 2020 20:40:08 +0800
Message-ID: <CAJRQjocLOXBU3GK+8s4=R=8ik_7xOeSNkpb9scaLDNZt6gAisA@mail.gmail.com>
Subject: Re: [PATCH 1/5] ath9k: Fix use-after-free read in htc_connect_service
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Qiujun Huang <anenbupt@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Apr 4, 2020 at 8:30 PM Markus Elfring <Markus.Elfring@web.de> wrote=
:
>
> > The skb is consumed by htc_send_epid, so it needn't release again.
>
> I suggest to use the word =E2=80=9Creleased=E2=80=9D so that a typo will =
be avoided
> in the final commit message.

Get that, thanks.

>
> Regards,
> Markus
