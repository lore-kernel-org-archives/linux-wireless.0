Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4828 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab2KZLgd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 06:36:33 -0500
Message-ID: <50B35438.9090704@broadcom.com> (sfid-20121126_123636_676115_CDBCADBC)
Date: Mon, 26 Nov 2012 12:36:24 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: change function signature of
 cfg80211_get_p2p_attr()
References: <1353867208-11429-1-git-send-email-arend@broadcom.com>
 <1353925623.9488.8.camel@jlt4.sipsolutions.net> (
 sfid-20121126_112638_885319_E67ABCE9)
 <1353925760.9488.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353925760.9488.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2012 11:29 AM, Johannes Berg wrote:
> On Mon, 2012-11-26 at 11:27 +0100, Johannes Berg wrote:
>> On Sun, 2012-11-25 at 19:13 +0100, Arend van Spriel wrote:
>>> The function cfg80211_get_p2p_attr() can fail and returns
>>> a negative error code. However, the return type is unsigned
>>> int. The largest positive number is determined by desired_len
>>> variable in the function, which is u16. So changing the return
>>> type to int to allow easy error checking. Also change the type
>>> for the attribute to enum for improved type checking.
>>>
>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>> ---
>>> Hi Johannes,
>>>
>>> I decided to make use of cfg80211_get_p2p_attr() in brcmfmac
>>> and would like this minor change to it.
>>>
>>> The only other "driver" using it is mac80211 and it seems it
>>> will not mind this change ;-)
>>
>> Yeah, well, it actually uses an int as this should, thanks for fixing!
>>
>> Applied, but I've fixed your indentation:
>>
>>> +int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
>>> +				   enum ieee80211_p2p_attr_id attr_id,
>>> +				   u8 *buf, unsigned int bufsize)
>>>  {
>>> +	u8 attr = (u8)attr_id;
>>
>> Also this isn't actually needed, you can compare a u8 to attr later :)
> 
> And if we change it back, this patch also doesn't break
> kernel-doc ... :P

Overlooked that one. I should add a 'generate kernel-doc' step to my
patch checklist. Thanks for taking care of it.

Gr. AvS


