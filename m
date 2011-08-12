Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52799 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1HLSMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 14:12:10 -0400
Received: by wwe5 with SMTP id 5so5067492wwe.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 11:12:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313152101.4022.3.camel@jlt3.sipsolutions.net>
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
	<1313117641-27351-1-git-send-email-thomas@cozybit.com>
	<1313152101.4022.3.camel@jlt3.sipsolutions.net>
Date: Fri, 12 Aug 2011 11:12:08 -0700
Message-ID: <CAG6hwVN+D+XXAR9B8ZAb2hf_OFKwE875tm=OAS7iytx32uU9MA@mail.gmail.com> (sfid-20110812_201214_170990_2D164F59)
Subject: Re: [PATCH v2 1/8] mac80211: improve mpath debugging
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 12, 2011 at 5:28 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-08-11 at 19:53 -0700, Thomas Pedersen wrote:
>
>> +#ifdef CONFIG_MAC80211_VERBOSE_MPATH_DEBUG
>> +static inline void mpath_dbg(const char *fmt, ...)
>> +{
>> +     struct va_format vaf;
>> +     va_list args;
>> +
>> +     va_start(args, fmt);
>> +
>> +     vaf.fmt = fmt;
>> +     vaf.va = &args;
>> +
>> +     printk(KERN_DEBUG "%pV", &vaf);
>> +     va_end(args);
>> +     return;
>> +}
>> +#else
>> +static inline void mpath_dbg(const char *fmt, ...)
>> +{
>> +     return;
>> +}
>> +#endif
>
> Oh, maybe that's too complicated after all... How about
>
> #ifdef ...
> #define ...
> #else
> static inline void mpath_dbg(const char *fmt, ...)
>        __attribute__ ((format (printf, 1, 2)))
> {
> }
> #endif
>
> Definitely want the format attribute, that was my whole point :)

Oh I see. Looking at it again, my function above doesn't even have any
argument checking :P. Didn't know about that __attribute__ etiher,
thanks!

> Bah, maybe it all doesn't matter, in which case maybe the first version
> is better.

Sure, let's go with the first one.
>
> johannes
>
>
