Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47046 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab1IARLJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 13:11:09 -0400
Message-ID: <4E5FBCA5.7020201@openwrt.org> (sfid-20110901_191130_860217_4B36BB76)
Date: Thu, 01 Sep 2011 19:11:01 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rmanohar@qca.qualcomm.com, shafi.wireless@gmail.com,
	vthiagar@qca.qualcomm.com
Subject: Re: [PATCH v11 3/4] ath9k: merge reset related functions
References: <1314833554-40721-1-git-send-email-nbd@openwrt.org> <1314833554-40721-2-git-send-email-nbd@openwrt.org> <1314833554-40721-3-git-send-email-nbd@openwrt.org> <CAB=NE6WXTs_wnoW0cdSNp=BrL=QnR=D2KNOcT6n4MOYOtE8sJQ@mail.gmail.com>
In-Reply-To: <CAB=NE6WXTs_wnoW0cdSNp=BrL=QnR=D2KNOcT6n4MOYOtE8sJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-01 7:01 PM, Luis R. Rodriguez wrote:
> On Wed, Aug 31, 2011 at 4:32 PM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>  reduces unnecessary code duplication. Also takes the sc_pcu_lock within
>>  ath_reset instead of callsites, which makes it possible to always cancel
>>  all queued work items before the reset, possibly fixing a few race
>>  conditions (work items vs reset) along with it.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>
> This was a bit hard to review, if helpers are being added can they be
> added without changing code around, and in some other patch make the
> changes you describe?
I don't think it can be easily split up, because the change to use the 
helper functions depends other things like the change to queue the reset 
work instead of calling ath_reset directly.

- Felix
