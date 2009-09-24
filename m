Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:56589 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZIXTOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 15:14:53 -0400
Received: by bwz6 with SMTP id 6so1558324bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 12:14:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909241132r2c684de2i9e80537bc3d13c63@mail.gmail.com>
References: <20090924180048.14503.9579.stgit@tikku>
	 <20090924180242.14503.11148.stgit@tikku>
	 <43e72e890909241132r2c684de2i9e80537bc3d13c63@mail.gmail.com>
Date: Thu, 24 Sep 2009 12:14:55 -0700
Message-ID: <da94abde0909241214y8179cfeoa86aa59346daa9ef@mail.gmail.com>
Subject: Re: [PATCH 1/2] cfg80211: add firmware and hardware version to wiphy
From: Kalle Valo <kalle.valo@iki.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 11:32 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Sep 24, 2009 at 11:02 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> From: Kalle Valo <kalle.valo@nokia.com>
>>
>> It's useful to provide firmware and hardware version to user space and have a
>> generic interface to retrieve them. Users can provide the version information
>> in bug reports etc.
>>
>> Add fields for firmware and hardware version to struct wiphy and return
>> them to user space in NL80211_CMD_GET_WIPHY reply.
>
> Wow that was quick :)

Yeah, it's easy to hack here at Plumbers :D

>>        NL80211_ATTR_PID,
>>
>> +       NL80211_ATTR_FW_VERSION,
>> +       NL80211_ATTR_HW_VERSION,
>> +
>
> Some kdoc on this would be nice.

Definitely. I'll add it in v2 if the implementation is ok otherwise.

>>        /* add attributes here, update the policy in nl80211.c */
>>
>>        __NL80211_ATTR_AFTER_LAST,
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index 3d874c6..de3da19 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -1070,6 +1070,8 @@ struct cfg80211_ops {
>>  * and registration/helper functions
>>  */
>>
>> +#define CFG80211_VERSION_LEN 32
>
> Probably best to just remove this or at least make this not just
> CFG80211_VERSION_LEN, seems like this is related to cfg80211's version
> somehow.

The length is used four time so I would not want to remove it. Maybe
rename to CFG80211_FWHW_VERSION_LEN?

Kalle
