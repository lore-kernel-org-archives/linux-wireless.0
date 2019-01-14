Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CDBFC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 20:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE7522064C
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 20:12:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OMyujEts"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfANUMo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 15:12:44 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41349 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfANUMn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 15:12:43 -0500
Received: by mail-ed1-f65.google.com with SMTP id a20so672826edc.8
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 12:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tJpZplM/Ub0TF6D/mVPcja1QURe/TVe3hotHw9Aop/M=;
        b=OMyujEtsX7ImoRS7qIufzt3gc5mi9NkDVrwPvkdyM/7S4h6RGvJLKAOU7T3ScGoDvD
         6TEQRlQ6R4hx6VeE7tkAmSZKbZMJyP+zvG7iPNL9VI6vIQmPX0kM3wc1rPosWvfW2z65
         u9sH9ILatPdNU2sPN5O4GUnNrPisniCCPsHX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tJpZplM/Ub0TF6D/mVPcja1QURe/TVe3hotHw9Aop/M=;
        b=aKbmneR98t0bjAHqxGlBWYySP60vWYFhA07a6N4S+hMFDo9M8ImD0lyvE5d2eXozcZ
         wpqsLw2dBDGdJhzE/uXH1xtp4Ny8IuDONvdO886/QQEPtPSpw+pkp4vuM1X+rkmrJKJu
         qpcgPkW3YPfRnOgzSjZtx63TcS/jDyUw/eyzGErHjMaZvS458rtKpFSOWAh15cLKDzO0
         zyLtZOsR73T4iC+FZvlf9CrddArlFmfZ8CMLrun1gmc7mbRDhAaVvdMU8GWdILbcPcRR
         qw8mOWw263VIlJXp8ygY35f5fNTsymm9/pYtwt7CmQxcLCc/6Yu4QYLZwqQohKfHwX0Q
         +8uA==
X-Gm-Message-State: AJcUuke6gZ+1Vr1OT/imP5h0r3NUKkXaJ9gkKyUYwB242N+NKytlJE8r
        wAAg3QgB7bk3zeCvTtwCFGXzUw==
X-Google-Smtp-Source: ALg8bN5yHXY/yD4KYQTAQsFG1Rn4WUbUSLCQOwbsKtRLgfgt+aWLjl+rtAE5a/Fb0UBqkifkrSBahg==
X-Received: by 2002:a50:f5af:: with SMTP id u44mr697302edm.172.1547496761915;
        Mon, 14 Jan 2019 12:12:41 -0800 (PST)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id a13-v6sm2447541ejt.69.2019.01.14.12.12.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 12:12:41 -0800 (PST)
Subject: Re: Kernel oops / WiFi connection failure with wpa_supplicant 2.7
To:     Denis Kenzior <denkenz@gmail.com>, Jouni Malinen <j@w1.fi>,
        Eric Blau <eblau@eblau.com>
Cc:     hostap@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
References: <CADU241PtPeiTQWHwb=uF6Ohuua_asOwCarCAKVC8jdVVNAsByA@mail.gmail.com>
 <20190103154921.GA25015@w1.fi>
 <41e7ccaf-c73d-b404-69fe-ad17433add37@broadcom.com>
 <1cefde13-3fcf-47b7-1c3a-e44a2901ddea@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0490b8fa-bf8c-c76c-1367-70d0f4e3845f@broadcom.com>
Date:   Mon, 14 Jan 2019 21:12:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1cefde13-3fcf-47b7-1c3a-e44a2901ddea@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/8/2019 6:44 PM, Denis Kenzior wrote:
> Hi Arend,
> 
>> However, there is more to it. When these offloads were introduced, we 
>> discussed about having a PORT_AUTHORIZED event or not. It was decided 
>> passing an attribute in CONNECT and ROAMED event would suffice and 
>> that is what was implemented in brcmfmac. However, it seems time 
>> passed and the need for an explicit PORT_AUTHORIZED was there 
>> (probably Denis knows), which wpa_supplicant now supports thus 
>> ignoring the attribute in the CONNECT and ROAMED events. The brcmfmac 
>> driver was not changed accordingly. For this there are patches pending 
>> in linux-wireless which are necessary to have a working connection.
>>
> 
> Coming in a bit late to this discussion, but it does raise a few points 
> I wouldn't mind some clarification on:
> 
> - With commit 503c1fb98ba3, the kernel effectively changed the userspace 
> API.  So I take it that breaking userspace APIs are OK sometimes? If so, 
> I have lots of suggestions to make ;)

I bet you do :-p I think the rule of thumb is that there are no drivers 
providing the functionality behind the user-space API and/or no 
user-space applications are using that API.

> - Is RTNL LINK_MODE / OPER_STATE status being (supposed to be?) affected 
> by the driver during a roam?  E.g. if we're in a 802.1X network with 
> userspace authentication, and driver roamed requiring a new 802.1X auth, 
> then in theory the RTNL mode needs to be brought back out of UP state...

So do you expect the driver/cfg80211 to take care of that or the 
supplicant? I assumed wpa_supplicant would be doing that.

> - The new API leaves a lot to be desired in terms of race conditions. 
> For example, how long should userspace wait for EAPoL-EAP packets to 
> arrive (before triggering its own EAPoL-Start for example) if a 
> CMD_ROAMED event comes?

I think that question applies to CMD_CONNECT as well, right? Not sure if 
the specs provide any guidance for that. I can dive into that, but maybe 
someone like Jouni or Johannes know. If so, let me know ;-)

> - What happens if userspace does send an EAPoL-Start in the middle of an 
> offloaded 4-way handshake?

Probably those would be dropped.

Regards,
Arend
