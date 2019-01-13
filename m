Return-Path: <SRS0=htfS=PV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C48B1C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 13 Jan 2019 13:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97FBA2084C
	for <linux-wireless@archiver.kernel.org>; Sun, 13 Jan 2019 13:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfAMNdp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 13 Jan 2019 08:33:45 -0500
Received: from mail-it1-f178.google.com ([209.85.166.178]:51667 "EHLO
        mail-it1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfAMNdp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 13 Jan 2019 08:33:45 -0500
Received: by mail-it1-f178.google.com with SMTP id w18so9447535ite.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2019 05:33:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CwdrgU8Ki4pQNNz+cVeAS2B5A3FC3Hv2MflgdUWz63g=;
        b=GBvSEHdlZ6AKAwS0ZqChhlgMnBp9a9oZbRpkTNqtMds0P1ug7VSF4Xwl7dC0Qd2DyT
         Yq4NLamP+/oMjy1tvMGHR2EIjI7R2OrRogty7IRwQN+jZ5oKWtiDEf3vqEeYcZanDz4k
         kOiu1iu3x0cL0/eScyu8KH2WjHndfMYfLpCF5/J9vs2YjxrM0VViF+3hGa1l2uFKkE6P
         OdOYJJ3uPSajgi2XIscHFhnL9nYV7bR/8g/xnM+G4qb8SKN7esdk/2xZPtsS4XOhByVI
         ZGTlv+43H697itvaOkJyMGh8rl0UbaAxbcyrNvEtgp1qsgEU14M6IkPh6h+efAnzdDCN
         7EXQ==
X-Gm-Message-State: AJcUukcOEQFh3Yzpb6IP7VXEUHYEAhVma5umcR/6+7faAr3GrSWXhAPa
        Iv/gc7pTOc41bd0mf0tZB7efljS3kqGPFNWvMBislw==
X-Google-Smtp-Source: ALg8bN4b7oWLVXsRiRcfbYo/NCeoNGVqwFU8a5u8MrcKv0xz2anIf4L7bfJgyBhpyu/VRZneECHYQp85vafwfkgVfS0=
X-Received: by 2002:a24:a141:: with SMTP id n1mr6021680iti.31.1547386424622;
 Sun, 13 Jan 2019 05:33:44 -0800 (PST)
MIME-Version: 1.0
References: <CAKxU2N9o5WeUwFMUwwXKHaPj7R+oiSKV1c2n8RtXwGNZRtw5Sw@mail.gmail.com>
 <CAJ0CqmVNF83bWgc+LSQ3_i=zfp-sXC5Nf=nKfqB3SWa8r7sKdQ@mail.gmail.com> <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com>
In-Reply-To: <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sun, 13 Jan 2019 14:33:33 +0100
Message-ID: <CAJ0CqmUgPWNJtCW4Q__sOtB8w-YtwW+uZy7crxMNrmSgQ6OFyA@mail.gmail.com>
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
To:     Rosen Penev <rosenp@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Direct. No VM used. This is the only peripheral causing this issue.

Is the device connected to a usb3.0 port? If so, could you please try
to connect the dongle to a 2.0 one?
Could you please double check if IOMMU is enabled?

Regards,
Lorenzo
