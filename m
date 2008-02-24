Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xyz.pp.se ([212.31.160.244]:62638 "EHLO xyz.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbYBXVNi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 16:13:38 -0500
Received: from localhost (localhost [127.0.0.1])
	by xyz.pp.se (Postfix) with ESMTP id ACD951CC012
	for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2008 22:04:26 +0100 (CET)
Received: from xyz.pp.se ([127.0.0.1])
	by localhost (xyz.pp.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xvtcsDurDGs4 for <linux-wireless@vger.kernel.org>;
	Sun, 24 Feb 2008 22:04:14 +0100 (CET)
Received: from [10.0.0.97] (hbg-112-76-233-83.3.cust.bredband2.com [83.233.76.112])
	by xyz.pp.se (Postfix) with ESMTP id 637FC1CC010
	for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2008 22:04:14 +0100 (CET)
Subject: 'make unload' fails if you run Ubuntu Hardy
From: Thomas Novin <thnov@xyz.pp.se>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sun, 24 Feb 2008 21:34:39 +0100
Message-Id: <1203885279.7537.1.camel@pc-thnov-ubuntu> (sfid-20080224_211343_740879_5A3C3747)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

I have just installed the latest compat-wireless system and 'make
unload' failed for me.

thnov@pc-thnov-ubuntu:~/src/compat-wireless-2.6$ sudo make unload
Unloading iwl3945...
Unloading mac80211...
Unloading cfg80211...
FATAL: Module cfg80211 is in use.
make: *** [unload] Error 1
thnov@pc-thnov-ubuntu:~/src/compat-wireless-2.6$ lsmod | grep iwl
iwlwifi_mac80211      220004  0
cfg80211               15112  1 iwlwifi_mac80211
thnov@pc-thnov-ubuntu:~/src/compat-wireless-2.6$ sudo modprobe -r
iwlwifi_mac80211
thnov@pc-thnov-ubuntu:~/src/compat-wireless-2.6$ sudo make unload
thnov@pc-thnov-ubuntu:~/src/compat-wireless-2.6$ 
 
So by manually unloading iwlwifi_mac80211 I managed to get past this.

Rgds,

Thomas

Ps. I'm not on the list.

