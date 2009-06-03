Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:55660 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbZFCPsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 11:48:36 -0400
Received: by bwz9 with SMTP id 9so76515bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2009 08:48:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244027298.2650.0.camel@johannes.local>
References: <4A26593B.6050704@tls-tautenburg.de>
	 <1244027298.2650.0.camel@johannes.local>
Date: Wed, 3 Jun 2009 16:17:04 +0100
Message-ID: <3ace41890906030817q5143d028lc933dbbb5efd1507@mail.gmail.com>
Subject: Re: compile error: compat-wireless-2009-06-03
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bringfried Stecklum <stecklum@tls-tautenburg.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 3, 2009 at 12:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-06-03 at 13:06 +0200, Bringfried Stecklum wrote:
>> When trying to compile the latest compat-wireless package on an Ubuntu 8.10
>> 64bit system running linux kernel 2.6.27-12 I get the following error
>>
>> stecklum@extragalactix:~/System/src/compat-wireless-2009-06-03$ make
>> make -C /lib/modules/2.6.27-12-mygeneric/build
>> M=/home/stecklum/System/src/compat-wireless-2009-06-03 modules
>> make[1]: Entering directory `/usr/src/linux-headers-2.6.27-12-mygeneric'
>>    CC [M]
>> /home/stecklum/System/src/compat-wireless-2009-06-03/drivers/net/wireless/ath/ath9k/hw.o
>> In file included from
>> /home/stecklum/System/src/compat-wireless-2009-06-03/drivers/net/wireless/ath/ath9k/hw.c:20:
>> /home/stecklum/System/src/compat-wireless-2009-06-03/drivers/net/wireless/ath/ath9k/ath9k.h:469:
>> error: field ‘ops’ has incomplete type
>
> That's rfkill, not sure what to do about it.
>
> johannes

Yes, i saw the error too - I just git-format-patch'ed the rfkill
commit from wireless-testing and reverted it in compat-wireless.  Then
compat-wireless built and worked ok.

The rfkill commit changed a two files (an include/net/* and an
Kconfig) which doesn't exist in compat-wireless (I just press return
to skip during the revert). I suppose the include will need to go to
the top of whatever files needing it, the Kconfig part will need to go
to config.mk ... but I haven't looked in detail and other change may
be needed.

The commit is this:
>From df1937eaa2b4f60ba9d8aedea1bd2e069ea31aae Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 2 Jun 2009 13:01:41 +0200
Subject: [PATCH] cfg80211: add rfkill support


Hin-Tak
