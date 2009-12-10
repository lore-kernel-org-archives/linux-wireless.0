Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5397 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762049AbZLJWtp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 17:49:45 -0500
Subject: Re: [PATCH 0/7] iwlwifi updates 12/10/2009
From: reinette chatre <reinette.chatre@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20091210.144239.110141276.davem@davemloft.net>
References: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
	 <20091210.144239.110141276.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 10 Dec 2009 14:49:52 -0800
Message-Id: <1260485392.25564.6308.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-12-10 at 14:42 -0800, David Miller wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> Date: Thu, 10 Dec 2009 14:37:20 -0800
> 
> > In this series we also include support for the new mac80211 spatial
> > multiplexing support.
> 
> No more new features for 2.6.33, sorry.
> 
> Only bug fixes at this time.

Absolutely - the feature you quoted was not intended for 2.6.33 ...
especially since the mac80211 API it relies on is not there either.

The series I posted included both fixes for 2.6.33 and features for
2.6.34. The one you quoted is a feature for 2.6.34.

I tried to be clear in the fixes we target for 2.6.33 by clearly
mentioning them in the commit message like so:

On Thu, 2009-12-10 at 14:37 -0800, Chatre, Reinette wrote:
> This series includes three fixes targeting 2.6.33:
> - "iwlwifi: power up all devices for EEPROM read" fixes a issue where
> devices are unable to be initialized on certain platforms due to too
> aggressive power savings.
> - "iwlwifi: allocated rx page accounting cleanup" fixes some accounting
> issues in the recent paged RX work
> - "iwlwifi: fix syslog message for event log dump size" fixes the problem
> where the entire debug log was not printed when requested by user
> 

... and also annotating the Subject line of the fixes like so:

[PATCH X/XX w-t and 2.6.33] iwl.....

With the above I hoped to make it clear that the patch is targeting both
wireless-testing (for 2.6.34) and 2.6.33 as a fix. Patches targeting
2.6.34 do not have special "tags" after "PATCH". 

This is the way we have been submitting patches for a long time now.
Sorry that I introduced confusion now ... perhaps I should submit fixes
and features in separate series to prevent this in the future.

Reinette


