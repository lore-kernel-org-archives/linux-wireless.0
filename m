Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAACC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 18:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D39E321547
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 18:48:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D39E321547
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbeI0BCz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 21:02:55 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45316 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725733AbeI0BCz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 21:02:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5ErT-0002jW-Pw; Wed, 26 Sep 2018 20:48:36 +0200
Message-ID: <1537987703.28767.22.camel@sipsolutions.net>
Subject: Re: How many null-data probes on connection loss?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Wed, 26 Sep 2018 20:48:23 +0200
In-Reply-To: <7ed031b0-19d9-46db-33d9-082999e5ed22@candelatech.com>
References: <9a1447d9-9a61-dc2d-0101-33c6bdeb946f@candelatech.com>
         <1537951137.28767.5.camel@sipsolutions.net>
         <fc564b2e-b6f2-75db-a2d9-99ea55a63c4a@candelatech.com>
         <1537986415.28767.17.camel@sipsolutions.net>
         <7ed031b0-19d9-46db-33d9-082999e5ed22@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-09-26 at 11:47 -0700, Ben Greear wrote:

> > > I think I'll start by making sure the firmware does not do software retransmits
> > > for frames from the driver (self-gen frames are OK to be retransmitted I guess).
> > 
> > You do want it to be doing retries for frames from the driver, since you
> > want it to recover from temporary collisions with a microwave and
> > whatnot ... just not *that many*, I guess.
> 
>  From what I can tell so far, my firmware has this sort of logic:
> 
> frame from stack to the driver
>    -> send to firmware
>    -> in firmware, hardware will do up to X retries (maybe 16 or so, need to check)
>    -> On failure, the firmware may re-queue the packet (firmware-software retry)
>    -> back to hardware retries (~32 frames on air at this point)
>    ...
>    Eventually tx-fail notification is sent back to the driver one way or another.
> 
> I am thinking it would be best to have the software retry in the firmware
> disabled.
> 
> Then, when mac80211 sends a null-data frame, you would see at most about
> 16 of them on air, every 500ms or so until it recovers or considers the
> connection lost.

Yes, that seems reasonable. In fact, I'd argue that such software-retry
should just be disabled completely - it's better to lose the occasional
frame than to keep using airtime for it forever ...

Toke is probably getting nightmares reading this - sweet dreams ;-)

johannes
