Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g19.free.fr ([212.27.42.28]:51220 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbYGEKCQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 06:02:16 -0400
Received: from smtp2-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 8B1E212B6ED
	for <linux-wireless@vger.kernel.org>; Sat,  5 Jul 2008 12:02:14 +0200 (CEST)
Received: from [192.168.0.6] (cac94-1-81-57-151-96.fbx.proxad.net [81.57.151.96])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 66F1512B6E3
	for <linux-wireless@vger.kernel.org>; Sat,  5 Jul 2008 12:02:14 +0200 (CEST)
Message-ID: <486F46A7.4020105@free.fr> (sfid-20080705_120234_518879_E8AD5135)
Date: Sat, 05 Jul 2008 12:02:15 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [Fwd: airo with WPA support merge]
References: <4807C194.4040108@free.fr>
In-Reply-To: <4807C194.4040108@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 > To: prjmgr@linuxdriverproject.org
matthieu castet wrote:
> Hi,
> 
> I added wpa support to airo driver some years ago, but I maintain the 
> support as a OutOfTreeDrivers [1]. I use it everyday in wpa mode.
> 
> It can't be merged in main because the wpa support is selected by a 
> module option. I did this because supporting wpa and other mode together 
> may need a large rewrite of the driver (when I did first 
> experimentation, I got firmware hang if I mix wpa command that use a new 
> firmware API and wep command that use old firmware API).
> 
> 
> But they have been some work to make it ok for main Linux tree [2], but 
> it failed because of some issues [3].
> 
> I don't have time nor interest to continue the work made in [2].
> May be somebody is interested.
> 
> Matthieu
> 
> [1]
> https://gna.org/projects/airo-wpa/ and 
> http://svn.gna.org/viewcvs/airo-wpa/branches/kernel/
> 
> [2]
> http://svn.gna.org/viewcvs/airo-wpa/branches/kernel-merge/
> 
> [3]
> Dan Williams :
> One problem I have is that after setting the TKIP key, I always get a
> sequence of 3 bad MICs, and then the MAC sends a status of 0x8117 which
> causes the driver to send a disconnection event to userspace, which
> makes wpa_supplicant fail the connection.  If I comment out the 'goto
> badrx;' in the interrupt handler where the WPA mic is checked,
> everything works great and I can complete the 4-way handshake.  It needs
> more investigation, but do you have any thoughts on what might be going
> on here?
> 

