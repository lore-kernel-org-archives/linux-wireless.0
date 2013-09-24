Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36274 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734Ab3IXTyy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 15:54:54 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 24 Sep 2013 12:54:09 -0700
Subject: RE: [PATCH v5 2/2] Bluetooth: btmrvl: add calibration data download
 support
Message-ID: <477F20668A386D41ADCC57781B1F70430F450779E4@SC-VEXCH1.marvell.com> (sfid-20130924_215459_840331_6FEE7F58)
References: <1379715667-22424-1-git-send-email-bzhao@marvell.com>
 <1379715667-22424-2-git-send-email-bzhao@marvell.com>
 <05172D80-CE30-4B7D-A64E-11B8E320EF7F@holtmann.org>
 <477F20668A386D41ADCC57781B1F70430F44C59423@SC-VEXCH1.marvell.com>
 <34088279-04B9-49D0-9387-88A602F518EC@holtmann.org>
 <477F20668A386D41ADCC57781B1F70430F450779BE@SC-VEXCH1.marvell.com>
 <C42E9D11-1E8B-499E-96E0-74469F7649EC@holtmann.org>
In-Reply-To: <C42E9D11-1E8B-499E-96E0-74469F7649EC@holtmann.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

> > We can extend __hci_cmd_sync() function with a new parameter 'type'.
> > This way we can pass HCI_VENDOR_PKT into __hci_cmd_sync(), while other drivers will pass in
> HCI_COMMAND_PKT.
> 
> That will actually not work. And I also do not want to do that. The __hci_cmd_sync() is for real HCI
> packets. That means types 0x01 and 0x04 only. They need to adhere to the HCI flow control mechanism
> for commands.

I see.

> 
> > Our driver will make HCI_VENDOR_PKT -> MRVL_VENDOR_PKT conversion before downloading the frame to
> firmware. And the MRVL_VENDOR_PKT frame from firmware will be replaced with HCI_VENDOR_PKT while
> uploading the frame to stack.
> >
> > Please let us know if this approach works for you or not.
> 
> I think this is best kept inside the driver. However you might consider building something like
> __hci_cmd_sync() that is specific to your driver, but allows for a similar flow within ->setup().

Sure, we will consider building a function in the driver to handle this.

Thanks,
Bing
