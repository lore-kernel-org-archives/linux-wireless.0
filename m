Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa01-07.prod.phx3.secureserver.net ([72.167.82.87]:37832
	"HELO p3plsmtpa01-07.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758099Ab1ANS6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 13:58:00 -0500
Message-ID: <D323CFEF4DEC4E18AFF56742F78C16B6@ChuckPC>
From: "Chuck Crisler" <ccrisler@vgocom.com>
To: <linux-wireless@vger.kernel.org>
Subject: intermittent eap authentication failure
Date: Fri, 14 Jan 2011 13:51:08 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am running wpa_supplicant v. 0.6.10. I am having a problem remaining on a 
network with PEEP authentication. I can initially get on the network but 
then fail with the first session timeout sent by the AP. Sometimes if the 
ESS is hidden I will have a subsequent probe request fail, causing me to 
re-start the entire process, which will then succeed, only to fail with the 
next session timeout.

Sometime ago I found a conflict between the supplicant and the MAC80211 code 
dealing with Cisco session timeouts. When we were 'deauthenticated', the MAC 
code notified the supplicant AND re-associated with the AP. When the driver 
got the association response, it then notified the supplicant, which was in 
the process of running a scan, which had often already been sent to the 
driver, causing a mess. We modified the driver so that if it received a 
de-auth with reason code 1 (undefined?), it would *NOT* notify the 
supplicant but would re-associate, then notify the supplicant of the new 
association. We modified the supplicant so that when it was in the completed 
state and received an association event, it went through the disassociation 
sequence of calls, then proceeded with whatever was remaining for the 
authentication. Later we determined that we could receive the deauth with a 
reason code = 4 also, so that was added.
Specifically, this is what we do with a COMPLETED->ASSOCIATED transition in 
wpa_supplicant_event_assoc in events.c:

wpa_clear_keys(wpa_s, wpa_s->bssid);
eapol_sm_notify_portEnabled(wpa_s->eapol, FALSE);
eapol_sm_notify_portValid(wpa_s->eapol, FALSE);
if (wpa_key_mgmt_wpa_psk(wpa_s->key_mgmt))
    eapol_sm_notify_eap_success(wpa_s->eapol, FALSE);
wpa_sm_set_config(wpa_s->eapol, NULL, NULL);
wpa_s->new_connection = 1;

This works fine with WPA/WPA2, but seems to fail with PEEP and (I guess) the 
other EAP methods. I don't know EAP well enough yet to understand why this 
is failing or what I need to do to make WPA/WPA2 and EAP all work. Would 
someone please shed some light on this for me?

Thank you,
Chuck Crisler 

