Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8F5C67839
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 19:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C17C2087F
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 19:17:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="afsDL2/F"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C17C2087F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbeLKTRg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 14:17:36 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41488 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbeLKTRf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 14:17:35 -0500
Received: by mail-ed1-f66.google.com with SMTP id z28so13490055edi.8
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 11:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rysaqCsPhNcFPfeRslvrzUlGhJzKsD6wjnPQl/x6I8s=;
        b=afsDL2/FwZ5dz0luhha7y92bdSYZz/d1LbUPl++zMZ0YTY7z0tuKXrHNqQeZiKqVPM
         xEYg2CB7j4qq2315UzQX1kBzCqNymO+fGahdJot7M8niNnjf9mIAnSiFSMPbyO7rJObS
         hUF9DgA9r7XIQptTpD/eQxt1bYwYExCKpm/+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rysaqCsPhNcFPfeRslvrzUlGhJzKsD6wjnPQl/x6I8s=;
        b=Ch9gw144DUffZKJZX2eS5sz3KKsvPZXZs14R6EP7VSv1vzZ1fsor6uvxeXGl44ZcMV
         EvUzKhOo4fd+Oi1fkiNY8+JbZCDEUkmUSHAnhxDTle8ZkaUPgaDcqhsVjeaxggOC9orZ
         AY9WLWIuTCgc59dYlTsOlWNB789KmhX5SRaL2S71W1Ed+9roIv12KyKqg1rtX8TbufHq
         xlad/5I3LfchKinROld+mDdmB9M60YzTYtlhExRY3S4pK2OPzo6ngaK+P3Neui3QqGx4
         N/Vlkpx0C30+Y/VeFSikJxEgQckpMFe8Dj9RZBoPoF1+Mj9a+et5TbcmqhFZyqQR/jyJ
         wwKw==
X-Gm-Message-State: AA+aEWbtrtESdP+n/zO90OfDY4G7C0PiyOOlwJ+PzfANkDXwl1GVIM+P
        o6SdLEn6YVfKnFTmPMLxFOFkZx7Ff7XjkA==
X-Google-Smtp-Source: AFSGD/WAepYcV9aESJaM9nG1q6n/nAQEWAbb1UTxy1/9z65tnpcc0i06q6oY9HiFYLuceNLt3WfJAA==
X-Received: by 2002:a17:906:4a4b:: with SMTP id a11-v6mr13376496ejv.68.1544555854091;
        Tue, 11 Dec 2018 11:17:34 -0800 (PST)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id s3sm4337756eda.69.2018.12.11.11.17.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Dec 2018 11:17:33 -0800 (PST)
Subject: Re: [PATCH V4 0/8] brcmfmac: chip related changes
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
 <4dca6580-8fa8-b2fb-6f65-86e8791319cf@broadcom.com>
 <87k1kg1aiz.fsf@kamboji.qca.qualcomm.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1bf08105-0369-09ce-0a49-db80bc9185a9@broadcom.com>
Date:   Tue, 11 Dec 2018 20:17:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <87k1kg1aiz.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 12/11/2018 2:02 PM, Kalle Valo wrote:
> Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
> 
>> On 11/21/2018 8:53 AM, Chi-Hsien Lin wrote:
>>> This patch series includes various chip-related changes:
>>> * 43012 support
>>> * 4373 saverestore support
>>> * SDIO bus settings
>>> * 4354 raw chipid
>>
>> Hi Kalle,
>>
>> This series [1] is still marked as New in patchwork. Are you planning
>> to take them?
> 
> Yeah, along with 111 other patches ;) In other words, I'm lagging behind
> in patch review but I'll try to catch up today and tomorrow. I haven't
> reviewed these patchset yet, but if all goes well I'm planning to take
> these.

That's quite a loaded plate you have there. Happy digestion :-p

>> [1] https://patchwork.kernel.org/cover/10692067/
> 
> BTW thanks for adding the link to patchwork, very helpful.

It is a great resource/tool so happy to use it.

Gr. AvS
