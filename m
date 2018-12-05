Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9EE9C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 22:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A4D2208E7
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 22:12:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="pA1BMCY7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A4D2208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbeLEWMv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 17:12:51 -0500
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:48862 "EHLO
        17.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbeLEWMu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 17:12:50 -0500
X-Greylist: delayed 2399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2018 17:12:47 EST
Received: from player750.ha.ovh.net (unknown [10.109.143.225])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id 9248A1EBC7E
        for <linux-wireless@vger.kernel.org>; Wed,  5 Dec 2018 21:54:47 +0100 (CET)
Received: from awhome.eu (p57B7EDEA.dip0.t-ipconnect.de [87.183.237.234])
        (Authenticated sender: postmaster@awhome.eu)
        by player750.ha.ovh.net (Postfix) with ESMTPSA id 5198AA77B6A;
        Wed,  5 Dec 2018 20:54:46 +0000 (UTC)
Subject: Re: [RFC PATCH v2 1/2] nl80211/cfg80211: Add support for Extended Key
 ID
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1544043285;
        bh=QoRcVulR/aH2sLSawMkiRJ4gcHi6qqxmFkeHRVX6Msg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=pA1BMCY7FHNb19pMku+/HTDdhKJU4Pz/HYxzIyA/YmXAdimsyfHUdT0fya2vzgei9
         MELbv29spcK/Xk6MWWEhOZOmZurU3oSvAgIJTLtCX6KWb6wUFPC5ZwBFZrxb4sFvv1
         392ckHzW12RcA7YYjt2dJKiHtlXuUA5tol0/gYwQ=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20181111110235.14213-1-alexander@wetzel-home.de>
 <20181111110235.14213-2-alexander@wetzel-home.de>
 <471c7131e4b81a06f8c514652038d69819ae66ea.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <a2d2f2ff-f776-93e8-579a-fbc05f236d76@wetzel-home.de>
Date:   Wed, 5 Dec 2018 21:54:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <471c7131e4b81a06f8c514652038d69819ae66ea.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 4257871973701131463
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudefhedgudeggecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Sun, 2018-11-11 at 12:02 +0100, Alexander Wetzel wrote:
>> Extend cfg80211 and nl80211 to allow pairwise keys to be installed for
>> RX only, allowing to switching over TX independently, as required by
>> IEEE-802.11-2016 to support "Extended Key ID for Individually Addressed
>> Frames"
>>
>> PTK and STK keys are now also allowed to use Key ID 1.
>>
>> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
>> ---
>>   include/net/cfg80211.h       |  2 ++
>>   include/uapi/linux/nl80211.h | 41 ++++++++++++++++++++++++++---
>>   net/wireless/nl80211.c       | 51 ++++++++++++++++++++++++++++++++----
>>   net/wireless/rdev-ops.h      |  3 ++-
>>   net/wireless/trace.h         | 31 ++++++++++++++++++----
>>   net/wireless/util.c          |  9 ++++---
>>   6 files changed, 119 insertions(+), 18 deletions(-)
>>
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index 1fa41b7a1be3..0d59340563e0 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -485,6 +485,7 @@ struct vif_params {
>>    *	with the get_key() callback, must be in little endian,
>>    *	length given by @seq_len.
>>    * @seq_len: length of @seq.
>> + * @flag: One flag from &enum key_params_flag
> 
> That should be nl80211_key_params_flag.
> 
> But if only one flag can be set, then maybe this should instead be
> 
> enum nl80211_key_install_mode install_mode;
> 
> or so?

It started out as a flag and I switched to enum later without updating 
it. I'll chnage that to nl80211_key_install_mode, much much better...

>> +/**
>> + * enum key_params_flag - additional key flag for drivers
>> + *
>> + * Actions other than @NL80211_KEY_DEFAULT_RX_TX are only required from drivers
>> + * supporting Extended Key ID for pairwise keys using keyid 0 or 1.
>> + *
>> + * @NL80211_KEY_DEFAULT_RX_TX: key can be immediately used for Rx and Tx
>> + * @NL80211_KEY_RX_ONLY: key must be installed for Rx only
>> + * @NL80211_KEY_SET_TX: switch Tx for sta to specified keyid
>> + */
>> +enum key_params_flag {
>> +	NL80211_KEY_DEFAULT_RX_TX,
>> +	NL80211_KEY_RX_ONLY,
>> +	NL80211_KEY_SET_TX
>> +};
> 
> Clearly those aren't flags anyway.
> 
> I guess RX_ONLY and SET_TX are mostly needed AP-side?
> 
> 
No, all stations using Extended Key ID will always use RX_ONLY and 
SET_TX for pairwise key installs. The AP will install the Key Rx only 
prior to sending eapol #3, the sta prior to sending eapol #4.

>> + * @NL80211_ATTR_KEY_RXONLY: Flag attribute to request RX key install only for
>> + *      a pairwise key. Only supported for keyid's 0 and 1 when driver is
>> + *      supporting Extended Key ID.
>> + *
>> + * @NL80211_ATTR_KEY_SETTX: Flag attribute to switch TX to a specified keyid.
>> + *      Only supported for keyid's 0 and 1 when driver is supporting Extended
>> + *      Key ID.
> 
> Ok, so you have these as separate netlink flags, but then you really
> shouldn't also have the "install mode" in nl80211.h, that's not related
> to userspace API then.
> 
> We might discuss instead having an NL80211_ATTR_INSTALL_MODE attribute,
> and that takes the values from the enum, and then you do need the enum -
> but if you don't need the enum then don't define it in nl80211.h but
> keep it kernel-internal in cfg80211.h (and name it appropriately).
> 
I may have mixed up mac80211 and nl80211 api and/or the correct include 
files..

The idea was, to have NL80211_ATTR_KEY_RXONLY, NL80211_ATTR_KEY_SETTX 
with the new API duplicates of NL80211_KEY_RXONLY and NL80211_KEY_SETTX 
for communication with the userspace and the enums ones in 
key_params_flag for communication with the drivers.

But unifying that with NL80211_ATTR_INSTALL_MODE attribute sounds like a 
good idea. I'll try to sanitize that.

>> @@ -4312,6 +4343,8 @@ enum nl80211_key_attributes {
>>   	NL80211_KEY_DEFAULT_MGMT,
>>   	NL80211_KEY_TYPE,
>>   	NL80211_KEY_DEFAULT_TYPES,
>> +	NL80211_KEY_RXONLY,
>> +	NL80211_KEY_SETTX,
> 
> Indeed if you have this, you don't need the corresponding top-level NL80211_ATTR_*?
> 
> We went through a few iterations with the API, so a lot of this is
> backward compatibility stuff, you should update the latest version only.
> I believe it's this one.
> 
I did not think of that when writing the code, but came a bit late to 
the same conclusion... I'll drop the old API support.

>> - * @NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER: Driver supports enabling fine
>> - *	timing measurement responder role.
>> - *
>>    * @NL80211_EXT_FEATURE_CAN_REPLACE_PTK0: Driver/device confirm that they are
>>    *      able to rekey an in-use key correctly. Userspace must not rekey PTK keys
>>    *      if this flag is not set. Ignoring this can leak clear text packets and/or
>>    *      freeze the connection.
>> + * @NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER: Driver supports enabling fine
>> + *	timing measurement responder role.
> 
> What's going on here?
>

The PTK0 rekey patch added a new line in front of the description. The 
next author did not notice that and added the description for 
NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER at the wrong place, probably 
assuming it was the end of the list. I've noticed that and fixed the 
documentation order and the misleading empty line.
I'll break that out as a separate cleanup patch if nobody beats me to it:-)

>> @@ -945,6 +960,16 @@ static int nl80211_parse_key_old(struct genl_info *info, struct key_parse *k)
>>   	if (k->defmgmt)
> 
> Yeah, just don't change parse_key_old, whoever wants to use this stuff
> should upgrade to the new API. wpa_s has both IIRC, but of course the
> old-side is ignored on newer kernels (and the new on older) so the older
> stuff never needs new features.
> 
ok.

>>   		k->def_multi = true;
>>   
>> +	k->rx_only = !!info->attrs[NL80211_ATTR_KEY_RXONLY];
>> +	k->set_tx = !!info->attrs[NL80211_ATTR_KEY_SETTX];
> 
> shouldn't this already be install_mode?
> 
Looks like switching to NL80211_ATTR_INSTALL_MODE will throw out that, 
but with the code from this patch that's an interim layer for checks and 
mapping it. So I'm not sure I understand that comment.

>> +	/* only support setting default key and
>> +	 * Extended Key ID action NL80211_KEY_SET_TX */
>> +	if (!key.def && !key.defmgmt && !key.set_tx)
>>   		return -EINVAL;
> 
> You need to check if extended key ID is supported

Yes. I have added checks in cfg80211_validate_key_settings current 
development version already, making sure only valid combinations can be 
called and reach this section.
>> -	}
>> +	} else if (wiphy_ext_feature_isset(&rdev->wiphy,
>> +					   NL80211_EXT_FEATURE_EXT_KEY_ID)) {
>> +		if (info->attrs[NL80211_ATTR_MAC])
>> +			mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
>>   
>> +		if (!mac_addr || key.idx < 0 || key.idx > 1) {
>> +			err = -EOPNOTSUPP;
>> +			goto out;
>> +		}
>> +
>> +		err = rdev_add_key(rdev, dev, key.idx,
>> +				   NL80211_KEYTYPE_PAIRWISE,
>> +				   mac_addr, &key.p);
> 
> I think you should _parse_ all the new stuff, and then reject it, when
> extended key ID support isn't there?
> 
> Though not sure I'm parsing this code correctly right now.
> 
NL80211_CMD_SET_KEY is normally only used to set default keys for wep or 
managment keys. That changes here.

In this API draft NL80211_CMD_NEW_KEY is only used when installing a 
Extended Key ID key RX only. The switch to TX is added to 
NL80211_CMD_SET_KEY. The code has some sanity checks and then tells the 
driver to switch the key to tx.

But that has been changed quite a bit, the procedure in this patch 
turned out to be not so good and even had a locking issue, so it has 
changed a bit. I guess we should shelf that till I get the new variant 
working and then look at it again.


>> +++ b/net/wireless/util.c
>> @@ -236,13 +236,14 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
>>   	case WLAN_CIPHER_SUITE_CCMP_256:
>>   	case WLAN_CIPHER_SUITE_GCMP:
>>   	case WLAN_CIPHER_SUITE_GCMP_256:
>> -		/* Disallow pairwise keys with non-zero index unless it's WEP
>> +		/* IEEE802.11-2016 allows only 0 and 1 for pairwise keys.
>> +		 * Disallow pairwise keys with index above 1 unless it's WEP
>>   		 * or a vendor specific cipher (because current deployments use
>> -		 * pairwise WEP keys with non-zero indices and for vendor
>> +		 * pairwise WEP keys with higher indices and for vendor
>>   		 * specific ciphers this should be validated in the driver or
>> -		 * hardware level - but 802.11i clearly specifies to use zero)
>> +		 * hardware level.
>>   		 */
>> -		if (pairwise && key_idx)
>> +		if (pairwise && key_idx > 1)
>>   			return -EINVAL;
>>   		break;
> 
> Again, only if driver support is advertised, and the comment should
> probably reference the feature bit from the spec.

That is where I added most of the sanity checks in the meantime.
But what feature bit from the spec are you referring to? The RSN 
Capability one?


Alexander


