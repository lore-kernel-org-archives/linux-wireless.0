Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:51615 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2GBL7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 07:59:16 -0400
Date: Mon, 2 Jul 2012 14:59:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: thomas@net.t-labs.tu-berlin.de
Cc: linux-wireless@vger.kernel.org
Subject: re: mac80211: correct size the argument to kzalloc in
Message-ID: <20120702115907.GA28105@elgon.mountain> (sfid-20120702_135919_947147_B03D699C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

minstrel_ht

Hello Thomas Huehn,

The patch 0a08adeb773c: "mac80211: correct size the argument to
kzalloc in minstrel_ht" from Jun 29, 2012, leads to the following
Sparse warning:
	net/mac80211/rc80211_minstrel_ht.c:816:33:
		warning: expression using sizeof(void)

-       msp->ratelist = kzalloc(sizeof(struct minstrel_rate) * max_rates, gfp);
+       msp->ratelist = kzalloc(sizeof(*msp->ratelist) * max_rates, gfp);
        if (!msp->ratelist)
                goto error;

"msp->ratelist" is a void pointer so that will cause memory corruption.
You could consider making it a struct minstrel_rate pointer.  I haven't
looked at this.

regards,
dan carpenter

