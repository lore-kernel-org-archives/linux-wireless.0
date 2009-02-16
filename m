Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:14569 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZBPJz0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 04:55:26 -0500
Received: by yx-out-2324.google.com with SMTP id 8so925091yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 01:55:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234695858.4219.54.camel@johannes.local>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-9-git-send-email-lrodriguez@atheros.com>
	 <1234695858.4219.54.camel@johannes.local>
Date: Mon, 16 Feb 2009 01:55:25 -0800
Message-ID: <43e72e890902160155j402e887an9c5ea3ca9b9f64f3@mail.gmail.com> (sfid-20090216_105532_236120_76C8B514)
Subject: Re: [PATCH 08/10] cfg80211: make regulatory_request use wiphy_idx
	instead of wiphy
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 15, 2009 at 3:04 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2009-02-13 at 21:33 -0800, Luis R. Rodriguez wrote:
>
>> +static inline
>> +int wiphy_idx(struct wiphy *wiphy)
>> +{
>> +     struct cfg80211_registered_device *drv;
>> +     if (!wiphy)
>> +             return WIPHY_IDX_STALE;
>> +     drv = wiphy_to_dev(wiphy);
>> +     return drv->wiphy_idx;
>> +}
>
> I neither like the name of this function (same as the variable name) nor
> the function -- you're using it in exactly one place where you cannot
> ever pass NULL afaict.

Nope, I'm calling it from 2 places:

* Driver hints which never have the wiphy NULL
* __regulatory_hint: called from 11d hints, and from the workqueue
that processes the pending requests (which can come from userspace or
from drivers right now).

Do you want me to move it into reg.c?

  Luis
