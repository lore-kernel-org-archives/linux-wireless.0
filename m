Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.210.202]:35075 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbZGVBtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 21:49:55 -0400
Received: by yxe40 with SMTP id 40so991879yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2009 18:49:54 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 21 Jul 2009 18:49:34 -0700
Message-ID: <43e72e890907211849h373a07dcxc6361c1aeb2f20ff@mail.gmail.com>
Subject: WoW patches - if anyone is up for following up with them
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I won't have time to finish testing this series and getting it merged
as I need to focus on another driver, I ran into some last issues
where I was seeing the nullfunc frames only be issued if I send a WOL
packet first, not sure what's up with that. Some other issues are the

ath9k: timeout (100000 us) on reg 0x806c: 0xdeadbeef & 0x01f00000 != 0x00000000
ath9k: RX failed to go idle in 10 ms RXSM=0xdeadbeef

after resume (not sure if this was caused by the WoW patches or what)
and the mac80211 WARN on the workqueue running local->suspended is
already true.

I probably won't get to these for a long long while (until I need WoW
for another driver), so in case someone is interesting in this, please
feel free to take them on and work on them.

You'll need two things:

* wireless-testing patches:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/wow-07-21.patch

This has johannes's netns patches since his nl80211 cmd is going in
first and then the WoW patches. I've stuffed some documentation on the
patch file itself to help anyone wishing to push that further,
including examples on how to get the pattern stuff initially done.

* http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/iw-add-wow.patch

You'll need this to enable WoW. Keep in mind based on feedback you
*need* to be associated to an AP to enable WoW.

  Luis
