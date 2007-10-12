Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:36078 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbXJLNXQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 09:23:16 -0400
From: Helmut Schaa <hschaa@suse.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] [PATCH] mac80211: honor IW_SCAN_THIS_ESSID in siwscan ioctl
Date: Fri, 12 Oct 2007 15:25:24 +0200
Cc: linux-wireless@vger.kernel.org, dana.r.ferguson@intel.com,
	dcbw@redhat.com, ipw3945-devel@lists.sourceforge.net,
	Bill Moss <bmoss@clemson.edu>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
References: <1192048496718-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1192048496718-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_FX3DH2PP0dgP5yw"
Message-Id: <200710121525.25574.hschaa@suse.de> (sfid-20071012_142322_280704_D38B0F36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_FX3DH2PP0dgP5yw
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Am Mittwoch, 10. Oktober 2007 22:34:56 schrieb John W. Linville:
> This patch fixes the problem of associating with wpa_secured hidden
> AP.  Please try out.

The patch did not fix the issue for _some_ APs I have here but it is 
apparently correct.

I was able to track the issue further down to the probe-request iwlwifi sends 
to connect to a hidden AP (hw_scan is enabled). Attached is a quick hack 
against iwlwifi-1.1.0 which made hidden AP working for me (using hw_scan).

The patch is only ment as a hint, not as a real fix!

The problem seemed to be in the info element "supported rates". The 
probe-request mac80211 would generate does only attach eight supported rates 
to this info element, the rest goes to "extended supported rates".

Instead iwlwifi puts _all_ (more then eight) rates into "supported rates" and 
omits "extended supported rates". As "supported rates" is specified in 
802.11b there should only be 802.11b rates (this is an assumption as I do not 
have the 802.11 specs here). This is exactly what my patch does: limit the 
number of supported rates to eight.

Can somebody please verify if I'm right?

Btw iwlwifi generates the probe-request itself _only_ if hw_scan is enabled. 
If hw_scan is disabled mac80211 generates the probe-request (which then 
should be correct) but the request gets somehow corrupted.

Thanks,
Helmut

--Boundary-00=_FX3DH2PP0dgP5yw
Content-Type: text/x-diff;
  charset="utf-8";
  name="fix_probe_request.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix_probe_request.diff"

diff -ur iwlwifi-1.1.0/origin/iwl-base.c iwlwifi-1.1.0_1/origin/iwl-base.c
--- origin/iwl-base.c	2007-09-19 11:11:16.000000000 +0200
+++ origin/iwl-base.c	2007-10-12 13:46:23.000000000 +0200
@@ -1877,6 +1877,7 @@
 	int len = 0;
 	u8 *pos = NULL;
 	u16 ret_rates;
+	int rate_count = 0;
 
 	/* Make sure there is enough space for the probe request,
 	 * two mandatory IEs and the data */
@@ -1924,11 +1925,16 @@
 	/* ... fill it in... */
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos = 0;
+
+	rate_count = 8;
+	if (left < 8)
+		rate_count = left;
+
 	ret_rates = priv->active_rate = priv->rates_mask;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
 
 	iwl_supported_rate_to_ie(pos, priv->active_rate,
-				 priv->active_rate_basic, left);
+				 priv->active_rate_basic, rate_count);
 	len += 2 + *pos;
 	pos += (*pos) + 1;
 	ret_rates = ~ret_rates & priv->active_rate;
Nur in iwlwifi-1.1.0_1/origin: iwl-base.c.orig.

--Boundary-00=_FX3DH2PP0dgP5yw--
