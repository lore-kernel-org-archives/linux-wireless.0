Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B7DC282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A332520863
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:05:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Vqje0E1B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbfBHRF2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 12:05:28 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43007 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbfBHRF2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 12:05:28 -0500
Received: by mail-ed1-f65.google.com with SMTP id r15so3348126eds.9
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2019 09:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MWMOX+oYPgK2dUHfERzejc5eIWlGjgJ9HuVBpHoRkT4=;
        b=Vqje0E1Bs9d1tcKDuJBl82t4ZtCFtoSm1w2AqgP/7IoqcMRWZGdt6ovrQEWqqmKzzH
         mQX8UeHzPg3PvbRXth94zqXJMAjg3D+IzFJW8LcmBMlEhzPMmBHxn9H5XRmaomKchoOx
         GPluPxxe9wS+0CvxrWoW0XVnVRZ1dYz9xkxTU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MWMOX+oYPgK2dUHfERzejc5eIWlGjgJ9HuVBpHoRkT4=;
        b=WKEsP9z3ERdDRFJ5PQBQjNLzCDSrRPV64b7tax0AWDXH+q1hv67e1SI/RAfCm/L3tO
         ToF+JtCGk3+iOM6p5azIXb+bSOg/ZN8Q2howyXKSrtVwPQJDYsORLb6HYQjcdx+qtMvd
         Du+SSWvYQKf/OrvS/MtZVAt5MuOvT7TQrJdUgOwMFRB4pcfwM0prxJ9oQHPI6t1tihze
         gW2mbuaGqLBdOeNahgh/fG1PHR205+HZWPkcUQ2+zgrZdMSNTwcqpRXzvU17gW6O0E+A
         AnLE9OWvGLZPUulfD5sFoIBj6Vxr28LTl7ErKPG7dxPdsWqQjmf07pwmO3Syp0YmT6/e
         RqVw==
X-Gm-Message-State: AHQUAuYJ/w3GxT8ZbwJXAek3y4FzEJQ/L3QzRB5It7xRs5MgaNCFFfra
        pGk5QegCsfRKssidAB995cXVu/oh/Sk=
X-Google-Smtp-Source: AHgI3IbUM0d+z3Oh/AS1umEPh7y4LjWkeMrxrC1/ZoWxc8+qT8n6l3xN/a02aanGUoQICp67K5iKVg==
X-Received: by 2002:aa7:d749:: with SMTP id a9mr17221890eds.223.1549645526316;
        Fri, 08 Feb 2019 09:05:26 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id t26sm581801ejs.48.2019.02.08.09.05.24
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 09:05:25 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id t6so3337434edw.12
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2019 09:05:24 -0800 (PST)
X-Received: by 2002:a17:906:5382:: with SMTP id g2mr4042771ejo.163.1549645523924;
 Fri, 08 Feb 2019 09:05:23 -0800 (PST)
MIME-Version: 1.0
References: <1542163848-837-1-git-send-email-wgong@codeaurora.org>
 <20181115002836.GA71934@google.com> <c94346b26a6d4b11a045a176ca854051@aptaiexm02f.ap.qualcomm.com>
 <20181115184333.GA87504@google.com> <87va4x8q2c.fsf@codeaurora.org>
 <CABvG-CVAnwkiKVJik0PdsmRxF62kKv2N+aRKNq=nbopoExLvDA@mail.gmail.com> <87y36q75wr.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87y36q75wr.fsf@kamboji.qca.qualcomm.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 8 Feb 2019 09:05:11 -0800
X-Gmail-Original-Message-ID: <CA+ASDXO8NujrORVLZMPbDy916cnzOvx_Bp8Vr-VvkbBwJvB97A@mail.gmail.com>
Message-ID: <CA+ASDXO8NujrORVLZMPbDy916cnzOvx_Bp8Vr-VvkbBwJvB97A@mail.gmail.com>
Subject: Re: [PATCH] ath10k: support PCIe enter L1 state
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>,
        Wen Gong <wgong@qti.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org, Wen Gong <wgong@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Feb 8, 2019 at 5:42 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> No replies from anyone (including Wen) for 3 months about testing this
> patch on anything else than QCA6174. So I'll drop this now, please
> resubmit once test coverage is better.

I know this isn't exactly what you're asking for, but FWIW we've been
using this since late November on all our QCA6174 products. No issues
seen as far as I know, and we have seen some power savings.

Regards,
Brian
