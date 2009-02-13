Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:56635 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZBMHIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 02:08:48 -0500
Received: by gxk22 with SMTP id 22so510818gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 23:08:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234508048.1327.17.camel@johannes.local>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
	 <1234508048.1327.17.camel@johannes.local>
Date: Thu, 12 Feb 2009 23:08:46 -0800
Message-ID: <43e72e890902122308o1e7a7ff9s2148fc0b63963537@mail.gmail.com> (sfid-20090213_080851_981134_FA208832)
Subject: Re: [PATCH 4/6] cfg80211: add assert_cfg80211_lock() to ensure proper
	protection
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 10:54 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-02-12 at 21:36 -0800, Luis R. Rodriguez wrote:
>
>> +static inline void assert_cfg80211_lock(void)
>> +{
>> +     BUG_ON(!mutex_is_locked(&cfg80211_mutex));
>> +}
>
> That's a little heavy-handed for a small development mistake, can we
> have a WARN_ON instead?

Sure, will change.

  Luis
