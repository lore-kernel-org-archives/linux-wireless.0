Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F57C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 08:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 224C92083A
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 08:39:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 224C92083A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbeIZOu7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 10:50:59 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:37778 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbeIZOu7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 10:50:59 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g55Lf-00007w-U0; Wed, 26 Sep 2018 10:39:08 +0200
Message-ID: <1537951137.28767.5.camel@sipsolutions.net>
Subject: Re: How many null-data probes on connection loss?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Wed, 26 Sep 2018 10:38:57 +0200
In-Reply-To: <9a1447d9-9a61-dc2d-0101-33c6bdeb946f@candelatech.com> (sfid-20180926_011302_681374_72D229A5)
References: <9a1447d9-9a61-dc2d-0101-33c6bdeb946f@candelatech.com>
         (sfid-20180926_011302_681374_72D229A5)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-09-25 at 16:12 -0700, Ben Greear wrote:
> While testing out some other issue, I noticed that my ath10k system creates
> several hundred null-data probes when I abruptly down the AP the station
> is connected to.
> 
> I guess this is because I use the mac80211 stack to handle the probes, and
> the firmware then retries each mac80211 probe many times.
> 
> So, in the case where mac80211 is sending a null-data probe, is the assumption
> that the driver will try each frame exactly once?

Not really, it should be treated like any other management frame.

> Or is several hundred frames expected?  I'm guessing the former, but before I go
> hacking firmware, I thought I would ask...

Certainly not several hundred, but maybe a dozen? I think iwlwifi uses
16, and minstrel would set up max_rate_tries, which drivers set to
somewhere between 1 and 18? One seems s a bit low, mt76?

johannes
