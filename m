Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11387 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbcFCQKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 12:10:41 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
CC: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 2/2] ath10k: remove 10.1 firmware support
Date: Fri, 3 Jun 2016 16:09:55 +0000
Message-ID: <87shwuuuct.fsf@kamboji.qca.qualcomm.com> (sfid-20160603_181044_786772_9E539C0B)
References: <20160603153328.11947-1-rmanohar@qti.qualcomm.com>
	<20160603153328.11947-2-rmanohar@qti.qualcomm.com>
	<5751A6D5.7080901@candelatech.com>
	<743182bcbd1efbdb576bcc51b0215300@codeaurora.org>
In-Reply-To: <743182bcbd1efbdb576bcc51b0215300@codeaurora.org> (Rajkumar
	Manoharan's message of "Fri, 03 Jun 2016 21:25:00 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2016-06-03 21:18, Ben Greear wrote:
>> On 06/03/2016 08:33 AM, Rajkumar Manoharan wrote:
>>> Earlier qca9888 device was brought up using 10.1 firmware and then
>>> later all firmware fixes and new features are migrated to 10.2/10.2.x
>>> firmware branch. As all of 10.1 funtionalities are supported in 10.2
>>> based firmware, removing 10.1 firmware support for qca9888 device.
>>
>> Oh please do not do this.  My 10.1 firmware works very nicely,
>> and out-performs 10.2 in my testing.  Lots of people use my firmware
>> when they need IBSS support or other features not found in
>> official firmware, so it is not just me that will have
>> problems if you remove this support.
>>
> Aah.. I thought CT firmware is 10.2 based. Since most of firmware bug
> fixes and enhancements are integrated into 10.2 based firmware, we
> thought of get rid of 10.1 firmware to reduce code size. Moreover
> existing 10.1 official firmware has known issues.

Yeah, we really want to reduce the amount firmware branches to support
in ath10k.

> Is it possible to upgrade CT firmware to 10.2 WMI/HTT interfaces?

That's a good idea. That shouldn't be too hard, right? I don't think HTT needs
any changes, but for WMI few commands and ids need to be changed.

-- 
Kalle Valo