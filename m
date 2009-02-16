Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:61585 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbZBPITe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 03:19:34 -0500
Received: by yx-out-2324.google.com with SMTP id 8so920427yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 00:19:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234695713.4219.51.camel@johannes.local>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-8-git-send-email-lrodriguez@atheros.com>
	 <1234695713.4219.51.camel@johannes.local>
Date: Mon, 16 Feb 2009 00:19:32 -0800
Message-ID: <43e72e890902160019x9acdf3bk41631800f4c9fcba@mail.gmail.com> (sfid-20090216_091936_690689_910628DD)
Subject: Re: [PATCH 07/10] cfg80211: add assert_cfg80211_lock() to ensure
	proper protection
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 15, 2009 at 3:01 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2009-02-13 at 21:33 -0800, Luis R. Rodriguez wrote:
>
>> @@ -1122,6 +1128,9 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
>>       bool intersect = false;
>>       int r = 0;
>>
>> +     if (set_by != REGDOM_SET_BY_CORE)
>> +             assert_cfg80211_lock();
>> +
>>       r = ignore_request(wiphy, set_by, alpha2);
>>
>>       if (r == REG_INTERSECT) {
>
> still conditional locking?

WTF, that was a typo the idea with this new series was to remove that.
Sorry I'll resend with that removed.

  Luis
