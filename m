Return-Path: <SRS0=ZKB3=N4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E28C43441
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 00:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5B582087C
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 00:48:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mQYJfv0u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5B582087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbeKQLDU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Nov 2018 06:03:20 -0500
Received: from mail-io1-f43.google.com ([209.85.166.43]:41685 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729714AbeKQLDU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Nov 2018 06:03:20 -0500
Received: by mail-io1-f43.google.com with SMTP id s22so6561317ioc.8
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2018 16:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bKyUv2BV0HZneewf+8R52kNO3d2aIsm31o9c0Oy98vg=;
        b=mQYJfv0ulEIpDI4pQVtbE/iZbNC0SxpT7y5XjLoobbySsNpc/oTD68r71h7jtwZCkv
         yf3UuSGM6gjLMt5fQikwdiLU0J2BmHX49s7lbBvCRcH30I+vwb8aqQHPO/VAjdt8FfqV
         faf0kvvXjvPqQVnXVaSoM/LHVqVXYy+EAaDMs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bKyUv2BV0HZneewf+8R52kNO3d2aIsm31o9c0Oy98vg=;
        b=e2X1B9dNFd5YydgieB7JxrmAGOhzsDZ9uGvjt5+oCt/4IUAl7+m7fgc0PIotn0RUda
         /7HViZ+7nwgDgQ8zACquBIkEAjaZWJbElS0oPOftLa3BFNJ3SQGrHmGIkmd1xf1p6mnP
         dBKAip3Tka620/gMWVIF5eFZZ1ogJV8KG1rEAuuru1843H80dCAr8UqFtR+X04Lns7XW
         DwcaJ/D6/iwqwt0Mbfi//IO5b5JrD5kRp2uqdg+ckqwIFZQFrUtSaukg26/ZygQwR1G/
         TF3bssPh1JjNBsRTnr5ysB0SLiCngaAHddKR2pcDGCKw95VaPyZ9rBYrCTqqL16wIm1a
         0UlA==
X-Gm-Message-State: AGRZ1gLNt5yZ7RWeTMKmINQXPoaGMI142lsG9ZVd9SQzNnh8ASqwJTTa
        EWna5J671vRL0KgV+6ZvfQ97Bvjn2qI=
X-Google-Smtp-Source: AFSGD/VLRcjrWgtgiyxtyw1RUXDazf7dxQUBZZvW6zAxPyB4F7J4caakQ5hV55mHcW1FSN0p4khL+w==
X-Received: by 2002:a6b:8f91:: with SMTP id r139mr10500974iod.128.1542415721539;
        Fri, 16 Nov 2018 16:48:41 -0800 (PST)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com. [209.85.166.50])
        by smtp.gmail.com with ESMTPSA id i74-v6sm18970828itc.29.2018.11.16.16.48.40
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Nov 2018 16:48:40 -0800 (PST)
Received: by mail-io1-f50.google.com with SMTP id a3so11742594ioc.4
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2018 16:48:40 -0800 (PST)
X-Received: by 2002:a6b:c047:: with SMTP id q68-v6mr9832526iof.86.1542415720092;
 Fri, 16 Nov 2018 16:48:40 -0800 (PST)
MIME-Version: 1.0
References: <20181117004720.205811-1-briannorris@chromium.org>
In-Reply-To: <20181117004720.205811-1-briannorris@chromium.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 16 Nov 2018 16:48:28 -0800
X-Gmail-Original-Message-ID: <CA+ASDXPaPiooFGxsx-4dajW3XWb3wo_VFjUJOOrGjqO7bo2RRw@mail.gmail.com>
Message-ID: <CA+ASDXPaPiooFGxsx-4dajW3XWb3wo_VFjUJOOrGjqO7bo2RRw@mail.gmail.com>
Subject: Re: [PATCH] qca-swiss-army-knife: ath10k-fwencoder: add new 'single-chan-info-per-channel'
To:     qca-linux-team@qca.qualcomm.com
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 16, 2018 at 4:47 PM Brian Norris <briannorris@chromium.org> wrote:
> This ancient Wifi still tells me I can send patches here, though I

s/Wifi/Wiki/

Sorry,
Brian

> haven't seen that much :)
>
> https://github.com/mcgrof/qca-swiss-army-knife/wiki
