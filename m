Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-68.dex002.intermedia.net ([64.78.20.34]:43066 "EHLO
	DHOST002-68.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754460AbXEIP2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2007 11:28:40 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Wed, 9 May 2007 08:28:55 -0700
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: fail back to use associate from reassociate
Message-ID: <20070509152855.GB941@devicescape.com>
References: <20070509054152.GA30839@mail.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070509054152.GA30839@mail.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 09, 2007 at 01:41:52PM +0800, Zhu Yi wrote:

> mac80211: fail back to use associate from reassociate failure
> 
> Some APs have strict checking between associate and reassociate. In
> a case when an AP is restarted during a connection, it denies the
> mac80211 reassoc request since this is a new association for the AP.
> To fix this problem, we need to check the status code against
> WLAN_STATUS_REASSOC_NO_ASSOC and clear ifsta->prev_bssid_set in
> handling the association failure response.

Can you please identify such an AP? This sounds like a workaround that
makes the non-AP STA (client) behave in a way that does not match with
IEEE 802.11 standard and in general, I'm against this change without a
very good reason for it. This type of change would, e.g., break IEEE
802.11r fast transition which can only be done using reassociation.

-- 
Jouni Malinen                                            PGP id EFC895FA
