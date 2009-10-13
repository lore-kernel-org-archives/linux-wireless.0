Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:39358 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761259AbZJMVF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 17:05:27 -0400
Received: by iwn10 with SMTP id 10so2998092iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 14:04:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255075519.3713.34.camel@johannes.local>
References: <3ace41890910071216y69b8bc9la67b8f0ce5890cd8@mail.gmail.com>
	<3ace41890910071228i786d4097w69dc7a3dfeb64afe@mail.gmail.com>
	<1254952886.3713.4.camel@johannes.local> <3ace41890910072328n1460ee34v1fe7ca9b78eb646f@mail.gmail.com>
	<1254995514.3713.22.camel@johannes.local> <1255002647.3713.25.camel@johannes.local>
	<43e72e890910080643h282c4bf1xf972f15f13eae755@mail.gmail.com>
	<3ace41890910081622k7c86453dm72e5584f4adbb763@mail.gmail.com>
	<43e72e890910081714u7e1d2168u98c0ccb74915c94c@mail.gmail.com>
	<1255075519.3713.34.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 13 Oct 2009 14:04:31 -0700
Message-ID: <43e72e890910131404m7239f06ev4416be2625a14594@mail.gmail.com>
Subject: Re: NULL pointer deref at wext ioctl (Re: [PATCH] compat-2.6: adding
	ethtool.h to compat-2.6.31.h)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 9, 2009 at 1:05 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2009-10-08 at 20:14 -0400, Luis R. Rodriguez wrote:
>
>> > There are some harmless warnings from using the old header, but
>> > otherwise it is working as it should:
>> >  CC [M]  /home/Hin-Tak/tmp-git/compat-wireless-2.6/net/wireless/sme.o
>> > /home/Hin-Tak/tmp-git/compat-wireless-2.6/net/wireless/sme.c: In
>> > function ‘__cfg80211_connect_result’:
>> > /home/Hin-Tak/tmp-git/compat-wireless-2.6/net/wireless/sme.c:370:
>> > warning: passing argument 4 of ‘wireless_send_event’ discards
>> > qualifiers from pointer target type
>> > include/net/iw_handler.h:443: note: expected ‘char *’ but argument is
>> > of type ‘const u8 *’
>
>> The last argument to wireless_send_event() was changed to be const on
>> 2.6.32, cant think of a way to avoid this warning.
>
> Yeah, it was never modified though so the warning is harmless.

OK so casting was enough to avoid these warnings, will use that for
older kernels.

#define wireless_send_event(a, b, c, d) wireless_send_event(a, b, c,
(char * ) d)

  Luis
