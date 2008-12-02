Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:54670 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbYLBQrz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 11:47:55 -0500
Subject: Re: [PATCH] iwlwifi: disable AP mode
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1228153827.10627.25.camel@johannes.berg>
References: <1228153827.10627.25.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 08:48:49 -0800
Message-Id: <1228236529.10900.46.camel@rc-desk> (sfid-20081202_174808_212038_715C66F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-01 at 09:50 -0800, Johannes Berg wrote:
> iwlwifi does not support AP mode in any way. For one, it doesn't even
> buffer multicast/broadcast frames properly. We didn't allow zd1211rw AP
> mode to be enabled without this, so iwlwifi shouldn't be allowed to
> advertise AP mode either.
> 
> It also doesn't work at all, it doesn't even answer to probe requests,
> I'm guessing the packet injection code was disabled again.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> FYI, I've also tested AP mode on iwl5000 and it most definitely does not
> work properly:
> 
> [  471.524478] iwlagn: ERROR: APs don't scan
> 
> this is a long-standing bug, of course APs scan to know their
> surroundings, not sure why this is there, it's also very pointless since
> I can remove it by enabling software scan...
> 
> [  487.507346] iwlagn: Microcode SW error detected.  Restarting 0x2000000.
> 
> apparently even the microcode doesn't like AP mode :) Note that I've
> done nothing out of the ordinary, just started hostapd.
> 
> Once somebody cares to fix the code these two lines can be put back
> easily, I haven't ripped out the actual support code. But when you do
> please test with PS clients and multicast traffic.
> 
>  drivers/net/wireless/iwlwifi/iwl-core.c     |    1 -
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
>  2 files changed, 2 deletions(-)
> 

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


