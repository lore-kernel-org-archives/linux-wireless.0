Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C644FC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 22:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 973F02081C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 22:53:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 973F02081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388192AbeKFIPi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 03:15:38 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:50416 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387965AbeKFIPi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 03:15:38 -0500
Received: from [192.168.43.60] (unknown [172.58.40.243])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 8D96040A539;
        Mon,  5 Nov 2018 14:53:29 -0800 (PST)
Message-ID: <5BE0CA46.7080705@candelatech.com>
Date:   Mon, 05 Nov 2018 14:55:02 -0800
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Jouni Malinen <j@w1.fi>
Subject: Re: [RFC 0/3] cfg80211/nl80211/iw: add basic AMPDU/AMSDU controls
References: <20181105143027.17570-1-sergey.matyukevich.os@quantenna.com> <34042c1e8020bfb49ab97c9160ab50df044846af.camel@sipsolutions.net> <a65739ee-ab89-cf4d-af1b-f86fcc783bac@candelatech.com> <97d75b4c-3dc6-d863-c08b-bcc31da635b1@quantenna.com>
In-Reply-To: <97d75b4c-3dc6-d863-c08b-bcc31da635b1@quantenna.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/05/2018 02:49 PM, Igor Mitsyanko wrote:
> On 11/05/2018 12:45 PM, Ben Greear wrote:
>>>
>>> I see you don't implement it this way in the driver, but wouldn't it
>>> make more sense to have this as a per-STA (RA) setting? That's really
>>> the granularity it can be done on, I think?
>>>
>>> Arguably even per-RA/TID, though that seems a little excessive?
>>
>> I like the idea of providing this API per peer/tid.  And, just allow
>> peer == -1, tid == -1 or similar to mean 'all' so that you can still set
>> the entire device
>> to one particular setting w/out having to iterate through all peers if you
>> don't want to iterate...
>
> Maye I'm wrong, but isn't the setting we're discussing are for the
> device itself, not for its peers? I mean, disabling AMSDU, AMPDU implies
> we need to update capabilities advertised in our information elements,
> which are common for all devices, and it affects both Tx and Rx.
>
> And per-node/per-TID aggregation settings are a separate configuration
> option related to rate adaptation on Tx path only..

You can advertise your maximum capabilities, but just because you advertise
that you can do large AMPDU chains doesn't mean you are required to send
them.

So, to advertise stuff, it is per vdev (not per radio), but once you associate
a peer, you might decide to configure it so that you always send no more than 5
frames in an AMPDU chain, for instance.

And, you might decide that BE gets up to 32 AMPDU chain, but VI should be limitted to 16
to decrease latency just a bit.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

