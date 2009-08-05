Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33142 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbZHEFjD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 01:39:03 -0400
Subject: Re: [PATCH] wireless: display wext SSID when connected by cfg80211
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1249450543.6902.1.camel@johannes.local>
References: <1249437950-8059-1-git-send-email-yi.zhu@intel.com>
	 <1249449590.4168.16.camel@johannes.local>
	 <1249450026.4069.111.camel@debian> <1249450543.6902.1.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 13:39:01 +0800
Message-Id: <1249450741.4069.114.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-08-05 at 13:35 +0800, Johannes Berg wrote:
> On Wed, 2009-08-05 at 13:27 +0800, Zhu Yi wrote:
> 
> > Yeah, I'm lazy to parse the current_bss.pub->information_elements for
> > SSID in the first instance. Should we implement some beacon parsing in
> > cfg80211 or move ieee802_11_parse_elems from mac80211?
> 
> There's ieee80211_bss_get_ie() in cfg80211, which doesn't give you the
> length/data in two separate values, but otherwise behaves pretty
> similarly. IOW, something like
> 
> const u8 *ssid = ieee80211_bss_get_ie(bss /* or &bss->pub */, WLAN_EID_SSID);
> if (ssid) {
> 	ssid_len = ssid[1];
> 	ssid_data = ssid + 2;
> }

Ah, I missed that. Will send out a patch.

Thanks,
-yi

