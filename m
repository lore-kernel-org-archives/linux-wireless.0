Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:60973 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757192AbXD0UVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 16:21:39 -0400
Message-ID: <46325B51.7090506@lwfinger.net>
Date: Fri, 27 Apr 2007 15:21:37 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Wireless rates with mac80211
References: <462F9617.8010207@lwfinger.net> <20070427221153.7ecc04de@griffin.suse.cz>
In-Reply-To: <20070427221153.7ecc04de@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> 
> If you have debugfs compiled in, you can look into
> <debugfs_mount_point>/ieee80211/phy0/stations/*/rc_simple_tx_avg_rate_[ns]um.
> But that's just average.

Jiri,

Thanks for the info. I'm using txrate in the sta_info struct, which is an index into the rates 
array. That turned out to be very useful as I discovered that rc80211_simple was setting the initial 
rate to 54 Mbs. I have some doubt if that rate is best under any circumstance, but it certainly is 
not for bcm43xx as the current issues with TX power do not allow transmission at that rate. By 
setting the initial rate to 1 Mbs, I was able to connect for the first time with my BCM4311.

Larry
