Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-del1-1.globallogic.com ([202.174.92.25]:50854 "EHLO
	emailsecurity-del1-1.globallogic.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365Ab0ATJYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 04:24:40 -0500
Received: from emailsecurity-del1-1.globallogic.com (127.0.0.1) by emailsecurity-del1-1.globallogic.com (MlfMTA v3.2r9) id har5te0171sd for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2010 14:54:29 +0530 (envelope-from <Andriy.Tkachuk2@globallogic.com>)
Message-ID: <4B56CBC1.2040406@globallogic.com>
Date: Wed, 20 Jan 2010 11:24:17 +0200
From: Andriy Tkachuk <andriy.v.tkachuk@globallogic.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: Account HT Control field also in Data frame hdrlen according
 to 802.11n-2009
References: <4B546A68.5050503@globallogic.com> <43e72e891001190949u717da5f6maae6a2ca81f3101f@mail.gmail.com>
In-Reply-To: <43e72e891001190949u717da5f6maae6a2ca81f3101f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-19 19:49, Luis R. Rodriguez wrote:
> The commit log entry is empty.

Sorry, I thought it will be obvious from the $subj

> Can you describe what this fixes
> verbally and if its a critical fix or not, if it is, its important to
> know whether or not to propagate this to stable,

I would say it is rather feature then a fix. It just makes
ieee80211_hdrlen() to account new HT Control field in 802.11 header of
data frames introduced by IEEE 802.11n-2009 standard. That's it.

>  so please explain its
> impact and what the behavior was before this.
>   

According to 802.11n-2009 standard HT Control field is present in data
frames when both following items are true:

   1. It is QoS data frame.
   2. Order bit is 1 in Frame Control field.

The change might be totally compatible with legacy non-11n aware frames,
because 802.11-2007 standard states that for all QoS frames (i.e.
non-11n frames) Order bit must be set to zero.

> Also please prefix your e-mails with [PATCH].
>   

Sorry, just forgot to do this. Hope, next time it will be better. :)

Thanks a lot for attention!

    Andriy
