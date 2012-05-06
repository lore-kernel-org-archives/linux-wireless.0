Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:38650 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab2EFQbH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 12:31:07 -0400
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SR4MS-0001Zs-KS
	for linux-wireless@vger.kernel.org; Sun, 06 May 2012 18:31:04 +0200
Received: from localhost ([::1]:56430 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SR4MS-0008GH-Gd
	for linux-wireless@vger.kernel.org; Sun, 06 May 2012 18:31:04 +0200
Received: from [195.4.92.19] (port=48283 helo=9.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SR4KO-0007Ep-BW
	for linux-wireless@vger.kernel.org; Sun, 06 May 2012 18:28:56 +0200
Received: from [2002:4fde:aad:2:5054:ff:feb8:40bd] (port=57643 helo=mail.maya.org)
	by 9.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SR4KO-0007BD-2q
	for linux-wireless@vger.kernel.org; Sun, 06 May 2012 18:28:56 +0200
Message-ID: <4FA6A6C2.50102@01019freenet.de> (sfid-20120506_183111_602798_8CEF8663)
Date: Sun, 06 May 2012 18:28:50 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
CC: linux-wireless@vger.kernel.org,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt28xx: Revert eccc068e8e84c8fe997115629925e0422a98e4de
 which causes txpower to be stuck at 0
References: <20120506153806.GF2774@yumi.tdiedrich.de>
In-Reply-To: <20120506153806.GF2774@yumi.tdiedrich.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Tobias,

Tobias Diedrich wrote:
> Revert eccc068e8e84c8fe997115629925e0422a98e4de which causes txpower
> to be stuck at 0.
> 
> Recent OpenWRT has txpower stuck at 0 for at least rt28xx, and I
> found this commit as the root cause:
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commitdiff;h=eccc068e8e84c8fe997115629925e0422a98e4de
> 
> Before reverting this "iw phy phy0 info" would show "0.0 dBm" as
> maximum transmit power for all frequencies.
> 
> After reverting this (and with regdomain set to CH) it is back to
> the expected 20 dBm.

I can confirm this, too (rt2800pci|usb).


Thanks,
kind regards,
Andreas
