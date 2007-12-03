Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50174 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbXLCGV3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 01:21:29 -0500
Subject: Re: [PATCH] iwlwifi: delay firmware loading from pci_probe to
	network interface open
From: Zhu Yi <yi.zhu@intel.com>
To: Ian Schram <ischram@telenet.be>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomasw@gmail.com>, Ben Gamari <ben@mw0.ath.cx>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <47532F45.9020508@telenet.be>
References: <1196327913-24715-1-git-send-email-yi.zhu@intel.com>
	 <47532F45.9020508@telenet.be>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 14:21:29 +0800
Message-Id: <1196662889.3109.27.camel@debian.sh.intel.com> (sfid-20071203_062134_934608_EF35D4F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sun, 2007-12-02 at 23:18 +0100, Ian Schram wrote:
> 
> The main problem was:
> pci_save/restore_state() wasn't being called when the device was
> disabled in pci_probe to save power. which meant that when it was
> reenabled it had no idea about the dma and hence the card would
> seemingly never wake up, seeing as no init_alive_resp would be
> received
> 
> secondary problems:
> 1) additionally the code should not have dereferenced a null pointer.
> This
> happened in mac80211 because the failure was hidden and null was
> returned
> in ops->start
> 
> 2) when the ops->start failed, the irq was registered, but never
> freeded because
> ops->close wouldn't be called. i added a bit of error handling in the
> function
> and pulled enable/disbale msi there because i was having additional
> oopses when testing
> but i think they might be redundant. I figured it made sense to keep
> these two events
> together though
> 
> 3) there was an inconsistency in iwl*_mac_stop
> the if condition was ones checked for falseness in 3945 and for
> trueness in 4965
> i believe 4965 code was right so i altered it in the 3945 code

The patch is correct. I also add pci_save_state in ops->stop in case the
interface is up and down multiple times. I also move iwl_down() from the
branch so that it will be called in ops->stop anyway in case we don't
clean up the h/w state in some rare cases. Fixed a typo also for 4965.

Thanks for the patch! It's in the GIT tip now.
http://intellinuxwireless.org/repos/?p=iwlwifi.git;a=commitdiff;h=523a55dd0f182f3aa8534d25398832d71d61c655

-yi
