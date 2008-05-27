Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:36881 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbYE0RVY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 13:21:24 -0400
Date: Tue, 27 May 2008 20:20:33 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 1/1] mac80211: sends HT IE to user level through wext
Message-ID: <20080527172032.GN4932@jm.kir.nu> (sfid-20080527_192127_892648_5E3CD491)
References: <1211907611-27979-1-git-send-email-tomas.winkler@intel.com> <1211907892.3930.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1211907892.3930.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2008 at 07:04:52PM +0200, Johannes Berg wrote:

> I'm fine with this, but I'm wondering if maybe we should just pass out
> the whole IE area of the beacon/probe response?

I would prefer to get all IEs in one blob (assuming WEXT does not have
length limits on this data that could be up to about 2250 bytes long).
This would avoid need to add new IEs one by one in the future (e.g., for
IEEE 802.11r).

wpa_supplicant should be able to combine multiple IEs (or even multiple
IE groups) together, so I'm not too concerned of this being done
separately, but in general, it would be simpler to just pass all IEs as
a single blob. It might even be worthwhile to start storing the IEs as a
single buffer and have helper functions to fetch pointer to the
beginning of whatever IE is needed in the MLME code (this is how the
current wpa_supplicant processes IEs from scan results).

-- 
Jouni Malinen                                            PGP id EFC895FA
