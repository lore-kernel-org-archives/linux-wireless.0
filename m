Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZCLWSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 18:18:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v6 0/3] ath9k: SMP fixes
Date: Thu, 12 Mar 2009 18:18:48 -0400
Message-Id: <1236896331-5026-1-git-send-email-lrodriguez@atheros.com> (sfid-20090312_231856_795469_9560EC9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This v6 removes the hotplug CPU stuff which although it technically
would be correct is more cruft and highly unlikely. The down side
is you will get serialization applied even if you only have one
CPU but who cares, I doubt those nutty SGI guys are toying with
ath9k in the lab.

Yesterday I started mucking with an alternative approach to
serialization which worked. I added just 5 udelay()s in key places
where we had a lot of consecutive IO read/writes issued and that
resolved the issue at least for STA mode but it didn't do the trick
for AP mode. Technically it should be possible to groom all hardware
access routines to do the same but I'm tired of this issue and want
to a fix merged today not a few weeks from now. Anyway if you are
curious you can check out that patch replacement approach for
serialization here:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-03-12/smp-udelay-fix.patch

Note that AP won't work though so if you have a lot of time in your
hands and have an SMP box with PCI Atheros 11n and are seeing the hangs
and want a neat alternative to the current serialization implementation
try adding udelays like the ones in the patch in places where we do a lot
of io read/writes. Send me the results :)

The compromise is to keep serialization conditional -- we do not want to
do it for every read/write regardless of the type of card you have, the
code overhead is not great and we maintain this anyway. Adding it for all
cases would just not be optimal.

Luis R. Rodriguez (3):
  ath9k: implement IO serialization
  ath9k: AR9280 PCI devices must serialize IO as well
  ath9k: remove dummy PCI "retry timeout" fix

 drivers/net/wireless/ath9k/ath9k.h |   34 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/hw.c    |   28 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath9k/hw.h    |    4 ++--
 drivers/net/wireless/ath9k/main.c  |    1 +
 drivers/net/wireless/ath9k/pci.c   |   18 ------------------
 5 files changed, 64 insertions(+), 21 deletions(-)

