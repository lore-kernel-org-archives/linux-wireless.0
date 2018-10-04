Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAFFC64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 19:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2C7320877
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 19:07:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZtokSSzd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2C7320877
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbeJECBj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 22:01:39 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:37214 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeJECBj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 22:01:39 -0400
Received: by mail-qt1-f173.google.com with SMTP id d14-v6so2528989qto.4
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 12:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=wVGBbmrFOlm2YIm2TJFkaef2wa2zeHznealWeEB055o=;
        b=ZtokSSzd9tRGt/KJxdFVNG8JEsw2IqjeMmwzlroQYKvhF8BEauH8Gvp1VQIJ7ZzV9t
         Kejy8JqLQ/3lLKYH1K6+Rci4P6T0DOFjbfBUUouvqMp6oqlQAu+KtRCJgRhWJdWzRPii
         odVF/djXT1UzyqKOrYT9qdGo3ls9spRTTKk7jl/wI3lemClAsZ4qVi5MffZFoCpIdDJW
         K3oil25K9VSNOGy+phoUsXQ08zzLq3iH2efzP7PxCJPXvemc/Bq7mA2m5Pb+u9xfQa/F
         ZSD3q3qskOvN92gWX/9gRDt/kcAGRsb52JbpwOzdI3dQilJaWFIzOGid3msSOrvf7tKL
         YCmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=wVGBbmrFOlm2YIm2TJFkaef2wa2zeHznealWeEB055o=;
        b=TnVIHkgUw0Bg/QA9lyaSi04QHJ1PKlYRI/Cx3adIWxuOVglkGKX4VZKkhg+cVH8teV
         xbJ0KyBtwKCIQ1f/0m7pLhxmyNqemLDFldZw9VE8TfgMNFTqb47Z45BWYkG3B512X8+V
         YSFU6PvdL+8KWLzbb+5iKoqQGphdNa/g9JeXLMvVvm3LYrISMRW/3dva5b0a06UcbAe1
         npxP7iIVRJBnimnHmgYrPJx3mRTC5NatFIYLN3ZPEUbmI3SAxlNzFhHXJZmHjI8PRdTB
         dvXObbSmXMLLkuBHVlj7Ue9lxfZtrj3rKQ9TJ+TR9QNuKwHKXAPan2p/6XoqCP+tc0Y1
         3NNw==
X-Gm-Message-State: ABuFfoiTmKHxFxYQj78KJcHq9nt3SX5NSAMBq/ieeFk89BqwKSHE+Q+g
        CHeFeBVbc6VBqN2S7YfC4Hq6yEgSxZlprH2cKeCQ3IdWKYY=
X-Google-Smtp-Source: ACcGV61dfEah72oYB8UqxMCHRPuEksE8ylDETN58VPYCy0LExkyimMmrhvV02Nz4gzFWkuVKvG7sCmTCX+1eDPFUhwQ=
X-Received: by 2002:a0c:a8cc:: with SMTP id h12-v6mr6701676qvc.161.1538680021849;
 Thu, 04 Oct 2018 12:07:01 -0700 (PDT)
MIME-Version: 1.0
From:   Matthew Wang <matthewmwang@google.com>
Date:   Thu, 4 Oct 2018 12:06:50 -0700
Message-ID: <CAAooHFeLWrY_wmCp-HWqygh8gnKsfpoPCky7SykOBKZgXkb8OQ@mail.gmail.com>
Subject: Flag for detecting 802.11r Fast BSS Transition support
To:     linux-wireless@vger.kernel.org
Cc:     Brian Norris <briannorris@google.com>,
        Kirtika Ruchandani <kirtika@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I'm wondering if there is a flag for detecting firmware/driver support
for FT. It seems like checking for SME support is a pretty good proxy
for this, but there is a non-mac80211 driver that can do FT as well
(ath/wil6210). It would be great if anyone knows of a feature flag
specifically for FT.

Thanks,
Matthew
