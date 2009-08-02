Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:49975 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZHBByQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 21:54:16 -0400
Received: by rv-out-0506.google.com with SMTP id f6so820986rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2009 18:54:15 -0700 (PDT)
Message-ID: <4A74F1E3.8050502@lwfinger.net>
Date: Sat, 01 Aug 2009 20:54:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Regression since 2.6.31-rc3-wl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I tested 2.6.31-rc4-wl on my old i386 laptop that uses ifup to
control the network, wireless did not work. The problem was bisected
to the following:

commit f1b3c87b70287ded1338fb03a0a714d185041a96
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Jul 7 03:56:05 2009 +0200

    cfg80211: fix netdev down problem

    We shouldn't be looking at the ssid_len for non-IBSS,
    and for IBSS we should also return an error on trying
    to leave an IBSS while not in or joining an IBSS.

    This fixes an issue where we wouldn't disconnect() on
    an interface being taken down since there's no SSID
    configured this way.

The patch cannot be reverted as net/wireless.ibss.c has changed.
Reverting the first hunk that modifies net/wireless/core.c does not
make the system work.

Larry
