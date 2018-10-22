Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE4AC004D3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 20:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51D0D20651
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 20:27:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51D0D20651
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbeJWEr5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 00:47:57 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:38962 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeJWEr4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 00:47:56 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 42BC440A30A
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 13:27:54 -0700 (PDT)
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: Should we check netif_running in cfg80211_calculate_bi_data?
Organization: Candela Technologies
Message-ID: <8c876445-a065-ddb2-4dcf-e922f22a1b7d@candelatech.com>
Date:   Mon, 22 Oct 2018 13:27:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I was testing on my 4.16 kernel with a bunch of VAPs and I had two configured
for 100 beacon interval, and more at 240.  This failed for reasons I figured out
(gcd logic), but even once I tried to configure the vaps for 240 interval they
could not come up.  I am thinking maybe it was because I could only re-configure
admin-up interfaces, and they couldn't come up due the gcd thing?

Anyway, while poking, I thought maybe the patch below would be helpful since
we shouldn't care about admin-down interfaces in this case?

diff --git a/net/wireless/util.c b/net/wireless/util.c
index fbc880e..56d7583 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1541,6 +1541,9 @@ static void cfg80211_calculate_bi_data(struct wiphy *wiphy, u32 new_beacon_int,
                 if (wdev->beacon_interval == *beacon_int_gcd)
                         continue;

+               if (!netif_running(wdev->netdev))
+                       continue;
+
                 *beacon_int_different = true;
                 *beacon_int_gcd = gcd(*beacon_int_gcd, wdev->beacon_interval);
         }

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

