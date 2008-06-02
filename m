Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYFBRqj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 13:46:39 -0400
Subject: Re: IW_SCAN_CAPA_ESSID vs hidden ESSID
From: Dan Williams <dcbw@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1212354884.4722.26.camel@deadeye.i.decadent.org.uk>
References: <1212354884.4722.26.camel@deadeye.i.decadent.org.uk>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 13:45:29 -0400
Message-Id: <1212428729.10093.13.camel@localhost.localdomain> (sfid-20080602_194642_949366_8B449DDE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-06-01 at 22:14 +0100, Ben Hutchings wrote:
> Since upgrading from Linux 2.6.24 to .25, I have found that
> NetworkManager cannot associate my Intel wireless card, handled by the
> ipw2200 driver, with my AP, which has a hidden SSID.
> 
> NetworkManager thinks that wpa_supplicant should be able to scan for
> specific hidden SSIDs if the underlying driver advertises
> IW_SCAN_CAPA_ESSID, which ipw2200 does since 2.6.25:
> 
> 	/* Use "AP_SCAN 2" if:
> 	 * - The wireless network is non-broadcast and the driver doesn't support
> 	 *     scanning specific SSIDs
> 	 * - The wireless network is Ad-Hoc
> 	 * - The wireless driver does not support WPA (stupid drivers...)
> 	 */
> 	is_adhoc = (nm_ap_get_mode(ap) == IW_MODE_ADHOC);
> 	if (is_adhoc || !supports_wpa)
> 		ap_scan = "AP_SCAN 2";
> 	else if (!nm_ap_get_broadcast (ap))
> 		ap_scan = self->priv->has_scan_capa_ssid ? "AP_SCAN 1" : "AP_SCAN 2";
> 
> However, this doesn't work because the scan results just have an empty
> string or "<hidden>" (not consistently, which is weird).
> 
> So one of these components is doing the wrong thing.  Is it that:
> 
> 1. ipw2200 or ieee80211 should copy the selected ESSID into scan results
> 2. wpa_supplicant should not check the ESSID of scan results if it has
> already selected an ESSId
> 3. NetworkManager should not expect IW_SCAN_CAPA_ESSID to mean that this
> will work

You might also want:

http://lists.shmoo.com/pipermail/hostap/2008-June/017873.html

that patch.  It fixes an issue that caused wpa_supplicant to never
probe-scan the AP in with a hidden SSID test configuration with ipw2200.

Dan


