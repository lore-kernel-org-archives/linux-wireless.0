Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25971 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab1IFIsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 04:48:12 -0400
Message-ID: <4E65DE46.7030006@qca.qualcomm.com> (sfid-20110906_104816_701077_9CC5A141)
Date: Tue, 6 Sep 2011 11:48:06 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: How to request firmware during module init?
References: <4E65DC7D.70306@qca.qualcomm.com>	 (sfid-20110906_104037_973452_28D96118) <1315298660.3900.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1315298660.3900.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2011 11:44 AM, Johannes Berg wrote:
> On Tue, 2011-09-06 at 11:40 +0300, Kalle Valo wrote:
>> Hi,
>>
>> ath6kl needs to request the firmware from user space during module init
>> (or to be exact from sdio probe, but it's almost the same thing) and
>> boot hardware to get some settings etc before it registers itself to
>> cfg80211. What's the proper way to handle this?
>>
>> I noticed that when I compile ath6kl into kernel boot fails on my x86
>> box as firmware is not available because user space is not ready.
> 
> We do an async request, once it comes back we register with mac80211.

I take it you mean request_firmware_nowait(). I'll use that also.

Thanks!

Kalle
