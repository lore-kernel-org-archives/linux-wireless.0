Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:42777 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3IXEYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 00:24:04 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v5 1/2] Bluetooth: btmrvl: add setup handler
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F44C59418@SC-VEXCH1.marvell.com>
Date: Tue, 24 Sep 2013 06:23:49 +0200
Cc: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <DF6283E3-8476-400F-A230-CB7CA0F98564@holtmann.org> (sfid-20130924_062411_691763_0FF1976A)
References: <1379715667-22424-1-git-send-email-bzhao@marvell.com> <18678858-E711-43E5-AFE6-E637D1CECFFB@holtmann.org> <477F20668A386D41ADCC57781B1F70430F44C59418@SC-VEXCH1.marvell.com>
To: Bing Zhao <bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

>>> -	btmrvl_send_module_cfg_cmd(priv, MODULE_BRINGUP_REQ);
>>> +	hdev->setup = btmrvl_setup;
>> 
>> just to make sure you guys understand how ->setup() works. It is only called once. Bringing the
>> adapter down and up again does not call ->setup() a second time. So do you guys need this setup_done
>> variable and if so, then you need to be a bit more verbose and help me understand why.
> 
> It's observed that sometimes the setup handler is called twice when Bluetooth daemon is running in background. We will rebase to latest commit on bluetooth-next tree and test again. If the issue is gone with the latest code in -next tree we will remove the setup_done flag.

that is a bug. It should only be ever called once. Could this be due to RFKILL issue we had? Please re-test with Johan's patches applied and check if it makes a difference. Otherwise please send some logs since we want to get this fixed.

Regards

Marcel

