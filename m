Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45459 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393Ab3IWTTZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 15:19:25 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Mon, 23 Sep 2013 12:18:48 -0700
Subject: RE: [PATCH v5 1/2] Bluetooth: btmrvl: add setup handler
Message-ID: <477F20668A386D41ADCC57781B1F70430F44C59418@SC-VEXCH1.marvell.com> (sfid-20130923_211930_848303_CA403A93)
References: <1379715667-22424-1-git-send-email-bzhao@marvell.com>
 <18678858-E711-43E5-AFE6-E637D1CECFFB@holtmann.org>
In-Reply-To: <18678858-E711-43E5-AFE6-E637D1CECFFB@holtmann.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

> > -	btmrvl_send_module_cfg_cmd(priv, MODULE_BRINGUP_REQ);
> > +	hdev->setup = btmrvl_setup;
> 
> just to make sure you guys understand how ->setup() works. It is only called once. Bringing the
> adapter down and up again does not call ->setup() a second time. So do you guys need this setup_done
> variable and if so, then you need to be a bit more verbose and help me understand why.

It's observed that sometimes the setup handler is called twice when Bluetooth daemon is running in background. We will rebase to latest commit on bluetooth-next tree and test again. If the issue is gone with the latest code in -next tree we will remove the setup_done flag.

Thanks,
Bing


