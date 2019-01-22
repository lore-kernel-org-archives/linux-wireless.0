Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5C9C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 20:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA15921726
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 20:08:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Gbc1hoZE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfAVUH7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 15:07:59 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45159 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfAVUH6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 15:07:58 -0500
Received: by mail-pf1-f193.google.com with SMTP id g62so12278043pfd.12
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2019 12:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nSCiDmvEKK1umqixYkYg0ZY/PwJtUZG68fykpqOn/nI=;
        b=Gbc1hoZE8ThgmhjNwmTNRY3C+DpDxDFkCDqcf4s1jItV/X24dBHBTzBs0yDi5Civ7k
         O11ZpN6c31oB66ZXHWaO9HHvH7xqgmhTcVuHP8u7aZaQVLPhzQQdiagoSJlxZqcWaMl+
         It/VxvDGYMYVZFhYDaVrL8ZMZxdGjEOSJ3z2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nSCiDmvEKK1umqixYkYg0ZY/PwJtUZG68fykpqOn/nI=;
        b=gCPMG7nf4n+cWNxIZ5YRVudUSCtOT8NMrcuz628WKeYENN/pgECWb0CsbQ++x6oiEO
         AF88H85hs1kLm82be1yXnZyTaCIqMAf3fB1tBThnx+qlWloq3JQiPpbXUkD8GTuO0GBI
         sLmt9PtfbxEkz1ENxRfmKOGZmPnQWGH0wtpzbUKWOTSfH0M6yet8M3xQYspHI4f4ST9p
         8uNrZyhzdi3TGGBw4uTjaWVJhoFUnU0fUrLExRbJlYAMyqBGlQqrdjwxok530tSaunUq
         6MvAy+TfhC5/ocyUv7aMBPM2guJh8oqjOLof/ANVzwnWTgS7pvpuznoPIcAV59YT+hAJ
         u/jQ==
X-Gm-Message-State: AJcUukcAW+G16hhfyr0txeE46T7S6pBWEK+zRRlqzkK0aOlLDbBIan6e
        +3QKq5dphuHPD++RFsFyaLe7Aw==
X-Google-Smtp-Source: ALg8bN6o3jUllwnPsZZ1G1Q+W5aOLlJFiYz6W9r8AgieawDgi4doEvBkpxVlQX+MlcUlJEJBxs4qMw==
X-Received: by 2002:a63:c00b:: with SMTP id h11mr23193182pgg.429.1548187677852;
        Tue, 22 Jan 2019 12:07:57 -0800 (PST)
Received: from [10.177.251.206] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id d18sm23345241pfj.47.2019.01.22.12.07.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 12:07:57 -0800 (PST)
Subject: Re: [PATCH] brcm80211: no need to check return value of
 debugfs_create functions
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
References: <20190122152151.16139-32-gregkh@linuxfoundation.org>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <530d2424-d679-c81a-9d11-02b2d7631bea@broadcom.com>
Date:   Tue, 22 Jan 2019 21:07:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122152151.16139-32-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The prefix should be 'brcmsmac'.

On 1/22/2019 4:21 PM, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.

I could argue that if above is true it would be better to make the 
debugfs function return void, but I won't ;-p

In start_creating() the parent dentry is indeed checked for IS_ERR() so...

Acked-by: Arend van Spriel

> Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: Franky Lin <franky.lin@broadcom.com>
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> Cc: Wright Feng <wright.feng@cypress.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: brcm80211-dev-list.pdl@broadcom.com
> Cc: brcm80211-dev-list@cypress.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   .../broadcom/brcm80211/brcmsmac/debug.c       | 26 +++----------------
>   .../broadcom/brcm80211/brcmsmac/debug.h       |  2 +-
>   2 files changed, 5 insertions(+), 23 deletions(-)
