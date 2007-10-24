Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbXJXPM0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 11:12:26 -0400
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep
	network
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, dragoran <drago01@gmail.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1193161034.7733.38.camel@johannes.berg>
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
	 <1193127280.3069.261.camel@debian.sh.intel.com>
	 <1193148453.8648.20.camel@localhost.localdomain>
	 (sfid-20071023_150810_118446_E87EE8F5)  <1193161034.7733.38.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 11:07:03 -0400
Message-Id: <1193238423.2557.41.camel@localhost.localdomain> (sfid-20071024_161228_714432_B147C57C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-10-23 at 19:37 +0200, Johannes Berg wrote:
> On Tue, 2007-10-23 at 10:07 -0400, Dan Williams wrote:
> 
> > Was there ever a conclusion to this patch?  ISTR it went through a
> > couple comments and was more or less rejected as the wrong approach.
> > Can anyone comment as to what the _right_ approach is?  Not being able
> > to connect to dynamic WEP networks is not acceptable, what needs to be
> > done to make this work?
> 
> My take on it is that it's a wpa_supplicant/wext bug.
> 
> See, the log says:
> eth1: privacy configuration mismatch and mixed-cell disabled - disassociate
> 
> So that means ieee80211_privacy_mismatch() returned non-zero. However,
> ieee80211_privacy_mismatch() will return 0 instantly when key management
> is enabled, which is obviously true with dynamic WEP.
> 
> Hence, IMHO wpa_supplicant should be telling us that it enabled key
> management. But the wext interface is crappy enough to not have a
> definition for dynamic WEP which probably means that in the
> wpa_driver_wext_keymgmt2wext() function in wpa_supplicant's
> driver_wext.c 0 is returned, while we take anything but zero to be "key
> management is enabled".

Could you educate me a bit more about the problem if you've got a bit of
time?

A normal Dynamic WEP configuration should result in wpa_supplicant
sending IW_AUTH_KEY_MGMT with IW_AUTH_KEY_MGMT_802_1X since ieee8021x is
specified in the wpa_supplicant config.  Is this not happening here?  I
seem to be seeing that wpa_supplicant _should_ be setting key
management, and mac80211 _should_ be returning 0 from
ieee80211_privacy_mismatch() because key management has been set, and
therefore this should succeed...

Dan

> The proper fix would be to
>  (a) remove the crap about IW_AUTH_KEY_MGMT values from wext,
>      no drivers except mac80211 care and that cares only about
>      enabled/disabled
>  (b) make the parameter to IW_AUTH_KEY_MGMT a boolean
>      (no code changes required, only comment updates, since no driver
>      cares one bit except mac80211 which treats it as a bool already)
>  (c) update wpa_supplicant's wpa_driver_wext_keymgmt2wext function to
>      return 0 for KEY_MGMT_NONE and 1 for everything else
> 
> I'm not going to do it though. Dynamic WEP is just too uninteresting to
> me.
> 
> johannes

