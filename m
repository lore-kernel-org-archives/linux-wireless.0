Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab3J3IfZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 04:35:25 -0400
Date: Wed, 30 Oct 2013 09:34:34 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Dietmar Rudolph <dietmar@crlf.de>,
	Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: Re: [PATCH] iwl3945: do not print RFKILL message
Message-ID: <20131030083432.GA1478@redhat.com> (sfid-20131030_093531_928891_3956A931)
References: <20131025103751.GB16384@redhat.com>
 <1382699879.12755.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
In-Reply-To: <1382699879.12755.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 25, 2013 at 01:17:59PM +0200, Johannes Berg wrote:
> On Fri, 2013-10-25 at 12:37 +0200, Stanislaw Gruszka wrote:
> > We can mess logs if user space try to open device again and again if
> > RFKILL switch is on. Do not print message and return ERFKILL error
> > instead to indicate where the problem is.
> 
> Are you maybe not calling wiphy_rfkill_set_hw_state() in the right
> places?

This is done from work scheduled every 2 second if rfkill state change,
but is possible that initial state is not provided to upper layer.

Dietmar or Pedro, could you test attached patch (my old laptop with 3945
does not work any longer). It is alternative to previous patch posted
before, does rfkill work ok with it?

Stanislaw


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iwl3945_rfkill.patch"

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index dea3b50..74e2b0a 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -2202,6 +2202,9 @@ il3945_alive_start(struct il_priv *il)
 	} else
 		set_bit(S_RFKILL, &il->status);
 
+	wiphy_rfkill_set_hw_state(il->hw->wiphy,
+				  test_bit(S_RFKILL, &il->status));
+
 	/* After the ALIVE response, we can send commands to 3945 uCode */
 	set_bit(S_ALIVE, &il->status);
 
@@ -2397,7 +2400,7 @@ __il3945_up(struct il_priv *il)
 	else {
 		set_bit(S_RFKILL, &il->status);
 		IL_WARN("Radio disabled by HW RF Kill switch\n");
-		return -ENODEV;
+		return 0;
 	}
 
 	_il_wr(il, CSR_INT, 0xFFFFFFFF);
@@ -2825,6 +2828,9 @@ il3945_mac_start(struct ieee80211_hw *hw)
 	if (ret)
 		goto out_release_irq;
 
+	if (il_is_rfkill(il))
+		goto out;
+
 	D_INFO("Start UP work.\n");
 
 	/* Wait for START_ALIVE from ucode. Otherwise callbacks from
@@ -2845,6 +2851,7 @@ il3945_mac_start(struct ieee80211_hw *hw)
 	 * no need to poll the killswitch state anymore */
 	cancel_delayed_work(&il->_3945.rfkill_poll);
 
+out:
 	il->is_open = 1;
 	D_MAC80211("leave\n");
 	return 0;

--h31gzZEtNLTqOjlF--
