Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE60C10F03
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 21:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF23421773
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 21:08:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="qshe5xCD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfDWVIN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 17:08:13 -0400
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:36433 "EHLO
        4.mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfDWVIM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 17:08:12 -0400
Received: from player792.ha.ovh.net (unknown [10.108.54.87])
        by mo2.mail-out.ovh.net (Postfix) with ESMTP id 7A73618FF2C
        for <linux-wireless@vger.kernel.org>; Tue, 23 Apr 2019 22:59:45 +0200 (CEST)
Received: from awhome.eu (p57B7E5B2.dip0.t-ipconnect.de [87.183.229.178])
        (Authenticated sender: postmaster@awhome.eu)
        by player792.ha.ovh.net (Postfix) with ESMTPSA id 460BB520B4DE;
        Tue, 23 Apr 2019 20:59:42 +0000 (UTC)
Subject: Re: [PATCH 1/2] mac80211: Fix Extended Key ID auto activation
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1556053180;
        bh=DCAprEPCchlj5b10z6obtHb4k29NNvOTozeJzhBfZA4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=qshe5xCDACBFgD3GBPSBXtJcOrcDh0ay9TkaZnAUFphIATQ+GERE7OeyhUbgSHO/V
         N46W5OGU4oDkzLfricKAXvWS7AXziNb2NZ09EUVrjf4Scn5KAZhBbkGa0gLHiviL7T
         aP0cOM9FArsZkTA8YaoJ9a3DPAzQe1gx57XdfSSY=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190422213412.16533-1-alexander@wetzel-home.de>
 <4464ea399dbbc1aca040ad8a4442a73f78cc38fb.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <62a76eb7-2cd4-65ed-e583-663d1d971820@wetzel-home.de>
Date:   Tue, 23 Apr 2019 22:59:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <4464ea399dbbc1aca040ad8a4442a73f78cc38fb.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8989466334041939143
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrgeekgddugeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am 23.04.19 um 14:14 schrieb Johannes Berg:
> On Mon, 2019-04-22 at 23:34 +0200, Alexander Wetzel wrote:
>> Only enable Extended Key ID support for drivers which are not supporting
>> crypto offload and also do not support A-MPDU.
>>
>> While any driver using SW crypto from mac80211 is generally able to also
>> support Extended Key ID these drivers are likely to mix keyIDs in
>> AMPDUs when rekeying.
>>
>> According to IEEE 802.11-2016 "9.7.3 A-MPDU contents" this is not
>> allowed.
>>
> 
> I applied this (with some changes), but please resend the other patch as
> two separate patches to mac80211/hwsim.

I've just dropped you the updated patch for hwsim Extended Key ID 
support. That's kind of critical for the attempt to get Extended Key ID 
support merged in hostapd/wpa_supplicant.

The patch to allow ptk0 rekeys with hwsim should follow soon. (The PTK0 
rekey patches I have for hostapd/wpa_supplicant still need serious work 
anyhow and are far away to be ready for merge.)

Alexander
