Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59491 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab1HZP0m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 11:26:42 -0400
Message-ID: <4E57BB2A.2050906@openwrt.org> (sfid-20110826_172646_254356_3C7FCCBB)
Date: Fri, 26 Aug 2011 17:26:34 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k_hw: Fix slottime with coverage class
References: <1314283522-6143-1-git-send-email-rmanohar@qca.qualcomm.com> <1314283522-6143-2-git-send-email-rmanohar@qca.qualcomm.com> <4E566BE3.3080907@openwrt.org> <20110826133200.GA17491@vmraj-lnx.users.atheros.com> <4E57B4F4.9080007@openwrt.org> <20110826152020.GA20953@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110826152020.GA20953@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-26 5:20 PM, Rajkumar Manoharan wrote:
> On Fri, Aug 26, 2011 at 05:00:04PM +0200, Felix Fietkau wrote:
>>  On 2011-08-26 3:32 PM, Rajkumar Manoharan wrote:
>>  >On Thu, Aug 25, 2011 at 05:36:03PM +0200, Felix Fietkau wrote:
>>  >>  On 2011-08-25 4:45 PM, Rajkumar Manoharan wrote:
>>  >>  >The commit b6ba41bb27eb9810d54e2301355ce56fd0e94a1a updates
>>  >>  >acktimeout wihout updating slottime when coverage class is defined
>>  >>  >as per IEEE 802.11-2007 17.3.8.6.
>>  >>  >
>>  >>  >Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
>>  >>  I intentionally left the coverage class out of the hw slot time
>>  >>  setting, because increasing slot time too much causes severe
>>  >>  throughput issues. I've observed this even with relatively minor
>>  >>  coverage class settings (e.g. for 2 km) on AR9160 and AR9280. I
>>  >>  haven't tested AR9380 though.
>>  >>
>>  >Which band have you tested on AR9280?
>>  Both.
> IIRC, the scope of section 17 is meant for 5GHz alone. isn't it?
Could be, but it doesn't make much sense to make the coverage class 
setting dependent on 5 GHz. 2.4 GHz is actively being used (also with 
ath9k) for long distance links as well.
The way the coverage class setting is implemented in ath9k at the moment 
works just fine and is tested for both 2.4 GHz and 5 GHz.

- Felix
