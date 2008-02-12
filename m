Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57467 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbYBLWBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 17:01:39 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: mac80211/iwl4965: ad-hoc broken in 2.6.25-rc1
Date: Tue, 12 Feb 2008 13:51:48 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003A461BF@orsmsx416.amr.corp.intel.com> (sfid-20080212_220154_289545_DE643DF5)
In-Reply-To: <47B1F422.4060501@scherping.de>
References: <47B1F422.4060501@scherping.de>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Richard Scherping" <richard@scherping.de>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Richard Scherping wrote:

> Hello list!
> 
> Sorry for this slightly off-topic post (as I have not tried
> the latest wirless-dev git version)...
> 
> When trying to set up an ad-hoc interface on iwl4965 (version
> 1.2.23 according to modinfo) on recently released kernel
> 2.6.25-rc1 it seems to work at first glance (accepts setting
> of channel and essid, starts beaconing and receives frames
> just fine) but the TX part does not work at all. Frames are
> shown in "tcpdump -i wlan0" but never make it into the air
> (checked with dedicated machine equipped with an Atheros card running
> in monitor mode). With 2.6.24 (iwl4965 version 1.1.17) everything
> worked fine. System is Debian Lenny amd64 on a Thinkpad T61p.
> 
> Unfortunately I do not have the time to debug this
> intensively, so any hints what to check first are welcome! Did
> something with the last big API change in mac80211 went wrong?

We have not done ad-hoc testing in the recent code. Any debugging you
can do will be greatly appreciated (anything interesting in your logs?).
Just to confirm the monitor mode is ok, can you confirm that your
monitoring machine can see data between a host and AP? We have seen some
problems with monitoring in iwlwifi so I would like to make sure.

Please load the driver with debugging (debug=0x43fff) and send us what
you see during data transmission. It may be useful to open a bug at
bughost.org at this point for us to keep track of the problem.

Thanks!

Reinette
