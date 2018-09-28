Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D10A2C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 10:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 814F12172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 10:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YWwxcBfw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 814F12172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbeI1Q60 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 12:58:26 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44502 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729242AbeI1Q60 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 12:58:26 -0400
Received: by mail-lj1-f195.google.com with SMTP id q127-v6so5320161ljq.11;
        Fri, 28 Sep 2018 03:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8hy3niZF/l97v4Ns2Gf1rhpp+Ch/DHelIBWRZC2DFAw=;
        b=YWwxcBfwGEfqyNt1oqTfN6lIU7YYQh/DYRJWVyuuUzNcD4CL8dqYSveO59j60kv21T
         6iqQyM3bFYtL5TbGUgi46Wdp5J6NVYiY32klkzTVsLa8Rmnp1nnpJ9itlZ5IUtErWILx
         eetbma+95Xvy8QoC9yRf4XXZZnSaccfT3PrIHUkkYjg2537mS2huRmKa0HZLZvAZPq0T
         uizqJTSKa4WQgNGIc+GZDGJpEDAvX6j+ojpquidMDH5KbIfa1bfBNZgqfT+oNjSUsdY8
         br9ISe8tOCmiEuKKpenzLQA0tjGwSNl+eXiEXQCEJed9G0HLMamykmQwFD6ydC3OerVG
         tNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8hy3niZF/l97v4Ns2Gf1rhpp+Ch/DHelIBWRZC2DFAw=;
        b=CfWrZgI5VYUqvbWRs4QnydTiq8YktPK4gzmsAhTPtzLrC2n1tVNMPeKSUmxN7Sbtwd
         X3FPTi5n41hBD2pNaTGc30O/Qm7ufH71lS1rT9jbfwzKI/vXc8Qkdon9vxPZSuhxe8x0
         YPhB1gux4e5jKZOfa/jPNBiLbIjLWaoTtRILNCu7zFR93bPvwZ1gXsA8UoteZgojr/W+
         9cQOmThb1yIWplleaGQh/cGJITCuQWTsJfMuA0Ziqb60k3PG/aMigidJPSUCY3OmVqPj
         IZTDZeSv57n/cXjaF3iop4Vi720yI2G5gyDyJVV4Wm24qt+qDd8b1pMeFCoa1HonHzWh
         2u6Q==
X-Gm-Message-State: ABuFfohrEg+kVLO3Va1VeR2EInKvRcH21U3zo9KFCr9fdMuRNsINXwWb
        1bRnXLu7fwXUnsNAo0P3Cyk=
X-Google-Smtp-Source: ACcGV60XqV7f1PtZ3OKYI9tSpUW8TzH+4Esyn+EP7l4kNhLLsN+ex6B968LAc/CSNOI9vdf0YvvgbQ==
X-Received: by 2002:a2e:9e99:: with SMTP id f25-v6mr2117657ljk.142.1538130916816;
        Fri, 28 Sep 2018 03:35:16 -0700 (PDT)
Received: from jonathartonsmbp.lan (83-245-238-10-nat-p.elisa-mobile.fi. [83.245.238.10])
        by smtp.gmail.com with ESMTPSA id g5-v6sm949800ljg.54.2018.09.28.03.35.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Sep 2018 03:35:16 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [Make-wifi-fast] [PATCH RFC v4 3/4] mac80211: Add airtime
 accounting and scheduling to TXQs
From:   Jonathan Morton <chromatix99@gmail.com>
In-Reply-To: <5d961a5f61de45b85b1b037bcef9270d@codeaurora.org>
Date:   Fri, 28 Sep 2018 13:35:14 +0300
Cc:     =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kan Yan <kyan@google.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless-owner@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Content-Transfer-Encoding: quoted-printable
Message-Id: <44B09168-C08F-4C85-8D74-D576CCC79880@gmail.com>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
 <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk>
 <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk>
 <8f7145bf5abe50194bced025a5e739b9@codeaurora.org>
 <863bc54fbf04441d38dd53f523300a7e@codeaurora.org>
 <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk>
 <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org> <87zhw2eyfo.fsf@toke.dk>
 <5d961a5f61de45b85b1b037bcef9270d@codeaurora.org>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
X-Mailer: Apple Mail (2.3445.9.1)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On 28 Sep, 2018, at 1:19 pm, Rajkumar Manoharan =
<rmanohar@codeaurora.org> wrote:
>=20
>> This is going to break fairness; we only want to increase deficits =
when
>> all stations' deficits are negative. Hence the two loops. Did you see
>> any problems with those specifically?
>=20
> No. I didn't see any issue but the loop won't exit until one txq =
becomes positive.
> Till then the lock won't be released. Hence I converged into single =
iteration.

The problem is that the fairness behaviour is changed when there are =
already positive txqs, but the first one happens to not be positive.  =
That's why there were two loops.

 - Jonathan Morton

