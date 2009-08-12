Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:2823 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZHLHH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 03:07:27 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: David Seira <davidseira@gmail.com>
Subject: Re: Roaming behavior
Date: Wed, 12 Aug 2009 09:07:18 +0200
Cc: linux-wireless@vger.kernel.org
References: <loom.20090811T124332-602@post.gmane.org> <20090811135915.GC2684@tuxdriver.com> <1250003481.4185.7.camel@solid2>
In-Reply-To: <1250003481.4185.7.camel@solid2>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908120907.18501.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I want to delete this behavior because I'm developing an
> application which do that alone.

Please look at wpa_supplicants behavior when you configure 
ap_scan= and scan_ssid=. With them, you can configure 
wpa_supplicant to not issue scan requests on it's own.

Then your user-space app can do the monitoring, scanning (via 
nl80211) issue a command to wpa_supplicant to authenticate to 
some AP.

Another option would be to look into network-manager and see what 
it offers.


But basically, mac80211 has inferior support for roaming compared 
to some older solutions.

Some examples: with madwifi, I can tell the driver to only scan 
on channels 1,6,11. That's not exactly standards-conforming, but 
can speed up roaming considerably, because a full scan is now 
way shorter. mac80211 doesn't support such a thing directly. It 
just occurs to me that you might be able to do something like 
with with a special regulatory daemon.

Or with orinoco, you could define a level when to roam (e.g. at 
what SNR/RSSI/whatever it is based on). mac80211 doesn't have 
this.



I'm quite sure that this will be eventually done, and then you 
have the same seamless roaming with all/most of your WLAN cards, 
where with the pre-mac80211 only some of the card did somewhat 
well and other cards were only usable for hot-spot operation.

-- 
http://www.holgerschurig.de
