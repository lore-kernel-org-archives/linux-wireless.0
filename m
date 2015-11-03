Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40407 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbbKCO3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 09:29:52 -0500
Date: Tue, 3 Nov 2015 17:29:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: christophe.ricard@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: re: NFC: nci: Create pipe on specific gate in nci_hci_connect_gate
Message-ID: <20151103142944.GE28591@mwanda> (sfid-20151103_152955_332727_2A057DC5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christophe Ricard,

The patch a1b0b9415817: "NFC: nci: Create pipe on specific gate in
nci_hci_connect_gate" from Oct 25, 2015, leads to the following
static checker warning:

	net/nfc/nci/hci.c:679 nci_hci_connect_gate()
	warn: impossible condition '(pipe < 0) => (0-255 < 0)'

net/nfc/nci/hci.c
   655  int nci_hci_connect_gate(struct nci_dev *ndev,
   656                           u8 dest_host, u8 dest_gate, u8 pipe)
   657  {
   658          bool pipe_created = false;
   659          int r;
   660  
   661          if (pipe == NCI_HCI_DO_NOT_OPEN_PIPE)
   662                  return 0;
   663  
   664          if (ndev->hci_dev->gate2pipe[dest_gate] != NCI_HCI_INVALID_PIPE)
   665                  return -EADDRINUSE;
   666  
   667          if (pipe != NCI_HCI_INVALID_PIPE)
   668                  goto open_pipe;
   669  
   670          switch (dest_gate) {
   671          case NCI_HCI_LINK_MGMT_GATE:
   672                  pipe = NCI_HCI_LINK_MGMT_PIPE;
   673          break;
   674          case NCI_HCI_ADMIN_GATE:
   675                  pipe = NCI_HCI_ADMIN_PIPE;
   676          break;
   677          default:
   678                  pipe = nci_hci_create_pipe(ndev, dest_host, dest_gate, &r);
   679                  if (pipe < 0)
                            ^^^^^^^^
Unsigned never less than zero.

   680                          return r;
   681                  pipe_created = true;
   682                  break;
   683          }
   684  
   685  open_pipe:
   686          r = nci_hci_open_pipe(ndev, pipe);


regards,
dan carpenter
