Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:56130 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755396AbZFWLrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 07:47:13 -0400
Date: Tue, 23 Jun 2009 13:49:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH 1/2 RFC] cfg80211: connect/disconnect API
Message-ID: <20090623114917.GB5349@sortiz.org>
References: <20090622170409.GB30147@sortiz.org> <1245697719.4184.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1245697719.4184.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 22, 2009 at 09:08:39PM +0200, Johannes Berg wrote:
> On Mon, 2009-06-22 at 19:04 +0200, Samuel Ortiz wrote:
> 
> >  /**
> > + * struct cfg80211_connect_params - Connection parameters
> > + *
> > + * This structure provides information needed to complete IEEE 802.11
> > + * authentication and association.
> > + *
> > + * @channel: The channel to use or %NULL if not specified (auto-select based
> > + *	on scan results)
> > + * @bssid: The AP BSSID or %NULL if not specified (auto-select based on scan
> > + *	results)
> > + * @ssid: SSID
> > + * @ssid_len: Length of ssid in octets
> > + * @auth_type: Authentication type (algorithm)
> > + * @assoc_ie: IEs for association request
> > + * @assoc_ie_len: Length of assoc_ie in octets
> > + * @control_port: Whether user space controls IEEE 802.1X port, i.e.,
> > + *	sets/clears %NL80211_STA_FLAG_AUTHORIZED. If true, the driver is
> > + *	required to assume that the port is unauthorized until authorized by
> > + *	user space. Otherwise, port is marked authorized by default.
> 
> One question I just had -- if bssid is NULL, and the card selects the
> BSSID, I suppose it will also roam by itself if it can [1]. Don't we
> need a "roamed" event for that then, even if we're not yet adding a
> ->roam() call?
I guess userspace will get 2 events: a disconnect one and then a connect one.
Not exactly a "roamed" event though, I agree.

Cheers,
Samuel.

 
> johannes
> 
> [1] yes, we need to have a way to export roaming capabilities of the
> card to user space



-- 
Intel Open Source Technology Centre
http://oss.intel.com/
