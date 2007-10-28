Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:32879 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292AbXJ1Rhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 13:37:42 -0400
Date: Sun, 28 Oct 2007 10:36:10 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, Zhu Yi <yi.zhu@intel.com>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep
	network
Message-ID: <20071028173610.GM4936@jm.kir.nu> (sfid-20071028_173812_784616_1663B25F)
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com> <1193127280.3069.261.camel@debian.sh.intel.com> <1193148453.8648.20.camel@localhost.localdomain> <1193161034.7733.38.camel@johannes.berg> <1193238423.2557.41.camel@localhost.localdomain> <1193318969.6092.19.camel@johannes.berg> <1193320140.5542.11.camel@localhost.localdomain> <1193320661.14136.10.camel@johannes.berg> <1193548708.7779.10.camel@localhost.localdomain> <1193567294.3966.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1193567294.3966.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 28, 2007 at 11:28:14AM +0100, Johannes Berg wrote:

> > This turned out to be a wpa_supplicant issue.  wpa_supplicant uses
> > KEY_MGMT_802_1X_NO_WPA (instead of KEY_MGMT_802_1X) to handle Dynamic
> > WEP where the AP doesn't broadcast WPA IEs (ie, a pure Dynamic WEP
> > network), and that value wasn't being handled correctly by
> > wpa_driver_wext_keymgmt2wext().
> 
> Great, thanks for tracking this down.

While there is indeed a bug in wpa_supplicant 0.5.x, I think that
another issue here is in mac80211 trying to do something that it was not
supposed to do, i.e., to figure out whether privacy is enabled or not
based on keymgmt value. This is decided in the supplicant and the value
is configured with IW_AUTH_PRIVACY_INVOKED to the kernel. In other
words, mac80211 should follow this parameter and not IW_AUTH_KEY_MGMT.

> > This has been fixed on the wpa_supplicant 0.6.x branch but not
> > backported to the 0.5.x branch yet.  Tested with EAP-TLS and LEAP with
> > iwl4965 on kernel-2.6.23.1-35.fc8.
> > 
> > For Fedora, I've built wpa_supplicant-0.5.7-15.fc8 to fix this issue.
> 
> Alright. Jouni, will you push this fix for 0.5.x?

I merged the fix into 0.5.x branch, so it should be included in the next
release. This was fixed as part of a more generic cleanup and it did not
end up being flagged as a bug fix and consequently, not merged into
0.5.x branch.

-- 
Jouni Malinen                                            PGP id EFC895FA
