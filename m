Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52645 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2LTVNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 16:13:25 -0500
Received: by mail-pa0-f54.google.com with SMTP id bi5so2370969pad.41
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2012 13:13:24 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v12] wireless: add wil6210
Date: Thu, 20 Dec 2012 13:13:18 -0800
Message-Id: <1356037999-26092-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20121220_221343_346001_C4E8B340)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

John,

I've taken Vladimir's work and adjusted the Kconfig, added
MAINTAINERS and goes reviewed by me. We'd like this in for
the 3.8-rc series and as such the code identified as generic
will be moved to generic places in the development cycle,
for not it goes stuffed under dbg_hexdump.h. I also folded
his second patch into this one that adds the entries to
Kconfig to enable the module. The concerns that Johannes
had expressed of using PCP mode emulated as AP mode are
addressed by removing that support for now. I've also nuked
the Documentation/ pages in favor more for ensuring we keep
up to date the wiki page.

The volatile use cases seem odd but the hardware has issues
using the supplied IO accessors and as such it provdes its
own for now. If and when that can be addressed each use case
will be addressed. Other checkpatch warnings are spurious.

In case the patch does not make it to your inbox you can
wget it here:

http://bombadil.infradead.org/~mcgrof/2012/12/20/0001-wireless-add-new-wil6210-802.11ad-60GHz-driver.patch
sha256sum:
dd4d8927c24a7906f94b80af7438b3fbb220d2f304d1a5ea7d7d200a8c650418

Vladimir Kondratiev (1):
  wireless: add new wil6210 802.11ad 60GHz driver

 MAINTAINERS                                    |    8 +
 drivers/net/wireless/ath/Kconfig               |    1 +
 drivers/net/wireless/ath/Makefile              |    1 +
 drivers/net/wireless/ath/wil6210/Kconfig       |   30 +
 drivers/net/wireless/ath/wil6210/Makefile      |   14 +
 drivers/net/wireless/ath/wil6210/cfg80211.c    |  573 ++++++++++++
 drivers/net/wireless/ath/wil6210/dbg_hexdump.h |   30 +
 drivers/net/wireless/ath/wil6210/debugfs.c     |  603 +++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c   |  471 ++++++++++
 drivers/net/wireless/ath/wil6210/main.c        |  407 +++++++++
 drivers/net/wireless/ath/wil6210/netdev.c      |  157 ++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c    |  223 +++++
 drivers/net/wireless/ath/wil6210/txrx.c        |  871 ++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.h        |  362 ++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h     |  363 ++++++++
 drivers/net/wireless/ath/wil6210/wmi.c         |  975 +++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h         | 1116 ++++++++++++++++++++++++
 17 files changed, 6205 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wil6210/Kconfig
 create mode 100644 drivers/net/wireless/ath/wil6210/Makefile
 create mode 100644 drivers/net/wireless/ath/wil6210/cfg80211.c
 create mode 100644 drivers/net/wireless/ath/wil6210/dbg_hexdump.h
 create mode 100644 drivers/net/wireless/ath/wil6210/debugfs.c
 create mode 100644 drivers/net/wireless/ath/wil6210/interrupt.c
 create mode 100644 drivers/net/wireless/ath/wil6210/main.c
 create mode 100644 drivers/net/wireless/ath/wil6210/netdev.c
 create mode 100644 drivers/net/wireless/ath/wil6210/pcie_bus.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wil6210.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.h

-- 
1.7.10.4

