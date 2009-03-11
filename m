Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40723 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbZCKCwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 22:52:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 0/4] ath9k: SMP fixes
Date: Tue, 10 Mar 2009 22:52:29 -0400
Message-Id: <1236739953-17701-1-git-send-email-lrodriguez@atheros.com> (sfid-20090311_035322_578840_4A376262)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, Sujith pointed out it would be best to have the ioread/iowrite
serialized routines as inline, here is the new batch based on that.
I had tried a macro but that is just too ugly..

I figured its best to revert instead of patching on top. Sorry for any
trouble.

It requires revert of the last serialization series:

3149fde1bf083d32d5190cdc7f2bf8d0035966b1
ath9k: remove dummy PCI "retry timeout" fix

b214ce676b438434a32d8e3dbddb28639ffb56a1
ath9k: add cpu notifier to enhance device configuration

c006bbb7932b3f6594fcbf56fec0552fe51d4386
ath9k: AR9280 PCI devices must serialize IO as well

cd70622da755f37534e72d289fca6b98347aff65
ath9k: implement IO serialization

Luis R. Rodriguez (4):
  ath9k: implement IO serialization
  ath9k: AR9280 PCI devices must serialize IO as well
  ath9k: add cpu notifier to enhance device configuration
  ath9k: remove dummy PCI "retry timeout" fix

 drivers/net/wireless/ath9k/ath9k.h |   41 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/hw.c    |   41 +++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath9k/hw.h    |    9 ++++++-
 drivers/net/wireless/ath9k/main.c  |   30 ++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/pci.c   |   22 +++---------------
 5 files changed, 122 insertions(+), 21 deletions(-)

