Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f180.google.com ([209.85.210.180]:64410 "EHLO
	mail-yx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0BQQmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 11:42:50 -0500
Received: by yxe10 with SMTP id 10so105733yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 08:42:46 -0800 (PST)
Message-ID: <4B7C1B56.7090804@lwfinger.net>
Date: Wed, 17 Feb 2010 10:37:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Frederic Leroy <fredo@starox.org>
CC: Hin-Tak Leung <hintak.leung@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Chris Mayo <aklhfex@googlemail.com>,
	linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: staging: No option to select rtl8192su in linux-2.6.33-rc2
References: <4B38A298.7070103@googlemail.com>	<1262037590.16627.99.camel@localhost.localdomain>	<3ace41890912310638x4387f73bvc7ba5e00d096ead7@mail.gmail.com>	<20100213234456.5ae49b67@houba>	<20100214004010.GB18815@tuxdriver.com>	<20100214131810.1a8b49ac@houba>	<3ace41891002161644g7d09c598td86381680c3f04f8@mail.gmail.com> <20100217091743.3c763cf1@houba>
In-Reply-To: <20100217091743.3c763cf1@houba>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2010 02:17 AM, Frederic Leroy wrote:
> Le Wed, 17 Feb 2010 00:44:56 +0000,
> Hin-Tak Leung <hintak.leung@gmail.com> a écrit :
> 
>> On Sun, Feb 14, 2010 at 12:18 PM, Frederic Leroy <fredo@starox.org>
>> wrote:
>>> On which tree should I base my work :
>>> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git ?
>>
>> It is probably useful to pull from
>> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>> as well - I think wireless-testing's log may be more granular
>  
> I saw it. But I have a problem with this tree. The rtl8192su driver
> don't compile : 
> 
>   CC [M]  drivers/staging/rtl8192su/r8180_93cx6.o
> In file included from drivers/staging/rtl8192su/r8192U.h:43,
>                  from drivers/staging/rtl8192su/r8180_93cx6.h:16,
>                  from drivers/staging/rtl8192su/r8180_93cx6.c:21:
> drivers/staging/rtl8192su/ieee80211/ieee80211.h:612: erreur: redefinition of ‘struct ieee80211_hdr_3addr’
> make[3]: *** [drivers/staging/rtl8192su/r8180_93cx6.o] Erreur 1
> 
> For the moment, I am working on linux-2.6-stable tree for
> removing dead code in staging and check that it breaks nothing.

There was a similar problem with the RTL8187SE driver when the
ieee80211_hdr_3addr struct was added to ieee80211.h. My patch for that problem
is commit b6b1ac69372da99 in wireless-testing. BTW, the mainline kernel will
have this problem when the 2.6.34 merge happens. I recommend fixing it ASAP.

Larry
