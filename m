Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47361 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766Ab0DPXaB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 19:30:01 -0400
Received: by pva18 with SMTP id 18so2097492pva.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 16:30:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1271454610.16507.33.camel@mj>
References: <t2wd01f95791004151011n1a5077a3oca9f7b641b311ac2@mail.gmail.com>
	<1271454610.16507.33.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 16 Apr 2010 16:29:40 -0700
Message-ID: <u2o43e72e891004161629zfd1046ccx5e000e7f9bc887e9@mail.gmail.com>
Subject: Re: compat-wireless doesn't compile against 2.6.32 on Ubuntu beta
To: Pavel Roskin <proski@gnu.org>
Cc: Andrey Semyonov <gatekeeper.mail@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 16, 2010 at 2:50 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Thu, 2010-04-15 at 21:11 +0400, Andrey Semyonov wrote:
>> I get this when trying to compile current drivers:
>>
>>
>> /usr/local/src/compat-wireless-2010-04-14# make
>> make -C /lib/modules/2.6.32-19-generic/build
>> M=/usr/local/src/compat-wireless-2010-04-14 modules
>> make[1]: Вход в каталог `/usr/src/linux-headers-2.6.32-19-generic'
>>  CC [M]  /usr/local/src/compat-wireless-2010-04-14/net/mac80211/main.o
>> /usr/local/src/compat-wireless-2010-04-14/net/mac80211/main.c: In
>> function 'ieee80211_alloc_hw':
>> /usr/local/src/compat-wireless-2010-04-14/net/mac80211/main.c:394:
>> error: implicit declaration of function '__hw_addr_init'
>
> I confirm the problem.  Basically, the bleeding edge compat-wireless is
> useless now.

Right, I've noted in other threads what needs backport:

22bedad3ce112d5ca1eaf043d4990fa2ed698c87 net: convert multicast list
to list_head
2f787b0b76bf5de2eaa3ca3a29d89123ae03c856 mac80211: Ensure initializing
private mc_list in prepare_multicast().

These just need to be reverted through an ifdef, just havent' had time
to do it yet.

> Perhaps we need a check to to prevent broken tarballs from
> being uploaded.  It's better than force users to search for the last
> working tarball.

Indeed, I once suggested to do this on johill's box but he had little
space, I now moved the tarball building to orbit and we have plenty of
space there so we could do the automatic compile checks against all
stable kernels we support prior to uploading. Just need to get that
done.

  Luis
