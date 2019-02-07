Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54912C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 06:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EA252175B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 06:47:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W4cEVJG2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfBGGrz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 01:47:55 -0500
Received: from mail-it1-f176.google.com ([209.85.166.176]:50646 "EHLO
        mail-it1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfBGGry (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 01:47:54 -0500
Received: by mail-it1-f176.google.com with SMTP id z7so12171815iti.0
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2019 22:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=zeF0SqKHdGuCTio2VG/qq22R0c8tMiAd4qGMdky+UXk=;
        b=W4cEVJG2iGBLtSRq75XO5ShLD3BBNuzO8ZYYusRe+4QeOiI0xZsFbuNHqR5ZAdtACq
         T+6e5bgddOkPTCkkelE4KPB9N7n0z2tVxA5FZyYed6zAJrVvJPjESGbtaeb3fKWPUBwu
         HOP5mBm+SLl1wbZnrExcYLK+Z3zUeY7kxwoYMUfc3jYXVOV64eZWk5ultEPut5cm2Du3
         iO4PPGPiUN7AA9l0P0v9g9Sc8IrOH7QEBXfzBTMjqIfThaMZ1HOTwy+jZtIBzJChSxit
         RE1H9Fu02sAa4ykWV4sd2uLSB33bnoqgABI8QULVieqMWGql1DgYHhQ3WKGxRwpS3Kz3
         R+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=zeF0SqKHdGuCTio2VG/qq22R0c8tMiAd4qGMdky+UXk=;
        b=nVYIBVsqzUs2bEcxzz76S9vy6mrh+3+IXyJY6IObEgsIW/7eQc9PgAVh9VpurbOag1
         nl7+N+jBe+YljmByIfD7IJoDfsiD6zH3cMVaNbM6eSK/fALZl+EmLwXKJNFJFqXMuXRh
         CZxH1u+TaO4nzERXtc5dIqo72JwVF9bU8YI7pL5azD0wlx6m0ZpkKdFlLYFzY0wbXN6a
         GyKIK3WHc92bJQBUv8YmaM+kCc4UJ90io1x+h5DRZiU3ovqNiiIj7yoMy9eJD3EvB/ha
         X4nQzvat1HpPsgZ0jz5aaCUEculoFNGVfXU9ZeGJr2ET+Bd5HCHgvPGWcn7r5/8PbiJk
         3xmA==
X-Gm-Message-State: AHQUAuadFVApsWMUoX8BtrqbffIAik+e8RIYz5EhlFQzWIE9Vuhr1V7C
        MM0+Fq2IsviGlJ+YRcvjTdSIDrbV
X-Google-Smtp-Source: AHgI3IbanxNTN8wMhTjQ13WjkdEm9cDppYcaPX9PwW7iQm7JWmwMMD/b1cDv0Ewx36pq/rII1tfdaA==
X-Received: by 2002:a24:d6:: with SMTP id 205mr3636059ita.99.1549522073646;
        Wed, 06 Feb 2019 22:47:53 -0800 (PST)
Received: from ?IPv6:2409:11:321:2100:e049:70d0:c4a5:9b67? ([2409:11:321:2100:e049:70d0:c4a5:9b67])
        by smtp.gmail.com with ESMTPSA id 196sm5201633itu.37.2019.02.06.22.47.51
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 22:47:52 -0800 (PST)
To:     linux-wireless@vger.kernel.org
From:   Masashi Honma <masashi.honma@gmail.com>
Subject: [REGRESSION] mesh_pmksa_caching_oom test case fails
Message-ID: <60841bf1-3435-60f4-75df-1b49bdea88b9@gmail.com>
Date:   Thu, 7 Feb 2019 15:47:50 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The hwsim test "mesh_pmksa_caching_oom" fails by inconsistent lock state.

By bisect commit c42055105785580563535e6d3143cad95c7ac7ee
'mac80211: fix TX status reporting for ieee80211s' looks causes this
issue.

The wpa_supplicant version is
commit e5a410f4726cc978781692a7eb9a2e2ceee9c076
'tests: Make /etc/alternatives work in VM'

Bisected-and-reported-by: Masashi Honma <masashi.honma@gmail.com>

Masashi Honma.
