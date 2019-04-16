Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7367AC10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 19:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42A8020663
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 19:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfDPTL5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 15:11:57 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:37838 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfDPTL5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 15:11:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hGTUp-0000AY-BZ; Tue, 16 Apr 2019 21:11:55 +0200
Message-ID: <08b4769ff83eb9b098fee8915ca25666f29512c7.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 16 Apr 2019 21:11:54 +0200
In-Reply-To: <7338263c-9e01-1559-888f-adcb4b7c8ca1@wetzel-home.de>
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
         <91d60fa7ba614c96fe2814375a28802e9165218b.camel@sipsolutions.net>
         <7338263c-9e01-1559-888f-adcb4b7c8ca1@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-04-16 at 20:28 +0200, Alexander Wetzel wrote:

> They can enable the mode when a key with IEEE80211_KEY_FLAG_NO_AUTO_TX 
> set

This I agree with.

> and quiet it again as soon as they get a MPDU using the new KeyID.

This isn't true, afaict. You need to be sure that no MPDUs remain using
the old key ID, not just that the new key ID showed up.

> Since switching back to normal doesn't have to be done immediately a 
> asyc call from Tx path or even a worker should do the job just fine.

Sure.

> Btw:
> This also means we'll have to update the merged mac80211 Extended Key ID 
> support: We can only enable it for cards without HW crypto when they do 
> not set AMPDU_AGGREGATION. With the updated userspace these cards will 
> start using Extended Key ID with the already merged patches.

I was going to say this is fine, but no, of course not ... we shouldn't
use different key id in the same A-MPDU.

That said, I'd be very surprised if there are any such drivers, except
in corner cases (like loading some drivers like ath9k or iwlwifi with
swcrypto=1 or so)

> Of those only hwsim and brcmsmac seems to support AMPDU and only 
> brcmsmac relly needs the fix to not lose some packets when rekeying.

I can't believe that brcmsmac has no HW crypto support?

Anyway, a patch - even if it serves mostly as documentation - would be
most welcome.

> I assume we still have to wait till the API is in mainline (probably 
> 5.2) to ask hostapd/wpa_supplicant to merge the patches?

No, mac80211-next is (usually?) good enough.

johannes

