Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17431 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab2HTTI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 15:08:58 -0400
Message-ID: <50328B3F.3070206@qca.qualcomm.com> (sfid-20120820_210902_077136_96B63908)
Date: Mon, 20 Aug 2012 22:08:47 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: protect firmware from excessive WoW pattern length
References: <1345076116-5053-1-git-send-email-c_tpeder@qca.qualcomm.com> <1345446793.4504.0.camel@jlt3.sipsolutions.net> <5031E74F.4010104@qca.qualcomm.com> <20120820181837.GA4695@pista>
In-Reply-To: <20120820181837.GA4695@pista>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/20/2012 09:18 PM, Pedersen, Thomas wrote:
> On Mon, Aug 20, 2012 at 10:29:19AM +0300, Kalle Valo wrote:
>> On 08/20/2012 10:13 AM, Johannes Berg wrote:
>>
>>> No objection, but doesn't nl80211 already validate that (assuming you
>>> give the right pattern_max_len, of course)?
> 
> Thanks for pointing that out. That check would be completely redundant
> then.
> 
> Kalle,
> 
> Can you revert this patch? Otherwise the followup will just do the same.

I can revert the patch. But IMHO the check isn't that bad, and even
cfg80211 can be buggy sometimes ;)

>> And ath6kl even uses different define pattern_max_len:
>>
>> 	wiphy->wowlan.pattern_max_len = WOW_PATTERN_SIZE;
>>
>> But the value is still same:
>>
>> #define WOW_PATTERN_SIZE	 64
>> #define WOW_MASK_SIZE		 64
>>
>> Thomas, can you please check this? Do we really need two different
>> defines? And which one is the correct one here?
> 
> No AFAICT there is no reason to have two different defines. I can submit
> a small patch consolidating these, but it would remove the above hunk
> anyway so I need to know whether you'll revert or not.

Thanks. I'll revert the patch so please prepare your patch without the
check.

Kalle
