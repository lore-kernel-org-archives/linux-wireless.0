Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE105C10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C639220868
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfDPJbN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 05:31:13 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56788 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbfDPJbL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 05:31:11 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hGKQn-0004KN-OL; Tue, 16 Apr 2019 11:31:09 +0200
Message-ID: <91d60fa7ba614c96fe2814375a28802e9165218b.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 16 Apr 2019 11:31:08 +0200
In-Reply-To: <577d4307-27ca-c5f5-8814-bbef515559e3@wetzel-home.de>
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
         <577d4307-27ca-c5f5-8814-bbef515559e3@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-04-15 at 22:09 +0200, Alexander Wetzel wrote:
> Honestly I don't like my own patch for the KeyId border signal, too 
> complex and not intuitive at all. But I wanted to have some code for 
> discussion and then got carried away a bit in what may have been not the 
> right direction.

:-)

> Could we not simply ask (at least) the drivers supporting Extended Key 
> IDs to implement a special for the remote STA invisible A-MPDU "stop" mode?
> In this new mode each A-MPDU would simply be build out of a single MPDU. 
> We then could keep Block-Ack active and we don't have to tell the remote 
> STA anything about that decision. After all a A-MPDU with only one MPDU 
> is allowed...
> We then could tell the driver to switch to this mode when installing the 
> new key and out of it again when we have activated the new key for Tx.
> That should be perfectly fine to run only in the control path and 
> comparable simple to set up, too.

Sounds doable, but I'm still debating if we even should give them a
signal - they have all the information in a sense, and do we have a good
idea of when we can go out of this mode again?

(FWIW, I'd probably call it "suspend" and "resume" or so)

> That also sounds like something all drivers supporting A-MPDU should be 
> able to pull off somehow. (But then I've never even looked at more than 
> ath9k and iwlwifi so far for A-MPDU, and at those not close, yet.)
> Do you see any problems with that solution and/or a better idea?

It ought to be possible, or if not then the device just can't support
extended key ID?

> Also would you prefer we first sort out the A-MPDU issue prior I adding 
> test cases to the hostapd/wpa_supplicant or the other way round?

I think adding the code to hostapd/wpa_s is fine - right now we're
obviously OK since we have no drivers using extended key ID that use
hardware crypto, and if we have software crypto there's no problem
either way, even if A-MPDUs are built (which is probably not the case
for any such drivers anyway.)

In a sense I'd prefer getting the necessary bits and pieces elsewhere in
the stack upstream first since that's a prerequisite for anyone
else being able to easily work on this, and that's something we need for
drivers to pick it up.

johannes

