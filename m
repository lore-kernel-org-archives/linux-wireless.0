Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40119C282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 23:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01D2F2148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 23:12:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RnTcY35p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfA1XMm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 18:12:42 -0500
Received: from mail-io1-f43.google.com ([209.85.166.43]:37135 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfA1XMl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 18:12:41 -0500
Received: by mail-io1-f43.google.com with SMTP id g8so15028493iok.4
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 15:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=RJhzwbCKJhDkoU4j6D86DZsHz75ht5qcGzab3ztBsKM=;
        b=RnTcY35pyQlU8Qwi4uRbQ9cspAF6JvVqKYFLhGjcyIcIzOV3OrPWjkxvLofty7ZblE
         KK23teyOQ+i4QJnuiHs+IeDyaGeNBiQsnAGoh6pGhLsC17BU1H/LmQVCSc0MFYjnhzUX
         tdQjLIsKkG+9WLcDg/IJO3FkzB9mc71SoDRYw3DLpsuC0VbsehhWvUb1XmoeVxqN3i+m
         x5zUd9nXqsT6vbyej6FlBqBjzNfuzPgnuh5xfwfysRmhiTHR7zEq3RntssSmotstv8TV
         8scAfg7viJsQGrLtzx3ftobYRbIM/MQZfqHOg7xhFnY2rVFTPWKHmsE+4l2ti4SxPd93
         L0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=RJhzwbCKJhDkoU4j6D86DZsHz75ht5qcGzab3ztBsKM=;
        b=BsuEkzU9pPkmt9ztARm1IWyrVlLTnuApskcWfuqc+i7xCdPfCg5Gpnujq1cTflAEc4
         Nn2myaQamzwiNf+u421PAjvV3ATnjGhAxyJJlmDELejdccyrdiXpTdctuDKDObpD6E7L
         JcfoK07f+apgNPGjvpNLRUi86Rim/JY8RjGyj28pN1Vi8KZC5w6+XXGSwEbORlOj7kVK
         4U3pX283kb+LhUY9uiLp5Af6Sci4nIV+PYZSk9SNFBIdkH78HumIpLuYmyOOWvd5uTzD
         ClZfkRXI36iqqT/EZF74vek7ngKzFhBk1SvxUuv9gOcCcvgrHbB46dDNRtzHKOwAFgEv
         X/6g==
X-Gm-Message-State: AJcUukfZJkntv2NeijBL/yhg5ATeN2BYVLoFFtdZPpWogGbguDo/BQSQ
        PM2w9itXVYY449s4gCpxA5Q0oyQz5YhRKhEND1QjOwbOrZA=
X-Google-Smtp-Source: AHgI3Ibe6hspT37PMXnKrkxnH4DSpyA5u4rFyonR1rR0Q59jbJCM7+x8lhnoiGIiaSX+WgrsVEY48Zhzm/aolgv8T38=
X-Received: by 2002:a6b:5b12:: with SMTP id v18mr14646293ioh.157.1548717160737;
 Mon, 28 Jan 2019 15:12:40 -0800 (PST)
MIME-Version: 1.0
From:   Raul Siles <raul.siles@gmail.com>
Date:   Tue, 29 Jan 2019 00:12:29 +0100
Message-ID: <CANP28d09JUQRB-iCBAGgkzv3zZ6k+irNB3uMYW3teN5xLX-eWw@mail.gmail.com>
Subject: Wi-Fi drivers/chipsets supporting 802.11w / PMF / MFP
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,
I already published the following message in the
hostapd/wpa_supplicant mailing list two weeks ago without any success.

Is there any resource publicly available with the list of Wi-Fi
drivers/chipsets providing support for Protected Management Frames
(802.11w / PMF / FMP)?

Based on my testing, PMF (a requirement for WPA3) works with the
Atheros chipset and the ath9k driver.

However, looking around for compatibility with other Wi-Fi cards, I
have only been able to find the following references (aside from spare
patches for other drivers, sometimes mentioned in this mailing list):

https://wireless.wiki.kernel.org/welcome?do=search&id=11w
    ath9k: https://wireless.wiki.kernel.org/en/users/drivers/ath9k?s[]=11w
    p54: https://wireless.wiki.kernel.org/en/users/drivers/p54?s[]=11w
    carl9170: https://wireless.wiki.kernel.org/en/users/drivers/carl9170?s[]=11w
https://wireless.wiki.kernel.org/welcome?do=search&id=mfp
    ath10k: https://wireless.wiki.kernel.org/en/users/drivers/ath10k/mesh?s[]=mfp

What other Wi-Fi drivers/chipsets (or specific Wi-Fi cards) provide
support for 802.11w / PMF / MFP?

Thanks!
--
Raul Siles
