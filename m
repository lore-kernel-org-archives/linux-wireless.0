Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:27536 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041AbZJECNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2009 22:13:40 -0400
Received: by fg-out-1718.google.com with SMTP id 22so384325fge.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2009 19:11:52 -0700 (PDT)
Subject: deauthentication and disassociation nl80211 commands
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Oct 2009 04:11:47 +0200
Message-Id: <1254708707.24430.68.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here I want to ask and summarize problems we found in thread
'driver_nl80211 broken again'


First of all it it known that lifetime of connection to access point is
typically:

authentication request/response
association request/response

EAPOL 4 way handshake (for WPA)

<session>

disassociation
deauthentication

Today kernel explicitly requests the driver to perform both
disassociation and deauthentication in that order.
It is also possible to do disassociation and then association, skipping
the authentication step.

However, currently wpa_supplicant assumes that once it called
wpa_drv_disassociate it can again start the complete connect sequence
from the authentication.

In fact I have carefully studied the code and found that calls to
wpa_supplicant_deauthenticate (which is the only user of
wpa_drv_deauthenticate) only happen at deinitialization of wireless
interface and when wpa_supplicant really has to do it, that is if there
is a failure (mic failure for example).

My hacky patch that was rejected on the grounds that it is not right to
introduce the driver dependent behavior might actually be the correct
solution. It just makes the wpa_supplicant_disassociate do both
disassociation and deauthentication, as was always assumed by the
wpa_supplicant core.


Or kernel should became smarter and do the work for wpa_supplicant. 

In this case it should work like that:

If mac80211 is already authenticated to the AP that was requested, it
should just return success.
However currently (and I was told that this is feature, not a bug)
mac80211 would flatly refuse to do any scanning while it is in
authenticated but not associated state.

If it isn't authenticated to new AP then, new authentication should be
made.
(and old one can be kept, but removed after a timeout)


And the last question.
When do you plan to switch officially the wpa_supplicant to
driver_nl80211?

Currently it has this issue, and another issue that it (nl80211) reports
signal levels in another format that NetworkManager doesn't understand.

Other that that it is faster, and especially it allows me to bring
network up, when I press rfkill button within 4 seconds or less.


Best regards,
Maxim Levitsky

