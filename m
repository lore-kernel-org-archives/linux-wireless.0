Return-Path: <SRS0=gO0h=QY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB20DC43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 19:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D28D217FA
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 19:27:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="rKQOMYzo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbfBQT1b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Feb 2019 14:27:31 -0500
Received: from 1.mo179.mail-out.ovh.net ([178.33.111.220]:56240 "EHLO
        1.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfBQT1b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Feb 2019 14:27:31 -0500
Received: from player771.ha.ovh.net (unknown [10.109.143.232])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id C91C711ACC0
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2019 20:19:17 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player771.ha.ovh.net (Postfix) with ESMTPSA id 5382B2CAB534;
        Sun, 17 Feb 2019 19:19:16 +0000 (UTC)
Subject: Re: [RFC PATCH v3 02/12] nl80211/cfg80211: Extended Key ID support
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1550431155;
        bh=bo2XCIMk72ttHxj2nPxhR1cmfMNUY9Hzm59jYZmX1Y0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=rKQOMYzobgDwTxZbqiF9+vxFz+FtVOZR2uZ7cdI/1IBNz80N2Ndj+htnSYay0whRN
         B67Yx/+VxA9hRgnHqTB7OVE0uojW5uJCvtcKwCtMs8gdURjhZwRCu8zxxpV0KCUq3t
         QV+ZTxB8EKExcqvvU74ASqLBAfvIEKa4iSULkfug=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-3-alexander@wetzel-home.de>
 <790f69239a9635c62c9349323c069e4ac9ad51c9.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <a0e99ac4-4c10-55e6-3ded-5bb5a3ddfb78@wetzel-home.de>
Date:   Sun, 17 Feb 2019 20:19:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <790f69239a9635c62c9349323c069e4ac9ad51c9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12949256304744930503
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrleehgdegjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>> +/**
>> + * enum nl80211_key_install_mode - Key install mode
>> + *
>> + * @NL80211_KEY_RX_TX: Key must be installed for Rx and Tx
>> + * @NL80211_KEY_RX_ONLY: Allowed in combination with @NL80211_CMD_NEW_KEY:
>> + *	Unicast key has to be installed for Rx only.
>> + * @NL80211_KEY_SWITCH_TX: Allowed in combination with @NL80211_CMD_SET_KEY:
>> + *	Switch Tx to a Rx only, referenced by sta mac and idx.
> 
> Don't you mean the other way around? Or, well, what you say is true for
> the *other* keys?

I don't see the problem but I may simply be to set on my way to see 
it... So I'll just give an outline what's required of the API and how 
this implementation meets those. Hoping that answers your question or 
allowing you to pinpoint our differences in understanding. (I've added a 
  more than really required, it may be useful for other discussions to 
have that outlined in one piece, too.)

Extended Key ID has only two requirements for the kernel API:
1) Allow a key to be used for decryption first and switch it to a 
"normal" Rx/Tx key with a second call

2) Allow pairwise keys to use keyids 0 and 1 instead only 0.

"Legacy" key installs are using NL80211_CMD_NEW_KEY to install a new key 
and are allow to mark a key for WEP or management  default usages via 
NL80211_CMD_SET_KEY later.

With Extended Key ID we stick to a similar approach: NL80211_CMD_NEW_KEY 
is called to install the new key and nl80211_key_install_mode allows to 
select between a "legacy" or "extended" key install: NL80211_KEY_RX_TX 
for "legacy" or NL80211_KEY_RX_ONLY for "extended".

NL80211_KEY_SWITCH_TX is only allowed with NL80211_CMD_SET_KEY and is 
the only Extended Key ID action allowed for that function.

Any non-pairwise keys can only use NL80211_KEY_RX_TX which is of course 
always the default and also allowed for "legacy" pairwise keys.

A Extended Key Install will:
1) call NL80211_CMD_NEW_KEY with all the usual parameters of a new key 
install plus the flag NL80211_KEY_RX_ONLY set.

2) Once ready will call NL80211_CMD_SET_KEY with flag 
NL80211_KEY_SWITCH_TX to activate a specific key.


>>    *	by the %NL80211_SCAN_FLAG_MIN_PREQ_CONTENT flag.
>>    * @NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER: Driver supports enabling fine
>>    *	timing measurement responder role.
>> - *
> 
> no need to remove that :)

ok, I'll remove all the drive-by comment "cleanups".
It (often) looks kind of untidy and not really worth separate patches 
and I'm kind of responsible for (most) of them.. I see why you don't 
want to see those fixed drive-by...

My understanding is now that we prefer to not change those and I'll 
leave them alone.

> 
>> -	/* only support setting default key */
>> -	if (!key.def && !key.defmgmt)
>> +	/* Only support setting default key and
>> +	 * Extended Key ID action @NL80211_KEY_SWITCH_TX.
>> +	 */
> 
> you can remove the @, it's not a kernel-doc formatted comment
> 
>> -	}
>> +	} else if (key.p.install_mode == NL80211_KEY_SWITCH_TX &&
>> +		   wiphy_ext_feature_isset(&rdev->wiphy,
>> +					   NL80211_EXT_FEATURE_EXT_KEY_ID)) {
>> +		u8 *mac_addr = NULL;
>>   
>> +		if (info->attrs[NL80211_ATTR_MAC])
>> +			mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
>> +
>> +		if (!mac_addr || key.idx < 0 || key.idx > 1) {
>> +			err = -EINVAL;
>> +			goto out;
>> +		}
> 
> Really only 0 and 1 are allowed? Not 0-3?

Yes. Extended Key ID only allows to use Key ID 1 on top of the 
established ID 0. See "IEEE 802.11 - 2016 9.4.2.25.4 RSN capabilities":

Bit 13: Extended Key ID for Individually Addressed Frames. This subfield 
is set to 1 to indicate that the STA supports Key ID values in the range 
0 to 1 for a PTKSA and STKSA when the cipher suite is CCMP or GCMP. A 
value of 0 indicates that the STA only supports Key ID 0 for a PTKSA and
STKSA.

Or also "12.7.6.4 4-way handshake message 2":

If the Extended Key ID for Individually Addressed Frames subfield of the 
RSN Capabilities field is 1 for both the Authenticator and the 
Supplicant, then the Authenticator assigns a new Key ID for the PTKSA in
the range 0 to 1 that is different from the Key ID assigned in the 
previous handshake and uses the MLME-SETKEYS.request primitive to 
install the new key to receive individually addressed MPDUs protected by
the PTK with the assigned Key ID.

> 
>> +++ b/net/wireless/util.c
>> @@ -236,14 +236,22 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
>>   	case WLAN_CIPHER_SUITE_CCMP_256:
>>   	case WLAN_CIPHER_SUITE_GCMP:
>>   	case WLAN_CIPHER_SUITE_GCMP_256:
>> -		/* Disallow pairwise keys with non-zero index unless it's WEP
>> -		 * or a vendor specific cipher (because current deployments use
>> -		 * pairwise WEP keys with non-zero indices and for vendor
>> -		 * specific ciphers this should be validated in the driver or
>> -		 * hardware level - but 802.11i clearly specifies to use zero)
>> +		/* IEEE802.11-2016 allows only 0 and - when using Extended Key
>> +		 * ID - 1 as index for pairwise keys.
>> +		 * @NL80211_KEY_RX_ONLY is only allowed for pairwise keys when
>> +		 * the driver supports Extended Key ID.
>> +		 * @NL80211_KEY_SWITCH_TX must not be set when validating a key.
>>   		 */
>> -		if (pairwise && key_idx)
>> +		if (params->install_mode == NL80211_KEY_RX_ONLY) {
>> +			if (!wiphy_ext_feature_isset(&rdev->wiphy,
>> +						     NL80211_EXT_FEATURE_EXT_KEY_ID))
>> +				return -EINVAL;
>> +			else if (!pairwise || key_idx < 0 || key_idx > 1)
>> +				return -EINVAL;
> 
> same question here

same answer with one remark: The original code did only allow id 0 and 
and I made sure only with install mode NL80211_KEY_RX_ONLY is allowed to 
use non-zero IDs.

Alexander
