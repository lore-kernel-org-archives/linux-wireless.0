Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5DE2C67863
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 17:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 727CF205F4
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 17:16:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 727CF205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbeJWBfw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 21:35:52 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:33576 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbeJWBfw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 21:35:52 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 84BB8409E08;
        Mon, 22 Oct 2018 10:16:28 -0700 (PDT)
Subject: Re: Where to report mpdus tx vs failed?
To:     Johannes Berg <johannes@sipsolutions.net>,
        Steve deRosier <derosier@gmail.com>
References: <104c8823-e867-6244-a528-979482c7fccc@candelatech.com>
 <CALLGbRKOLVg0bLhezLkEA_MPCg_S1L-drJNy3fSWxPJXJV+ajQ@mail.gmail.com>
 <93888bdc-b27d-78db-7fde-e881fa74c99b@candelatech.com>
 <c46e9b859318574a3b5ce7e1dbdf48404892d101.camel@sipsolutions.net>
 <512247ba69be323b6cef3b17ccd6957343acebd1.camel@sipsolutions.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <ae110050-1eec-25c4-57ba-86b42aae2930@candelatech.com>
Date:   Mon, 22 Oct 2018 10:16:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <512247ba69be323b6cef3b17ccd6957343acebd1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/22/2018 05:07 AM, Johannes Berg wrote:
> On Mon, 2018-10-22 at 14:06 +0200, Johannes Berg wrote:
>> On Fri, 2018-10-19 at 11:32 -0700, Ben Greear wrote:
>>>
>>> I was hoping I could fit it into some existing stat.  It is sort of like
>>> retries, so that will be my first attempt.
>>>
>>> By investigating an RF sniff, I notice the 9880 ath10k (with my fw
>>> and driver, at least), will retransmit about 30% of the frames when running
>>> at least one of my test cases (small udp frame transmit to AP that can only do about mcs5 or mcs7
>>> reliably at 3x3 nss).
>>>
>>> I'd like to report this stat in my wifi test tool if nothing else, but
>>> likely other people would make use of it as well.
>>
>>
>> We have NL80211_STA_INFO_TX_RETRIES, shouldn't you be able to capture it
>> there?
>
> Or, per TID, NL80211_TID_STATS_TX_MSDU_RETRIES

I added this code (rate is struct ieee80211_tx_rate)

	if (tx_done->mpdus_failed) {
		/* Maybe there is a better way to report this tried vs failed stat up the stack? */
		rate->count = tx_done->mpdus_failed + 1;
	}
	else {
		rate->count = 1;
	}

I think this is mostly providing useful info up the stack and we are trying to verify
the counts against a packet sniff today.  The driver is only reporting
this number for the first packet in the ampdu chain, so all retries are counted against the
first frame (the rest will have mpdus_failed == 0 regardless of how many retries they have).

And, on total retry failure, packets should be reported up the stack as tx-no-ack, so I think
that is working OK too.

I guess mac80211 could use this tx-status to report per-tid if it cared to.  I don't see any
other way to pass such tx failure details up the stack to mac80211.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

