Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50754 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899AbXKTQoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 11:44:22 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] mac80211: hardware scan rework (V2)
Date: Tue, 20 Nov 2007 08:37:57 -0800
Message-ID: <4220499A1B034C4FA93B547BA01E1FF00174649C@orsmsx413.amr.corp.intel.com> (sfid-20071120_164428_671023_639C3CA2)
In-Reply-To: <1195576182.10920.54.camel@johannes.berg>
References: <119553601948-git-send-email-yi.zhu@intel.com> <1195566632.10920.39.camel@johannes.berg> <4220499A1B034C4FA93B547BA01E1FF001746499@orsmsx413.amr.corp.intel.com> <1195576182.10920.54.camel@johannes.berg>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Zhu, Yi" <yi.zhu@intel.com>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 

> -----Original Message-----
> From: Johannes Berg [mailto:johannes@sipsolutions.net] 
> Sent: Tuesday, November 20, 2007 11:30 AM
> To: Cahill, Ben M
> Cc: Zhu, Yi; linville@tuxdriver.com; 
> linux-wireless@vger.kernel.org; Abbas, Mohamed
> Subject: RE: [PATCH] mac80211: hardware scan rework (V2)
> 
> 
> > The firmware-driven scan on 4965 (3945 also) returns to the 
> original 
> > channel by itself. [...]
> 
> Right. Thanks for the description.
> 
> > Once done with the list, the scan engine returns to the service 
> > channel automatically.  While it *might* work okay to 
> change or reset 
> > that channel, it is not necessary, and might be asking for trouble.
> 
> Well, in the patch right now the channel the user sets will 
> be completely ignored because the scan_finished thing doesn't 
> reconfigure the hardware as it should.
> 
> Since the user has an expectation that the working channel is 
> changed after setting it with the ioctl, the code should make 
> sure. Since hw scanning is mostly transparent to mac80211, 
> the ioctl should imho be passed to the driver right away. If 
> there's a problem with setting it to the hardware directly, 
> the driver can cache it for until the firmware scan finished, 
> but I don't think we should do that in mac80211. It has to be 
> done somewhere though and just ignoring the setting is wrong.

I see ... thanks, I didn't quite understand the context.  Agreed, if the
user says to do something, we should not throw it on the floor.

-- Ben --

> 
> johannes
> 
