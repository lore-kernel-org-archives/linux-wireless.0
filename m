Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:51950 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbXJSWPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 18:15:12 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1Ij07b-0001Y3-5H
	for linux-wireless@vger.kernel.org; Fri, 19 Oct 2007 18:15:11 -0400
Subject: iwl3945 lists supported rates backwards
From: Pavel Roskin <proski@gnu.org>
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-/DFK8IAR+KPPayogZFdN"
Date: Fri, 19 Oct 2007 18:15:09 -0400
Message-Id: <1192832109.19766.14.camel@dv> (sfid-20071020_011633_265754_8C731778)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/DFK8IAR+KPPayogZFdN
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello!

My iwl3945 device cannot associate to Linksys BEFW11S4.  The AP reports
code 18 (unsupported rates).

I tried the current master branch from iwlwifi repository with the
current wireless-2.6/everything kernel patched by mac80211 10.0.0, and
it still exhibits the problem.

It turns out the driver sends CCK rates as extended and OFDM rates as
"non-extended":

    Tagged parameters (23 bytes)
        SSID parameter set: "WTEST"
            Tag Number: 0 (SSID parameter set)
            Tag length: 5
            Tag interpretation: WTEST
        Supported Rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0 
            Tag Number: 1 (Supported Rates)
            Tag length: 8
            Tag interpretation: Supported rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0  [Mbit/sec]
        Extended Supported Rates: 1.0 2.0 5.5 11.0 
            Tag Number: 50 (Extended Supported Rates)
            Tag length: 4
            Tag interpretation: Supported rates: 1.0 2.0 5.5 11.0  [Mbit/sec]

The association request captured by WireShark is attached.

I tried swapping WLAN_EID_SUPP_RATES and WLAN_EID_EXT_SUPP_RATES in the
sources, but it didn't work.  Maybe mac80211 rewrites the request, I
don't know.

Also, iwl3945 refuses to scan more than several times, and the only
workaround is to reload the module.  Maybe the association failure
triggers that.  If it's not a known problem, I can look closer.

-- 
Regards,
Pavel Roskin

--=-/DFK8IAR+KPPayogZFdN
Content-Disposition: attachment; filename=iwl3945assocreq
Content-Type: application/octet-stream; name=iwl3945assocreq
Content-Transfer-Encoding: base64

1MOyoQIABAAAAAAAAAAAAP//AAB/AAAANCQZR9UxDwBRAAAAUQAAAAAAGgBvGAAAeaUsHAAAAAAS
DIUJgATZoAE5AAA8AAAPZi/vWQATAsh3owAPZi/vWRAAIQQBAAAFV1RFU1QBCAwSGCQwSGBsMgQC
BAsW+33QrA==


--=-/DFK8IAR+KPPayogZFdN--

