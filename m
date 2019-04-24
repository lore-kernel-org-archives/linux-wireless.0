Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C44C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 20:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7345E20835
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 20:58:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="B/LZX7Pz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731576AbfDXU6t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 16:58:49 -0400
Received: from 1.mo69.mail-out.ovh.net ([178.33.251.173]:34684 "EHLO
        1.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731020AbfDXU6t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 16:58:49 -0400
X-Greylist: delayed 9974 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Apr 2019 16:58:49 EDT
Received: from player728.ha.ovh.net (unknown [10.109.143.3])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 2571E4F41D
        for <linux-wireless@vger.kernel.org>; Wed, 24 Apr 2019 22:58:47 +0200 (CEST)
Received: from awhome.eu (p579AA28C.dip0.t-ipconnect.de [87.154.162.140])
        (Authenticated sender: postmaster@awhome.eu)
        by player728.ha.ovh.net (Postfix) with ESMTPSA id 939F1502335B;
        Wed, 24 Apr 2019 20:58:45 +0000 (UTC)
Subject: Re: [PATCH] mac80211: Set CAN_REPLACE_PTK0 for SW crypto only drivers
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1556139524;
        bh=g0tqfqcBmCTfyobHNamat3+xbv8ufOGVTieIQeQRv28=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=B/LZX7Pz+JAfYTIJ62z4deUf0oQcZKea6eZERWz9LGLAjb37aByG+e+EgESqbIsXJ
         UC5GYVgphUnwXA9i3NDcNXEjtDSF4kcwOGT/Lbd2joRZIk9AUMMi19ZqoSfQufeMyV
         sT2UPEToPVSUwGHr491u97z3i2cGTfnGObQFrzYY=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190424173246.26421-1-alexander@wetzel-home.de>
 <45ef6418002ddb01bc99a06a5c52e0dcd30afd4b.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <0e1d8f51-ca1b-a55e-73a1-d4b95fe3f0b5@wetzel-home.de>
Date:   Wed, 24 Apr 2019 22:58:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <45ef6418002ddb01bc99a06a5c52e0dcd30afd4b.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 14845834699223342279
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrhedvgdehvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am 24.04.19 um 20:55 schrieb Johannes Berg:
> On Wed, 2019-04-24 at 19:32 +0200, Alexander Wetzel wrote:
>> Mac80211 SW crypto handles replacing PTK keys correctly.
>>
>> Don't trigger needless warnings or workarounds when the driver can only
>> use the known good SW crypto provided by mac80211.
>>
>> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
>> ---
>>   net/mac80211/main.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
>> index e56650a9838e..2b608044ae23 100644
>> --- a/net/mac80211/main.c
>> +++ b/net/mac80211/main.c
>> @@ -1060,6 +1060,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>>   		wiphy_ext_feature_set(local->hw.wiphy,
>>   				      NL80211_EXT_FEATURE_EXT_KEY_ID);
>>   
>> +	/* Mac80211 and therefore all cards only using SW crypto are able to
>> +	 * handle PTK rekeys correctly
>> +	 */
>> +	if (!local->ops->set_key)
>> +		wiphy_ext_feature_set(local->hw.wiphy,
>> +				      NL80211_EXT_FEATURE_CAN_REPLACE_PTK0);
> 
> Now I wonder - shouldn't the same A-MPDU issue apply here? After all, if
> you replace the PTK 0 surely you shouldn't use different ones for the
> same frame in an A-MPDU?

Not from what I found in IEEE 802.11. It's only forbidden to mix keyIDs, 
not MPDUs using different keys. And without Extended Key ID the keyID 
can only be zero. So from a standard point of view we are ok, no keyID 
mixing possible.

 From a practical point of view cards like mvm cards will for sure 
corrupt MPDUs aggregated in a A-MPDU when different key were used for 
them. But we still don't care:-)

We'll corrupt the MPDU's encoded with either the old or the new key 
anyhow and we don't care which ones. After all the card will only have 
one key active for key ID 0 at any time won't have the second key 
installed at all.

Alexander
