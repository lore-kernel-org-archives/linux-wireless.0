Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25015 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753799Ab3IXTna convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 15:43:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johan Hedberg <johan.hedberg@gmail.com>
CC: Marcel Holtmann <marcel@holtmann.org>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 24 Sep 2013 12:42:57 -0700
Subject: RE: [PATCH v5 1/2] Bluetooth: btmrvl: add setup handler
Message-ID: <477F20668A386D41ADCC57781B1F70430F450779D4@SC-VEXCH1.marvell.com> (sfid-20130924_214336_034025_7C512647)
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

> Hi Bing,
> 
> On Tue, Sep 24, 2013, Bing Zhao wrote:
> > > that is a bug. It should only be ever called once. Could this be due
> > > to RFKILL issue we had? Please re-test with Johan's patches applied
> > > and check if it makes a difference. Otherwise please send some logs
> > > since we want to get this fixed.
> >
> > Amitkumar Karwar has tested it with latest code on bluetooth-next tree
> > but the result is the same.
> > Apparently two threads race to call hci_dev_open(). If the thread from
> > hci_sock calls hci_dev_open earlier, it ends up not updating HCI_SETUP
> > hdev flag in hci_power_on(). This results that the setup handler gets
> > called again when user brings up the interface later.
> 
> Let's see if I understood this right: the only hci_dev_open call in
> hci_sock.c is the one for the HCIDEVUP ioctl. So what you're doing is
> having user space call the HCIDEVUP ioctl before our own hci_power_on
> callback gets called to initialize the adapter?

That's right. The ioctl is initiated by the Bluetooth daemon.
Amitkumar has a setup that can reproduce this corner case easily.
I tested it on my Ubuntu but I couldn't replicate it.

> 
> You're right that we're missing the clearing of the HCI_SETUP flag for
> such a scenario. Could you try the attached patch. It should fix the
> issue. One problem that it does have is that if the HCIDEVUP ioctl path
> goes through before hci_power_on gets called we will never notify mgmt
> of the adapter. However, that might be acceptable here since if you're
> using HCIDEVUP like this it seems it's not a mgmt based system anyway.
> 
> > I checked the bluetooth-next tree, the following two patches (by
> > Johan) are not present in this tree.
> >
> > bf54303 Bluetooth: Fix rfkill functionality during the HCI setup stage
> > 5e13036 Bluetooth: Introduce a new HCI_RFKILLED flag
> >
> > They are in bluetooth.git tree. So, I'm not certain if Amitkumar has
> > applied them manually or not. Anyway we will re-test with Johan's
> > patches applied and confirm if they fix the race or not.
> 
> I don't think these patches will help you in this case.

OK, we will test your patch instead.

Thanks,
Bing

