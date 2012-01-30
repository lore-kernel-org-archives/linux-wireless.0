Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:62379 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab2A3Iyc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 03:54:32 -0500
Message-ID: <4F265AB6.6010004@lri.fr> (sfid-20120130_095435_357718_532C255B)
Date: Mon, 30 Jan 2012 09:54:14 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Do not scan for IBSS merge with a fixed BSSID.
References: <1327581394-15368-1-git-send-email-cavallar@lri.fr> (sfid-20120126_133659_805161_39F32A75) <4F237C16.5050100@sipsolutions.net>
In-Reply-To: <4F237C16.5050100@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28/01/2012 05:39, Johannes Berg wrote:
> On 1/26/2012 4:36 AM, Nicolas Cavallari wrote:
> 
>> -    if (ifibss->fixed_channel)
>> +    if (ifibss->fixed_bssid)
>>           return;
>>
>>       printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for
>> other "
>>              "IBSS networks with same SSID (merge)\n", sdata->name);
> 
> Just from the looks of it, this doesn't seem right. If you're fixing the
> BSSID, you're still asking for automatic channel selection and merging
> with other peers using the same BSSID on different channels, so I
> disagree with your commit message quite completely.

I didn't know that. In fact, from my understanding of the current
source, if you fix the BSSID, you won't merge, period. And even if you
don't fix the BSSID, if you found a BSS with the same BSSID but a
different channel, you still won't merge.

And now, if you are alone and you fixed your channel, you won't try to
merge with other BSS in the same channel.

If you believe that the condition should be "fixed_bssid &&
fixed_channel", i can send another patch.
