Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9E6C004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 13:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B86DB2064A
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 13:40:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F8WiZlRE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B86DB2064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbeJXWIc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 18:08:32 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37704 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbeJXWIb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 18:08:31 -0400
Received: by mail-lf1-f67.google.com with SMTP id a82-v6so4004566lfa.4
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 06:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HoCUUCvKkB81zlJ8IH9KKVYD8VDhfY+y87uOHG+xmMQ=;
        b=F8WiZlREd7qYaHk16HAgxl8AMLHeIbGTcz9LlYEo7bv+OVY+EupWyxI3rYzCPcqdun
         nel9frwpkFi56DlUOudgQG1bYTGCY6HjRHEi9dxHnUqyRI6ek0BBRTtfR+RFdQkkJjJR
         Yp48E9jv4sxUwLCylDTxl8CnawrBoqWo5JsYg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HoCUUCvKkB81zlJ8IH9KKVYD8VDhfY+y87uOHG+xmMQ=;
        b=M8sZH5i58qc/R2wQNxMEPjgTPKr9Mbr/ol3aOzJXicIaIB/g0MdmmTazQVRW1zTk7S
         b45Fd6WUxwxFpKZS52vct+pOHeVky/obqNQWKa7E8SQIIEYFAAAOP2C1V1sIEwyq0M0O
         X7JGcjc01itR9Pu8lbEhjV9MGBDu3Fs17G9oGmQRQRbg/WS5aon0zvWsAFmGu6VpvFvN
         bdDIEXVojQ80KTZrmvuNl2WQaZpIJqFBRZf2puYI0F5NMsZxK/e7W9m55W6LG++HL4cK
         ZgX2jj1E2di/SNBtiGtq6Klm4UU2T7u0eVduMc51Zp6+Lx/M7OP53CH+MGe0nx1O+45V
         t7wQ==
X-Gm-Message-State: ABuFfogts+rKgNjUa2Kamo0x4ULd37ju2ToJvCOJYYONjVR7ntSzlws2
        LdG82N4h4O4ffalMXF22mZcNINUwyHNxdQ==
X-Google-Smtp-Source: ACcGV61uORJFpFeQ3pIqR7A8tHH84Z/rO0fG5sAVPOpvG1LKPR6Jd4xpCsvm5dLj2C//PMYv/TGIGA==
X-Received: by 2002:a19:d58e:: with SMTP id m136mr9266493lfg.70.1540388420364;
        Wed, 24 Oct 2018 06:40:20 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id o19-v6sm657517ljj.81.2018.10.24.06.40.19
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Oct 2018 06:40:20 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id t22-v6so4803558lji.7
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 06:40:19 -0700 (PDT)
X-Received: by 2002:a2e:9584:: with SMTP id w4-v6mr1860731ljh.118.1540388419188;
 Wed, 24 Oct 2018 06:40:19 -0700 (PDT)
MIME-Version: 1.0
References: <20181023.202921.1185045750138652543.davem@davemloft.net>
 <CAHk-=whuhCGujWKO8JObGQaSdWOpJBXdkM-B-vD80QZifveScw@mail.gmail.com>
 <CAHk-=wh2H9jE2RXibQgWs3_Q539roj62_gzPXKjnhhKqSFcw2g@mail.gmail.com>
 <87lg6nu6k1.fsf@codeaurora.org> <87h8hbu5uy.fsf@qca.qualcomm.com> <CAPBZ5Qen9ak4eFqdHEKNVoGBWUtohu_hwYxZ2cwmyAU=a8Mv9A@mail.gmail.com>
In-Reply-To: <CAPBZ5Qen9ak4eFqdHEKNVoGBWUtohu_hwYxZ2cwmyAU=a8Mv9A@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 24 Oct 2018 14:40:03 +0100
X-Gmail-Original-Message-ID: <CAHk-=wjjRzVi3qXvKEz7F1kA=YW_Ygp5PA6z6E1Jr-8cy-6J5g@mail.gmail.com>
Message-ID: <CAHk-=wjjRzVi3qXvKEz7F1kA=YW_Ygp5PA6z6E1Jr-8cy-6J5g@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     andy.gross@linaro.org
Cc:     kvalo@qca.qualcomm.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Govind Singh <govinds@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        jeffrey.t.kirsher@intel.com, niklas.cassel@linaro.org,
        david.brown@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 24, 2018 at 2:24 PM Andy Gross <andy.gross@linaro.org> wrote:
>
> Yes this will conflict with Niklas's patch which is part of the 4.20
> pull requests. I would prefer that we revert Linus's and take Niklas's
> unless there is a compelling argument to have it fixed before -rc1.

I have no objection to just reverting my patch when I get the real fix.

I just don't want my tree to have warnings that I see, and that may
hide new warnings coming in when I do my next pull request..

               Linus
