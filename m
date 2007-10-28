Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbXJ1FYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 01:24:45 -0400
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep
	network
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, dragoran <drago01@gmail.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1193320661.14136.10.camel@johannes.berg>
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
	 <1193127280.3069.261.camel@debian.sh.intel.com>
	 <1193148453.8648.20.camel@localhost.localdomain>
	 (sfid-20071023_150810_118446_E87EE8F5)  <1193161034.7733.38.camel@johannes.berg>
	 <1193238423.2557.41.camel@localhost.localdomain>
	 <1193318969.6092.19.camel@johannes.berg>
	 <1193320140.5542.11.camel@localhost.localdomain>
	 <1193320661.14136.10.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 28 Oct 2007 01:18:28 -0400
Message-Id: <1193548708.7779.10.camel@localhost.localdomain> (sfid-20071028_052454_129599_CFA1E010)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-10-25 at 15:57 +0200, Johannes Berg wrote:
> On Thu, 2007-10-25 at 09:49 -0400, Dan Williams wrote:
> 
> > Ok, I'll try to track it down starting with wpa_supplicant then.
> 
> If you have a network, it's probably as simple as putting a printk into
> the ioctl path and a printf into hostapd's conversion function to see
> what it returns.

This turned out to be a wpa_supplicant issue.  wpa_supplicant uses
KEY_MGMT_802_1X_NO_WPA (instead of KEY_MGMT_802_1X) to handle Dynamic
WEP where the AP doesn't broadcast WPA IEs (ie, a pure Dynamic WEP
network), and that value wasn't being handled correctly by
wpa_driver_wext_keymgmt2wext().

This has been fixed on the wpa_supplicant 0.6.x branch but not
backported to the 0.5.x branch yet.  Tested with EAP-TLS and LEAP with
iwl4965 on kernel-2.6.23.1-35.fc8.

For Fedora, I've built wpa_supplicant-0.5.7-15.fc8 to fix this issue.

Dan


