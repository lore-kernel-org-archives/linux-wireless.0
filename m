Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D785C10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 23:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E59020675
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 23:45:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="hCDdMVlZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbfDOXph (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 19:45:37 -0400
Received: from 14.mo6.mail-out.ovh.net ([46.105.56.113]:59903 "EHLO
        14.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbfDOXph (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 19:45:37 -0400
Received: from player716.ha.ovh.net (unknown [10.109.159.248])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id 3B4B81BD213
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2019 22:09:31 +0200 (CEST)
Received: from awhome.eu (p57B7E5B2.dip0.t-ipconnect.de [87.183.229.178])
        (Authenticated sender: postmaster@awhome.eu)
        by player716.ha.ovh.net (Postfix) with ESMTPSA id 96C3A4BB076C;
        Mon, 15 Apr 2019 20:09:29 +0000 (UTC)
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1555358968;
        bh=c84umI1qqm6ZpdW85oO6H1p2aoCRmwMZeEOEq0r4TS4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=hCDdMVlZrUiIbMMiKpoXFPnQ3wQmx3wxRk+8ccnV1PUylwfXX+KeKZc7fSHHhPfgv
         50tNtwWRrzpDNDDi4B4dWm9MAUkqeRfV77i4LKGET4skwoKX8ofdPgBQlKWsw2bvmI
         axF2jSPuF6ONn2LM8yYWALjQM/ORENaA8kvaQ04Q=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-8-alexander@wetzel-home.de>
 <1a3b6e515c73a2c185e8dad84ab2ebfd8982a6ce.camel@sipsolutions.net>
 <e84c30de-28d6-7d1b-0fa3-d1ca466e257b@wetzel-home.de>
 <69e6577f90d99289acaa9853fe236e6f15f9e774.camel@sipsolutions.net>
 <14c9d8f7-7cf6-d7e1-a1c0-9f1a10920d4e@wetzel-home.de>
 <ed6e95dad39ef0ac98c62e3acd3f78fd7b3a6d2b.camel@sipsolutions.net>
 <185ea9a2-f3c6-04a5-000b-44191da5a0ee@wetzel-home.de>
 <0de9d60ffef574b34e9a76ad2cea68fab49aac0f.camel@sipsolutions.net>
 <45ae97d6-3357-64ac-0a40-9ae3ea4a8ed2@wetzel-home.de>
 <84694a97bf884985afd49d93e28b309a92801916.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <577d4307-27ca-c5f5-8814-bbef515559e3@wetzel-home.de>
Date:   Mon, 15 Apr 2019 22:09:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <84694a97bf884985afd49d93e28b309a92801916.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 16499781662544960711
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrvdelgddugeegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am 15.04.19 um 10:44 schrieb Johannes Berg:
>> But for my understanding the driver could also set A-MPDU to
>> only one frame, forcing the firmware to flush all A-MPDUs under
>> construction and then set it back to the normal value. (Or that is how
>> I've planned to test that in that way with your tips in the past and
>> what's documented of the mvm/dvm firmware API.)
> It's probably getting more complicated with newer versions of the API,
> but yes, I guess it should be doable to suspend aggregation.

Honestly I don't like my own patch for the KeyId border signal, too 
complex and not intuitive at all. But I wanted to have some code for 
discussion and then got carried away a bit in what may have been not the 
right direction.

Could we not simply ask (at least) the drivers supporting Extended Key 
IDs to implement a special for the remote STA invisible A-MPDU "stop" mode?
In this new mode each A-MPDU would simply be build out of a single MPDU. 
We then could keep Block-Ack active and we don't have to tell the remote 
STA anything about that decision. After all a A-MPDU with only one MPDU 
is allowed...
We then could tell the driver to switch to this mode when installing the 
new key and out of it again when we have activated the new key for Tx.
That should be perfectly fine to run only in the control path and 
comparable simple to set up, too.

That also sounds like something all drivers supporting A-MPDU should be 
able to pull off somehow. (But then I've never even looked at more than 
ath9k and iwlwifi so far for A-MPDU, and at those not close, yet.)
Do you see any problems with that solution and/or a better idea?

Also would you prefer we first sort out the A-MPDU issue prior I adding 
test cases to the hostapd/wpa_supplicant or the other way round?

Looks like I'll have some time at Easter to (start) looking into one or 
the other.
I'm currently trending to the A-MPDU issue, as it's the more fundamental 
of the two immediate topics. (And the captures are pretty clear, this 
explains so far every corrupted packet captured.)


Regards,
Alexander
