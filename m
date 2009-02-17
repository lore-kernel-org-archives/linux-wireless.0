Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:51280 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbZBQEZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 23:25:50 -0500
Message-ID: <499A3C3C.7070409@lwfinger.net> (sfid-20090217_052554_963289_D877EE11)
Date: Mon, 16 Feb 2009 22:25:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	Lorenzo Nava <navalorenx@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Question about sequence numbers
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Francesco and Lorenzo,

Should the sequence numbers be sequential? Do you know of any case where the
cookie would be incremented but the sequence number be unchanged?

The reason I'm asking is that I modified my system to dump the registers and
memory whenever a new_seq != (old_seq + 1 ) & 0xFFF. When I do that, I see
b43_dma_handle_txstatus called cookie 0x2062 and seq 0x371. From my buffered
status info, the previous call had cookie 0x2060 and seq 0x371.

BTW, the proprietary firmware does the same thing, but it never gets called with
the poisoned skb.

Larry

