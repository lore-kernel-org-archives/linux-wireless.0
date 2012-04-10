Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16586 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab2DJHus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 03:50:48 -0400
Message-ID: <4F83E64D.4010102@qca.qualcomm.com> (sfid-20120410_095052_045796_5283FAB9)
Date: Tue, 10 Apr 2012 13:20:37 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<ath6kl-devel@qualcomm.com>,
	Subramania Sharma <sharmat@qca.qualcomm.com>
Subject: Re: [PATCH V2] ath6kl: Fix 4-way handshake failure in AP and P2P
 GO mode
References: <\> <1333984880-4328-1-git-send-email-vthiagar@qca.qualcomm.com> <1333987238.2152.5.camel@joe2Laptop>
In-Reply-To: <1333987238.2152.5.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> +static int ath6kl_get_rsn_capab(struct cfg80211_beacon_data *beacon,
>> +				u8 *rsn_capab)
>> +{
>> +	const u8 *rsn_ie;
>> +	size_t rsn_ie_len;
>> +	u16 cnt;
>> +
>> +	if (!beacon->tail)
>> +		return -EINVAL;
>> +
>> +	rsn_ie = cfg80211_find_ie(WLAN_EID_RSN, beacon->tail, beacon->tail_len);
>> +	if (!rsn_ie)
>> +		return -EINVAL;
>> +
>> +	rsn_ie_len = *(rsn_ie + 1);
>> +	/* skip element id and length */
>> +	rsn_ie += 2;
>> +
>> +	/* skip version, group cipher */
>> +	if (rsn_ie_len<  6)
>> +		return -EINVAL;
>> +	rsn_ie +=  6;
>> +	rsn_ie_len -= 6;
>> +
>> +	/* skip pairwise cipher suite */
>> +	if (rsn_ie_len<  2)
>> +		return -EINVAL;
>> +	cnt = *((u16 *) rsn_ie);
>
> Any endian or alignment issues?

Indeed this can pretty much result in unaligned memory access.
I'll fix that. Thanks for pointing this out.
>
>> +	rsn_ie += (2 + cnt * 4);
>> +	rsn_ie_len -= (2 + cnt * 4);
>> +
>> +	/* skip akm suite */
>> +	if (rsn_ie_len<  2)
>> +		return -EINVAL;
>> +	cnt = *((u16 *) rsn_ie);

This too.

Vasanth
