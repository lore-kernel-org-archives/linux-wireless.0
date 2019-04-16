Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684BCC10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 18:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FF5A2075B
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 18:28:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="r2ogllPE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbfDPS2i (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 14:28:38 -0400
Received: from 2.mo6.mail-out.ovh.net ([46.105.76.65]:50493 "EHLO
        2.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfDPS2i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 14:28:38 -0400
X-Greylist: delayed 71580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Apr 2019 14:28:36 EDT
Received: from player774.ha.ovh.net (unknown [10.109.160.251])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id A42F31BDCA3
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 20:28:34 +0200 (CEST)
Received: from awhome.eu (p57B7E5B2.dip0.t-ipconnect.de [87.183.229.178])
        (Authenticated sender: postmaster@awhome.eu)
        by player774.ha.ovh.net (Postfix) with ESMTPSA id E21324D3BCB1;
        Tue, 16 Apr 2019 18:28:32 +0000 (UTC)
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1555439312;
        bh=lAqXI2cnKoVrEGpkmQwsB9NzzpV8Okel7p0k09qTXWY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=r2ogllPEDzwPYW0ifqSOR3NEcYq74IRUqA3V536Ee8oeFRwJFtchvBd23fMwr2hNp
         DtrvFwtUqmiEe/rfKTu23RaWKsE9MatVLY33tY7u309o2XcFzoo3VXJrPU3husT9eL
         MspAokqJjwCvbG0p7ukGsEqIHfx8bwiypqAHufBI=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
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
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <7338263c-9e01-1559-888f-adcb4b7c8ca1@wetzel-home.de>
Date:   Tue, 16 Apr 2019 20:28:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <91d60fa7ba614c96fe2814375a28802e9165218b.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 2220837566372322503
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrfedugdduvdeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>> Could we not simply ask (at least) the drivers supporting Extended Key
>> IDs to implement a special for the remote STA invisible A-MPDU "stop" mode?
>> In this new mode each A-MPDU would simply be build out of a single MPDU.
>> We then could keep Block-Ack active and we don't have to tell the remote
>> STA anything about that decision. After all a A-MPDU with only one MPDU
>> is allowed...
>> We then could tell the driver to switch to this mode when installing the
>> new key and out of it again when we have activated the new key for Tx.
>> That should be perfectly fine to run only in the control path and
>> comparable simple to set up, too.
> 
> Sounds doable, but I'm still debating if we even should give them a
> signal - they have all the information in a sense, and do we have a good
> idea of when we can go out of this mode again?

Handling that on the Tx path would be tricky, but I you are right: 
Drivers should be able to handle that as it is on the control path, too.

They can enable the mode when a key with IEEE80211_KEY_FLAG_NO_AUTO_TX 
set and quiet it again as soon as they get a MPDU using the new KeyID.
Since switching back to normal doesn't have to be done immediately a 
asyc call from Tx path or even a worker should do the job just fine.

Btw:
This also means we'll have to update the merged mac80211 Extended Key ID 
support: We can only enable it for cards without HW crypto when they do 
not set AMPDU_AGGREGATION. With the updated userspace these cards will 
start using Extended Key ID with the already merged patches.

Drivers which should be able to use Extended Key ID with the two merged 
patches seem to be:
admtek/adm8211.c
ath/ar5523/ar5523.c
broadcom/b43legacy/main.c
broadcom/brcm80211/brcmsmac/mac80211_if.c
mac80211_hwsim.c
marvell/libertas_tf/main.c
ralink/rt2x00/rt2400pci.c
ralink/rt2x00/rt2500pci.c
realtek/rtl818x/rtl8180/dev.c
realtek/rtl818x/rtl8187/dev.c
zydas/zd1211rw/zd_mac.c

Of those only hwsim and brcmsmac seems to support AMPDU and only 
brcmsmac relly needs the fix to not lose some packets when rekeying.


>> That also sounds like something all drivers supporting A-MPDU should be
>> able to pull off somehow. (But then I've never even looked at more than
>> ath9k and iwlwifi so far for A-MPDU, and at those not close, yet.)
>> Do you see any problems with that solution and/or a better idea?
> 
> It ought to be possible, or if not then the device just can't support
> extended key ID?

Agree. Or drivers can decide to deny A-MPDU setup when the key has been 
installed with IEEE80211_KEY_FLAG_NO_AUTO_TX when they want.

>> Also would you prefer we first sort out the A-MPDU issue prior I adding
>> test cases to the hostapd/wpa_supplicant or the other way round?
> 
> I think adding the code to hostapd/wpa_s is fine - right now we're
> obviously OK since we have no drivers using extended key ID that use
> hardware crypto, and if we have software crypto there's no problem
> either way, even if A-MPDUs are built (which is probably not the case
> for any such drivers anyway.)
> 
> In a sense I'd prefer getting the necessary bits and pieces elsewhere in
> the stack upstream first since that's a prerequisite for anyone
> else being able to easily work on this, and that's something we need for
> drivers to pick it up.

Ok:-)

I assume we still have to wait till the API is in mainline (probably 
5.2) to ask hostapd/wpa_supplicant to merge the patches?

At the moment I'm planning to get the patches merge ready and posted as 
RFC till 5.2 is out. I'm also planing to keep Extended Key ID for Mesh 
networks till later, so we can focus on AP/STA.


Alexander

