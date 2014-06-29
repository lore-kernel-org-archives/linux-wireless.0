Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mdfmta010.mxout.tch.inty.net ([91.221.169.51]:38510 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751558AbaF2RXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 13:23:12 -0400
Received: from smtp.demon.co.uk (unknown [127.0.0.1])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mdfmta010.tch.inty.net (Postfix) with ESMTP id 04F9B400C96
	for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2014 18:15:52 +0100 (BST)
Received: from mdfmta004.tch.inty.net (unknown [127.0.0.1])
	by mdfmta004.tch.inty.net (Postfix) with ESMTP id DFECBAC40A6
	for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2014 18:15:29 +0100 (BST)
Received: from mdfmta004.tch.inty.net (unknown [127.0.0.1])
	by mdfmta004.tch.inty.net (Postfix) with ESMTP id BC04CAC408F
	for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2014 18:15:29 +0100 (BST)
Received: from [192.168.0.7] (unknown [80.176.227.157])
	by mdfmta004.tch.inty.net (Postfix) with ESMTP
	for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2014 18:15:28 +0100 (BST)
Message-ID: <53B049A3.7000803@dpets.co.uk> (sfid-20140629_192316_237097_2AFC0D41)
Date: Sun, 29 Jun 2014 18:15:15 +0100
From: John Talbut <jt@dpets.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Firmware loading with static kernel and initramfs
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There seems to be a general problem when using a static kernel and 
initramfs in that the wireless drivers try to load firmware before the 
disks are mounted and the /lib/firmware folder is available.  Various 
people seem to have come across problems with firmware not loading, some 
of which seem to relate to this problem, which they have approached as 
if it is a problem with their particular driver.  However it seems to be 
a general problem and I have had it with three different drivers.

There seems to be a number of possible approaches to this: loading the 
firmware in an initramfs; changing the sequence in which wireless 
drivers start so that they wait until the disks are mounted; compiling 
the firmware into the kernel and loading the firmware as part of ifup. 
I see that the latter has been done for one driver 
(http://thread.gmane.org/gmane.linux.kernel.wireless.general/3390).

What is the current situation with this problem and what needs doing?
