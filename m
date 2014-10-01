Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46612 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaJAOVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 10:21:03 -0400
Date: Wed, 1 Oct 2014 17:20:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mgreer@animalcreek.com
Cc: linux-wireless@vger.kernel.org
Subject: re: NFC: trf7970a: Handle timeout values of zero
Message-ID: <20141001142048.GA32518@mwanda> (sfid-20141001_162107_095560_14F939B6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Mark A. Greer,

The patch 1961843ceeca: "NFC: trf7970a: Handle timeout values of
zero" from Sep 2, 2014, leads to the following static checker warning:

	drivers/nfc/trf7970a.c:897 trf7970a_irq()
	warn: passing zero to 'ERR_PTR'

drivers/nfc/trf7970a.c
   892                          trf7970a_cmd(trf, TRF7970A_CMD_FIFO_RESET);
   893  
   894                          if (!trf->timeout) {
   895                                  trf->ignore_timeout = !cancel_delayed_work(
   896                                                  &trf->timeout_work);
   897                                  trf->rx_skb = ERR_PTR(0);
                                                      ^^^^^^^^^^
Why not just say "NULL"?

   898                                  trf7970a_send_upstream(trf);
   899                                  break;
   900                          }

regards,
dan carpenter
