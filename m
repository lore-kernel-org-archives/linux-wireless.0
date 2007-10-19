Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:61231 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966787AbXJSW2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 18:28:22 -0400
Message-ID: <47192F84.1020101@lwfinger.net> (sfid-20071020_011638_875997_53969014)
Date: Fri, 19 Oct 2007 17:28:20 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 lists supported rates backwards
References: <1192832109.19766.14.camel@dv>
In-Reply-To: <1192832109.19766.14.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> Hello!
> 
> My iwl3945 device cannot associate to Linksys BEFW11S4.  The AP reports
> code 18 (unsupported rates).
> 
> I tried the current master branch from iwlwifi repository with the
> current wireless-2.6/everything kernel patched by mac80211 10.0.0, and
> it still exhibits the problem.
> 
> It turns out the driver sends CCK rates as extended and OFDM rates as
> "non-extended":
> 
>     Tagged parameters (23 bytes)
>         SSID parameter set: "WTEST"
>             Tag Number: 0 (SSID parameter set)
>             Tag length: 5
>             Tag interpretation: WTEST
>         Supported Rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0 
>             Tag Number: 1 (Supported Rates)
>             Tag length: 8
>             Tag interpretation: Supported rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0  [Mbit/sec]
>         Extended Supported Rates: 1.0 2.0 5.5 11.0 
>             Tag Number: 50 (Extended Supported Rates)
>             Tag length: 4
>             Tag interpretation: Supported rates: 1.0 2.0 5.5 11.0  [Mbit/sec]
> 
> The association request captured by WireShark is attached.
> 
> I tried swapping WLAN_EID_SUPP_RATES and WLAN_EID_EXT_SUPP_RATES in the
> sources, but it didn't work.  Maybe mac80211 rewrites the request, I
> don't know.
> 
> Also, iwl3945 refuses to scan more than several times, and the only
> workaround is to reload the module.  Maybe the association failure
> triggers that.  If it's not a known problem, I can look closer.

Using the latest git pull from Linus, I am able to associate with my BEFW11S4 AP using the b43
driver. The problem is probably not in mac80211.

Larry
