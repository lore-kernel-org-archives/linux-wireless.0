Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:45008 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3IXToG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 15:44:06 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v5 2/2] Bluetooth: btmrvl: add calibration data download support
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F450779BE@SC-VEXCH1.marvell.com>
Date: Tue, 24 Sep 2013 21:43:49 +0200
Cc: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <C42E9D11-1E8B-499E-96E0-74469F7649EC@holtmann.org> (sfid-20130924_214411_661257_E5572F27)
References: <1379715667-22424-1-git-send-email-bzhao@marvell.com> <1379715667-22424-2-git-send-email-bzhao@marvell.com> <05172D80-CE30-4B7D-A64E-11B8E320EF7F@holtmann.org> <477F20668A386D41ADCC57781B1F70430F44C59423@SC-VEXCH1.marvell.com> <34088279-04B9-49D0-9387-88A602F518EC@holtmann.org> <477F20668A386D41ADCC57781B1F70430F450779BE@SC-VEXCH1.marvell.com>
To: Bing Zhao <bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

>>> The reason of not using __hci_cmd_sync() is that we are sending vendor specific command here
>> (MRVL_VENDOR_PKT). The __hci_cmd_sync seems handle HCI_COMMAND_PKT only.
>>> Please let us know if you have any suggestion to solve this problem.
>> 
>> what is a MRVL_VENDOR_PKT actually?
> 
> It's defined as 0xfe in our driver. The firmware doesn't understand 0xff (HCI_VENDOR_PKT).

so it is actually out-of-channel vendor packet.

>> 
>> If you guys are not using standard HCI command/event for vendor operation, then this obviously does
>> not fit. However a similar model might make sense instead of manually building packets all the time.
> 
> We can extend __hci_cmd_sync() function with a new parameter 'type'.
> This way we can pass HCI_VENDOR_PKT into __hci_cmd_sync(), while other drivers will pass in HCI_COMMAND_PKT.

That will actually not work. And I also do not want to do that. The __hci_cmd_sync() is for real HCI packets. That means types 0x01 and 0x04 only. They need to adhere to the HCI flow control mechanism for commands.

> Our driver will make HCI_VENDOR_PKT -> MRVL_VENDOR_PKT conversion before downloading the frame to firmware. And the MRVL_VENDOR_PKT frame from firmware will be replaced with HCI_VENDOR_PKT while uploading the frame to stack.
> 
> Please let us know if this approach works for you or not.

I think this is best kept inside the driver. However you might consider building something like __hci_cmd_sync() that is specific to your driver, but allows for a similar flow within ->setup().

Regards

Marcel

