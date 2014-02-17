Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55591 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaBQQ4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 11:56:18 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [net-next v2 0/3] 802.21 and MPLS headers and classification
Date: Mon, 17 Feb 2014 17:56:10 +0100
Message-Id: <1392656174-14791-1-git-send-email-sw@simonwunderlich.de> (sfid-20140217_175639_775999_7C2F881C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this series contains a header file proposal for MPLS labels. These
labels do not seem to be properly defined in the kernel so far. We are
developing a wired/wireless 802.21/MPLS switch and need to check the
MPLS labels to use the traffic control info for transmissions over
802.11 networks.

Thanks to Joe Perches for comments - changes have been made according
to his suggestions, check the individual patches for details.

Thanks,
     Simon

Simon Wunderlich (3):
  if_ether.h: add IEEE 802.21 Ethertype
  UAPI: add MPLS label stack definition
  cfg80211: add MPLS and 802.21 classification

 include/linux/mpls.h          |    6 ++++++
 include/uapi/linux/if_ether.h |    1 +
 include/uapi/linux/mpls.h     |   34 ++++++++++++++++++++++++++++++++++
 net/wireless/util.c           |   24 ++++++++++++++++++++++++
 4 files changed, 65 insertions(+)
 create mode 100644 include/linux/mpls.h
 create mode 100644 include/uapi/linux/mpls.h

-- 
1.7.10.4

