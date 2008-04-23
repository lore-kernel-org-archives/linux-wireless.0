Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2840 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbYDWVaP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 17:30:15 -0400
Date: Wed, 23 Apr 2008 16:47:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Lars Ericsson <Lars_Ericsson@telia.com>,
	"'Johannes Berg'" <johannes@sipsolutions.net>,
	hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Subject: Re: Roaming problems
Message-ID: <20080423204704.GA30048@tuxdriver.com> (sfid-20080423_233052_982365_6E64AAEF)
References: <004201c8a55e$f4668f10$0b3ca8c0@gotws1589> <1208968274.24395.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1208968274.24395.10.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 23, 2008 at 12:31:14PM -0400, Dan Williams wrote:
> On Wed, 2008-04-23 at 18:27 +0200, Lars Ericsson wrote:

> > The root problem is that the drive start associate when any of the
> > ieee80211_ioctl_siwgenie()
> > ieee80211_ioctl_siwessid() and ieee80211_ioctl_siwap() is called.
> > If the wpa_supplicant need call more than one of them the association start
> > to early.
> 
> When either SIWESSID or SIWAP is called, the driver should restart
> association using the latest settings sent by the supplicant.  So by the
> end of the GENIE -> SSID -> BSSID call chain, the driver should have
> everything it needs to associate, and should restart association with
> those parameters.

I'm not disputing that as a reasonable approach.  But FWIW for two
years we've been saying it is OK for drivers to use setting SSID as
the only trigger for association.  Is that not your understanding?

Clearly we need to get rolling on doing associations through nl80211...

John
-- 
John W. Linville
linville@tuxdriver.com
