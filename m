Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:55148 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775AbXEJQjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 12:39:18 -0400
Message-ID: <46434AB4.1070807@lwfinger.net>
Date: Thu, 10 May 2007 11:39:16 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] mac80211: Add support for SIOCGIWRATE ioctl to provide  rate information
References: <463a8a92.jFmmjY4cDnfJeisJ%Larry.Finger@lwfinger.net> <200705100016.45876.flamingice@sourmilk.net> <46433293.9010002@lwfinger.net> <200705101156.12588.flamingice@sourmilk.net>
In-Reply-To: <200705101156.12588.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Thursday 10 May 2007 10:56, Larry Finger wrote:
>> Why has the review of this patch been so strung out? Everything you comment
>> on here was in versions 1 & 2, but not mentioned in any review of those
>> versions.
>>
> Sorry, I've been busy. I'm pretty sure these issues are the last ones.
> 
>> As to the usefulness of this function, I am testing in infrastructure, not
>> ad-hoc, mode, and the output matches the average rate in the log files if
>> debugging is enabled. If the address in u.sta.bssid is not correct, which
>> address should I be using? I still maintain that the user is entitled to
>> know the transmission rate from user space even if debugging is turned off,
>> and that this function is needed.
>>
> I didn't say infrastructure wasn't gonna work. That's the one that should 
> work. However, adhoc probably won't.

Sorry, I misread your previous comment.

Why is txrate in the sta_info structure an int? I think it should be a small, positive integer. 
Would it not be better as a u8, or a u16 if you think a larger range is needed?

Larry

> 
> -Michael Wu

