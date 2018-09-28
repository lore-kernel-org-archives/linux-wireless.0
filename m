Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBAFC43143
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 19:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C0CD206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 19:57:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C0CD206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbeI2CWf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 22:22:35 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:33778 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbeI2CWf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 22:22:35 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 113CC40A5A2;
        Fri, 28 Sep 2018 12:57:14 -0700 (PDT)
Subject: Re: [RFC 2/2] ath10k: reporting estimated tx airtime for fairness
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <1538008874-11692-1-git-send-email-rmanohar@codeaurora.org>
 <1538008874-11692-2-git-send-email-rmanohar@codeaurora.org>
 <87lg7lfxtw.fsf@toke.dk> <34bac7851e6c9d3194cef87bd952c388@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <25469b4a-219d-f941-15ad-a1c95308dd69@candelatech.com>
Date:   Fri, 28 Sep 2018 12:57:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <34bac7851e6c9d3194cef87bd952c388@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 09/28/2018 12:47 PM, Rajkumar Manoharan wrote:
> On 2018-09-28 08:25, Toke Høiland-Jørgensen wrote:
>
>> So this just uses the calculated airtime based on rate and size? Wasn't
>> there supposed to be an airtime usage value reported by the firmware? :)
>>
> Firmware interface changes are in progress. Airtime for sta/tid will be reported via
> htt tx-compl and rx ind messages. Meantime I thought it would be useful to use Kan's changes
> for ATF validation in ath10k using existing firmware. :)

Maybe you can get the firmware guys to report the tx rate in the tx-completion
(like I have been doing for years in my ath10k-ct firmware)?  Then let the host
do the air-time calculating?

I'll give them firmware patches if the want :)

Thanks,
Ben

>
> -Rajkumar
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

