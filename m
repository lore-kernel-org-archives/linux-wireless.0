Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11013 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2I1E6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 00:58:06 -0400
Message-ID: <50652E56.10303@qca.qualcomm.com> (sfid-20120928_065811_097345_6D7745E2)
Date: Fri, 28 Sep 2012 10:27:58 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Antonio Quartulli <ordex@autistici.org>
Subject: Re: [RFC 1/2] ath9k_htc: Advertize allowed vif combinations
References: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com> <20581.2614.43943.601901@gargle.gargle.HOWL>
In-Reply-To: <20581.2614.43943.601901@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Friday 28 September 2012 07:53 AM, Sujith Manoharan wrote:
> Mohammed Shafi Shajakhan wrote:
>> From: Antonio Quartulli <ordex@autistici.org>
>>
>> Advertize allowed VIFs combinations to the cfg80211 sublayer.
>> Other than that, practical tests shown that ath9k_htc devices allow an
>> IBSS VIF to coexist with VIF set up on other modes, so advertize
>> that to. We can also further add p2p/mesh mode to be advertized
>> in the combinations allowed.
>
> I don't think IBSS can co-exist with other op-modes.
>

oh yeah, you are saying that we will have some issues with IBSS
coexistence with other modes because of TSF sync.

Antonio seems to be testing this sometime back and came up with the 
following observation :

"ath9k_htc is running since some hours with AP+IBSS without any 
problems.What I think that the maintainer was referring to is a general 
problem of IBSS+AP: in most devices, TFS is unique among VIFs, therefore 
TSF jumps introduced by IBSS can be reflected in a bad way on the AP VIF".

please let us know if you have further thoughts about this.
I will just look into the code if we have some more limitations.
thanks for your review!

-- 
thanks,
shafi


