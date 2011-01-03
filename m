Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44566 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1ACHPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 02:15:34 -0500
Received: by iyi12 with SMTP id 12so11876159iyi.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Jan 2011 23:15:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=w+EEdROx5NCBEe2fLv6RM-7fGSoNEpQ-tBZYo@mail.gmail.com>
References: <AANLkTi=w+EEdROx5NCBEe2fLv6RM-7fGSoNEpQ-tBZYo@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Sun, 2 Jan 2011 23:15:13 -0800
Message-ID: <AANLkTind_8HzraBGxyA90ymQ_e3uJV+iykMNKzekRLA9@mail.gmail.com>
Subject: Fwd: mac80211+iwlwifi bug with HT rates?
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux-wireless spam filter rejected our school's google appliance
mail, trying again as plain text.

Sorry,
Dan

---------- Forwarded message ----------
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Sun, Jan 2, 2011 at 11:13 PM
Subject: mac80211+iwlwifi bug with HT rates?
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Cc: Swati Rallapalli <swati@cs.utexas.edu>


I'm trying to track down an anomaly with a 3-stream 802.11n AP.
iwlwifi is saying that a single antenna should be sufficient even when
the AP supports 3 streams.  Here's what I've tracked down:
Code in iwl-agn-rxon.c uses the ht_cap TX MCS parameters to determine
how many streams the other side supports:
<http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=blob;f=drivers/net/wireless/iwlwifi/iwl-agn-rxon.c;h=d33e4db7e56cab88abc3281d04adf32162b8020e;hb=HEAD#l470>
Yet, it looks like mac80211 doesn't actually set those variables at
all!  In net/mac80211/ht.c, when converting the IE to the Station HT
cap:
<http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=blob;f=net/mac80211/ht.c;h=75d679d75e63e92143d55a47601a1dfc1377ba03;hb=HEAD#l21>
we first zero out the HT CAP (line 30) and then never actually set the
ht_cap->mcs.tx_params variables at all.  Grep says that's the only use
of mcs.tx_params in that directory, so I'm pretty confident mac80211
just never does that.  Thus iwlwifi thinks it only needs to have 1 RX
antenna enabled (though it defaults to a minimum of 2 when possible)
and basically fails to receive 3 stream packets.
Is this a bug in iwlwifi or mac80211?
Thanks,
Dan
