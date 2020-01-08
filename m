Return-Path: <SRS0=curT=25=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989FCC282DD
	for <linux-wireless@archiver.kernel.org>; Wed,  8 Jan 2020 17:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67C5E20705
	for <linux-wireless@archiver.kernel.org>; Wed,  8 Jan 2020 17:54:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="WxkdEKRf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgAHRyt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 8 Jan 2020 12:54:49 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:47128 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgAHRyt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Jan 2020 12:54:49 -0500
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id C45DF13C340
        for <linux-wireless@vger.kernel.org>; Wed,  8 Jan 2020 09:54:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com C45DF13C340
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1578506088;
        bh=zGanaNGSpfMubaMAL7C+H8kveJA9BkkHMFGXf7s+CcI=;
        h=To:From:Subject:Date:From;
        b=WxkdEKRfxlyqG0CcacSfAeHBjH3q18LAasEBcR53FHvyfoHeTus0zpgc5AwRtFCTc
         TDLAB4FrWwzfhwK3Ar2+7u2WJcpMr18XriHTexPmV9OIjYCLHyqYGIOmD0SKSdDDoO
         H2u5BhL7Md6yGA/TID6gBNV4SHhc7oI16LLwc2Sg=
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: Does ath10k firmware need to do congestion control?
Organization: Candela Technologies
Message-ID: <20d8f9cf-1b5c-6617-f0a6-4f0083c6d64c@candelatech.com>
Date:   Wed, 8 Jan 2020 09:54:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

While debugging some packet drops in the tx path with ath10k-ct wave-2 stuff,
we found that the firmware congestion control was causing packets to be discarded.  The congestion
control tries to reserve a certain number of descriptors for higher priority packets,
so the driver never applies any real back pressure since it will have some tx descriptors
available (though firmware will immediately drop them).

If the upper stacks are already doing QoS/WMM type logic, then there should be little use
of leaving the congestion control compiled into the firmware.

So question is:  What is the state of the upper stack with regard to QoS/WMM congestion
control and throttling?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

