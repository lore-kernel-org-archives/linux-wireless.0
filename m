Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C8BC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 15:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5056B20850
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 15:36:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5056B20850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbeLCPgy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:36:54 -0500
Received: from gateway22.websitewelcome.com ([192.185.47.65]:40187 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726612AbeLCPgy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 10:36:54 -0500
X-Greylist: delayed 1279 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2018 10:36:54 EST
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 3EDA727DB2
        for <linux-wireless@vger.kernel.org>; Mon,  3 Dec 2018 09:15:30 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id TpwYg1BgdaSeyTpwYgCnPy; Mon, 03 Dec 2018 09:15:30 -0600
X-Authority-Reason: nr=8
Received: from [189.250.78.127] (port=53140 helo=[192.168.43.131])
        by gator4166.hostgator.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gTpwX-002Kjh-Kl; Mon, 03 Dec 2018 09:15:29 -0600
Subject: Re: linux-next: build warnings after merge of the
 wireless-drivers-next tree
To:     Luciano Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sara Sharon <sara.sharon@intel.com>,
        Kees Cook <keescook@google.com>
References: <20181130120555.1d35eb6b@canb.auug.org.au>
 <87lg5b5glw.fsf@kamboji.qca.qualcomm.com>
 <20181130165006.60b2545f@canb.auug.org.au>
 <87h8fz57ty.fsf@kamboji.qca.qualcomm.com>
 <1773a3329bcd1bde2a22c267e4c582b0149a307e.camel@intel.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <8c9a4e83-35c9-6078-8b15-f1b7895c8923@embeddedor.com>
Date:   Mon, 3 Dec 2018 09:15:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1773a3329bcd1bde2a22c267e4c582b0149a307e.camel@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.78.127
X-Source-L: No
X-Exim-ID: 1gTpwX-002Kjh-Kl
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.43.131]) [189.250.78.127]:53140
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 12/3/18 6:38 AM, Luciano Coelho wrote:
> On Fri, 2018-11-30 at 09:43 +0200, Kalle Valo wrote:
>> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>>
>>> Hi Kalle,
>>>
>>> On Fri, 30 Nov 2018 06:33:47 +0200 Kalle Valo <kvalo@codeaurora.org
>>>> wrote:
>>>> I take it that -Wimplict-fallthrough is not enabled by default
>>>> yet? So
>>>> Dave and Linus won't see these warnings?
>>>
>>> Correct.
>>>
>>>> What I'm planning is to send a pull request to Dave today and fix
>>>> these
>>>> warnings in the next pull request. Does that sound good?
>>>
>>> That sounds fine.
>>
>> Great, thanks for the confirmation. I'll then send the pull request
>> today.
> 
> Just FYI, I enabled this by default in our internal tree so we will
> notice when it happens before sending the patch upstream.
> 

That's really great.

Thanks, Luca
--
Gustavo
