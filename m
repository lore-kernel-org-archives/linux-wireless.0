Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab0AaKbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2010 05:31:19 -0500
Subject: RE: [PATCH 1/1 v3] cfg80211: wext: fix cfg80211's SIOCSIWAP
 function
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Shanyu" <shanyu.zhao@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <380B2771CDD78E46856E6B788D9F199750162F62@orsmsx503.amr.corp.intel.com>
References: <1264801649-4985-1-git-send-email-shanyu.zhao@intel.com>
	 <1264840545.3546.179.camel@johannes.local>
	 <1264841037.3546.183.camel@johannes.local>
	 <380B2771CDD78E46856E6B788D9F199750162F62@orsmsx503.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Jan 2010 11:31:12 +0100
Message-ID: <1264933872.3597.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-01-30 at 21:24 -0800, Zhao, Shanyu wrote:
> Yes, that's exactly what I tried to do. From what I read from the man
> page of iwconfig, I thought iwconfig wlanx ap <mac> should be enough
> to connect to an ap without specifying the essid. Maybe I didn't
> understand the correct usage of iwconfig.
> 
> However, one of our test cases failed because of this:
> Steps to Reproduce: 
> 1. set up the SSID name with Open/None in AP
> 2. reload the driver
> 3. interface up
> 4. send the command 'iwconfig wlan0 ap <MAC address of the AP>
> 
> Expected Results:
> the association is established successfully.

Fun, so you ran into one of the few things we don't (want to) support.
And to be honest, I don't think there's a good reason to support it; for
example this would never connect to a hidden SSID network.

johannes

