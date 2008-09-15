Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:56779 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbYIOLZG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 07:25:06 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KfCCV-00044v-9y
	for linux-wireless@vger.kernel.org; Mon, 15 Sep 2008 11:25:03 +0000
Received: from 220.227.207.12 ([220.227.207.12])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 11:25:03 +0000
Received: from pavan.k.pujari by 220.227.207.12 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 11:25:03 +0000
To: linux-wireless@vger.kernel.org
From: Pavan <pavan.k.pujari@gmail.com>
Subject: Channel scan during the AP re-association increases delay
Date: Mon, 15 Sep 2008 11:18:53 +0000 (UTC)
Message-ID: <loom.20080915T110100-223@post.gmane.org> (sfid-20080915_132524_401693_4106696E)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I am working on fast handovers to APs during roaming of wireless devices. I have
been looking through the mac80211 code to understand how the re-associations are
initiated in wireless STAs. To my surprise, I see that everytime I issue a
associate command using the `iwconfig' utility, it starts with scanning on all
channels collecting information from each AP in the ESSID set. Subsequently,
begins the authentication and association process. This results in large
re-association delays which is unacceptable to real time traffic like voice.

As I went through the code, I could trace that `hw->scan' is initiated before
authentication and association process. I could not figure the exact reason for
having a channel scan every time an association command is issued, instead it
could be done passively when the STAs are immobile or experiencing good channel
conditions (as one of the conditions). This way a lot of time could be saved
during roaming to bring down the total re-association delays. 

I would appreciate any help in this regard.

Thanks,
Pavan





