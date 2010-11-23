Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:41171 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755399Ab0KWQNn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 11:13:43 -0500
Message-ID: <4CEBE834.9000303@gmx.net>
Date: Tue, 23 Nov 2010 17:13:40 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Linux Client vs. CISCO AP with band select
References: <4CE6EA98.3020300@gmx.net> <20101120112753.GA12225@jm.kir.nu> <201011201304.48821.helmut.schaa@googlemail.com>
In-Reply-To: <201011201304.48821.helmut.schaa@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------070909040009090007090203"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070909040009090007090203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

On 2010-11-20 13:04, Helmut Schaa wrote:
> If the Cisco APs would reply to direct probes we could (as a workaround) just
> send an additional direct probe here. I agree with Jouni that the AP behavior
> is just stupid but the users will blame Linux for not being able to connect
> and not the AP vendor.
> 
> Wolfgang, could you please try the (untested) patch below if it makes any
> difference?

Sorry, it took me a day longer as promised because I had to stay at home
yesterday.

The patch from Helmut didn't change anything. I even tried to send both
broadcast and direct probes in triples to check if that's the threshold
which is configured in band select as retries. It's not;-)

After that I tried a dirty hack on wpa_supplicant 0.7.3:
-------
--- wpa_supplicant-0.7.3.orig/wpa_supplicant/sme.c	2010-09-07
17:43:39.000000000 +0200
+++ wpa_supplicant-0.7.3/wpa_supplicant/sme.c	2010-11-23
15:21:23.866829986 +0100
@@ -456,8 +456,23 @@
 void sme_event_auth_timed_out(struct wpa_supplicant *wpa_s,
 			      union wpa_event_data *data)
 {
+	int timeout = 5000;
 	wpa_printf(MSG_DEBUG, "SME: Authentication timed out");
-	wpa_supplicant_req_scan(wpa_s, 5, 0);
+	if (wpa_blacklist_add(wpa_s, wpa_s->pending_bssid) == 0) {
+		struct wpa_blacklist *b;
+		wpa_blacklist_add(wpa_s, wpa_s->pending_bssid);
+		b = wpa_blacklist_get(wpa_s, wpa_s->pending_bssid);
+		if (b && b->count < 3) {
+			/*
+			 * Speed up next attempt if there could be other APs
+			 * that could accept association.
+			 */
+			timeout = 100;
+		}
+	}
+	wpa_supplicant_req_scan(wpa_s, timeout / 1000,
+				1000 * (timeout % 1000));
+//	wpa_supplicant_req_scan(wpa_s, 5, 0);
 }


--------
In other words I reused the code found in sme_event_assoc_reject() to
add the BSSID to the blacklist. To speed up things further I add it
twice;-) I don't know why wpa_supplicant needs a blacklist count of 2 to
finally try an other BSSID.

And it helps a lot. With this change wpa_supplicant stops retrying the
same BSSID all the time and tries a 5GHz one pretty fast. And I think
that's exactly what CISCO tries to achieve.

Finally there is another timeout in the EAP stage (SUPP_BE) I can't
pinpoint. I attached the wpa_supplicant.log.

Authenticated once reauthentication works very fast if needed.

Knowing where to search and how to hack mac80211 and wpa_supplicant I'll
try to find some details which probes CISCO responds to reaching the
threshold.

I can still provide packet traces if you need/want them. In case of the
load balancing feature it may take some time because I've not found a
trick to provoke it. But I think a well and fast trained blacklist will
help in this case, too.

Greetings,
Wolfgang

--------------070909040009090007090203
Content-Type: application/x-gzip;
 name="wpa_eap.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="wpa_eap.log.gz"

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
8x/Nm2H6gz0AAA==
--------------070909040009090007090203--
