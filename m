Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44706 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaLLWzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 17:55:09 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so3947015wid.3
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2014 14:55:08 -0800 (PST)
Message-ID: <548B7249.1060602@konagma.com> (sfid-20141212_235513_722059_FBCE5F3C)
Date: Fri, 12 Dec 2014 23:55:05 +0100
From: Krzysztof Konopko <kris@konagma.com>
MIME-Version: 1.0
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
References: <1418336609-10191-1-git-send-email-kris@konagma.com>	<548A2E7A.4010303@lwfinger.net> <548AD2F1.3080200@konagma.com>	<548B2752.7030607@lwfinger.net> <wrfjwq5wwvik.fsf@redhat.com>
In-Reply-To: <wrfjwq5wwvik.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/14 19:52, Jes Sorensen wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>> On 12/12/2014 05:35 AM, Krzysztof Konopko wrote:
>>> I was hunting particularly for inconsistencies with `sparse` and came
>>> across this one.  But I dug a bit further and I wonder why the driver is
>>> not using standard stuff like the one in `include/linux/ieee80211.h`
>>> where any data wider than one byte is clearly declared as __le<nn>?
>>
>> That is a good question. One possibility is that those definitions do
>> not exist on some of the older kernels that Realtek supports. They
>> generally work with 2.6.18 and newer.
> 
> The reason the 8723au driver doesn't use the defines from there is that
> in ieee80211.h they are part of struct ieee80211_mgmt, while the 8723au
> driver access the addba etc. elements without the full struct in place.
> 

And why is that the case?
(I'm trying to understand, not debunk)

Looks to me that this driver has been kept out of the tree for quite a
while (by Realtek) and now suffers from locally invented stuff.  I
understand this is a lot of work to unify the codebase with ieee80211.h,
but are there any technical hurdles?  I'm just curious.

Thanks,
Kris

