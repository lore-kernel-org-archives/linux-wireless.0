Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50521 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935623Ab1KJQRZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 11:17:25 -0500
Message-ID: <4EBBF90A.2000808@openwrt.org> (sfid-20111110_171729_944704_0EA6E9A1)
Date: Thu, 10 Nov 2011 17:17:14 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>,
	Adrian Chadd <adrian.chadd@gmail.com>
Subject: Re: [PATCH v2 4/4] ath9k_hw: Fix tx power settings for AR9003
References: <1320918297-1799-1-git-send-email-rmanohar@qca.qualcomm.com> <4EBBA1C4.3070007@openwrt.org>
In-Reply-To: <4EBBA1C4.3070007@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-11-10 11:04 AM, Felix Fietkau wrote:
> On 2011-11-10 10:44 AM, Rajkumar Manoharan wrote:
>>  Retriving tx power for 2x2 and 3x3 chainmask is not handled
>>  properly. While calculating tx power for 2x2, 3 dBm was reduced
>>  and for 3x3, 5 dBm was reduced which should be added back when
>>  retriving.
>>
>>  Cc: Paul Stewart<pstew@google.com>
>>  Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> I think the tx power reduction for 2x2/3x3 needs to be revisited. In the
> discussion that led to Walsh spatial spreading being disabled you
> mentioned this:
>
>>  In the FCC rulings, only transmissions that are completely non-coherent, are
>>  allowed to waive the array gain contribution to EIRP for multi-transmit configurations.
>>  The use of 2-stream with 2 transmit and use of 3-steam with 3 transmit qualifies
>>  for this spatial multiplexing MIMO classification as long as the streams are
>>  directly mapped to each radio (not Walsh spread prior to splitting to multiple radios)
> So if I understand this issue correctly, Walsh spatial spreading was
> disabled so that the tx power for 2x2 or 3x3 would not have to be
> reduced by the array gain contribution - yet we're still doing that.
>
> When Adrian pointed out that tx power is reduced based on the number of
> chains, you mentioned this:
>>  Those pwrdecrease fields are applicable for AR9280 chips not for AR9003.
>
> According to this patch, this doesn't seem to match what the code does,
> though I didn't notice it back then.
>
> So before we merge this patch, let's decide whether we actually need
> this tx power reduction or not.
I just spent some time reading up on the FCC's MIMO test procedures and 
it appears that I just got mixed up in the terminology earlier. The 
patch should be merged as-is.

- Felix
