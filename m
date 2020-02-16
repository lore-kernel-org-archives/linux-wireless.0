Return-Path: <SRS0=oA8K=4E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A179C2BA83
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Feb 2020 13:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02D64206E2
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Feb 2020 13:40:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=permerror (0-bit key) header.d=schafweide.org header.i=@schafweide.org header.b="WCeG8+Sf";
	dkim=pass (1024-bit key) header.d=schafweide.org header.i=@schafweide.org header.b="ZAODn44n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgBPNkV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 16 Feb 2020 08:40:21 -0500
Received: from mail.schafweide.org ([185.45.112.52]:50692 "EHLO
        mail.schafweide.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgBPNkU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Feb 2020 08:40:20 -0500
Received: from [IPv6:2a07:59c6:eeff:20:d66:7892:f4ef:c5b1] (unknown [IPv6:2a07:59c6:eeff:20:d66:7892:f4ef:c5b1])
        by mail.schafweide.org (Postfix) with ESMTPSA id 570978340103;
        Sun, 16 Feb 2020 14:40:18 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=schafweide.org;
        s=default; t=1581860418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JLwRLkDUYX0Lt+0jUJ5aVSHs8JY8u20Kwqfd3joHZuA=;
        b=WCeG8+SfBDSPNe3doy2iQXeuLnC3hIyIsrVagwfupt1PQTnsvUJnRcZ8MZSq6lrc9zn0NP
        v4rwckq525tTmpDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=schafweide.org;
        s=rsa; t=1581860418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JLwRLkDUYX0Lt+0jUJ5aVSHs8JY8u20Kwqfd3joHZuA=;
        b=ZAODn44n/3r+osaXlYaMUcpkxXM0LAyFzsbXGg2gXnnyViXPROdFfxFqZSpmd2aNIHU5tY
        WBcFMvuemogZl/WHXqsUXbtvYD/33pNWw6+itYgNt97AQnBjeHGoD5e76R0vNPf7PRISWY
        LRLnZZThr/vQbtnzHXaWvOnRImJ9aio=
Subject: Re: [rtw88] Linux 5.6-rc1 / RTL8822BE WiFi adapter
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Tobias Predel <tobias.predel@gmail.com>,
        linux-wireless@vger.kernel.org
References: <20200214214134.GA12764@t2b3>
 <c76d37cc-2cab-a8f2-e570-a444c06ad020@schafweide.org>
 <028ea5d3-1459-b37e-f996-72958be0ff4c@lwfinger.net>
From:   Bjoern Franke <bjo@schafweide.org>
Message-ID: <dcd22888-4a60-59f4-3a8e-0b1a49b1e922@schafweide.org>
Date:   Sun, 16 Feb 2020 14:40:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <028ea5d3-1459-b37e-f996-72958be0ff4c@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Larry,

> I deliberately stay behind the official kernel repo so as to avoid implementing
> any regressions. As you are the one with the problem, you need to perform a
> bisection to discover which change to rtw88 introduces your difficulty!!

Somebody commented the DKMS-package for your rtw88-branch with

"Thank you so much for this ! After kernel 5.5, that's the only way i 
can get functional wifi on my machine. (RTL8822BE) Deeply appreciate it."

So I assume I'm not the only one experiencing this issue.

But I can do a bisect if I find some time.

Regards
Bjoern

[1]https://aur.archlinux.org/packages/rtlwifi_new-rtw88-dkms/
