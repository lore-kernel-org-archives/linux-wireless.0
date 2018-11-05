Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0770BC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0F0020854
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:13:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="e/qp1co6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0F0020854
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbeKESce (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 13:32:34 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42693 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbeKEScd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 13:32:33 -0500
Received: by mail-wr1-f67.google.com with SMTP id y15-v6so8580869wru.9
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 01:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=wA7TyDJb/otO8QhHIlksbXuo8LT1Oi0HmcIwXXvvRmQ=;
        b=e/qp1co6W/KuTAqloqSSr5Ugq/YYo6wC5XXlVKi9YpBNKj5YsD86IKyKjjpEBpqFfL
         MNZzyCgRXpIkknQ2xvvydk6HX9iNjDZWG1jj0ozJtc9jkWvbVz9v1uQsDVF9pd/5QwIv
         eIo7d0BVUhtMj1z8lTUcnIECtqnjoyAn2XUpQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=wA7TyDJb/otO8QhHIlksbXuo8LT1Oi0HmcIwXXvvRmQ=;
        b=bHMM0WAZ/6hL8r8JOXuHmDNc6rzEuUWNoHrAE11UUG1BDmK/AZap8OMODVVENqMk8S
         w0+xJDnRWONCBPvFYZq3EyuJdvfUNdHgZbyAtbSrDP4fiV37sl1hu02Y3SjOthDXlpwN
         aOKrALvHA7Aq8J5d0248qjGItgJyEiX5+LgbTdgIdB2+vLhH8UtKf+3evfA65FMDJeyL
         rXx6t25p11A88PqfhOqeVT8Cp0Tw+1Vm9Jzw2FRqaeWX73zK7FbMi1JaXZSLRKdCYaG1
         GVX3gov69NMLb0S33blKVj13SBFlSWZJdqCu66u9uFkLOf5yeTIutOEftqIywlcFSoFI
         B8cA==
X-Gm-Message-State: AGRZ1gJimZ7iKV+E3OoIGPYRe9t3bJ6qBqIyxUzgrdZupjYTPx/CrwKD
        /G9VsKikQqtsadyXYTnTkS63rAUGWQgJzw==
X-Google-Smtp-Source: AJdET5drZNWJdxfR0XoW8eU1R/PmptP/mqhIYAeBmn2NSFx5W4Ig3LkJGc/fPX4awJbv226t+QeKnA==
X-Received: by 2002:adf:cc81:: with SMTP id p1-v6mr809562wrj.139.1541409228885;
        Mon, 05 Nov 2018 01:13:48 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id i7-v6sm8600443wrs.55.2018.11.05.01.13.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 01:13:48 -0800 (PST)
Subject: Re: [PATCH 2/5] brcmfmac: Use common CORDIC_FLOAT macro from lib
To:     Kalle Valo <kvalo@codeaurora.org>, Priit Laes <plaes@plaes.org>
References: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
 <4bd6e7758bc0d88b33cdb09448633bb5b97aba7c.1541238842.git-series.plaes@plaes.org>
 <877ehrhp21.fsf@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <21e6a75b-7728-761d-d899-395864226fb5@broadcom.com>
Date:   Mon, 5 Nov 2018 10:13:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <877ehrhp21.fsf@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/5/2018 10:05 AM, Kalle Valo wrote:
> Priit Laes <plaes@plaes.org> writes:
>
>> Now that cordic library has the CORDIC_FLOAT macro, use that
>>
>> Signed-off-by: Priit Laes <plaes@plaes.org>
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c | 4 ++--
>>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c   | 4 ++--
>
> The driver is "brcmsmac" (note the 's', not 'f'), you should fix the
> title accordingly.
>
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
>> @@ -3447,8 +3447,8 @@ wlc_lcnphy_start_tx_tone(struct brcms_phy *pi, s32 f_kHz, u16 max_val,
>>
>>  		theta += rot;
>>
>> -		i_samp = (u16) (FLOAT(tone_samp.i * max_val) & 0x3ff);
>> -		q_samp = (u16) (FLOAT(tone_samp.q * max_val) & 0x3ff);
>> +		i_samp = (u16)(CORDIC_FLOAT(tone_samp.i * max_val) & 0x3ff);
>> +		q_samp = (u16)(CORDIC_FLOAT(tone_samp.q * max_val) & 0x3ff);
>
> I haven't seen the patch 1 yet, but just from seeing this patch I don't
> get what's the benefit.

The FLOAT macro was defined in brcmsmac (see patch 3). It is now moved 
to the cordic library simply because it is more closely related to that.

Regards,
Arend

