Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58570 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2HJC1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 22:27:31 -0400
Received: by weyx8 with SMTP id x8so704460wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 19:27:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UNz2oXvCu3NpNVqQLg4pSsL5L-Dw==KGkqxS0CxQfjFg@mail.gmail.com>
References: <1344487215-24143-1-git-send-email-andy@greyhouse.net>
	<2121451356.93690.1344518764022.JavaMail.root@neratec.com>
	<CAB=NE6UNz2oXvCu3NpNVqQLg4pSsL5L-Dw==KGkqxS0CxQfjFg@mail.gmail.com>
Date: Thu, 9 Aug 2012 22:27:29 -0400
Message-ID: <CAHashqDJypSyRkk__zvK3arTdNBzC08Xgfhdp4NO0vyU_FuKEQ@mail.gmail.com> (sfid-20120810_042735_326638_631C88DF)
Subject: Re: [PATCH v2] compat: support RHEL6.3 as a build target
From: Andy Gospodarek <andy@greyhouse.net>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Phil Perry <phil@elrepo.org>,
	lf driver backport
	<lf_driver_backport@lists.linux-foundation.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 9, 2012 at 9:27 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Thu, Aug 9, 2012 at 6:26 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>> @@ -101,7 +101,7 @@ struct pm_qos_request_list {
>>  /* mask no_printk as RHEL6 backports this */
>>  #define no_printk(...) compat_no_printk(...)
>>  static inline __attribute__ ((format (printf, 1, 2)))
>> -int no_printk(const char *s, ...) { return 0; }
>> +int compat_no_printk(const char *s, ...) { return 0; }
>
> I merged this in. Andy can you review your other changes as Zefir points out?

Yes, I will check it out tomorrow.

> mcgrof@frijol ~/compat (git::master)$ gcc --version
> gcc (Debian 4.7.1-2) 4.7.1
> Copyright (C) 2012 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>
> I suppose we should get ckmake to spit out the version of gcc onto the report.
>
>   Luis
