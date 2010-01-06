Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:51127 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756491Ab0AFWwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 17:52:54 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 2.6.33 0/8] rt2x00: Cherry picked fixes for 2.6.33.
Date: Wed,  6 Jan 2010 23:52:41 +0100
Message-Id: <1262818369-16820-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Here is a set of fixes for rt2x00 for 2.6.33. All of these are already present
in wireless-next-2.6, and I've cherry-picked them to get rt2800 in a usable
state in 2.6.33.

The series can also be pulled from:
	git://git.gwingerde.nl/rt2x00-2.6.git

P.S. Once these enter mainline, I'll submit a similar set of patches to stable
to fix 2.6.32 as well. Unfortunately these patches don't apply directly on 
2.6.32.

Alban Browaeys (2):
  rt2x00 : modify padding location.
  rt2x00 : trim the skb after having the l2pad removed.

Benoit Papillault (1):
  rt2x00: Fix rt2800usb RX frame format and as such L2PAD

Gertjan van Wingerde (5):
  rt2x00: Further L2 padding fixes.
  rt2x00: Remove SKBDESC_L2_PADDED flag.
  rt2x00: Reorganize L2 padding inserting function.
  rt2x00: Only remove L2 padding in received frames if there is
    payload.
  rt2x00: Fix trimming of L2 padded frames.

 drivers/net/wireless/rt2x00/rt2800pci.c   |    6 +--
 drivers/net/wireless/rt2x00/rt2800usb.c   |   41 +++++++++-----
 drivers/net/wireless/rt2x00/rt2800usb.h   |   90 ++++++++++++++++++++++------
 drivers/net/wireless/rt2x00/rt2x00.h      |    6 ++
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   10 ++-
 drivers/net/wireless/rt2x00/rt2x00queue.c |   70 ++++++++++------------
 drivers/net/wireless/rt2x00/rt2x00queue.h |    5 +-
 7 files changed, 142 insertions(+), 86 deletions(-)

