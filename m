Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from namei.org ([69.55.235.186]:45466 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756142AbXISJWa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 05:22:30 -0400
Date: Wed, 19 Sep 2007 02:22:21 -0700 (PDT)
From: James Morris <jmorris@namei.org>
To: linux-wireless@vger.kernel.org
cc: fabrice@bellet.info
Subject: Problem with Cisco MPI350/airo
Message-ID: <Xine.LNX.4.64.0709190051080.29334@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've got an x31 thinkpad with an MPI350 card, which has worked more or 
less reliably for several years.

With current git and Fedora kernels, the wireless dies some time after 
boot, with the following types of messages ending up in syslog:

Sep 19 16:36:32 localhost kernel: airo(eth0): cmd:1 status:7f21 rsp0:21 rsp1:0 rsp2:2eab
Sep 19 16:36:32 localhost kernel: airo(eth0): Bad MAC enable reason=21, rid=0, offset=11947
Sep 19 16:36:33 localhost kernel: airo(eth0): cmd:2 status:7f02 rsp0:0 rsp1:0 rsp2:2eab
Sep 19 16:36:33 localhost kernel: airo(eth0): cmd:1 status:7f01 rsp0:2 rsp1:0 rsp2:2eab
Sep 19 16:36:33 localhost kernel: airo(eth0): Bad MAC enable reason=2, rid=0, offset=11947
Sep 19 16:36:33 localhost kernel: airo(eth0): cmd:3 status:7f03 rsp0:0 rsp1:0 rsp2:2eab

NetworkManager seems to lose contact with the card, then fails & asks for 
a new key (which it doesn't actually need).

Sep 19 16:37:03 localhost NetworkManager: <info>  Activation 
(eth0/wireless): association took too long (>20s), asking for
 new key. 

Anyone seen this before, and/or know what's happening ?


- James
-- 
James Morris
<jmorris@namei.org>
