Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42753 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaLFUQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2014 15:16:21 -0500
Date: Sat, 6 Dec 2014 23:16:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: christophe.ricard@gmail.com
Cc: Christophe Ricard <christophe.ricard@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: re: NFC: st21nfca: Rework st21nfca_hci_event_received to route event
 to relevent gate.
Message-ID: <20141206201613.GA28810@mwanda> (sfid-20141206_211624_681656_C97929C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christophe Ricard,

The patch a4415e761404: "NFC: st21nfca: Rework
st21nfca_hci_event_received to route event to relevent gate." from
Nov 13, 2014, leads to the following static checker warning:

	drivers/nfc/st21nfca/st21nfca.c:848 st21nfca_hci_event_received()
	info: ignoring unreachable code.

drivers/nfc/st21nfca/st21nfca.c
   832  /*
   833   * Returns:
   834   * <= 0: driver handled the event, skb consumed
   835   *    1: driver does not handle the event, please do standard processing
   836   */
   837  static int st21nfca_hci_event_received(struct nfc_hci_dev *hdev, u8 gate,
   838                                         u8 event, struct sk_buff *skb)
   839  {
   840          pr_debug("hci event: %d gate: %x\n", event, gate);
   841  
   842          switch (gate) {
   843          case ST21NFCA_RF_CARD_F_GATE:
   844                  return st21nfca_dep_event_received(hdev, event, skb);
   845          default:
   846                  return 1;
   847          }
   848          kfree_skb(skb);
                ^^^^^^^^^^^^^^
Not reached.  Confusing.

   849          return 0;
   850  }

regards,
dan carpenter
