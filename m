Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3495 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbYEMTVB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 15:21:01 -0400
Date: Tue, 13 May 2008 14:54:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] mac80211 : Association with 11n hidden ssid ap.
Message-ID: <20080513185429.GA11756@tuxdriver.com> (sfid-20080513_212106_675759_B87C8D20)
References: <12103509413156-git-send-email-abhijeet.kolekar@intel.com> <1210641995.2506.200.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1210641995.2506.200.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2008 at 09:26:35AM +0800, Zhu Yi wrote:
> On Fri, 2008-05-09 at 09:35 -0700, Abhijeet Kolekar wrote:
> > This patch fixes the association problem with 11n hidden ssid ap.
> > Patch fixes the problem of associating with hidden ssid when
> > all three parameters ap,essid and channel are given to iwconfig.
> > This patch removes the condition of checking three parameters
> > and always checks for bss in bss list while associating.
> 
> Johannes, can you please take a look at this patch? The original code
> looks like a shortcut to start authentication/association when all the
> three parameters (BSSID/SSID/CHANNEL) are provided. But this is not
> sufficient in the case of associate with an 11N hidden SSID AP. The 11n
> and wmm information must be retrieved by an active probe request. Not
> doing so will cause the 11N AP refuse to associate with the client.

I'll ACK this based on the above explanation and because I don't
think it will do any harm. :-)

John
-- 
John W. Linville
linville@tuxdriver.com
