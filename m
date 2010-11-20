Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46105 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab0KTMFw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 07:05:52 -0500
Received: by bwz15 with SMTP id 15so4710802bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Nov 2010 04:05:50 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Wolfgang Breyha <wbreyha@gmx.net>
Subject: Re: Linux Client vs. CISCO AP with band select
Date: Sat, 20 Nov 2010 13:04:48 +0100
Cc: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4CE6EA98.3020300@gmx.net> <20101120112753.GA12225@jm.kir.nu>
In-Reply-To: <20101120112753.GA12225@jm.kir.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011201304.48821.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag 20 November 2010 schrieb Jouni Malinen:
> On Fri, Nov 19, 2010 at 10:22:32PM +0100, Wolfgang Breyha wrote:
> > In my case I see 10 BSSIDs for this SSID. 2 strong 2.4GHz APs and the
> > first 5GHz AP appears on third position reception wise. wpa_supplicant
> > starts authentication at the strongest. Then I see a probe request for
> > the SSID in wireshark, but no response from the selected BSSID. No
> > authentication packet is seen from wireshark.
> 
> OK, this is all expected thanks to the silly AP design.

I'm wondering if the Cisco APs would reply to direct probe requests (with
the bssid being set instead of the broadcast address). At least we're sending
broadcast probes before authentication (in case we did not receive a probe 
response from this AP yet during a previous scan):

 464         /*
 465          * Direct probe is sent to broadcast address as some APs
 466          * will not answer to direct packet in unassociated state.
 467          */
 468         ieee80211_send_probe_req(sdata, NULL, wk->probe_auth.ssid,
 469                                  wk->probe_auth.ssid_len, NULL, 0);

I guess this was introduced to work around another strange AP behavior.

If the Cisco APs would reply to direct probes we could (as a workaround) just
send an additional direct probe here. I agree with Jouni that the AP behavior
is just stupid but the users will blame Linux for not being able to connect
and not the AP vendor.

Wolfgang, could you please try the (untested) patch below if it makes any
difference?

Helmut

---
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index ae344d1..57ae8d5 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -467,6 +467,9 @@ ieee80211_direct_probe(struct ieee80211_work *wk)
 	 */
 	ieee80211_send_probe_req(sdata, NULL, wk->probe_auth.ssid,
 				 wk->probe_auth.ssid_len, NULL, 0);
+	ieee80211_send_probe_req(sdata, wk->filter_ta, wk->probe_auth.ssid,
+				 wk->probe_auth.ssid_len, NULL, 0);
+
 
 	wk->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
 	run_again(local, wk->timeout);
