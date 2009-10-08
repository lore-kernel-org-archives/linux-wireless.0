Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:34946 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbZJHO3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 10:29:31 -0400
Received: by iwn10 with SMTP id 10so629947iwn.4
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2009 07:28:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890910080643h282c4bf1xf972f15f13eae755@mail.gmail.com>
References: <3ace41890910071216y69b8bc9la67b8f0ce5890cd8@mail.gmail.com>
	<3ace41890910071228i786d4097w69dc7a3dfeb64afe@mail.gmail.com>
	<1254952886.3713.4.camel@johannes.local> <3ace41890910072328n1460ee34v1fe7ca9b78eb646f@mail.gmail.com>
	<1254995514.3713.22.camel@johannes.local> <1255002647.3713.25.camel@johannes.local>
	<43e72e890910080643h282c4bf1xf972f15f13eae755@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 8 Oct 2009 10:28:33 -0400
Message-ID: <43e72e890910080728ra63f1e7w6be3a2af65bc4766@mail.gmail.com>
Subject: Re: NULL pointer deref at wext ioctl (Re: [PATCH] compat-2.6: adding
	ethtool.h to compat-2.6.31.h)
To: Johannes Berg <johannes@sipsolutions.net>,
	reinette chatre <reinette.chatre@intel.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 8, 2009 at 9:43 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Oct 8, 2009 at 7:50 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Thu, 2009-10-08 at 11:51 +0200, Johannes Berg wrote:
>>
>>> Ok, that's odd. Is it possible that somehow cfg80211 is picking up an
>>> #ifdef'ed copy of "struct iw_handler_def", and thus the struct it is
>>> defining is simply too small?
>>
>> That is apparently what is happening since compat-wireless ships
>> iw_handler.h. This is wrong, as wext functionality is built into the
>> kernel image so you can't use a newer header file with it.
>
> Dah, thanks for looking into this! This must've been there this way
> for ages and we hadn't noticed until now. This is now fixed, and a new
> tarball pushed out. I'll fix on the stable stuff as well, although I
> doubt the header has changed much except now.

OK so iw_handler added the libipw pointer, so libipw and friends are
now messed up on compat-wireless. Do we care? I'll disable them for
now. Can't think of a way to backport this easily.

  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ipw2x00/ipw2100.o
/home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ipw2x00/ipw2100.c:
In function ‘ipw2100_alloc_device’:
/home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ipw2x00/ipw2100.c:6060:
error: ‘struct iw_public_data’ has no member named ‘libipw’
make[4]: *** [/home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ipw2x00/ipw2100.o]
Error 1


  Luis
