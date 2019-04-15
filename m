Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5F4C10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 08:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7713420693
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 08:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfDOIoH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:44:07 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34506 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbfDOIoH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 04:44:07 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hFxDg-0002qw-M6; Mon, 15 Apr 2019 10:44:04 +0200
Message-ID: <84694a97bf884985afd49d93e28b309a92801916.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 15 Apr 2019 10:44:03 +0200
In-Reply-To: <45ae97d6-3357-64ac-0a40-9ae3ea4a8ed2@wetzel-home.de>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2019-04-14 at 18:12 +0200, Alexander Wetzel wrote:
> > I'll take a look, but a trace-cmd recording would be more interesting
> > than the monitor interface, as it also tells us when what key was
> > installed etc.
> 
> I've just uploaded better captures also including traces to the same 
> location. Everything relevant for this mail is in the folder
> iwlwifi-debug here:
> https://www.awhome.eu/index.php/s/AJJXBLsZmzHdxpX

Great, thanks.

> It looks like we only have a problem when we get frames with the "new" 
> keyID and then again some with the "old" keyID. Of course we also could 
> have multiple problems, too... But in that case I would say let's first 
> look at this one.

This part kinda surprises me.

> The problematic frames are encrypted with the correct "old" key, 
> according to wireshark.
> 
> But on the STA they are scrambled and therefor probably have been 
> decrypted with the - in this case - wrong new key.
> 
> And as it happens there is also a really good looking first suspect why 
> this may have happened:
> According to the STA captures the broken frames came in one A-MPDU which 
> started with keyID 1 and then "appended" the older keyID 0 frames at the 
> end. (The OTA sniffer seems to be miss the A-MPDU details, see the STA 
> capture...)

This doesn't surprise me at all.

> Now it really looks like the mvm cards are trusting the standard and 
> decode all MPDUs within one A-MPDU with the same key while at the same 
> time allow mixing different keyIDs in a-MPDU.

Yes, I'm pretty sure the firmware will only be able to look at the whole
A-MPDU and thus must make a decision based on the first subframe
regarding the key.

> The so far mostly theoretical question how far mac80211 should support 
> the driver (e.g. key ID border signal) or if we want to let the 
> drivers/card handle that would become much more pressing...

Yeah, good point. I guess this really would have to be on the
transmitter though.

> Ideally the card/firmware would be able to detect that and start a new 
> A-MPDU. 

For similar reasons, I don't think it can do this even on TX.

> But for my understanding the driver could also set A-MPDU to 
> only one frame, forcing the firmware to flush all A-MPDUs under 
> construction and then set it back to the normal value. (Or that is how 
> I've planned to test that in that way with your tips in the past and 
> what's documented of the mvm/dvm firmware API.)

It's probably getting more complicated with newer versions of the API,
but yes, I guess it should be doable to suspend aggregation.

> Thanks for the reminder.
> I'll definitely will remember the option, I was not aware that there was 
> a more private way:-)

Just wanted to point it out. I'd agree the risk is minimal since you use
a separate test network anyway.

johannes

