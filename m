Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:48202 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbcGGPvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2016 11:51:50 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u67FpFrk019824
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Thu, 7 Jul 2016 15:51:15 GMT
Date: Thu, 7 Jul 2016 18:49:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: christophe.ricard@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] nfc: st-nci: Move loopback usage from HCI to NCI
Message-ID: <20160707154924.GA26650@mwanda> (sfid-20160707_175214_782141_461642E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christophe Ricard,

The patch 3aacd7fe552b: "nfc: st-nci: Move loopback usage from HCI to
NCI" from Apr 30, 2016, leads to the following static checker warning:

	drivers/nfc/st-nci/vendor_cmds.c:351 st_nci_loopback()
	error: potentially dereferencing uninitialized 'skb'.

drivers/nfc/st-nci/vendor_cmds.c
   336  static int st_nci_loopback(struct nfc_dev *dev, void *data,
   337                             size_t data_len)
   338  {
   339          int r;
   340          struct sk_buff *msg, *skb;
   341          struct nci_dev *ndev = nfc_get_drvdata(dev);
   342  
   343          if (data_len <= 0)
   344                  return -EPROTO;
   345  
   346          r = nci_nfcc_loopback(ndev, data, data_len, &skb);
   347          if (r < 0)
   348                  return r;
   349  
   350          msg = nfc_vendor_cmd_alloc_reply_skb(dev, ST_NCI_VENDOR_OUI,
   351                                               LOOPBACK, skb->len);


This bug is slightly complicated to analyze.

The complaint is basically that nci_nfcc_loopback() can return positive
error codes like ENOMEM instead of -ENOMEM.  The reason is that
nci_req_complete() is normally takes some sort of custom positive
error code like NCI_STATUS_REJECTED.  Later on we cast transform it to
a negative kernel error code.

But the two callers in nci_hci_data_received_cb() which pass regular
kernel error codes to nci_req_complete().

   352          if (!msg) {
   353                  r = -ENOMEM;
   354                  goto free_skb;
   355          }
   356  
   357          if (nla_put(msg, NFC_ATTR_VENDOR_DATA, skb->len, skb->data)) {
   358                  kfree_skb(msg);
   359                  r = -ENOBUFS;
   360                  goto free_skb;
   361          }
   362  
   363          r = nfc_vendor_cmd_reply(msg);
   364  free_skb:
   365          kfree_skb(skb);
   366          return r;
   367  }

regards,
dan carpenter
