Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847F1C64EAD
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 08:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C98920652
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 08:55:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="MH8Clibc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C98920652
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbeJAPcV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 11:32:21 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52553 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbeJAPcV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 11:32:21 -0400
Received: by mail-wm1-f66.google.com with SMTP id 189-v6so7583132wmw.2;
        Mon, 01 Oct 2018 01:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B8Wox00i0Sk5edRkDeLf769LH2deC03DBzqZKVh5780=;
        b=MH8ClibcEIv2XbB45JMwFiLN/i6YsdXUqrjTdVee9uwlXISRhwrXw1PChB4jYCpXE+
         vgUW4nVBn996bGJWW8CKrTygTnhhqutYzp98bCfA7jC92B9KPsoMQmi2EnmjgraBmk6G
         OgpBUOr60Be0JCEgFeSbYwLhofX3wsxZmzJ2B2GO/XSkxNC9R6qIl6ecIBwtiXbUQQ+n
         s/PBIF+VSqkRcMdGVBAlL6N3KqqQqU1xKUqB0HbDw6td0waewOABP6iSi2VlP32VEno0
         i0Lj7m934GeB+2fd/o7tKoWEpA2XNjrc8xo3VpSOleeYZbB+Bjz1yqS3xHIY7fBKRy99
         xfCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B8Wox00i0Sk5edRkDeLf769LH2deC03DBzqZKVh5780=;
        b=FP3deyNMut0XwVlZRxCyjpLI/kid22YiPhpFdY7dlxFZF3JLPpOPHvUz0svlJSKatN
         4WhmGe6Pe0xRjuSi99/GociDfXt4BcSIbT45S+Z6arBBHvVkoJz1v8uOyBd9ic8BEznJ
         aGl2sP6p7VnvISCnJVr3lI9tTFIVukFw7n6xQ8BPB3pdBhQ1VR4Usrwgb8pYhHtuhnuR
         fzwAblUgvZwZQbm8fucYCRvPJXUMccKvI7hppe7lww1XTlo6vRoprIjoOcJ10awPLHXl
         FNEdEFriP62RzylVhnn+0uMXj3p6k/+IrMJnwIq9v5lWt5hrsuRM/xWVKL8FZ7meRPdH
         2mmw==
X-Gm-Message-State: ABuFfohi/WLE6zCy7EiOB1YhTIL8gZOJry3m1BSiSsE+bMt000p60W2b
        a5AAGRT7SBSxURiXGuOwxlMVBzCP
X-Google-Smtp-Source: ACcGV60QbtcbfEo6BR0Wl1wFqhjPtxzoG9PcE2hFzEQDxsVIBo46R7XGkF8tva+r8rUjc9QCWy7Mgg==
X-Received: by 2002:a1c:8bcc:: with SMTP id n195-v6mr8873080wmd.118.1538384137935;
        Mon, 01 Oct 2018 01:55:37 -0700 (PDT)
Received: from [192.168.201.5] (p57B63A04.dip0.t-ipconnect.de. [87.182.58.4])
        by smtp.googlemail.com with ESMTPSA id 198-v6sm12097859wmm.0.2018.10.01.01.55.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 01:55:37 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: fix wext-compat memory leak
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     Stefan Seyfried <seife+kernel@b1-systems.com>
References: <20180930105300.30797-1-stefan.seyfried@googlemail.com>
 <1538377946.3126.0.camel@sipsolutions.net>
From:   Stefan Seyfried <stefan.seyfried@googlemail.com>
Openpgp: preference=signencrypt
Message-ID: <e7bb48f5-3933-6d0b-160f-8d0801e3c1a7@message-id.googlemail.com>
Date:   Mon, 1 Oct 2018 10:55:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <1538377946.3126.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Johannes,

Am 01.10.18 um 09:12 schrieb Johannes Berg:
> Hi Stefan,
> 
> Thanks for the investigation & fix. I've changed the fix to use
> cfg80211_sinfo_release_content(),

Being totally unfamiliar with the code, I was not sure about that :-)

> take care of the error path in
> cfg80211_wext_giwrate() and added a Fixes tag :-)

That's certainly much better.

Thanks!

(kudos to Vlastimil Babka who pointed out trace-cmd to me on the
 opensuse-kernel malinglist, which made the investigation quite easy)
-- 
Stefan Seyfried

"For a successful technology, reality must take precedence over
 public relations, for nature cannot be fooled." -- Richard Feynman
