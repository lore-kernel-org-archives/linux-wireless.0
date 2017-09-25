Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32857 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932966AbdIYLGo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 07:06:44 -0400
Date: Mon, 25 Sep 2017 14:06:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: christophe.ricard@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] NFC: st21nfcb: Add support for secure element
Message-ID: <20170925110635.i7lsjvzjzyffhfgo@mwanda> (sfid-20170925_130923_708137_DAB0C65F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christophe Ricard,

The patch 8ae01f796771: "NFC: st21nfcb: Add support for secure
element" from Feb 1, 2015, leads to the following static checker
warning:

	drivers/nfc/st-nci/se.c:373 st_nci_hci_event_received()
	warn: constraint overflow 'ndev->hci_dev->pipes' 127 <= 0-127

drivers/nfc/st-nci/se.c
   370  void st_nci_hci_event_received(struct nci_dev *ndev, u8 pipe,
   371                                   u8 event, struct sk_buff *skb)
   372  {
   373          u8 gate = ndev->hci_dev->pipes[pipe].gate;
   374          u8 host = ndev->hci_dev->pipes[pipe].host;
   375  
   376          switch (gate) {
   377          case NCI_HCI_ADMIN_GATE:
   378                  st_nci_hci_admin_event_received(ndev, event, skb);
   379          break;
   380          case ST_NCI_APDU_READER_GATE:
   381                  st_nci_hci_apdu_reader_event_received(ndev, event, skb);
   382          break;
   383          case ST_NCI_CONNECTIVITY_GATE:
   384                  st_nci_hci_connectivity_event_received(ndev, host, event, skb);
   385          break;
   386          }
   387  }
   388  EXPORT_SYMBOL_GPL(st_nci_hci_event_received);


pipe comes from skb->data[].  The call tree is:

nci_hci_msg_rx_work  <-- gets pipe from skb->data[0]
  -> nci_hci_hcp_message_rx
     --> nci_hci_event_received
         -->  st_nci_hci_event_received  <-- off by one

regards,
dan carpenter
