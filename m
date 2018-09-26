Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3161C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 18:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 912312152F
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 18:27:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 912312152F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbeI0AlW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 20:41:22 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44988 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727235AbeI0AlW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 20:41:22 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5EWh-0002NU-98; Wed, 26 Sep 2018 20:27:07 +0200
Message-ID: <1537986415.28767.17.camel@sipsolutions.net>
Subject: Re: How many null-data probes on connection loss?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Wed, 26 Sep 2018 20:26:55 +0200
In-Reply-To: <fc564b2e-b6f2-75db-a2d9-99ea55a63c4a@candelatech.com>
References: <9a1447d9-9a61-dc2d-0101-33c6bdeb946f@candelatech.com>
         <1537951137.28767.5.camel@sipsolutions.net>
         <fc564b2e-b6f2-75db-a2d9-99ea55a63c4a@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-09-26 at 11:04 -0700, Ben Greear wrote:

> I have been running with mac80211/mlme.c's max_nullfunc_tries set to 5 for many years.
> Long ago it helped with connectivity issues with lots of vdevs and and/orloaded APs
> if I recall correctly.

That's different, that's the number of distinct frames mac80211 will
send.

I thought you were asking about *retries*.

> In fact, I see 62 frames captured on air all with the same sequence number
> in the test I just did, and subsequent frames with the next seq-no are sent
> immediately after the first one.  The frames are all right after each other, so
> I guess this is probably firmware doing lots of HW retransmits and then *also*
> doing software retransmits in the firmware (my reading of mlme.c indicates it should
> only probe every 500ms).

Yes.

> I think I'll start by making sure the firmware does not do software retransmits
> for frames from the driver (self-gen frames are OK to be retransmitted I guess).

You do want it to be doing retries for frames from the driver, since you
want it to recover from temporary collisions with a microwave and
whatnot ... just not *that many*, I guess.

johannes
