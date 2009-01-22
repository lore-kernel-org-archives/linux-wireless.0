Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44717 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZAVQvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 11:51:24 -0500
From: "Abbas, Mohamed" <mohamed.abbas@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Date: Thu, 22 Jan 2009 08:51:19 -0800
Subject: RE: [PATCH 1/2 v2.6.29] iwlwifi: fix rs_get_rate WARN_ON()
Message-ID: <26E9B811E137AB4B95200FD4C950886B1C8F7AC9@orsmsx507.amr.corp.intel.com> (sfid-20090122_175130_402067_FCF235DE)
References: <> <1232564283-18008-1-git-send-email-reinette.chatre@intel.com>
	 <1232564283-18008-2-git-send-email-reinette.chatre@intel.com>
	 (sfid-20090121_195542_734853_62E08E0F)
 <1232621853.30174.19.camel@johannes.local>
In-Reply-To: <1232621853.30174.19.camel@johannes.local>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



-----Original Message-----
From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: Thursday, January 22, 2009 2:58 AM
To: Chatre, Reinette
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; ipw3945-devel@lists.sourceforge.net; Abbas, Mohamed
Subject: Re: [PATCH 1/2 v2.6.29] iwlwifi: fix rs_get_rate WARN_ON()

On Wed, 2009-01-21 at 10:58 -0800, Reinette Chatre wrote:
> From: Abbas, Mohamed <mohamed.abbas@intel.com>
> 
> In ieee80211_sta structure there is u64 supp_rates[IEEE80211_NUM_BANDS]
> this is filled with all support rate from assoc_resp.  If we associate
> with G-band AP only supp_rates of G-band will be set the other band
> supp_rates will be set to 0. If the user type this command
> this will cause mac80211 to set to new channel, mac80211
> does not disassociate in setting new channel, so the active
> band is now A-band. then in handling the new essid mac80211 will
> kick in the assoc steps which involve sending disassociation frame.
> in this mac80211 will WARN_ON sta->supp_rates[A_BAND] == 0.

Sounds like we should fix mac80211 to disassociate _before_ switching
the channel? It won't help anyway if we're on another channel?
[mabbas] 
I totally agree, all the disassociation frame will happen in the new channel that AP wont hear.
Mohamed

johannes
