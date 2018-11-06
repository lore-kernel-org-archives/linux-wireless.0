Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BFCC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 12:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBF1B20862
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 12:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QDOyo/zn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBF1B20862
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbeKFWPE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 17:15:04 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40345 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387704AbeKFWPE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 17:15:04 -0500
Received: by mail-wm1-f65.google.com with SMTP id b203-v6so11678510wme.5
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2018 04:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=ss7EPADjlHzCT4+KoTMK42l9ZG6ZHVmIq8Bia4nO8E4=;
        b=QDOyo/znINFVdjE4nYH4mmExTKAI+Bio2AUyUE4PDwMnuS5HHBtvn2hx3N4zyzhCeB
         gCU+7UaakA2JVIPWrjogusNLJ8F0OUN+r+EhUS4NLfqvTuVHpxThHj+isJQTsPE/gQtJ
         l3/mty+4oi4igjOi2CNX5prDLW1lqZDxMKqog=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=ss7EPADjlHzCT4+KoTMK42l9ZG6ZHVmIq8Bia4nO8E4=;
        b=SWVtD9xUwQfJskGfDqYy0lS4K0L8CwzaABR/MOa7HgGXr4Ob7LNXepzF49VjXYWAKs
         VatkffN4Pp/vF3e2Bljym3Lh3UYLh9o5lSy6Zk/rHp1yNZUUaMn+QOLOG2AZVDMEZKfF
         xvmtg/nJ+tmQ2ktpfiQg6gp5plxfFtJHD+P6ahwdZMekkvcH4GHIWgCdGPQpj/5Llc2j
         yXimLQsEfOVeODylViYVxmXaFF3vFY340rN9rMfcGHrNbpg0XYj0K0/fab+RTuRtBUAx
         JBBZGKprur46x/7T5GV/su6aeHOOMVf6IG/PP6ULbspYKsZgT8SnHZrN0/mp5d7VMa9m
         hpVw==
X-Gm-Message-State: AGRZ1gISCKMA4ILeegDZWrpY9e1Xx107Y2/86MVfwkMxgDVf896IAfD2
        PdDa8WS4M1ulIOKX4zd57nVXw7RQXYyYXQ==
X-Google-Smtp-Source: AJdET5dwxekAZQa/FS/HudQ51D0toasEPxBRjANeeQZybBVm1t7Scx6htOR56a6TS70yLjFHgaCYEg==
X-Received: by 2002:a1c:58c5:: with SMTP id m188-v6mr1800133wmb.85.1541508598383;
        Tue, 06 Nov 2018 04:49:58 -0800 (PST)
Received: from [10.177.251.64] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id m16-v6sm2054194wmd.35.2018.11.06.04.49.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Nov 2018 04:49:57 -0800 (PST)
Subject: Re: [PATCH v2 1/3] lib: cordic: Move cordic macros and defines to
 header file
To:     Priit Laes <plaes@plaes.org>
References: <cover.9ec98292c595a111ae78f31383ff8618c9cb04da.1541446422.git-series.plaes@plaes.org>
 <3be396e01b33905e9ac5c80e7038b7aacf72eaf8.1541446422.git-series.plaes@plaes.org>
 <8eb0e232-d14b-60d9-e3c8-008c46659a30@broadcom.com>
 <20181106071455.ch6wooqibm76tyjl@plaes.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <2dbd0169-6a07-2ff0-6ea7-99acd624db9f@broadcom.com>
Date:   Tue, 6 Nov 2018 13:49:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20181106071455.ch6wooqibm76tyjl@plaes.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/6/2018 8:14 AM, Priit Laes wrote:
> On Mon, Nov 05, 2018 at 11:02:35PM +0100, Arend van Spriel wrote:
>> On 11/5/2018 8:37 PM, Priit Laes wrote:
>>> Also append CORDIC_ prefix to nonprefixed macros.
>>
>> Bit annoying that you made me look at LKML for this patch. Can you just post
>> the entire series to linux-wireless so Kalle can take it all through his
>> tree. Also the commit message is a bit thin. Please explain why these are
>> moved to the header file.
>
> Sorry, I messed up again while trying to automate the send-email with
> get_maintainers script (dry-run argument did not work .gitconfig :S)

No worries. It was only a bit annoying ;-)

Regards,
Arend
