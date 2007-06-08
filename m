Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33028 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933212AbXFHBfR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 21:35:17 -0400
Subject: Re: [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
From: Zhu Yi <yi.zhu@intel.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070607223058.44122be4@griffin.suse.cz>
References: <20070606082210.GA28649@mail.intel.com>
	 <20070607223058.44122be4@griffin.suse.cz>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 09:34:37 +0800
Message-Id: <1181266477.3039.97.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-06-07 at 22:30 +0200, Jiri Benc wrote:
> > +#define SET_TSINFO_SCHEDULE(i, d)	(i.byte3 |= (d << 0) & 0x01)
> 
> Please add IEEE80211_ prefix here as well. For consistency and not
> polluting a name space.

Point accepted.

> > +enum wifi_oui_stype_wmm {
> > +	WIFI_OUI_STYPE_WMM_INFO = 0,
> > +	WIFI_OUI_STYPE_WMM_PARAM = 1,
> > +	WIFI_OUI_STYPE_WMM_TSPEC = 2,
> > +};
> 
> Please don't invent new useless prefixes. Also, a registered trademark
> doesn't seem to be a good prefix.

I think we have talked this early and now you know correctly WIFI is not
a trademark. You define IEEE80211_STYPE_ASSOC_REQ, etc, but defines
those for Wi-Fi with WLAN prefix? WLAN prefix should be used by symbols
defined by mac80211, for example: WLAN_CAPABILITY_ESS.

Thanks,
-yi
