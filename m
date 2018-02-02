Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43586 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbeBBOfj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Feb 2018 09:35:39 -0500
Date: Fri, 2 Feb 2018 17:35:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: christophe.ricard@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] NFC: nci: Add HCI over NCI protocol support
Message-ID: <20180202143525.GA24629@mwanda> (sfid-20180202_153543_530613_75516B02)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christophe Ricard,

The patch 11f54f228643: "NFC: nci: Add HCI over NCI protocol support"
from Feb 1, 2015, leads to the following static checker warning:

	net/nfc/nci/hci.c:297 nci_hci_cmd_received()
	error: buffer overflow 'ndev->hci_dev->pipes' 127 <= 127

net/nfc/nci/hci.c
   294  static void nci_hci_cmd_received(struct nci_dev *ndev, u8 pipe,
   295                                   u8 cmd, struct sk_buff *skb)
   296  {
   297          u8 gate = ndev->hci_dev->pipes[pipe].gate;
                                               ^^^^
->pipes[] has 127 elements and "pipe" can go up to 127 so this might be
reading one element beyond the end of the array.

   298          u8 status = NCI_HCI_ANY_OK | ~NCI_HCI_FRAGMENT;
   299          u8 dest_gate, new_pipe;
   300          struct nci_hci_create_pipe_resp *create_info;
   301          struct nci_hci_delete_pipe_noti *delete_info;
   302          struct nci_hci_all_pipe_cleared_noti *cleared_info;
   303  
   304          pr_debug("from gate %x pipe %x cmd %x\n", gate, pipe, cmd);
   305  

"pipe" can come from two places but their both essentially the same:

net/nfc/nci/hci.c
   413  static void nci_hci_msg_rx_work(struct work_struct *work)
   414  {
   415          struct nci_hci_dev *hdev =
   416                  container_of(work, struct nci_hci_dev, msg_rx_work);
   417          struct sk_buff *skb;
   418          struct nci_hcp_message *message;
   419          u8 pipe, type, instruction;
   420  
   421          while ((skb = skb_dequeue(&hdev->msg_rx_queue)) != NULL) {
   422                  pipe = NCI_HCP_MSG_GET_PIPE(skb->data[0]);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The NCI_HCP_MSG_GET_PIPE() macro looks like this:

#define NCI_HCP_MSG_GET_PIPE(header) (header & 0x7f)

   423                  skb_pull(skb, NCI_HCI_HCP_PACKET_HEADER_LEN);
   424                  message = (struct nci_hcp_message *)skb->data;
   425                  type = NCI_HCP_MSG_GET_TYPE(message->header);
   426                  instruction = NCI_HCP_MSG_GET_CMD(message->header);
   427                  skb_pull(skb, NCI_HCI_HCP_MESSAGE_HEADER_LEN);
   428  
   429                  nci_hci_hcp_message_rx(hdev->ndev, pipe,
   430                                         type, instruction, skb);
   431          }
   432  }

regards,
dan carpenter
