Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16083 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2FJILl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 04:11:41 -0400
Message-ID: <4FD456A8.5030702@qca.qualcomm.com> (sfid-20120610_101228_449966_3B4D92BD)
Date: Sun, 10 Jun 2012 11:11:20 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [RFC 2/2] mac80211: support rssi threshold scan
References: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com> <1339036996-6199-2-git-send-email-c_tpeder@qca.qualcomm.com> <1339229392.4539.8.camel@jlt3.sipsolutions.net> <20120609220310.GA3185@pista>
In-Reply-To: <20120609220310.GA3185@pista>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2012 01:03 AM, Pedersen, Thomas wrote:
> On Sat, Jun 09, 2012 at 10:09:52AM +0200, Johannes Berg wrote:
>> On Wed, 2012-06-06 at 19:43 -0700, Thomas Pedersen wrote:
>>
>>> +	if (sdata->local->scan_req->rssi &&
>>> +	    rx_status->signal < sdata->local->scan_req->rssi)
>>> +		return RX_DROP_MONITOR;
>>
>> I believe that should be RX_CONTINUE
> 
> Thanks. Since this is considered a performance optimization, it makes
> little sense to even implement it in mac80211?

It doesn't do any harm either and on the positive side the feature will
be tested with all mac80211 drivers. But other than that there's no real
advantage.

Well, there's a theoretical advantage once we implement partial scan
results which would avoid waking up user space unnecessary. But I doubt
it makes any difference in practise.

But I still vote to take this patch, just to make the feature supported
with a wider range of drivers.

Kalle
