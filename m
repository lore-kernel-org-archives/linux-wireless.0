Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52745 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbZG3Srp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 14:47:45 -0400
Subject: Re: [PATCH] iwlwifi: don't export symbols not needed in other
 modules
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1248979011.23496.4.camel@johannes.local>
References: <1248947897.8925.13.camel@johannes.local>
	 <1248978482.1216.1087.camel@rc-desk>
	 <1248979011.23496.4.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 11:47:45 -0700
Message-Id: <1248979665.1216.1094.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-30 at 11:36 -0700, Johannes Berg wrote:
> On Thu, 2009-07-30 at 11:28 -0700, reinette chatre wrote:
> > Hi Johannes,
> > 
> > On Thu, 2009-07-30 at 02:58 -0700, Johannes Berg wrote:
> > > Even with the split into iwlcore/agn/3945 not all symbols
> > > that cross file boundaries are needed in other modules, a
> > > few are only used within iwlcore, for example.
> > 
> > I think in this case we need to be explicit when talking about "need"
> > and "used". Yes, some of these exported symbols are only used within a
> > module and this needs to be fixed. At the same time, some of these may
> > be needed outside, but are just not currently used. Examples of the
> > latter are: iwl_remove_station, iwl_rx_ant_restriction, and
> > iwl_send_card_state. I think this is especially important for
> > iwl_remove_station and iwl_rx_ant_restriction because their partners
> > (iwl_add_station and iwl_tx_ant_restriction) are exported and used and I
> > think it will be clean if they are also, even if they are not currently
> > used.
> 
> But they can easily be exported when used. That's done even for
> subsystem symbols, for instance some generic netlink stuff wasn't
> exported until it was needed in wimax.
> 
> Is there a problem with adding the export back whenever it's needed?

No. If this is what you want then I think you also need to remove
iwl_rx_ant_restriction.

Reinette


