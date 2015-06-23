Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21285 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbbFWNHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 09:07:32 -0400
Date: Tue, 23 Jun 2015 16:07:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mgreer@animalcreek.com
Cc: linux-wireless@vger.kernel.org
Subject: re: NFC: trf7970a: Handle extra byte in response to Type 5 RMB
 commands
Message-ID: <20150623130703.GA27051@mwanda> (sfid-20150623_150735_660587_E3412ED2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Mark A. Greer,

This is a semi-automatic email about new static checker warnings.

The patch ab714817d7e8: "NFC: trf7970a: Handle extra byte in response 
to Type 5 RMB commands" from Apr 24, 2015, leads to the following 
Smatch complaint:

	drivers/nfc/trf7970a.c:632 trf7970a_send_upstream()
	 error: we previously assumed 'trf->rx_skb' could be null (see line 613)

drivers/nfc/trf7970a.c
   612	
   613		if (trf->rx_skb && !IS_ERR(trf->rx_skb) && !trf->aborting)
                    ^^^^^^^^^^^
Check for NULL.

   614			print_hex_dump_debug("trf7970a rx data: ", DUMP_PREFIX_NONE,
   615					16, 1, trf->rx_skb->data, trf->rx_skb->len,
   616					false);
   617	
   618		trf->state = TRF7970A_ST_IDLE;
   619	
   620		if (trf->aborting) {
   621			dev_dbg(trf->dev, "Abort process complete\n");
   622	
   623			if (!IS_ERR(trf->rx_skb)) {
   624				kfree_skb(trf->rx_skb);
   625				trf->rx_skb = ERR_PTR(-ECANCELED);
   626			}
   627	
   628			trf->aborting = false;
   629		}
   630	
   631		if (trf->adjust_resp_len) {
   632			skb_trim(trf->rx_skb, trf->rx_skb->len - 1);
                                 ^^^^^^^^^^^
Patch introduces unchecked dereference inside skb_trim().

   633			trf->adjust_resp_len = false;
   634		}

regards,
dan carpenter
