Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:33429 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbXJJJJr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 05:09:47 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1IfXZX-0001hW-05
	for linux-wireless@vger.kernel.org; Wed, 10 Oct 2007 09:09:43 +0000
Received: from 80.169.182.16 ([80.169.182.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 09:09:42 +0000
Received: from marcus by 80.169.182.16 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 09:09:42 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: Re: rt2500pci 2.0.9 not working
Date: Wed, 10 Oct 2007 11:06:11 +0200
Message-ID: <fei4sd$mm0$1@sea.gmane.org> (sfid-20071010_100953_396055_10BC12ED)
References: <fdqhn4$qab$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcus Better wrote:

> I just tried the rt2500pci driver version 2.0.9 from the wireless-2.6
> tree. It does not work.

Neither does 2.0.10 from the current wireless-2.6 "everything" branch. I see scan results now but cannot associate with the access point using WEP.

Here are some logs:

Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - Start initialization from EEPROM...
Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - BBP: 0x0f, value: 0x30.
Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - BBP: 0x11, value: 0x26.
Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - BBP: 0x15, value: 0x18.
Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - BBP: 0x16, value: 0x18.
Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - BBP: 0x35, value: 0x10.
Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - BBP: 0x36, value: 0x10.
Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - BBP: 0x3d, value: 0x6a.
Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - BBP: 0x3e, value: 0x10.
Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - BBP: 0x23, value: 0x50.
Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - BBP: 0x29, value: 0x60.
Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - BBP: 0x36, value: 0x18.
Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - BBP: 0x3e, value: 0x00.
Oct 10 10:26:27 better kernel: phy0 -> rt2500pci_init_bbp: Debug - ...End initialization from EEPROM.
Oct 10 10:26:27 better kernel: phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 0 - CWmin: 5, CWmax: 10, Aifs: 2.
Oct 10 10:26:27 better kernel: phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 1 - CWmin: 5, CWmax: 10, Aifs: 2.
Oct 10 10:26:27 better kernel: phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 7 - CWmin: 6, CWmax: 10, Aifs: 2.
Oct 10 10:26:27 better kernel: wlan0: Initial auth_alg=0
Oct 10 10:26:27 better kernel: wlan0: authenticate with AP 00:14:6c:a7:60:10
Oct 10 10:26:27 better kernel: wlan0: RX authentication from 00:14:6c:a7:60:10 (alg=0 transaction=2 status=0)
Oct 10 10:26:27 better kernel: wlan0: authenticated
Oct 10 10:26:27 better kernel: wlan0: associate with AP 00:14:6c:a7:60:10
Oct 10 10:26:27 better kernel: wlan0: invalid aid value 0; bits 15:14 not set
Oct 10 10:26:27 better kernel: wlan0: RX AssocResp from 00:14:6c:a7:60:10 (capab=0x431 status=19 aid=0)
Oct 10 10:26:27 better kernel: wlan0: AP denied association (code=19)
Oct 10 10:26:27 better kernel: wlan0: associate with AP 00:14:6c:a7:60:10
Oct 10 10:26:27 better kernel: wlan0: invalid aid value 0; bits 15:14 not set
Oct 10 10:26:27 better kernel: wlan0: RX AssocResp from 00:14:6c:a7:60:10 (capab=0x431 status=19 aid=0)
Oct 10 10:26:27 better kernel: wlan0: AP denied association (code=19)
Oct 10 10:26:27 better kernel: wlan0: associate with AP 00:14:6c:a7:60:10
Oct 10 10:26:27 better kernel: wlan0: invalid aid value 0; bits 15:14 not set
Oct 10 10:26:27 better kernel: wlan0: RX AssocResp from 00:14:6c:a7:60:10 (capab=0x431 status=19 aid=0)
Oct 10 10:26:27 better kernel: wlan0: AP denied association (code=19)
Oct 10 10:26:27 better kernel: wlan0: association with AP 00:14:6c:a7:60:10 timed out

Thanks,

Marcus


