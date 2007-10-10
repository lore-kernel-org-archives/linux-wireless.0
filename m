Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2249 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbXJJNjE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 09:39:04 -0400
Date: Wed, 10 Oct 2007 09:06:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: dragoran <drago01@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: Re: mac80211/iwlwifi + hidden ssids
Message-ID: <20071010130653.GB5962@tuxdriver.com> (sfid-20071010_143907_022217_0B118E66)
References: <470C9F28.1070803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <470C9F28.1070803@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 10, 2007 at 11:45:12AM +0200, dragoran wrote:
> Hello,
> I am unable to connect to a dynamic wep network with hidden ssid using 
> iwl3945 and the lastest fedora 7 kernel (which should have very recent 
> stuff). The problem is that the card never finds the ap. Running 
> wpa_supplicant directly shows "Got scan results xxx bytes" (can't 
> remeber the exact message).
> While with ipw3945d + ieee80211 it works fine. (NetworkManager does not 
> connect either see http://bugzilla.gnome.org/show_bug.cgi?id=464215 ).
> I haven't tryed the suggestion there yet because I am not near the 
> network right now.
> Any idea whats wrong? Does it work for anybody (maybe with other 
> mac80211 drivers)
> Currently I am not sure whom to blame iwl3945 or mac80211 or both.

Fedora 7 kernels are a little behind (1-2 weeks behind wireless-2.6)
ATM, so it might be best to handle this at bugzilla.kernel.org.

F7 _does_ have the kernel patch to probe for hidden SSIDs when
associating.  What I've found with that patch is that manually
invoking the wireless tools yields satisfactory results, but that NM
(which afaik relies on wpa_supplicant) still tends to have problems.
My hunch is that wpa_supplicant (at least how NM configures it)
is doing something "too smart", but I really don't know.

Do you have control over the AP?  If so, can you temporarily try
using static WEP or an open configuration so that you can test using
iwconfig?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
