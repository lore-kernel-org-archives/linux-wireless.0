Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07286C67863
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 10:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEB452064E
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 10:48:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VB1BS03K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEB452064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbeJVTGg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 15:06:36 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:33642 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbeJVTGg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 15:06:36 -0400
Received: by mail-yb1-f194.google.com with SMTP id m184-v6so4863347ybm.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 03:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=1EODZFdi2HOzDhLT9AU+29onKC2DDzNEtxdr5z50Ofw=;
        b=VB1BS03K550V63wcEJ+J5hZ1Sl/QdyP3F7grfRAgh8ytxzICiyHHDPgS+nL6jWXXK8
         jZOL7gyoIQaDQU1qXJqxp8A9FXBEI448n1L+NuO8TAhe77ixZWHJlKNqq/zLldheZtWT
         8gX8dkv6Zq2dUGLxoomY6QxCjiutzNpyB2YaA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=1EODZFdi2HOzDhLT9AU+29onKC2DDzNEtxdr5z50Ofw=;
        b=lgGBKG7rgdg5u/r6xvEpG9jwNDQmGZirWoaiVTtLuW5oEW2X0DTrhM8ionrDBm8BGo
         lNSLwQ4QFStgSDw9yPpqA658vz9Bj5w7nRgH1bSLwGaWi+ejGf9aDfszlkqJlkMEPMlK
         lMc76OB+wqHz5Qa3dfK3v/EUrwLZpms+SxYlgwdgGrQmMh/W+VP8I3ResMDWgUvgDZBJ
         iGqZ6qIeKBssWTC3GBqOC2DERwyTrfIrwxpN6PMdhkWW8lSfFn2a3WycSRMHtxQjJQQA
         Vnj/Z/s+iNcNRugy+ftUHSJ1KOD11F7xDr+AS8OfTfGA+Lq0Z9mkM6qU+wxtuiGhzRX3
         lFRA==
X-Gm-Message-State: AGRZ1gJYdGzNZ6GN9t7lwVqzUN1P6KgdXwh2CW0NhCKOCcEnX8Er6/r4
        P5K4C17yNnr/r+Q0zAPKax5Yv+ONQD4GwA==
X-Google-Smtp-Source: AJdET5cPiydzD8RVdf3TVPtetjUQp+t9+x1jiXyZkwPJqNR5AjhCDW8aoAbrAT3qwUg+gOC0wMwxJA==
X-Received: by 2002:a25:d643:: with SMTP id n64-v6mr3041932ybg.493.1540205313731;
        Mon, 22 Oct 2018 03:48:33 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id r85-v6sm8492083ywg.25.2018.10.22.03.48.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Oct 2018 03:48:33 -0700 (PDT)
Subject: Re: 4.18.16: memory leak in sta_set_sinfo
To:     Johannes Berg <johannes@sipsolutions.net>,
        Johannes Stezenbach <js@sig21.net>
References: <20181022080214.GA6379@sig21.net>
 <f1f5e0839f4b1b68510b9db398995c859a19a19e.camel@sipsolutions.net>
 <20181022083552.GA6878@sig21.net>
 <90015710a62fa0a6d9da17f5760616101b19c206.camel@sipsolutions.net>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        linux-wireless@vger.kernel.org
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <2ad39f6f-c01a-f51c-e114-641d11a5eb22@broadcom.com>
Date:   Mon, 22 Oct 2018 12:48:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <90015710a62fa0a6d9da17f5760616101b19c206.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/22/2018 10:37 AM, Johannes Berg wrote:
> On Mon, 2018-10-22 at 10:35 +0200, Johannes Stezenbach wrote:
>
>>> commit 848e616e66d4592fe9afc40743d3504deb7632b4
>>> Author: Stefan Seyfried <seife+kernel@b1-systems.com>
>>> Date:   Sun Sep 30 12:53:00 2018 +0200
>>>
>>>     cfg80211: fix wext-compat memory leak
>>>
>>> Hopefully that'll eventually propagate to stable.
>>
>> Good to know it's fixed, but "hopefully" makes me wonder,
>> I'd love to hear the confirmation that it's been queued.
>
> Well, normally it works automatically when you have a Fixes tag, so I
> don't usually try to queue anything manually. Maybe Greg has had his
> hands full with the 4.19 release :-)

Missed the memo. Does that mean Cc: to stable is no longer needed? It is 
still documented as such in Documentation/process/stable-kernel-rules.rst.

Regards,
Arend


