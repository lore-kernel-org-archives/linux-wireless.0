Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD2EC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 07:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E055B204EC
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 07:12:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E055B204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbeI0N3p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 09:29:45 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51734 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbeI0N3p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 09:29:45 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5QTn-00069p-Rs; Thu, 27 Sep 2018 09:12:56 +0200
Message-ID: <1538032363.14416.2.camel@sipsolutions.net>
Subject: Re: How many null-data probes on connection loss?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Thu, 27 Sep 2018 09:12:43 +0200
In-Reply-To: <e3c18a8d-9a58-54c5-9aaa-b778299f527b@candelatech.com>
References: <9a1447d9-9a61-dc2d-0101-33c6bdeb946f@candelatech.com>
         <1537951137.28767.5.camel@sipsolutions.net>
         <fc564b2e-b6f2-75db-a2d9-99ea55a63c4a@candelatech.com>
         <1537986415.28767.17.camel@sipsolutions.net>
         <7ed031b0-19d9-46db-33d9-082999e5ed22@candelatech.com>
         <1537987703.28767.22.camel@sipsolutions.net>
         <e3c18a8d-9a58-54c5-9aaa-b778299f527b@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-09-26 at 15:21 -0700, Ben Greear wrote:
> 
> Now only 4 retries per frame, but it seems mac80211 is all 5 of its
> null-data probes within a few miliseconds.  Is that expected, or should
> there be a bit more pause between each of the probe requests to better
> weather periodic network glitches?

Hmm. That's a good point, but it seems we've never considered this
before. This must be a consequence of retrying immediately on lost ACK,
but I guess I could see that delaying it for a little bit would make
sense.

We do delay it if there's no reliable ACK reporting, IIRC, but if we
know it failed for sure ...

It seems though that if there's some noise or so on the channel you
wouldn't be transmitting, so what kind of "network glitches" might
affect this? AP going away unexpectedly for some time?

johannes
