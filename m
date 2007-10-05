Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59905
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbXJEN5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 09:57:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: mac80211: What is get_sequence_counter?
Date: Fri, 5 Oct 2007 15:56:27 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200710051556.27401.mb@bu3sch.de> (sfid-20071005_145731_918120_FBA6760A)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What is the get_sequence_counter callback for?

	/* For devices that have internal sequence counters, allow 802.11
	 * code to access the current value of a counter */
	int (*get_sequence_counter)(struct ieee80211_hw *hw,
				    u8* addr, u8 keyidx, u8 txrx,
				    u32* iv32, u16* iv16);

It doesn't seem to be used in current mac80211 code.
It seems that this is to fetch the current initial values.
Is that correct?
Who is supposed to use this callback? If it's unused, let's remove
it please. The documentation for it sucks anyway. :)

-- 
Greetings Michael.
