Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:2001 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758977Ab2INKXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 06:23:47 -0400
Message-ID: <1347617853.14216.18.camel@x61.thuisdomein> (sfid-20120914_122351_352031_0F87CCFF)
Subject: iwlegacy:  "Can't stop Rx DMA." error
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 14 Sep 2012 12:17:33 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

0) Every now and then an error appears in the logs of a laptop:
     iwl4965 [...]: Can't stop Rx DMA.

Last time it was triggered while suspending this laptop.

1) This error is printed by il4965_rxq_stop() in
drivers/net/wireless/iwlegacy/4965-mac.c. (An identical function is
il3945_hw_rxq_stop() in drivers/net/wireless/iwlegacy/3945.c.)

A similar function is iwl_trans_rx_stop() in
drivers/net/wireless/iwlwifi/pcie/trans.c. That function will never
print any messages.

2) Why is this error needed? This function will always return 0,
regardless whether that error was printed or not, and the sole caller of
this function ignores the returned zero anyway. Can't it be downgraded
to debug level or perhaps even removed? If so, I'd be happy to submit
the trivial patch to do so.


Paul Bolle

