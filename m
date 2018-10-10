Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA4BC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 153942064E
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:52:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hP912XkC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 153942064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbeJJPNV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 11:13:21 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:35698 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbeJJPNV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 11:13:21 -0400
Received: by mail-pf1-f175.google.com with SMTP id l17-v6so2216196pff.2
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 00:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=5+b2wM5EGlVf10yTfkUs7gopyS7Wh69/93Dtf4x7lXU=;
        b=hP912XkCpu/txVwQIyovrZ1X5YmG84mfKxsbggQBby2J3ve/TCGPlCFwuwQzAgwmmD
         gLBQSGkhaM7oq+LUVHt7F5Kp/97Y+a4sQjK4YjcLv00xaChDRTJMBICdTcEVYYrybJHv
         DGVN7N+otFZ+an8DNc9reaKabHkBQ/NDSnicE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=5+b2wM5EGlVf10yTfkUs7gopyS7Wh69/93Dtf4x7lXU=;
        b=FV/8su3ENyxMaOBHmYAfA3k96RL9sWBGFajHZ5KbPvGkvlzxVO2a4+OLs/UxjugXU8
         hjfvHapXKd4QvpyPKEiKW8VMTbTVFIeVktOjOxZN4gKycJ3OssxumUhyiImbnsakI1JG
         mCR7UYgDhA5mFc/99hLqGhifxQF3X2/z1tCRdzacT2WGr2Gb1ph+dCIklaDNiyQrKohg
         Ot9JkY3FUuH3ZNKOCU2Zy5PNiHwm5Ob66FOtI8A/SkqR+Qjdfe2xxCr+2OC9z0XwNrde
         1W8f4xNPByNQLmc4bkkii+2zLA59De5TwEup1uwll3BKdJyWyQFqs3+X0Us06iVC4cKJ
         5diQ==
X-Gm-Message-State: ABuFfojdcmivBsxvyyN4BJC/vug3Cmjc38Pl1cNHI/lB8ps1r3E2nAFO
        ILttvVNSF2cNRQLnALLVeITlqg==
X-Google-Smtp-Source: ACcGV62pxRtJE0/QYMeJ9m9S9spQlQU4N+FME2R9fmDShW3X42UWTLoOKoXPFKPUWf6DTQkOP3UHow==
X-Received: by 2002:a63:4cb:: with SMTP id 194-v6mr29029052pge.183.1539157944603;
        Wed, 10 Oct 2018 00:52:24 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id t85-v6sm30917269pfi.73.2018.10.10.00.52.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Oct 2018 00:52:23 -0700 (PDT)
Subject: Re: [PATCH 5/6] brcmfmac: Set board_type from DMI on x86 based
 machines
To:     Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-5-hdegoede@redhat.com> <87murmxop9.fsf@codeaurora.org>
 <7397e1f5-5df6-4b49-78dd-ddc9774de16b@redhat.com>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <12cc4f0d-38d4-bb7b-8b02-dbb57db284b3@broadcom.com>
Date:   Wed, 10 Oct 2018 09:52:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <7397e1f5-5df6-4b49-78dd-ddc9774de16b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/10/2018 9:28 AM, Hans de Goede wrote:
> So how do you want to proceed with this, do you want me to just
> put the full ISC text in the header for now as the rest of brcmfmac
> does?

This is not entirely true as far as I know. I assume you are referring 
to this:

/*
  * Copyright (c) 2010 Broadcom Corporation
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
  * copyright notice and this permission notice appear in all copies.
  *
  * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
  * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE 
FOR ANY
  * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN 
AN ACTION
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */

As far as I recall we opted for BSD license and ISC is equivalent. 
However, The BSD license are already in place so why not use that. I 
would say BSD-2-Clause should cover it. As this is a new file I guess it 
is up to you although I would prefer to stick with a permissive license.

Regards,
Arend
