Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70164C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 14:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F1FB20643
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 14:21:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LMbdIRPG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbeLNOVw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 09:21:52 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:54265 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbeLNOVw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 09:21:52 -0500
Received: by mail-wm1-f44.google.com with SMTP id y1so5824586wmi.3;
        Fri, 14 Dec 2018 06:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ykJDrjKt84NaSffx2t81Rh4oVJ8wUAjXwmyHDpfTXeM=;
        b=LMbdIRPGxMjQVNhgOY31hh4jaIYXoWiuqgkG0aIQPLIeJ/XQp3TZadfAFFA3rmashh
         TWUadTEq5oKqMMMUF3aPxhZjAkLU7ER5BA0nCeD1ujYd6etpR5ljzls5AMr2Wc5kho1Z
         miQDTQDhbEsDo0f/zB8BlauCPVjq7qrnAAXChU9WvNKvbLwl1PuDdEXUXzUpZ/gGaI4U
         51eotOZCNinePasKiFMWUEnMdI5X0bRgRVxZLJwouqtyaCnK38lPVwAXlLD0D6Ix+zig
         51oEBmaZwo24w+C6hoxeZ4tUvBK/DSEGBIc1MBVWTpodayrRYEP5Qns9rgkNAZGPOVlU
         SxLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ykJDrjKt84NaSffx2t81Rh4oVJ8wUAjXwmyHDpfTXeM=;
        b=MKa7XFSInIXWGTROza6yYMKAxqOBIq61ZOMZ8jmBZF9DVimm2M5nbDZW5VTHk/GY+e
         aZ3vHC4MTMn65YzuQnZkK+OB4znupKAlQAPig60GHCRM0ekSKWbAUTqlIdiyZbPoTjEO
         IUIgV/hxYfc8qlv8+OAHtfwgp1cY3ueBFNo5u6xFF+NqrHu0csNQaQ3LGDhGHKYdxLbR
         Veu5R1uoRM7/vG6o58/XoRAPOZainyovoW6FCjVRIxwYuiMOdmDZPyu8Wt3VqwC6oYWK
         BqzQxv+bsGAI8b5m0DlMjZKx/v6r92DSORGa4xP1EDDozOm08vKBfY5vi0kJbL1eW+JF
         IABg==
X-Gm-Message-State: AA+aEWbA0XO4Z1z7F1pVGnUiMphyUforDRjgEVJstXyTzhLprMqhQR9c
        CTJT+iw4STUeKbhZPNiD1s/Y9R9R
X-Google-Smtp-Source: AFSGD/Ub1iCaiqGAJkbdrVQ29fGAbDkKVJwlQUaUs8Qfr6jGj7wBPpaw/KWi82jkVNfu8k5nzEER9w==
X-Received: by 2002:a1c:8b09:: with SMTP id n9mr3466038wmd.38.1544797310369;
        Fri, 14 Dec 2018 06:21:50 -0800 (PST)
Received: from [192.168.8.147] (225.83.136.77.rev.sfr.net. [77.136.83.225])
        by smtp.gmail.com with ESMTPSA id d16sm5773239wru.52.2018.12.14.06.21.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 06:21:48 -0800 (PST)
Subject: Re: question: ip forwarding and fq/mq qdisc
To:     Sergey Matyukevich <geomatsi@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        sergey.matyukevich.os@quantenna.com
References: <20181214120210.kmeuwvajuiwlp2n7@bars>
 <c3ac480b-2c6c-689a-a39e-75df601e5261@gmail.com>
 <20181214141244.7rob5gm245wqbive@bars>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0765feb7-6d05-9a7c-4610-de9f96a58388@gmail.com>
Date:   Fri, 14 Dec 2018 06:21:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181214141244.7rob5gm245wqbive@bars>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 12/14/2018 06:12 AM, Sergey Matyukevich wrote:

> Hi Eric,
> 
> This patch fixes the issue: ip forwarding works for fq/mq qdisc.
> 

Thanks for testing, I will send a formal patch for IPv4 and IPv6.


