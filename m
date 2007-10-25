Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbXJYNyq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:54:46 -0400
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep
	network
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, dragoran <drago01@gmail.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1193318969.6092.19.camel@johannes.berg>
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
	 <1193127280.3069.261.camel@debian.sh.intel.com>
	 <1193148453.8648.20.camel@localhost.localdomain>
	 (sfid-20071023_150810_118446_E87EE8F5)  <1193161034.7733.38.camel@johannes.berg>
	 <1193238423.2557.41.camel@localhost.localdomain>
	 <1193318969.6092.19.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 09:49:00 -0400
Message-Id: <1193320140.5542.11.camel@localhost.localdomain> (sfid-20071025_145449_671717_22ED9F42)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-10-25 at 15:29 +0200, Johannes Berg wrote:
> On Wed, 2007-10-24 at 11:07 -0400, Dan Williams wrote:
> 
> > Could you educate me a bit more about the problem if you've got a bit of
> > time?
> 
> As much as I've understood, the problem comes from the privacy mismatch
> function returning non-zero. This means that wpa_supplicant doesn't set
> IW_AUTH_KEY_MGMT_802_1X because if you check the function then the
> key_manegement_enabled variable is checked first thing.
> 
> > A normal Dynamic WEP configuration should result in wpa_supplicant
> > sending IW_AUTH_KEY_MGMT with IW_AUTH_KEY_MGMT_802_1X since ieee8021x is
> > specified in the wpa_supplicant config.  Is this not happening here?  I
> > seem to be seeing that wpa_supplicant _should_ be setting key
> > management, and mac80211 _should_ be returning 0 from
> > ieee80211_privacy_mismatch() because key management has been set, and
> > therefore this should succeed...
> 
> Yes, it seems that wpa_supplicant is not setting key management
> properly, possibly because internally it only translates two of the key
> management possibilities into the right wext state.

Ok, I'll try to track it down starting with wpa_supplicant then.

Dan


