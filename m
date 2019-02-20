Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED91BC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 05:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA47820C01
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 05:48:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oSe2iqNw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfBTFst (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 00:48:49 -0500
Received: from mail-pg1-f179.google.com ([209.85.215.179]:46073 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfBTFst (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 00:48:49 -0500
Received: by mail-pg1-f179.google.com with SMTP id y4so11283733pgc.12
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2019 21:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CvG8ML2/CkEyGPQAm7coyPVlQybN3niXwSj2YHnus+M=;
        b=oSe2iqNw26jBKgiwqA9seVmrPZHtKv2Btvmg8xNu7HbEoFZ/6QJsA2cVdORcDXBTjP
         8BFscC9EOTKDn+NEePqN6Z70rBeuQ3tU3LjP7SFfxGtYxg2raPZXsSu6Z6fWB379knPC
         Ci9UHbZnHs4Sem7uEB5zQy4KoCyxl/zc8ZiWra6Qt9AEUSRaRNXAP4UBeJ51+KnllZqW
         S1GaVwJ2S/+AfilkD8PWv5TXsUZWRPTi7CtNIK9xAmOt/RL5hK0ZH3MsbxNl1x94tzaG
         OCbFOuMYyO6CQjqIzqGTjFdIMZzkR6yeTaOvVTqVsaPA8Z1yJK8ndAFVYaLoqen2Lv0Z
         quwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CvG8ML2/CkEyGPQAm7coyPVlQybN3niXwSj2YHnus+M=;
        b=c5LnvGL6lNlJ8Qino1K0kL1igPPYue7jtn5EqtEpXQgEDTeAIgWmeK5TEb2BTb3EUp
         y8Nc5gEGxXB2yPWQ0MSUBhX1gVFvzsanNsqFMjbmqu5fPG5pagW1xXXzhwlAvwrKs2xU
         UOgBDtAet4ufPncmIguDxLrmsgA5fAvIb9odXM0d3kXYIrdZyuDBT4auW4et/yRCOKKE
         yA5r2MjFkacMN7voNRLsdRM4q3FTp3QVsyKgIcxjRduW83SxhBTTJvjxXPAgBWY6Otx5
         RI0hzE8dq/NhjDuOkuWZLJM8a52fczpg6783nFhxMyL8gQ18bFbBSkLy8fS24/uBL0W5
         zATg==
X-Gm-Message-State: AHQUAuaEQ+QNhP870qreGXBKV9+sYJ+Znw308TZ373usv5mVA4dAdAFf
        tAdi6BHaDlGcJVrQ5uNrRxUYgInS
X-Google-Smtp-Source: AHgI3IaM7VC+Mjv1Q4l4v8w9SB8mNPYtoaCraVQr4qGgdKgpApRPDt892ZeAaiKEZfttiBsIL75IPA==
X-Received: by 2002:a62:964d:: with SMTP id c74mr32965145pfe.213.1550641728284;
        Tue, 19 Feb 2019 21:48:48 -0800 (PST)
Received: from ?IPv6:2409:11:321:2100:7525:daa9:e003:a55c? ([2409:11:321:2100:7525:daa9:e003:a55c])
        by smtp.gmail.com with ESMTPSA id t12sm44862490pgq.68.2019.02.19.21.48.46
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 21:48:47 -0800 (PST)
Subject: Re: [REGRESSION] mesh_pmksa_caching_oom test case fails
From:   Masashi Honma <masashi.honma@gmail.com>
To:     linux-wireless@vger.kernel.org
References: <60841bf1-3435-60f4-75df-1b49bdea88b9@gmail.com>
 <98befb4d-0860-7397-e1ee-ab4db089597b@gmail.com>
Message-ID: <8020ba35-2132-f802-f004-a7b71e9582e4@gmail.com>
Date:   Wed, 20 Feb 2019 14:48:45 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <98befb4d-0860-7397-e1ee-ab4db089597b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019/02/07 17:49, Masashi Honma wrote:
> On 2019/02/07 15:47, Masashi Honma wrote:
>> The hwsim test "mesh_pmksa_caching_oom" fails by inconsistent lock state.
>>
>> By bisect commit c42055105785580563535e6d3143cad95c7ac7ee
>> 'mac80211: fix TX status reporting for ieee80211s' looks causes this
>> issue.
>>
>> The wpa_supplicant version is
>> commit e5a410f4726cc978781692a7eb9a2e2ceee9c076
>> 'tests: Make /etc/alternatives work in VM'
> 
> I forgot to attach the log file.

This looks fixed by this commit.

commit b4c3fbe6360178dc2181b7b43b7ae793a192b282
'mac80211: Use linked list instead of rhashtable walk for mesh tables'

Masashi Honma.

