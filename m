Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:35204 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZBMHON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 02:14:13 -0500
Received: by yw-out-2324.google.com with SMTP id 5so581791ywh.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 23:14:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890902122309q61036a23k2efeb14fe3a6e814@mail.gmail.com>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-7-git-send-email-lrodriguez@atheros.com>
	 <1234508187.1327.19.camel@johannes.local>
	 <43e72e890902122309q61036a23k2efeb14fe3a6e814@mail.gmail.com>
Date: Thu, 12 Feb 2009 23:14:12 -0800
Message-ID: <43e72e890902122314m2966471dm3a9485a91e8e927@mail.gmail.com> (sfid-20090213_081416_593303_89D1EB18)
Subject: Re: [PATCH 6/6] cfg80211: move regulatory hints to workqueue
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 11:09 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Feb 12, 2009 at 10:56 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Thu, 2009-02-12 at 21:36 -0800, Luis R. Rodriguez wrote:
>>> Driver and userspace regulatory hints are now processed in
>>> a workqueue. This should fix some lockdep warnings which complain
>>> about possible circular locking dependencies such as:
>>
>> Yes, but I need to look at the one Reinette posted and fix that one,
>> which will probably require a different solution.
>
> Oh I didn't see that one. How different?

I see an rtnl lock issue against scanning and the drv mutex. Doesn't
seem to be related to regulatory. So how would that affect a path to
move hints to a workqueue?

  Luis
