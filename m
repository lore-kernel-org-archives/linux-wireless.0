Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:40618 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbXK0DlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 22:41:14 -0500
Date: Mon, 26 Nov 2007 19:40:39 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: drago01 <drago01@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
Message-ID: <20071127034039.GC5698@jm.kir.nu> (sfid-20071127_034117_031655_FBA1BAF8)
References: <47494851.4070504@gmail.com> <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com> <1196079245.4149.255.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196079245.4149.255.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 26, 2007 at 01:14:04PM +0100, Johannes Berg wrote:

> That's weird. But why does it use ap_scan=2 to start with? With
> mac80211, ap_scan=1 is *much* much better because it lets wpa_supplicant
> control much of roaming, mac80211 really is designed that way.
> 
> I don't see why ap_scan=2 doesn't work though, can you enable some
> wpa_supplicant debugging and send me the logs?

Well, like you said, it was designed to work with ap_scan=1 and
actually, there was not even code for selecting the BSS in the original
version. Unless someone has added that functionality, it does not
work with ap_scan=2 which is only configuring the SSID, not BSSID, to
the driver.

-- 
Jouni Malinen                                            PGP id EFC895FA
