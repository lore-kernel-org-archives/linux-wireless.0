Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:13649 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965540AbXC1Rzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 13:55:42 -0400
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and   association
From: mohamed <mabbas@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1175073257.5151.27.camel@johannes.berg>
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
	 <1175073257.5151.27.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 22:56:08 -0700
Message-Id: <1175147768.4237.1.camel@dell-4965.jf.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-03-28 at 11:14 +0200, Johannes Berg wrote:
> On Mon, 2007-03-26 at 04:38 -0700, mohamed wrote:
> 
> > +	/* Get ht capabilities from the device */
> > +	int (*get_ht_capab)(struct ieee80211_hw *hw,
> > +			    struct ieee80211_ht_capability *ht_cap_param);
> > +
> 
> Does this really need to return an error? And if so, what happens? You
> currently send a blank HT capabilities IE but I think in that case it
> should be left out completely. But I don't think it will ever return an
> error, it doesn't even need to allocate memory. Just change this to
> void?
> 
> johannes
Since we are setting the structure to all 0 before calling the function
I guess it is safe to change the function to return void. I will
resubmit the patch with that fix
Mohamed
