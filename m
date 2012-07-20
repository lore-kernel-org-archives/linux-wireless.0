Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33986 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2GTGSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2012 02:18:22 -0400
Message-ID: <5008F829.8020902@qca.qualcomm.com> (sfid-20120720_081827_579520_245C05A1)
Date: Fri, 20 Jul 2012 09:18:17 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix incorrect use of IEEE80211_NUM_BANDS
References: <20120712091311.9751.60082.stgit@localhost6.localdomain6> <20120712134855.53d23fef@mj> <5007EABC.5050905@qca.qualcomm.com> <20120719171114.4d904006@mj>
In-Reply-To: <20120719171114.4d904006@mj>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/20/2012 12:11 AM, Pavel Roskin wrote:
> On Thu, 19 Jul 2012 14:08:44 +0300
> Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> On 07/12/2012 08:48 PM, Pavel Roskin wrote:
>>> On Thu, 12 Jul 2012 12:13:12 +0300
>>> Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>>
>>>> +	/* only check 2.4 and 5 GHz bands, skip the rest */
>>>> +	for (band = 0; band <= IEEE80211_BAND_5GHZ; band++) {
>>>
>>> There is something inelegant here.  The code is mixing an integer
>>> and an enum.  I'd rather go with one or those:
>>>
>>> two enums:
>>> for (band = IEEE80211_BAND_2GHZ; band <= IEEE80211_BAND_5GHZ;
>>> band++) {
>>
>> I somewhat see your point. But IMHO zero is commonly used when
>> iterating over an enum to denote the first value and I don't see how
>> IEEE80211_BAND_2GHZ helps here.
> 
> It's the lowest band we support.  What if the 900MHz band is added one
> day?

Then that should be added to the end of the enum, not beginning. I think
it would be bad if we change enum values on the fly.

Kalle
