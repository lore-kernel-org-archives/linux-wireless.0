Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41164 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689Ab3IYXXt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 19:23:49 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johan Hedberg <johan.hedberg@gmail.com>
CC: Marcel Holtmann <marcel@holtmann.org>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 25 Sep 2013 16:23:35 -0700
Subject: RE: [PATCH v5 1/2] Bluetooth: btmrvl: add setup handler
Message-ID: <477F20668A386D41ADCC57781B1F70430F45077E5B@SC-VEXCH1.marvell.com> (sfid-20130926_012358_401650_ECF79838)
References: <1379715667-22424-1-git-send-email-bzhao@marvell.com>
 <18678858-E711-43E5-AFE6-E637D1CECFFB@holtmann.org>
 <477F20668A386D41ADCC57781B1F70430F44C59418@SC-VEXCH1.marvell.com>
 <DF6283E3-8476-400F-A230-CB7CA0F98564@holtmann.org>
 <477F20668A386D41ADCC57781B1F70430F450779A4@SC-VEXCH1.marvell.com>
 <20130924193010.GA2584@x220.p-661hnu-f1>
In-Reply-To: <20130924193010.GA2584@x220.p-661hnu-f1>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johan,

> You're right that we're missing the clearing of the HCI_SETUP flag for
> such a scenario. Could you try the attached patch. It should fix the

We have tested your patch. Yes, it fixes the problem. Thanks!

> issue. One problem that it does have is that if the HCIDEVUP ioctl path
> goes through before hci_power_on gets called we will never notify mgmt
> of the adapter. However, that might be acceptable here since if you're
> using HCIDEVUP like this it seems it's not a mgmt based system anyway.

Do you think the following change helps?

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 3d9f02b..24814b0 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1665,7 +1665,7 @@ static void hci_power_on(struct work_struct *work)
 	BT_DBG("%s", hdev->name);
 
 	err = hci_dev_open(hdev->id);
-	if (err < 0) {
+	if (err < 0 && err != -EALREADY) {
 		mgmt_set_powered_failed(hdev, err);
 		return;
 	}

Thanks,
Bing

