Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jaguar.aricent.com ([180.151.2.24]:55621 "EHLO
	jaguar.aricent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0LPGvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 01:51:51 -0500
Received: from jaguar.aricent.com (localhost [127.0.0.1])
	by postfix.imss71 (Postfix) with ESMTP id 3918136B30
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 10:58:52 +0530 (IST)
Received: from GUREXHT02.ASIAN.AD.ARICENT.COM (gurexht02.asian.ad.aricent.com [10.203.171.138])
	by jaguar.aricent.com (Postfix) with ESMTP id 237B336B2D
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 10:58:52 +0530 (IST)
From: Saurabh8 Jain <saurabh8.jain@aricent.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 16 Dec 2010 11:01:07 +0530
Subject: Netlink Memory Leak Issue
Message-ID: <B659B0EE7F1D5A499E4A4BEB0BECBA2518292B3D21@GUREXMB01.ASIAN.AD.ARICENT.COM>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I would like to know the memory usage that happens between user space and kernel space communication. Communication happens via generic netlink library and we need to register doit and dump functions.

I was going through function "nl80211_set_mesh_params" in "net/wireless/nl80211.c" which receives values of mesh parameters. In this function skb is passed but it is never used and the skb is not freed. I saw other functions also which receives messages from user space but no memory is released for skb.

Where is this memory getting free? Do I need to free this memory?

When I executed iw commands to set few values in loop.  I saw there is drop in free memory of "top" command. I am working on compatwireless-2010-06-27.


Thanks,
Saurabh Jain

"DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
