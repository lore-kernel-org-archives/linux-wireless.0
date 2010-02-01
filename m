Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49766 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab0BAUAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 15:00:39 -0500
Date: Mon, 1 Feb 2010 14:47:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Zhao, Shanyu" <shanyu.zhao@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/1] cfg80211: wext: set bssid to NULL in SIOCIWESSID
Message-ID: <20100201194748.GC4952@tuxdriver.com>
References: <1264808376-8003-1-git-send-email-shanyu.zhao@intel.com> <1264840626.3546.181.camel@johannes.local> <380B2771CDD78E46856E6B788D9F199750233886@orsmsx503.amr.corp.intel.com> <1265052460.29119.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1265052460.29119.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 01, 2010 at 08:27:40PM +0100, Johannes Berg wrote:
> On Mon, 2010-02-01 at 10:57 -0800, Zhao, Shanyu wrote:
> > Actually I don't think my patch disables that functionality. If
> > there're multiple AP with the same essid "foo" and one of them has MAC
> > "00:...:ff", then:
> > 
> > iwconfig wlan0 essid "foo"
> > This will make the station associate with the first AP with essid
> > "foo".
> > 
> > iwconfig wlan0 ap "00:...:ff"
> > This will disassociate from the previous AP, and then associate with
> > the first AP with MAC "00:...:ff".
> > 
> > Am I missing anything here?
> 
> No, I missed something. The problem will only occur when the SSID is
> hidden as well, because the connect code will not have the SSID and not
> know what to scan for, or which SSID to choose (there are Cisco APs that
> use the same BSSID for multiple hidden SSIDs).

Well, in the confusion I deleted the original post.  Could you
(i.e. Shanyu Zhao) resend it to me?

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
