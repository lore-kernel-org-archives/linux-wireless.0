Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9910CC5ACC6
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 23:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59E7E2147E
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 23:31:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59E7E2147E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbeJQHYC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 03:24:02 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:54460 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbeJQHYC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 03:24:02 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 8ACE540A539
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 16:31:16 -0700 (PDT)
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: Rate-ctrl experience gained with ath10k
Organization: Candela Technologies
Message-ID: <c707767c-8349-6148-d401-c12d30190dec@candelatech.com>
Date:   Tue, 16 Oct 2018 16:31:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

So, I've been trying to understand why the ath10k-rate ctrl was acting
so poorly in my 20-station UDP tx case.  I wrote that wifi-diag tool,
and it gave some clues, but only in retrospect were they obvious :)

The problem in general was that a single station could upload, at say 500Mbps,
but 20 stations could only do about 325Mbps.  If we fixed the MCS at 3x3 MCS7,
then the 20 station upload test ran about 490Mbps.

There were several optimizations I made in the ath10k firmware rate-ctrl.  One
was to penalize rates with higher PER (packet error rate) more than the old algorithm did.  This helped
a small bit, but not enough (around 350-370Mbps total throughput).

Then, after adding logs I noticed that each station was probing once about every 5 ampdu
chains, or almost 20% of the time!  These probe AMPDUs are limited to a max of 4 AMSDUs,
and that explains why my 'bad' case showed 17% of the AMPDU chains were 4 in length in
my wifi-diag output.

I changed the firmware to take number of active stations into account, and increase the
75ms probe interval by up to a factor of 5.  I also probe less often when the probed
rate has PER > 5 or the last probe had a dropped frame.

And, I allow probing with AMPDU chains of up to 16 AMSDU instead of just 4.

Together this gets me up to about 460Mbps in this test case.   Still not quite as good
as fixing the MCS at 7, but good enough I think.

Here's hoping this email will let other folks poking at rate-ctrl have a faster
time at fixing things than I did.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

