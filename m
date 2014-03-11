Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:57018 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753484AbaCKPPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 11:15:17 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v2 0/3] mac80211: move specific tx flags into info->control.flags
Date: Tue, 11 Mar 2014 16:14:59 +0100
Message-Id: <1394550902-1228-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20140311_161523_165581_D3DC6B5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All usable  bits in enum mac80211_tx_control_flags are depleted. In
order to allow aditional control flag assigments this patchserie moves
all flags that got only used in the tx-path from info->flags into
info->control.flags. There are now 3 bits freed in enum mac80211_tx_control
that are usable for e.g. upcoming transmit power control (tpc).

Greetings Thomas

-v1: fix compile errors when all drivers are properly selected

-v2: remove 3 out of the 6 initial patches as those flags could not
     be moved (thx to Johannes Berg)

