Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52317 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab0H3OB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 10:01:59 -0400
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: mac80211 using different tx queue for frames with same TID and RA
Date: Mon, 30 Aug 2010 16:01:12 +0200
Cc: Krishna Kumar <krkumar2@in.ibm.com>, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008301601.12971.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

while debugging an issue in rt2x00 I've discovered that in some cases frames
with the same TID and RA end up in different tx queues (which causes problems
in rt2x00 when using aggregation).

Is this behavior expected and we need to handle that case in rt2x00 or is it
more likely a bug? At least I thought the select_queue implementation in
mac80211 was meant to always pick the same tx queue for skbs with the same
priority and hence it shouldn't happen that frames with the same TID are
queued into different tx queues.

This behavior seems to have changed already a while ago with the patch
"net: Use sk_tx_queue_mapping for connected sockets" (CC'ing Krishna & netdev).

Thanks,
Helmut
