Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A04C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 13:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BC4E206A3
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 13:57:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="UqnNoT0Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfDZN5L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 09:57:11 -0400
Received: from [208.74.158.174] ([208.74.158.174]:55358 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfDZN5L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 09:57:11 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id A513A13C283;
        Fri, 26 Apr 2019 06:57:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com A513A13C283
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1556287030;
        bh=cV1FMxDHhw0FNSyCwsRa6AF3HKu9kVz1PflxL468MSI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=UqnNoT0QVTS6zs3SfM2pffXYU4K4x77mGvCTqPqSpejzEUoC0bAQvj6gRd6n2Z6cq
         kJxOyLmwl0DZ7q33ly/d/j84y2HPhIsaHnCZ/dcQTwiXccKToPtRcl6S4Rjm116ojn
         prdwfJlnJ0qWmdXbyvfdxfBUO2Y/dgoKG7/jShww=
Subject: Re: [PATCHv2] ath10k: Add wrapper function to ath10k debug
To:     Venkateswara Naralasetty <vnaralas@qti.qualcomm.com>,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc:     Kan Yan <kyan@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1556283505-29539-1-git-send-email-vnaralas@codeaurora.org>
 <b9f263a4-e9da-18bb-5932-941a018ee860@candelatech.com>
 <be151755e771423eaa0ad6e6e2e81c2b@APSANEXR01F.ap.qualcomm.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <380a88cf-9da4-a772-a119-d8df24d5b450@candelatech.com>
Date:   Fri, 26 Apr 2019 06:57:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <be151755e771423eaa0ad6e6e2e81c2b@APSANEXR01F.ap.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/26/19 6:38 AM, Venkateswara Naralasetty wrote:

>>>    #ifdef CONFIG_ATH10K_DEBUG
>>> -void ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
>>> -		const char *fmt, ...)
>>> +void __ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
>>> +		  const char *fmt, ...)
>>>    {
>>>    	struct va_format vaf;
>>>    	va_list args;
>>
>> Do you still need the check later in this method:
>>
>> if (ath10k_debug_mask & mask)
>>
>> since you already checked in the ath10k_dbg() macro?
> Yes, we need this check.
> Otherwise all debug messages will be printed even without any debug mask set in case of tracing enabled.

Ahh, I see.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

