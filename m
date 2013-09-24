Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57800 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239Ab3IXTWe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 15:22:34 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 24 Sep 2013 12:22:03 -0700
Subject: RE: [PATCH v5 2/2] Bluetooth: btmrvl: add calibration data download
 support
Message-ID: <477F20668A386D41ADCC57781B1F70430F450779BE@SC-VEXCH1.marvell.com> (sfid-20130924_212239_595767_A55CAD1B)
References: <1379715667-22424-1-git-send-email-bzhao@marvell.com>
 <1379715667-22424-2-git-send-email-bzhao@marvell.com>
 <05172D80-CE30-4B7D-A64E-11B8E320EF7F@holtmann.org>
 <477F20668A386D41ADCC57781B1F70430F44C59423@SC-VEXCH1.marvell.com>
 <34088279-04B9-49D0-9387-88A602F518EC@holtmann.org>
In-Reply-To: <34088279-04B9-49D0-9387-88A602F518EC@holtmann.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

> > The reason of not using __hci_cmd_sync() is that we are sending vendor specific command here
> (MRVL_VENDOR_PKT). The __hci_cmd_sync seems handle HCI_COMMAND_PKT only.
> > Please let us know if you have any suggestion to solve this problem.
> 
> what is a MRVL_VENDOR_PKT actually?

It's defined as 0xfe in our driver. The firmware doesn't understand 0xff (HCI_VENDOR_PKT).

> 
> If you guys are not using standard HCI command/event for vendor operation, then this obviously does
> not fit. However a similar model might make sense instead of manually building packets all the time.

We can extend __hci_cmd_sync() function with a new parameter 'type'.
This way we can pass HCI_VENDOR_PKT into __hci_cmd_sync(), while other drivers will pass in HCI_COMMAND_PKT.

Our driver will make HCI_VENDOR_PKT -> MRVL_VENDOR_PKT conversion before downloading the frame to firmware. And the MRVL_VENDOR_PKT frame from firmware will be replaced with HCI_VENDOR_PKT while uploading the frame to stack.

Please let us know if this approach works for you or not.

Thanks,
Bing

