Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:50832 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab1HIPEl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 11:04:41 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 9 Aug 2011 17:04:29 +0200
Subject: [RFC] NFC: NCI protocol proposal
Message-ID: <AC090B9732AB2B4DB7FF476E907FE6600131D0E347@dnce02.ent.ti.com> (sfid-20110809_170444_843589_B6792DE6)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lauro, Aloisio, Samuel, all,

We would like to implement the NFC Controller Interface (NCI) protocol for the NFC subsystem.
The NCI is a standard communication protocol between an NFC Controller (NFCC) and a Device Host (DH), defined by the NFC Forum.

The NCI protocol implementation will be chip independent and responsible for:
	- Reset, initialization and configuration of the NFC controller
	- Sending commands/data to the NFC controller
	- Receiving responses/notifications/data from the NFC controller
	- Flow control for Control and Data Messages
	- Segmentation and reassembly for Control and Data Messages
	- An addressing scheme for NFC Execution Environments (NFCEE), e.g. 	secure element
	- An addressing scheme for Remote NFC Endpoints (NFCEE or RF targets) 	(via logical connections)

The NCI protocol will be added to the NFC subsystem below the NFC core:
 
+--------------------------------------+
|              USER SPACE              |
+--------------------------------------+
     ^                        ^
     | low-level              | control
     | data exchange          | operations
     |                        |
     |                        v
     |                  +-----------+
     | AF_NFC           |  netlink  |
     | socket           +-----------+
     | raw                    ^
     |                        |
     v                        v
+---------+             +-----------+
| rawsock | <---------> | NFC core  |
+---------+             +-----------+
                	            ^
                              |
                              v
              	      +-----------+
                        | NCI core  |
                        +-----------+
				      ^
				      |
				      V
			      +-----------+
			      |  driver   |
			      +-----------+

The driver will register itself to the NCI core, and in turn the NCI core will register itself to the NFC core.

We need to add the following 2 control operations (via generic netlink):
	- Dev_up, which turn on the NFC controller (this operation may take a 	few seconds, as it can download new FW to the NFC controller)
	- Dev_down, which turn off the NFC controller
The dev_up/down approach was also used with HCI protocol in the BlueZ project.

We suggest placing the NCI code in the net\nfc folder (beside the NFC code), as it's a generic and chip independent protocol, and not a driver.
This approach was also used with HCI protocol in the BlueZ project.
The driver itself will be located at drivers\nfc folder.

The NCI code will be divided in a few files, e.g. nci_core, nci_rsp, nci_ntf etc.

We'll appreciate your comments.

Thanks & BR
Ilan Elias
Texas Instruments
