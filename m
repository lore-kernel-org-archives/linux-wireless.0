Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47446 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0H3PQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 11:16:54 -0400
Received: by gwj17 with SMTP id 17so2008281gwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 08:16:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100830141705.GC30864@tuxdriver.com>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
 <1282979590-31113-3-git-send-email-lrodriguez@atheros.com> <20100830141705.GC30864@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 30 Aug 2010 08:16:32 -0700
Message-ID: <AANLkTimkvKZkx4=EP1v0ZN0ExDD_v1sMfi0OWj=XZxGf@mail.gmail.com>
Subject: Re: [RFC 2/3] mac80211: allow drivers to specify sw scan wait constraints
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, amod.bodas@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 30, 2010 at 7:17 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Sat, Aug 28, 2010 at 03:13:09AM -0400, Luis R. Rodriguez wrote:
>
>> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
>> index 14123dc..5025950 100644
>> --- a/net/mac80211/driver-ops.h
>> +++ b/net/mac80211/driver-ops.h
>> @@ -187,6 +187,22 @@ static inline void drv_sw_scan_start(struct ieee80211_local *local)
>>       trace_drv_return_void(local);
>>  }
>>
>> +static inline int drv_sw_scan_wait_constraints(struct ieee80211_local *local)
>> +{
>> +     bool wait_constraints = false;
>> +
>> +     might_sleep();
>> +
>> +     trace_drv_sw_scan_wait_constraints(local);
>> +     if (local->ops->sw_scan_start)
>
> Are we checking the right member here?

Nope, thanks, will fix.

  Luis
