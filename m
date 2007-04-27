Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47705 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757203AbXD0U3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 16:29:10 -0400
Date: Fri, 27 Apr 2007 22:29:32 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Wireless rates with mac80211
Message-ID: <20070427222932.548519eb@griffin.suse.cz>
In-Reply-To: <46325B51.7090506@lwfinger.net>
References: <462F9617.8010207@lwfinger.net>
	<20070427221153.7ecc04de@griffin.suse.cz>
	<46325B51.7090506@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Apr 2007 15:21:37 -0500, Larry Finger wrote:
> Thanks for the info. I'm using txrate in the sta_info struct, which is an index into the rates 
> array. That turned out to be very useful as I discovered that rc80211_simple was setting the initial 
> rate to 54 Mbs. I have some doubt if that rate is best under any circumstance, but it certainly is 
> not for bcm43xx as the current issues with TX power do not allow transmission at that rate. By 
> setting the initial rate to 1 Mbs, I was able to connect for the first time with my BCM4311.

Rate control modules can be switched on-the-fly with mac80211. You can
write your own rc module that uses 1 mbps all times :-) Actually, I
wrote that module but haven't kept it up to date so it doesn't even
compile now...

 Jiri

-- 
Jiri Benc
SUSE Labs
