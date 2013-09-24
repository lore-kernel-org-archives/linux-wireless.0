Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35522 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3IXTaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 15:30:19 -0400
Date: Tue, 24 Sep 2013 22:30:10 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH v5 1/2] Bluetooth: btmrvl: add setup handler
Message-ID: <20130924193010.GA2584@x220.p-661hnu-f1> (sfid-20130924_213031_849048_636BD8F3)
References: <1379715667-22424-1-git-send-email-bzhao@marvell.com>
 <18678858-E711-43E5-AFE6-E637D1CECFFB@holtmann.org>
 <477F20668A386D41ADCC57781B1F70430F44C59418@SC-VEXCH1.marvell.com>
 <DF6283E3-8476-400F-A230-CB7CA0F98564@holtmann.org>
 <477F20668A386D41ADCC57781B1F70430F450779A4@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F450779A4@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Bing,

On Tue, Sep 24, 2013, Bing Zhao wrote:
> > that is a bug. It should only be ever called once. Could this be due
> > to RFKILL issue we had? Please re-test with Johan's patches applied
> > and check if it makes a difference. Otherwise please send some logs
> > since we want to get this fixed.
> 
> Amitkumar Karwar has tested it with latest code on bluetooth-next tree
> but the result is the same.
> Apparently two threads race to call hci_dev_open(). If the thread from
> hci_sock calls hci_dev_open earlier, it ends up not updating HCI_SETUP
> hdev flag in hci_power_on(). This results that the setup handler gets
> called again when user brings up the interface later.

Let's see if I understood this right: the only hci_dev_open call in
hci_sock.c is the one for the HCIDEVUP ioctl. So what you're doing is
having user space call the HCIDEVUP ioctl before our own hci_power_on
callback gets called to initialize the adapter?

You're right that we're missing the clearing of the HCI_SETUP flag for
such a scenario. Could you try the attached patch. It should fix the
issue. One problem that it does have is that if the HCIDEVUP ioctl path
goes through before hci_power_on gets called we will never notify mgmt
of the adapter. However, that might be acceptable here since if you're
using HCIDEVUP like this it seems it's not a mgmt based system anyway.

> I checked the bluetooth-next tree, the following two patches (by
> Johan) are not present in this tree.
> 
> bf54303 Bluetooth: Fix rfkill functionality during the HCI setup stage
> 5e13036 Bluetooth: Introduce a new HCI_RFKILLED flag
> 
> They are in bluetooth.git tree. So, I'm not certain if Amitkumar has
> applied them manually or not. Anyway we will re-test with Johan's
> patches applied and confirm if they fix the race or not.

I don't think these patches will help you in this case.

Johan

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="hci-setup.patch"

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 634deba..c48bf1a 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1164,7 +1164,7 @@ int hci_dev_open(__u16 dev)
 	atomic_set(&hdev->cmd_cnt, 1);
 	set_bit(HCI_INIT, &hdev->flags);
 
-	if (hdev->setup && test_bit(HCI_SETUP, &hdev->dev_flags))
+	if (test_and_clear_bit(HCI_SETUP, &hdev->dev_flags) && hdev->setup)
 		ret = hdev->setup(hdev);
 
 	if (!ret) {
@@ -1581,10 +1581,13 @@ static const struct rfkill_ops hci_rfkill_ops = {
 static void hci_power_on(struct work_struct *work)
 {
 	struct hci_dev *hdev = container_of(work, struct hci_dev, power_on);
+	bool setup;
 	int err;
 
 	BT_DBG("%s", hdev->name);
 
+	setup = test_bit(HCI_SETUP, &hdev->dev_flags);
+
 	err = hci_dev_open(hdev->id);
 	if (err < 0) {
 		mgmt_set_powered_failed(hdev, err);
@@ -1595,7 +1598,7 @@ static void hci_power_on(struct work_struct *work)
 		queue_delayed_work(hdev->req_workqueue, &hdev->power_off,
 				   HCI_AUTO_OFF_TIMEOUT);
 
-	if (test_and_clear_bit(HCI_SETUP, &hdev->dev_flags))
+	if (setup)
 		mgmt_index_added(hdev);
 }
 

--HlL+5n6rz5pIUxbD--
