Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27287 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbbBJI7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 03:59:55 -0500
Date: Tue, 10 Feb 2015 12:00:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: christophe.ricard@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: re: NFC: st21nfca: Add HCI transaction event support
Message-ID: <20150210090051.GA31867@mwanda> (sfid-20150210_095958_378275_DB92044C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christophe Ricard,

The patch 26fc6c7f02cb: "NFC: st21nfca: Add HCI transaction event
support" from Feb 1, 2015, leads to the following static checker
warning:

	drivers/nfc/st21nfca/st21nfca_se.c:321 st21nfca_connectivity_event_received()
	error: 'skb->data[1]' from user is not capped properly

drivers/nfc/st21nfca/st21nfca_se.c
   300  int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
   301                                  u8 event, struct sk_buff *skb)
   302  {
   303          int r = 0;
   304          struct device *dev = &hdev->ndev->dev;
   305          struct nfc_evt_transaction *transaction;
   306  
   307          pr_debug("connectivity gate event: %x\n", event);
   308  
   309          switch (event) {
   310          case ST21NFCA_EVT_CONNECTIVITY:
   311                  break;
   312          case ST21NFCA_EVT_TRANSACTION:
   313                  if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
   314                      skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
   315                          return -EPROTO;

Here we don't trust skb->data[0].

   316  
   317                  transaction = (struct nfc_evt_transaction *)devm_kzalloc(dev,
   318                                                     skb->len - 2, GFP_KERNEL);
   319  
   320                  transaction->aid_len = skb->data[1];
   321                  memcpy(transaction->aid, &skb->data[2], skb->data[1]);
                                                                ^^^^^^^^^^^^
But here we trust skb->data[1].

NFC code is hard to analyze because sometimes skb->data[] comes from the
firmware and holds trusted values.  But sometimes it comes from the
network and can overflow.  Smatch marks it all as untrusted so it causes
a lot of false postives.

Some of them have comments like:

	net/nfc/hci/core.c:218 nfc_hci_cmd_received()
	error: buffer overflow 'hdev->pipes' 127 <= 255

But this one doesn't have a comment so it's hard for me as an outsider
to say if this is a bug or not.

   322  

regards,
dan carpenter
