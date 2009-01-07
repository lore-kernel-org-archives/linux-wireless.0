Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43483 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321AbZAGQeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 11:34:22 -0500
Date: Wed, 7 Jan 2009 18:33:22 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for
	management frames
Message-ID: <20090107163322.GA26418@jm.kir.nu> (sfid-20090107_173425_749789_947DEC8B)
References: <20090107112346.369581673@atheros.com> <20090107112707.370907962@atheros.com> <1231330118.3545.28.camel@johannes> <20090107122427.GA20019@jm.kir.nu> <1231332428.3545.33.camel@johannes> <20090107140956.GA22424@jm.kir.nu> <1231340944.3545.38.camel@johannes> <20090107153052.GA24894@jm.kir.nu> <1231342671.3545.43.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231342671.3545.43.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 07, 2009 at 04:37:51PM +0100, Johannes Berg wrote:

> > For nl80211, we can add capability
> > flag for MFP and then driver_nl80211.c can skip this validation step.
> 
> Would be nice to be able to print it out in iw, just for information.

OK. I think I'll leave this as a separate step since there does not seem
to be an existing command suitable for this yet, but anyway, the
information will be available once that gets added.. This should be
something that allows the driver to be queried about general
capabilities (encr algorithms, etc., and now also MFP).

> > However, we would still need to add a driver-mac80211 flag for
> > indicating whether the driver supports MFP.
> 
> Right, and once we have that the polarity of this key flag doesn't
> matter at all, though I suspect there are much fewer drivers that will
> be able to support it in hardware.

How about following on top of the MFP patch series (and a small change
to ath9k to set this flag)?


PS.

Actually, NM would probably not need to care about MFP at all (unless
user wants to require it). I think I will change wpa_supplicant default
to MFP-optional once 802.11w gets deployed and is found not to cause
problems.


 ---
 include/net/mac80211.h |    4 ++++
 net/mac80211/wext.c    |    4 ++++
 2 files changed, 8 insertions(+)

--- wireless-testing.orig/include/net/mac80211.h	2009-01-07 18:10:40.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-01-07 18:11:33.000000000 +0200
@@ -866,6 +866,9 @@ enum ieee80211_tkip_key_type {
  *	Hardware which has dynamic power save support, meaning
  *	that power save is enabled in idle periods, and don't need support
  *	from stack.
+ *
+ * @IEEE80211_HW_MFP_CAPABLE:
+ *	Hardware supports management frame protection (MFP, IEEE 802.11w).
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
@@ -879,6 +882,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SPECTRUM_MGMT			= 1<<9,
 	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<10,
 	IEEE80211_HW_NO_STACK_DYNAMIC_PS		= 1<<11,
+	IEEE80211_HW_MFP_CAPABLE			= 1<<12,
 };
 
 /**
--- wireless-testing.orig/net/mac80211/wext.c	2009-01-07 18:20:30.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-01-07 18:22:38.000000000 +0200
@@ -961,6 +961,10 @@ static int ieee80211_ioctl_siwauth(struc
 			ret = -EOPNOTSUPP;
 		break;
 	case IW_AUTH_MFP:
+		if (!(sdata->local->hw.flags & IEEE80211_HW_MFP_CAPABLE)) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
 		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
 		    sdata->vif.type == NL80211_IFTYPE_ADHOC)
 			sdata->u.sta.mfp = data->value;


-- 
Jouni Malinen                                            PGP id EFC895FA
