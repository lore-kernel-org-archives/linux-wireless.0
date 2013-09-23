Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46342 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835Ab3IWTgA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 15:36:00 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Mon, 23 Sep 2013 12:35:43 -0700
Subject: RE: [PATCH v5 2/2] Bluetooth: btmrvl: add calibration data download
 support
Message-ID: <477F20668A386D41ADCC57781B1F70430F44C59423@SC-VEXCH1.marvell.com> (sfid-20130923_213606_043666_A501E74F)
References: <1379715667-22424-1-git-send-email-bzhao@marvell.com>
 <1379715667-22424-2-git-send-email-bzhao@marvell.com>
 <05172D80-CE30-4B7D-A64E-11B8E320EF7F@holtmann.org>
In-Reply-To: <05172D80-CE30-4B7D-A64E-11B8E320EF7F@holtmann.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

> > +	cmd = (struct btmrvl_cmd *)skb->data;
> > +	cmd->ocf_ogf =
> > +		cpu_to_le16(hci_opcode_pack(OGF, BT_CMD_LOAD_CONFIG_DATA));
> > +	cmd->length = BT_CMD_DATA_SIZE;
> > +	cmd->data[0] = 0x00;
> > +	cmd->data[1] = 0x00;
> > +	cmd->data[2] = 0x00;
> > +	cmd->data[3] = BT_CMD_DATA_SIZE - 4;
> 
> why not use __hci_cmd_sync() here. It is designed to be used from ->setup() where it is guaranteed
> that the HCI request lock is held. And it is guaranteed that ->setup() is executed in a workqueue.

The reason of not using __hci_cmd_sync() is that we are sending vendor specific command here (MRVL_VENDOR_PKT). The __hci_cmd_sync seems handle HCI_COMMAND_PKT only.
Please let us know if you have any suggestion to solve this problem.

Thanks,
Bing

