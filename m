Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA22C004D1
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 07:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14805216FA
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 07:14:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14805216FA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbeI1NhL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:37:11 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:37890 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbeI1NhK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:37:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5mz9-0007zG-Hl; Fri, 28 Sep 2018 09:14:47 +0200
Message-ID: <1538118875.14416.53.camel@sipsolutions.net>
Subject: Re: Problem with sending pkt on a monitor port
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Fri, 28 Sep 2018 09:14:35 +0200
In-Reply-To: <6ac68a4c-04a3-ce6e-232e-3ebb6100ee29@candelatech.com>
References: <76ce3d16-dbea-e882-63e7-2337fbc269c6@candelatech.com>
         <1537389335.10305.92.camel@sipsolutions.net>
         <d6f99a05-77a3-f18a-4e7a-083062119ce4@candelatech.com>
         <1537428695.3874.1.camel@sipsolutions.net>
         <6ac68a4c-04a3-ce6e-232e-3ebb6100ee29@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sorry, I'm a bit behind things ...

> > It's actually created by mac80211, but only once, and not directly
> > mapped to each vif seen by userspace - it's an internal construction.
> 
> I'm not sure it matters, but ath10k firmware can also create a monitor vdev
> itself for certain reasons.  (Maybe offchannel tx on some FW, but I haven't looked at
> that code lately).

Yeah and I think it may actually do for active monitor, but I believe
those get their own MAC address anyway? That might get used in the end
as the vif to the driver too.

> > However, thinking about it, that also breaks userspace in other ways -
> > for example if you do injection this way you actually get encryption and
> > other nice things if you use the local address that matches an existing
> > interface.
> 
> I'm not entirely sure of a useful use-case for this feature in user-space.

Which feature?

At least ancient versions of hostapd would rely on this, but clearly
that's no longer super relevant. I don't know if anyone else relies on
it, but in a way that is the problem. If I knew, then I could think
about alternatives or how to keep that working if we change anything
here.

> I am using it just to test sending some test frames to debug some firmware
> features.  I think another user sent hand-crafted specialized beacons in this manner
> using my 10.1 ath10k firmware & driver.  For whatever reason, I didn't realize monitor
> vdevs were not directly used when I added that support..maybe I just got lucky
> before I had to dig closely.

They may be used if they were active monitor? I don't know ath10k well.
But then they shouldn't have had the same MAC address to start with,
IIRC.

> If I make the code in my original email be skipped, so that sdata remains the
> monitor vdev, then it fails a check later in that method because there is no
> chanctxt for the monitor sdata object.
> 
> I guess that changing the source MAC to something unique would cause the same
> issue and no frame would be sent towards the driver.

Hmm. This *should* work in one way or the other? But again, maybe ath10k
has something special here?

You skipped *just* that loop?

johannes
