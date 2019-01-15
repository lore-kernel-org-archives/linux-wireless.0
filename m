Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F83C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 23:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 043BB20883
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 23:29:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="DLTbo16s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391422AbfAOX3m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:29:42 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:40872 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbfAOX3l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 18:29:41 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id CF38A40AC0B
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 15:29:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail2.candelatech.com CF38A40AC0B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1547594978;
        bh=lJ2IVTC9TA9IGPHWEN0OSXI/M/jVc3QQFqKskNgr2AE=;
        h=To:From:Subject:Date:From;
        b=DLTbo16sKnSZeok7hdhmWZWJQKwRS/TE/7yvVvJE1oV+pSskzBDHBe9yz0utd5XTI
         +wEZIgvnbRlggfOoG6FnqRqpKec4Fq4oWX6ShR2eU7sZ0yCNXWIXPr99YBt1XF4puq
         5+2dkex2UqkM5Q9uXVxEELhQYGdN08fsg8Wc0mLM=
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: ath10k and min_gcd + adhoc issues in 4.20 kernel
Organization: Candela Technologies
Message-ID: <3dfff3d9-a070-f3a3-723c-d1442ec06bc5@candelatech.com>
Date:   Tue, 15 Jan 2019 15:29:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I just updated to 4.20 and ported forward my ath10k patches.  Now the driver
will not register with mac80211 because this warning hits in net/wireless/core.c:

			/*
			 * This isn't well-defined right now. If you have an
			 * IBSS interface, then its beacon interval may change
			 * by joining other networks, and nothing prevents it
			 * from doing that.
			 * So technically we probably shouldn't even allow AP
			 * and IBSS in the same interface, but it seems that
			 * some drivers support that, possibly only with fixed
			 * beacon intervals for IBSS.
			 */
			if (WARN_ON(types & BIT(NL80211_IFTYPE_ADHOC) &&
				    c->beacon_int_min_gcd)) {
				return -EINVAL;
			}


It looks like this was triggered by:

Commit 0c317a02ca982ca093e71bf07cb562265ba40032
Author: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Date:   Wed Oct 12 18:26:51 2016 +0530

     cfg80211: support virtual interfaces with different beacon intervals

and

commit 8ebee73b574ad3dd1f14d461f65ceaffbd637650
Author: Anilkumar Kolli <akolli@codeaurora.org>
Date:   Wed Mar 28 12:19:40 2018 +0300

     ath10k: advertize beacon_int_min_gcd


To be honest, I don't see why that check for beacon_int_min_gcd is in the registration
logic.  Having it be '1' means that the driver/nic/firmware is flexible on pretty much
any combination of beacon interval, so why should that trigger the WARN_ON case?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

