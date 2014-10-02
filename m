Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29750 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJBJK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 05:10:56 -0400
Date: Thu, 2 Oct 2014 12:10:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Subject: re: rtlwifi: rtl8192ee: Move driver from staging to the regular tree
Message-ID: <20141002091041.GA10993@mwanda> (sfid-20141002_111100_509666_B79DFCE0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry Finger,

There are still some static checker warnings after this driver moved.

drivers/net/wireless/rtlwifi/rtl8192ee/hw.c:533 rtl92ee_set_hw_reg() warn: add curly braces? (if)
drivers/net/wireless/rtlwifi/rtl8192ee/hw.c:539 rtl92ee_set_hw_reg() warn: add curly braces? (if)

Some unreleased static checker warnings for rtl are:

drivers/net/wireless/rtlwifi/rtl8723be/trx.c:550 rtl8723be_rx_query_desc() warn: 'hdr' can't be NULL.
drivers/net/wireless/rtlwifi/rtl8188ee/trx.c:621 rtl88ee_rx_query_desc() warn: 'hdr' can't be NULL.
drivers/net/wireless/rtlwifi/rtl8192ee/trx.c:567 rtl92ee_rx_query_desc() warn: 'hdr' can't be NULL.
drivers/net/wireless/rtlwifi/rtl8821ae/trx.c:758 rtl8821ae_rx_query_desc() warn: 'hdr' can't be NULL.
drivers/net/wireless/rtlwifi/rtl8723ae/trx.c:494 rtl8723e_rx_query_desc() warn: 'hdr' can't be NULL.
drivers/net/wireless/rtlwifi/rtl8192se/trx.c:315 rtl92se_rx_query_desc() warn: 'hdr' can't be NULL.
drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:392 rtl92ce_rx_query_desc() warn: 'hdr' can't be NULL.

These bogus null checks were added because:
drivers/net/wireless/rtlwifi/rtl8192se/trx.c says /* during testing, hdr
was NULL here */.  It is concerning because that means something weird
is going on when impossible things start happening during testing.

regards,
dan carpenter

