Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:60817 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3IXEWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 00:22:15 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v5 2/2] Bluetooth: btmrvl: add calibration data download support
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F44C59423@SC-VEXCH1.marvell.com>
Date: Tue, 24 Sep 2013 06:21:56 +0200
Cc: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <34088279-04B9-49D0-9387-88A602F518EC@holtmann.org> (sfid-20130924_062219_827528_025FD365)
References: <1379715667-22424-1-git-send-email-bzhao@marvell.com> <1379715667-22424-2-git-send-email-bzhao@marvell.com> <05172D80-CE30-4B7D-A64E-11B8E320EF7F@holtmann.org> <477F20668A386D41ADCC57781B1F70430F44C59423@SC-VEXCH1.marvell.com>
To: Bing Zhao <bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

>>> +	cmd = (struct btmrvl_cmd *)skb->data;
>>> +	cmd->ocf_ogf =
>>> +		cpu_to_le16(hci_opcode_pack(OGF, BT_CMD_LOAD_CONFIG_DATA));
>>> +	cmd->length = BT_CMD_DATA_SIZE;
>>> +	cmd->data[0] = 0x00;
>>> +	cmd->data[1] = 0x00;
>>> +	cmd->data[2] = 0x00;
>>> +	cmd->data[3] = BT_CMD_DATA_SIZE - 4;
>> 
>> why not use __hci_cmd_sync() here. It is designed to be used from ->setup() where it is guaranteed
>> that the HCI request lock is held. And it is guaranteed that ->setup() is executed in a workqueue.
> 
> The reason of not using __hci_cmd_sync() is that we are sending vendor specific command here (MRVL_VENDOR_PKT). The __hci_cmd_sync seems handle HCI_COMMAND_PKT only.
> Please let us know if you have any suggestion to solve this problem.

what is a MRVL_VENDOR_PKT actually?

If you guys are not using standard HCI command/event for vendor operation, then this obviously does not fit. However a similar model might make sense instead of manually building packets all the time.

Regards

Marcel

