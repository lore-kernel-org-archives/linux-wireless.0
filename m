Return-Path: <SRS0=76X5=YW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E520ECA9EAE
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Oct 2019 19:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E9620659
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Oct 2019 19:48:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20150623.gappssmtp.com header.i=@morsemicro-com.20150623.gappssmtp.com header.b="K4MOVcdh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfJ2Tsz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Oct 2019 15:48:55 -0400
Received: from mail-oi1-f182.google.com ([209.85.167.182]:35474 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfJ2Tsy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Oct 2019 15:48:54 -0400
Received: by mail-oi1-f182.google.com with SMTP id n16so7758197oig.2
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2019 12:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=693fUo1ysNssslShZbY83OFM2Y+KV6wMnMqE93xCHIY=;
        b=K4MOVcdhCM2rd5TifDwdU+jJjXfYrGreCS8OX8wfemC4fdsMCVNjUovEZirnDRXgYm
         XyJ3LMQkld+XO0/k9vW2aDJKyBV8wf5Nn9AApjIEB9bYCtWXCfrdA1MCbZokn9aaaPkW
         CBA5KOecJ+zxhoCgLShCIcYPCyMNZnAd0PkmpGAwydHG1KgalgQChlMEAlc5Px1gSYNG
         iRDgXmIN/xcTX6nUvFTV6bb87EfnWHrw2sWavhSpF2LkPtoqADmbwDOWWF/RG71Cgnhd
         dj00R+/RHeTCmz3sUA1Ghecep9/J/TO6p6MhYI/JMcsrV5kCiv8LUM8Z3wx0rMmC1ebq
         qJSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=693fUo1ysNssslShZbY83OFM2Y+KV6wMnMqE93xCHIY=;
        b=BGVlan5Fi9W9Xqj9LVN6+d3gYjXyrrjVqM7qx4heCg9pae6m/7V1kKNBv814fMAEmk
         Hs5FA1z2Qkr1DtSecXkU5oGyjgqYNvNN+q2L4/HHXRmGpEwlBfVjP09N2SiffObTQJvL
         4+cbrJMrwrioAy1J6pjCCWSr2F+k3iQUjM1KnES4fLs3QNf142DcR6nlNcTBdWKBDqX3
         BcFlUuNpMGt6noGZyRtZXF+kcqbxGd8QTPAC0VQNRoDH4G81QdscsLB0Z/CdFkJEgA4j
         See+7bNNPaZNP28jFIq0zcy1gabxaBYSgxuSVRGBaXktFLft6jcxC5MWMvMJ2x66ScgI
         Wttw==
X-Gm-Message-State: APjAAAXlaJHlu3lZXWQu2vtigpHraMFDe0YT7RRcXhdkbDgcQ/WlLV3Y
        udOIggqEbiuiqfF03IHbBsfE4XZdu44q52bc0WkwCuyzXavD3Q==
X-Google-Smtp-Source: APXvYqyA7TvlEzR3F6fRt17RfdBVo5MD1OW9pfuHKxvvA9EzeS7TYRkY/B1A+bxYTRJLzyYM8WvFDvOCDbnuvydiEZw=
X-Received: by 2002:a54:4f87:: with SMTP id g7mr5691570oiy.100.1572378532033;
 Tue, 29 Oct 2019 12:48:52 -0700 (PDT)
MIME-Version: 1.0
From:   Bassem Fahmy <bassem@morsemicro.com>
Date:   Wed, 30 Oct 2019 06:48:39 +1100
Message-ID: <CAEirPfz4FEtuRH8VST0ehtQtttPpFJFrZLDb9v7heUAb8EA2tw@mail.gmail.com>
Subject: Chip debug tool
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi
Our systems team is asking to develop a chip debug tool to be able to
test, calibrate and tweak every bit of the chip from user space
(something similar to Broadcom's WL tool). The tool would later be
stripped out and passed to customers to help them tweak specific
features.

The tool needs to be easy for the firmware and RF team to add extra
command, by adding some definitions in the user space tool and a
matching response in the firmware (no driver recompilation).

Based on this, I can think of few of options
- nl80211: to overload NL80211_CMD_TESTMODE or NL80211_CMD_VENDOR or
- nl80211: to create a new set of commands. These options don't seem
to have a chance to go back upstream though.

Another option is to use debugfs. In this case however, all the
commands would go to a single node, and the driver which would blindly
pass data to/from the chip. This is to avoid recompiling the driver
every time a new command is added.

Just wondering what is the proper (recommended way) for this. Any
ideas, directions?

Thanks, Bassem
