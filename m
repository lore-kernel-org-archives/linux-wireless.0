Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:47151 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab2ERH02 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 03:26:28 -0400
Message-ID: <4FB5F99D.1040707@tieto.com> (sfid-20120518_092636_173567_CCF16370)
Date: Fri, 18 May 2012 09:26:21 +0200
From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
MIME-Version: 1.0
To: Marek Lindner <lindner_marek@yahoo.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 0/2] bind RTS threshold to vif.
References: <1337248723-10946-1-git-send-email-lukasz.kucharczyk@tieto.com> <201205171940.42671.lindner_marek@yahoo.de>
In-Reply-To: <201205171940.42671.lindner_marek@yahoo.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/17/2012 01:40 PM, Marek Lindner wrote:
> On Thursday, May 17, 2012 17:58:41 Lukasz Kucharczyk wrote:
>> following patches bind rts threshold to vif.
>> I think it might be useful in multi channel operation
>> (one chip handling multiple virtual interfaces on different
>> channels).
>>
>> RTS threshold is still set with NL80211_CMD_SET_WIPHY, and can
>> be now executed for both hw and vif, so it's backward compatible
>> (from userspace).
>
> As much as I like the idea of having per vif rts/cts settings, the rts/cts
> user space API is useless as long as these settings are bluntly ignored by
> certain rate control algorithms. I already had to explain to a dozen people
> who turned rts/cts off via this API does not really turn it off.
> Therefore, I suggest to remove the rts/cts API altogether, so that nobody
> falls into the trap of believing this does anything useful.

Oops, I totally missed IEEE80211_TX_RC_USE_RTS_CTS. Thanks for comment!

BR,
Lukasz
