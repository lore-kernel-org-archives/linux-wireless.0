Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:36585 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3IZBpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 21:45:18 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v5 1/2] Bluetooth: btmrvl: add setup handler
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F45077E5B@SC-VEXCH1.marvell.com>
Date: Thu, 26 Sep 2013 03:45:27 +0200
Cc: Johan Hedberg <johan.hedberg@gmail.com>,
	"linux-bluetooth@vger.kernel.org development"
	<linux-bluetooth@vger.kernel.org>,
	"Gustavo F. Padovan" <gustavo@padovan.org>,
	"linux-wireless@vger.kernel.org Wireless"
	<linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <B3090D30-6F81-4E12-8F58-E650F77BB72E@holtmann.org> (sfid-20130926_034523_411778_7A4BB583)
References: <1379715667-22424-1-git-send-email-bzhao@marvell.com> <18678858-E711-43E5-AFE6-E637D1CECFFB@holtmann.org> <477F20668A386D41ADCC57781B1F70430F44C59418@SC-VEXCH1.marvell.com> <DF6283E3-8476-400F-A230-CB7CA0F98564@holtmann.org> <477F20668A386D41ADCC57781B1F70430F450779A4@SC-VEXCH1.marvell.com> <20130924193010.GA2584@x220.p-661hnu-f1> <477F20668A386D41ADCC57781B1F70430F45077E5B@SC-VEXCH1.marvell.com>
To: Bing Zhao <bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

>> You're right that we're missing the clearing of the HCI_SETUP flag for
>> such a scenario. Could you try the attached patch. It should fix the
> 
> We have tested your patch. Yes, it fixes the problem. Thanks!

then lets get a proper version with full commit message explaining the issue merged upstream. As I said, this is a real bug we need to fix.

>> issue. One problem that it does have is that if the HCIDEVUP ioctl path
>> goes through before hci_power_on gets called we will never notify mgmt
>> of the adapter. However, that might be acceptable here since if you're
>> using HCIDEVUP like this it seems it's not a mgmt based system anyway.
> 
> Do you think the following change helps?
> 
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 3d9f02b..24814b0 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -1665,7 +1665,7 @@ static void hci_power_on(struct work_struct *work)
> 	BT_DBG("%s", hdev->name);
> 
> 	err = hci_dev_open(hdev->id);
> -	if (err < 0) {
> +	if (err < 0 && err != -EALREADY) {
> 		mgmt_set_powered_failed(hdev, err);
> 		return;
> 	}

I am more and more convinced that we might just need to disable certain ioctl in case there is a mgmt socket/client present and HCI_MGMT is set. Trying to be graceful with legacy ioctl that BlueZ 5 will never use anymore seems to come at a too high cost. I rather fail on the legacy commands with a proper error than having mgmt interface behave inconsistent.

We might actually be able to keep HCIDEVUP and HCIDEVDOWN around, but then they need to behave like mgmt set powered command. So both commands need to go through the same mgmt engine for this.

Regards

Marcel

