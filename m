Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:32861 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbZKPQXh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 11:23:37 -0500
Received: from p5099b351.dip0.t-ipconnect.de ([80.153.179.81] helo=zzz.local)
	by bar.sig21.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.63)
	(envelope-from <js@sig21.net>)
	id 1NA4Mf-0000Ll-1u
	for linux-wireless@vger.kernel.org; Mon, 16 Nov 2009 17:23:42 +0100
Received: from js by zzz.local with local (Exim 4.69)
	(envelope-from <js@sig21.net>)
	id 1NA4Mb-0006ih-HI
	for linux-wireless@vger.kernel.org; Mon, 16 Nov 2009 17:23:37 +0100
Date: Mon, 16 Nov 2009 17:23:37 +0100
From: Johannes Stezenbach <js@sig21.net>
To: linux-wireless@vger.kernel.org
Subject: rt2x00: unused variable frame_control
Message-ID: <20091116162336.GA25817@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While looking for something else I noticed this in rt2xxmac.c:

int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
...
	frame_control = le16_to_cpu(ieee80211hdr->frame_control);

However, the value of frame_control is never used.


Johannes
