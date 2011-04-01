Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab1DAJZa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 05:25:30 -0400
Date: Fri, 1 Apr 2011 11:25:08 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ec15e68ba6a regresion?
Message-ID: <20110401092506.GB2790@redhat.com>
References: <20110331154232.GA7370@redhat.com>
 <20110331154638.GA28649@jm.kir.nu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
In-Reply-To: <20110331154638.GA28649@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 31, 2011 at 06:46:38PM +0300, Jouni Malinen wrote:
> On Thu, Mar 31, 2011 at 05:42:41PM +0200, Stanislaw Gruszka wrote:
> > Seems commit:
> > 
> > commit ec15e68ba6a505631016f230899bafbb7b8cd0d6
> > Author: Jouni Malinen <jouni.malinen@atheros.com>
> > Date:   Wed Mar 23 15:29:52 2011 +0200
> > 
> >     cfg80211: Add nl80211 event for deletion of a station entry
> > 
> > is causing problems on my system. Sometimes when I disconnect
> > from wireless network, I can not connect again. Without commit
> > I can not reproduce the problem.
> 
> That sounds strange.. That commit is supposed to just add a new nl80211
> event that existing user space tools would ignore (and new
> wpa_supplicant snapshot would only use in the case of IBSS). Would it be
> possible to get a wpa_supplicant debug log showing this problem?

Seems when disconnect event is handled, we remove some key. I'm
attaching non-debug and debug logs. Note this is kinda old
version of wpa_supplicant.

NetworkManager-0.8.1-7.el6.x86_64
wpa_supplicant-0.6.8-10.el6.x86_64
kernel-latest wireless-testing

Stanislaw

--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wpa_supplicant.log"


wpa_driver_wext_disassociate
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
State: COMPLETED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 1->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Removing interface wlan3
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
No keys have been configured - skip key clearing
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
wpa_driver_wext_set_wpa
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_countermeasures
No keys have been configured - skip key clearing
Removed BSSID 00:00:00:00:00:00 from blacklist (clear)
Cancelling scan request
Cancelling authentication timeout
WEXT: Operstate: linkmode=0, operstate=6
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Removing interface wlan1
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
No keys have been configured - skip key clearing
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
wpa_driver_wext_set_wpa
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_countermeasures
No keys have been configured - skip key clearing
Removed BSSID 00:00:00:00:00:00 from blacklist (clear)
Cancelling scan request
Cancelling authentication timeout
WEXT: Operstate: linkmode=0, operstate=6
Failed to initiate AP scan.
Failed to initiate AP scan.
Failed to initiate AP scan.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3e
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (auth) [id=0 id_str=]
Associated with 00:23:69:35:d1:3f
WPA: Key negotiation completed with 00:23:69:35:d1:3f [PTK=CCMP GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3f completed (auth) [id=0 id_str=]
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Failed to initiate AP scan.
Failed to initiate AP scan.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (auth) [id=0 id_str=]
Failed to initiate AP scan.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (auth) [id=0 id_str=]
Associated with 00:23:69:35:d1:3f
WPA: Key negotiation completed with 00:23:69:35:d1:3f [PTK=CCMP GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3f completed (auth) [id=0 id_str=]
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (reauth) [id=0 id_str=]
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3f
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3f
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3f
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
NetworkManager-glib-0.8.1-7.el6.x86_64
NetworkManager-0.8.1-7.el6.x86_64
NetworkManager-gnome-0.8.1-7.el6.x86_64
wpa_supplicant-0.6.8-10.el6.x86_64

--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wpa_supplicant.log.debug"


wpa_driver_wext_disassociate
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
State: COMPLETED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 1->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Removing interface wlan3
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
No keys have been configured - skip key clearing
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
wpa_driver_wext_set_wpa
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_countermeasures
No keys have been configured - skip key clearing
Removed BSSID 00:00:00:00:00:00 from blacklist (clear)
Cancelling scan request
Cancelling authentication timeout
WEXT: Operstate: linkmode=0, operstate=6
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Removing interface wlan1
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
No keys have been configured - skip key clearing
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
wpa_driver_wext_set_wpa
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_countermeasures
No keys have been configured - skip key clearing
Removed BSSID 00:00:00:00:00:00 from blacklist (clear)
Cancelling scan request
Cancelling authentication timeout
WEXT: Operstate: linkmode=0, operstate=6
Failed to initiate AP scan.
Failed to initiate AP scan.
Failed to initiate AP scan.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3e
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (auth) [id=0 id_str=]
Associated with 00:23:69:35:d1:3f
WPA: Key negotiation completed with 00:23:69:35:d1:3f [PTK=CCMP GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3f completed (auth) [id=0 id_str=]
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Failed to initiate AP scan.
Failed to initiate AP scan.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (auth) [id=0 id_str=]
Failed to initiate AP scan.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (auth) [id=0 id_str=]
Associated with 00:23:69:35:d1:3f
WPA: Key negotiation completed with 00:23:69:35:d1:3f [PTK=CCMP GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3f completed (auth) [id=0 id_str=]
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (reauth) [id=0 id_str=]
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3f
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3f
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3f
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3f
WPA: Key negotiation completed with 00:23:69:35:d1:3f [PTK=CCMP GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3f completed (reauth) [id=0 id_str=]
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3f
Failed to initiate AP scan.
Failed to initiate AP scan.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3f
WPA: Key negotiation completed with 00:23:69:35:d1:3f [PTK=CCMP GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3f completed (auth) [id=0 id_str=]
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3f
WPA: Key negotiation completed with 00:23:69:35:d1:3f [PTK=CCMP GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3f completed (auth) [id=0 id_str=]
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
WPA: Group rekeying completed with 00:23:69:35:d1:3f [GTK=CCMP]
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3f
WPA: Key negotiation completed with 00:23:69:35:d1:3f [PTK=CCMP GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3f completed (auth) [id=0 id_str=]
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Associated with 00:23:69:35:d1:3f
WPA: Key negotiation completed with 00:23:69:35:d1:3f [PTK=CCMP GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3f completed (auth) [id=0 id_str=]
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
Authentication with 00:23:69:35:d1:3f timed out.
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Authentication with 00:00:00:00:00:00 timed out.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Authentication with 00:00:00:00:00:00 timed out.
Authentication with 00:00:00:00:00:00 timed out.
Failed to initiate AP scan.
Failed to initiate AP scan.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (auth) [id=0 id_str=]
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Authentication with 00:00:00:00:00:00 timed out.
Failed to initiate AP scan.
Failed to initiate AP scan.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (auth) [id=0 id_str=]
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Authentication with 00:23:69:35:d1:3f timed out.
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Authentication with 00:23:69:35:d1:3f timed out.
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Authentication with 00:00:00:00:00:00 timed out.
CTRL-EVENT-TERMINATING - signal 15 received
CTRL-EVENT-TERMINATING - signal 15 received
Could not request DBus service name: already registered.
Failed to initiate AP scan.
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Associated with 00:23:69:35:d1:3e
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (auth) [id=0 id_str=]
Providing DBus service 'fi.epitest.hostap.WPASupplicant'.
Daemonize..
Initializing interface 'wlan3' conf 'N/A' driver 'wext' ctrl_interface 'N/A' bridge 'N/A'
Initializing interface (2) 'wlan3'
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
  capabilities: key_mgmt 0xf enc 0xf flags 0x0
WEXT: Operstate: linkmode=1, operstate=5
Own MAC address: 00:24:d7:13:21:d4
wpa_driver_wext_set_wpa
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_countermeasures
wpa_driver_wext_set_drop_unencrypted
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
Added interface wlan3
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=48
Ignore event for foreign ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Failed to get scan results
Failed to get scan results - try scanning again
Setting scan request: 1 sec 0 usec
Initializing interface 'wlan1' conf 'N/A' driver 'wext' ctrl_interface 'N/A' bridge 'N/A'
Initializing interface (2) 'wlan1'
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
  capabilities: key_mgmt 0xf enc 0xf flags 0x0
WEXT: Operstate: linkmode=1, operstate=5
Own MAC address: 00:21:6a:6d:18:8e
wpa_driver_wext_set_wpa
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_countermeasures
wpa_driver_wext_set_drop_unencrypted
RSN: flushing PMKID list in the driver
Setting scan request: 1 sec 100000 usec
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
Added interface wlan1
Ignore event for foreign ifindex 3
Ignore event for foreign ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b1a len=48
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Trying to get current scan results first without requesting a new scan to speed up initial association
Failed to get scan results
Failed to get scan results - try scanning again
Setting scan request: 0 sec 0 usec
Setting scan request: 0 sec 0 usec
Starting AP scan (broadcast SSID)
Scan requested (ret=-1) - scan timeout 30 seconds
Failed to initiate AP scan.
Setting scan request: 10 sec 0 usec
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Trying to get current scan results first without requesting a new scan to speed up initial association
Failed to get scan results
Failed to get scan results - try scanning again
Setting scan request: 0 sec 0 usec
Setting scan request: 0 sec 0 usec
Starting AP scan (broadcast SSID)
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.
Setting scan request: 10 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Received 2671 bytes of scan results (5 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
No suitable AP found.
Setting scan request: 5 sec 0 usec
Ignore event for foreign ifindex 2
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
Ignore event for foreign ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
Failed to get scan results
Failed to get scan results - try scanning again
Setting scan request: 1 sec 0 usec
key_mgmt: 0x2
scan_ssid=1 (0x1)
PSK (ASCII passphrase) - hexdump_ascii(len=8): [REMOVED]
ssid - hexdump_ascii(len=12):
     70 65 61 72 74 72 65 65 5f 6e 32 34               peartree_n24    
PSK (from passphrase) - hexdump(len=32): [REMOVED]
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3e ssid='peartree_n24'
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=30): dd 1c 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02 0c 00
WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00
WPA: using GTK TKIP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: DISCONNECTED -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_psk
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=28
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Received 3447 bytes of scan results (7 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3e ssid='peartree_n24'
Already associated with the selected AP.
RSN: Ignored PMKID candidate without preauth flag
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8c08 len=181
AssocResp IE wireless event - hexdump(len=165): 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 2d 1a 6c 18 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6c 18 1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:23:69:35:d1:3e
Association info event
resp_ies - hexdump(len=165): 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 2d 1a 6c 18 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6c 18 1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATING -> ASSOCIATED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=00:23:69:35:d1:3e
No keys have been configured - skip key clearing
Associated with 00:23:69:35:d1:3e
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RX EAPOL from 00:23:69:35:d1:3e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 03
  key_nonce - hexdump(len=32): 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 28
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 13 34 b2 53 50 e7 bf 53 8a 9a b2 69 d7 fd 1f 69 b4 04 5f 89 a9 10 7f a9 e6 ca 58 e5 d0 ba 98 f7
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 03 13 34 b2 53 50 e7 bf 53 8a 9a b2 69 d7 fd 1f 69 b4 04 5f 89 a9 10 7f a9 e6 ca 58 e5 d0 ba 98 f7 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 cb e7 d0 90 97 66 df 49 12 53 fa 97 69 bc 1a 26 00 16 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3e
RX EAPOL - hexdump(len=179): 02 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 04 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 28 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 29 8a 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 72 c5 22 9e bd 0c 4e ec ac fd 92 9d f1 8a c1 bd 00 50 00 b5 f9 e7 47 42 d3 6f 3b 4f e4 4f d0 42 e9 08 d2 2d ef a2 04 a6 75 06 0d da b7 94 9a da 02 9c 5f 69 81 35 4b 66 ae 05 43 76 88 42 50 d8 16 8b 3c 6c 18 84 e1 59 c7 5b d3 ee 91 f3 23 c2 8a 2d 5d a0 7e db 53 6a 33 0f 0c 86 6f 8e f6 0f 48 13
IEEE 802.1X RX: version=2 type=3 length=175
  EAPOL-Key type=2
  key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
  key_length=16 key_data_length=80
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 04
  key_nonce - hexdump(len=32): 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 28
  key_iv - hexdump(len=16): 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 29
  key_rsc - hexdump(len=8): 8a 02 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 72 c5 22 9e bd 0c 4e ec ac fd 92 9d f1 8a c1 bd
WPA: RX EAPOL-Key - hexdump(len=179): 02 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 04 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 28 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 29 8a 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 72 c5 22 9e bd 0c 4e ec ac fd 92 9d f1 8a c1 bd 00 50 00 b5 f9 e7 47 42 d3 6f 3b 4f e4 4f d0 42 e9 08 d2 2d ef a2 04 a6 75 06 0d da b7 94 9a da 02 9c 5f 69 81 35 4b 66 ae 05 43 76 88 42 50 d8 16 8b 3c 6c 18 84 e1 59 c7 5b d3 ee 91 f3 23 c2 8a 2d 5d a0 7e db 53 6a 33 0f 0c 86 6f 8e f6 0f 48 13
RSN: encrypted key data - hexdump(len=80): 00 b5 f9 e7 47 42 d3 6f 3b 4f e4 4f d0 42 e9 08 d2 2d ef a2 04 a6 75 06 0d da b7 94 9a da 02 9c 5f 69 81 35 4b 66 ae 05 43 76 88 42 50 d8 16 8b 3c 6c 18 84 e1 59 c7 5b d3 ee 91 f3 23 c2 8a 2d 5d a0 7e db 53 6a 33 0f 0c 86 6f 8e f6 0f 48 13
WPA: decrypted EAPOL-Key key data - hexdump(len=72): [REMOVED]
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 3 of 4-Way Handshake from 00:23:69:35:d1:3e (ver=2)
WPA: IE KeyData - hexdump(len=72): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00 dd 26 00 0f ac 01 01 00 65 86 03 a6 05 0c b0 37 80 e1 0e 25 78 89 3d dc 76 0b 9d ad 37 d2 59 7b 5d 08 26 3d 72 e3 3e af dd 00 00 00 00 00
WPA: Sending EAPOL-Key 4/4
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4f 06 21 40 eb a9 b0 18 d4 e5 f6 ea c0 9f 9e 2d 00 00
WPA: Installing PTK to the driver.
wpa_driver_wext_set_key: alg=3 key_idx=0 set_tx=1 seq_len=6 key_len=16
EAPOL: External notification - portValid=1
State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RSN: received GTK in pairwise handshake - hexdump(len=34): [REMOVED]
WPA: Group Key - hexdump(len=32): [REMOVED]
WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32).
WPA: RSC - hexdump(len=6): 8a 02 00 00 00 00
wpa_driver_wext_set_key: alg=2 key_idx=1 set_tx=0 seq_len=6 key_len=32
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
Cancelling authentication timeout
State: GROUP_HANDSHAKE -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (auth) [id=0 id_str=]
wpa_driver_wext_set_operstate: operstate 0->1 (UP)
WEXT: Operstate: linkmode=-1, operstate=6
EAPOL: External notification - portValid=1
EAPOL: External notification - EAP success=1
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state SUCCESS
EAP: EAP entering state DISABLED
EAPOL: SUPP_PAE entering state AUTHENTICATED
EAPOL: SUPP_BE entering state IDLE
EAPOL authentication completed successfully
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Ignore event for foreign ifindex 3
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
Received 630 bytes of scan results (1 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
No suitable AP found.
Setting scan request: 5 sec 0 usec
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
key_mgmt: 0x2
scan_ssid=1 (0x1)
PSK (ASCII passphrase) - hexdump_ascii(len=8): [REMOVED]
ssid - hexdump_ascii(len=12):
     70 65 61 72 74 72 65 65 5f 6e 35 30               peartree_n50    
PSK (from passphrase) - hexdump(len=32): [REMOVED]
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3f ssid='peartree_n50'
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: DISCONNECTED -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_psk
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
Ignore event for foreign ifindex 3
Ignore event for foreign ifindex 3
Ignore event for foreign ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b1a len=28
Ignore event for foreign ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
Received 630 bytes of scan results (1 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3f ssid='peartree_n50'
Already associated with the selected AP.
RSN: Ignored PMKID candidate without preauth flag
EAPOL: disable timer tick
EAPOL: startWhen --> 0
EAPOL: disable timer tick
Setting scan request: 0 sec 0 usec
Starting AP scan (specific SSID)
Scan SSID - hexdump_ascii(len=12):
     70 65 61 72 74 72 65 65 5f 6e 32 34               peartree_n24    
Scan requested (ret=0) - scan timeout 30 seconds
Authentication with 00:23:69:35:d1:3f timed out.
Added BSSID 00:23:69:35:d1:3f into blacklist
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (specific SSID)
Scan SSID - hexdump_ascii(len=12):
     70 65 61 72 74 72 65 65 5f 6e 35 30               peartree_n50    
Scan requested (ret=0) - scan timeout 30 seconds
Ignore event for foreign ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Received 8028 bytes of scan results (16 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:3a:98:a0:30:50 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
2: 00:3a:98:a0:70:43 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
3: 00:3a:98:a0:70:40 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
4: 00:3a:98:a0:70:42 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
5: 00:3a:98:a0:30:52 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:3a:98:a0:30:53 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
7: 00:3a:98:7d:27:32 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
8: 00:3a:98:7d:27:33 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
9: 00:1b:11:e7:33:c7 ssid='glink' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
10: 00:3a:98:a0:72:60 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
11: 00:3a:98:a0:72:62 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
12: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
13: 00:3a:98:a0:70:41 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
14: 00:3a:98:a0:30:51 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
15: 00:3a:98:7d:27:31 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
Try to find non-WPA AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:3a:98:a0:30:50 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
2: 00:3a:98:a0:70:43 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
3: 00:3a:98:a0:70:40 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
4: 00:3a:98:a0:70:42 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
5: 00:3a:98:a0:30:52 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:3a:98:a0:30:53 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
7: 00:3a:98:7d:27:32 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
8: 00:3a:98:7d:27:33 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
9: 00:1b:11:e7:33:c7 ssid='glink' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
10: 00:3a:98:a0:72:60 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
11: 00:3a:98:a0:72:62 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
12: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - non-WPA network not allowed
13: 00:3a:98:a0:70:41 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
14: 00:3a:98:a0:30:51 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
15: 00:3a:98:7d:27:31 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
No APs found - clear blacklist and try again
Removed BSSID 00:23:69:35:d1:3f from blacklist (clear)
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:3a:98:a0:30:50 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
2: 00:3a:98:a0:70:43 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
3: 00:3a:98:a0:70:40 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
4: 00:3a:98:a0:70:42 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
5: 00:3a:98:a0:30:52 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:3a:98:a0:30:53 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
7: 00:3a:98:7d:27:32 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
8: 00:3a:98:7d:27:33 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
9: 00:1b:11:e7:33:c7 ssid='glink' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
10: 00:3a:98:a0:72:60 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
11: 00:3a:98:a0:72:62 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
12: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
13: 00:3a:98:a0:70:41 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
14: 00:3a:98:a0:30:51 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
15: 00:3a:98:7d:27:31 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
Try to find non-WPA AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:3a:98:a0:30:50 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
2: 00:3a:98:a0:70:43 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
3: 00:3a:98:a0:70:40 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
4: 00:3a:98:a0:70:42 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
5: 00:3a:98:a0:30:52 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:3a:98:a0:30:53 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
7: 00:3a:98:7d:27:32 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
8: 00:3a:98:7d:27:33 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
9: 00:1b:11:e7:33:c7 ssid='glink' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
10: 00:3a:98:a0:72:60 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
11: 00:3a:98:a0:72:62 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
12: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - non-WPA network not allowed
13: 00:3a:98:a0:70:41 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
14: 00:3a:98:a0:30:51 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
15: 00:3a:98:7d:27:31 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
No suitable AP found.
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Received 7520 bytes of scan results (15 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_driver_wext_get_signal_quality: level -33 (146), qual 70 (70)
wpa_supplicant_select_bss_and_associate: qual 70 (70)  qv=1  bv=1
Selecting BSS from priority group 0
Try to find current BSSID 00:23:69:35:d1:3e
   found
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   selected based on RSN IE
   matched associated BSSID
   selected WPA AP 00:23:69:35:d1:3e ssid='peartree_n24'
Already associated with the selected AP.
Ignore event for foreign ifindex 2
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
wpa_driver_wext_disassociate
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
State: COMPLETED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 1->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:00:00:00:00:00
Added BSSID 00:00:00:00:00:00 into blacklist
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_supplicant_event_disassoc: scheduled DISCONNECT spam handler
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=48
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 9000 bytes of scan results (18 BSSes)
CTRL-EVENT-SCAN-RESULTS 
Ignore event for foreign ifindex 2
key_mgmt: 0x2
scan_ssid=1 (0x1)
PSK (ASCII passphrase) - hexdump_ascii(len=8): [REMOVED]
ssid - hexdump_ascii(len=12):
     70 65 61 72 74 72 65 65 5f 6e 32 34               peartree_n24    
PSK (from passphrase) - hexdump(len=32): [REMOVED]
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3e ssid='peartree_n24'
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=30): dd 1c 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02 0c 00
WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00
WPA: using GTK TKIP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: DISCONNECTED -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_psk
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
Ignore event for foreign ifindex 3
Ignore event for foreign ifindex 3
Ignore event for foreign ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b1a len=28
Ignore event for foreign ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 8899 bytes of scan results (17 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3e ssid='peartree_n24'
Already associated with the selected AP.
RSN: Ignored PMKID candidate without preauth flag
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
key_mgmt: 0x2
scan_ssid=1 (0x1)
PSK (ASCII passphrase) - hexdump_ascii(len=8): [REMOVED]
ssid - hexdump_ascii(len=12):
     70 65 61 72 74 72 65 65 5f 6e 32 34               peartree_n24    
PSK (from passphrase) - hexdump(len=32): [REMOVED]
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3e ssid='peartree_n24'
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=30): dd 1c 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02 0c 00
WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00
WPA: using GTK TKIP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: DISCONNECTED -> ASSOCIATING
wpa_supplicant_set_state: canceling DISCONNECT spam handler
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_psk
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=28
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 9012 bytes of scan results (18 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3e ssid='peartree_n24'
Already associated with the selected AP.
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8c08 len=181
AssocResp IE wireless event - hexdump(len=165): 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 2d 1a 6c 18 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6c 18 1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:23:69:35:d1:3e
Association info event
resp_ies - hexdump(len=165): 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 2d 1a 6c 18 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6c 18 1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATING -> ASSOCIATED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=00:23:69:35:d1:3e
No keys have been configured - skip key clearing
Associated with 00:23:69:35:d1:3e
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RX EAPOL from 00:23:69:35:d1:3e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 04
  key_nonce - hexdump(len=32): 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 29
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): e6 6c fb e3 58 7a 0f 25 32 d9 a4 cb e2 8d ba 7b 17 17 84 65 14 a3 c9 3d 98 60 c8 47 05 96 74 c5
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 04 e6 6c fb e3 58 7a 0f 25 32 d9 a4 cb e2 8d ba 7b 17 17 84 65 14 a3 c9 3d 98 60 c8 47 05 96 74 c5 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 81 1f ea 42 76 df ce a9 e4 9c 5f 5c e4 0b e5 b7 00 16 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3e
RX EAPOL - hexdump(len=179): 02 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 05 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 29 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2a ae 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0b b9 71 20 3e a1 90 64 09 ac 72 af a4 64 16 07 00 50 78 0c 0f c4 02 77 b2 c8 de 73 13 52 0c 25 1a 83 6b b6 0d c3 f5 8b 70 ca 82 d2 34 24 51 9e 4f 30 84 91 56 85 af 39 ea 66 6a cd bb c9 95 57 43 b9 68 51 b2 40 5c 02 89 ce 17 fe 5b 3a 01 50 c6 fe 57 b4 e1 54 f8 ed 26 23 22 90 f0 da e4 d0 63 d2
IEEE 802.1X RX: version=2 type=3 length=175
  EAPOL-Key type=2
  key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
  key_length=16 key_data_length=80
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 05
  key_nonce - hexdump(len=32): 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 29
  key_iv - hexdump(len=16): 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2a
  key_rsc - hexdump(len=8): ae 02 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 0b b9 71 20 3e a1 90 64 09 ac 72 af a4 64 16 07
WPA: RX EAPOL-Key - hexdump(len=179): 02 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 05 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 29 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2a ae 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0b b9 71 20 3e a1 90 64 09 ac 72 af a4 64 16 07 00 50 78 0c 0f c4 02 77 b2 c8 de 73 13 52 0c 25 1a 83 6b b6 0d c3 f5 8b 70 ca 82 d2 34 24 51 9e 4f 30 84 91 56 85 af 39 ea 66 6a cd bb c9 95 57 43 b9 68 51 b2 40 5c 02 89 ce 17 fe 5b 3a 01 50 c6 fe 57 b4 e1 54 f8 ed 26 23 22 90 f0 da e4 d0 63 d2
RSN: encrypted key data - hexdump(len=80): 78 0c 0f c4 02 77 b2 c8 de 73 13 52 0c 25 1a 83 6b b6 0d c3 f5 8b 70 ca 82 d2 34 24 51 9e 4f 30 84 91 56 85 af 39 ea 66 6a cd bb c9 95 57 43 b9 68 51 b2 40 5c 02 89 ce 17 fe 5b 3a 01 50 c6 fe 57 b4 e1 54 f8 ed 26 23 22 90 f0 da e4 d0 63 d2
WPA: decrypted EAPOL-Key key data - hexdump(len=72): [REMOVED]
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 3 of 4-Way Handshake from 00:23:69:35:d1:3e (ver=2)
WPA: IE KeyData - hexdump(len=72): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00 dd 26 00 0f ac 01 01 00 65 86 03 a6 05 0c b0 37 80 e1 0e 25 78 89 3d dc 76 0b 9d ad 37 d2 59 7b 5d 08 26 3d 72 e3 3e af dd 00 00 00 00 00
WPA: Sending EAPOL-Key 4/4
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 00 00 00 00 00 00 00 00 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4d 0f cc 94 01 77 70 3a 0f 54 97 73 c3 a3 39 4e 00 00
WPA: Installing PTK to the driver.
wpa_driver_wext_set_key: alg=3 key_idx=0 set_tx=1 seq_len=6 key_len=16
EAPOL: External notification - portValid=1
State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RSN: received GTK in pairwise handshake - hexdump(len=34): [REMOVED]
WPA: Group Key - hexdump(len=32): [REMOVED]
WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32).
WPA: RSC - hexdump(len=6): ae 02 00 00 00 00
wpa_driver_wext_set_key: alg=2 key_idx=1 set_tx=0 seq_len=6 key_len=32
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
Cancelling authentication timeout
State: GROUP_HANDSHAKE -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (reauth) [id=0 id_str=]
wpa_driver_wext_set_operstate: operstate 0->1 (UP)
WEXT: Operstate: linkmode=-1, operstate=6
EAPOL: External notification - portValid=1
EAPOL: External notification - EAP success=1
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state SUCCESS
EAP: EAP entering state DISABLED
EAPOL: SUPP_PAE entering state AUTHENTICATED
EAPOL: SUPP_BE entering state IDLE
EAPOL authentication completed successfully
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Ignore event for foreign ifindex 2
EAPOL: startWhen --> 0
EAPOL: disable timer tick
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
Authentication with 00:00:00:00:00:00 timed out.
Added BSSID 00:00:00:00:00:00 into blacklist
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Setting scan request: 0 sec 0 usec
Ignore event for foreign ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 9240 bytes of scan results (18 BSSes)
CTRL-EVENT-SCAN-RESULTS 
Setting scan request: 0 sec 0 usec
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
wpa_driver_wext_disassociate
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
State: COMPLETED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 1->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:00:00:00:00:00
BSSID 00:00:00:00:00:00 blacklist count incremented to 2
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_supplicant_event_disassoc: scheduled DISCONNECT spam handler
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Failed to get scan results
Failed to get scan results - try scanning again
Setting scan request: 1 sec 0 usec
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=48
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 9516 bytes of scan results (19 BSSes)
CTRL-EVENT-SCAN-RESULTS 
Ignore event for foreign ifindex 2
key_mgmt: 0x2
scan_ssid=1 (0x1)
PSK (ASCII passphrase) - hexdump_ascii(len=8): [REMOVED]
ssid - hexdump_ascii(len=12):
     70 65 61 72 74 72 65 65 5f 6e 32 34               peartree_n24    
PSK (from passphrase) - hexdump(len=32): [REMOVED]
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3e ssid='peartree_n24'
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=30): dd 1c 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02 0c 00
WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00
WPA: using GTK TKIP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: DISCONNECTED -> ASSOCIATING
wpa_supplicant_set_state: canceling DISCONNECT spam handler
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_psk
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=28
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 9518 bytes of scan results (19 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3e ssid='peartree_n24'
Already associated with the selected AP.
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8c08 len=181
AssocResp IE wireless event - hexdump(len=165): 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 2d 1a 6c 18 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6c 18 1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:23:69:35:d1:3e
Association info event
resp_ies - hexdump(len=165): 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 2d 1a 6c 18 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6c 18 1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATING -> ASSOCIATED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=00:23:69:35:d1:3e
No keys have been configured - skip key clearing
Associated with 00:23:69:35:d1:3e
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RX EAPOL from 00:23:69:35:d1:3e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 05 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 05
  key_nonce - hexdump(len=32): 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2a
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 05 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 82 a6 6b 69 73 3f 60 0e 35 9e e9 f5 c3 a3 aa d0 b8 bb f1 b4 dd a2 ca d8 17 2b 45 9d ab 76 81 a8
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 05 82 a6 6b 69 73 3f 60 0e 35 9e e9 f5 c3 a3 aa d0 b8 bb f1 b4 dd a2 ca d8 17 2b 45 9d ab 76 81 a8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f9 2e 3e 3d 93 f4 3d 63 84 f6 16 6b 69 76 cd a0 00 16 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3e
RX EAPOL - hexdump(len=179): 02 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 06 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2a 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2b c0 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 d5 47 88 c6 ce 4b 86 90 62 d0 29 6b 83 d5 6f b1 00 50 1c 6f db 78 2d e0 be b6 ef 56 23 44 b8 41 75 34 7e 9d 14 d2 8c fa 0e 95 f0 bc 72 12 d4 0a 6b fe ac eb a0 7d 82 ab 38 70 ab 20 b3 5c 9b 33 ba aa 61 56 05 e9 15 cb ab 4e d3 7d 73 bb 23 97 49 fd 6d ef 68 95 95 04 b0 85 22 fb 2d 12 a2 88 b6 30
IEEE 802.1X RX: version=2 type=3 length=175
  EAPOL-Key type=2
  key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
  key_length=16 key_data_length=80
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 06
  key_nonce - hexdump(len=32): 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2a
  key_iv - hexdump(len=16): 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2b
  key_rsc - hexdump(len=8): c0 02 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): d5 47 88 c6 ce 4b 86 90 62 d0 29 6b 83 d5 6f b1
WPA: RX EAPOL-Key - hexdump(len=179): 02 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 06 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2a 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2b c0 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 d5 47 88 c6 ce 4b 86 90 62 d0 29 6b 83 d5 6f b1 00 50 1c 6f db 78 2d e0 be b6 ef 56 23 44 b8 41 75 34 7e 9d 14 d2 8c fa 0e 95 f0 bc 72 12 d4 0a 6b fe ac eb a0 7d 82 ab 38 70 ab 20 b3 5c 9b 33 ba aa 61 56 05 e9 15 cb ab 4e d3 7d 73 bb 23 97 49 fd 6d ef 68 95 95 04 b0 85 22 fb 2d 12 a2 88 b6 30
RSN: encrypted key data - hexdump(len=80): 1c 6f db 78 2d e0 be b6 ef 56 23 44 b8 41 75 34 7e 9d 14 d2 8c fa 0e 95 f0 bc 72 12 d4 0a 6b fe ac eb a0 7d 82 ab 38 70 ab 20 b3 5c 9b 33 ba aa 61 56 05 e9 15 cb ab 4e d3 7d 73 bb 23 97 49 fd 6d ef 68 95 95 04 b0 85 22 fb 2d 12 a2 88 b6 30
WPA: decrypted EAPOL-Key key data - hexdump(len=72): [REMOVED]
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 3 of 4-Way Handshake from 00:23:69:35:d1:3e (ver=2)
WPA: IE KeyData - hexdump(len=72): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00 dd 26 00 0f ac 01 01 00 65 86 03 a6 05 0c b0 37 80 e1 0e 25 78 89 3d dc 76 0b 9d ad 37 d2 59 7b 5d 08 26 3d 72 e3 3e af dd 00 00 00 00 00
WPA: Sending EAPOL-Key 4/4
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 00 00 00 00 00 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 13 38 6c b6 db 02 3c 2e 94 46 14 29 ea d4 2a 6f 00 00
WPA: Installing PTK to the driver.
wpa_driver_wext_set_key: alg=3 key_idx=0 set_tx=1 seq_len=6 key_len=16
EAPOL: External notification - portValid=1
State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RSN: received GTK in pairwise handshake - hexdump(len=34): [REMOVED]
WPA: Group Key - hexdump(len=32): [REMOVED]
WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32).
WPA: RSC - hexdump(len=6): c0 02 00 00 00 00
wpa_driver_wext_set_key: alg=2 key_idx=1 set_tx=0 seq_len=6 key_len=32
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
Cancelling authentication timeout
State: GROUP_HANDSHAKE -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (reauth) [id=0 id_str=]
wpa_driver_wext_set_operstate: operstate 0->1 (UP)
WEXT: Operstate: linkmode=-1, operstate=6
EAPOL: External notification - portValid=1
EAPOL: External notification - EAP success=1
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state SUCCESS
EAP: EAP entering state DISABLED
EAPOL: SUPP_PAE entering state AUTHENTICATED
EAPOL: SUPP_BE entering state IDLE
EAPOL authentication completed successfully
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Ignore event for foreign ifindex 2
EAPOL: startWhen --> 0
EAPOL: disable timer tick
wpa_driver_wext_disassociate
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
State: COMPLETED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 1->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:00:00:00:00:00
BSSID 00:00:00:00:00:00 blacklist count incremented to 3
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_supplicant_event_disassoc: scheduled DISCONNECT spam handler
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=48
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
key_mgmt: 0x2
scan_ssid=1 (0x1)
PSK (ASCII passphrase) - hexdump_ascii(len=8): [REMOVED]
ssid - hexdump_ascii(len=12):
     70 65 61 72 74 72 65 65 5f 6e 35 30               peartree_n50    
PSK (from passphrase) - hexdump(len=32): [REMOVED]
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 9518 bytes of scan results (19 BSSes)
CTRL-EVENT-SCAN-RESULTS 
Ignore event for foreign ifindex 2
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:1b:9e:90:d8:cc ssid='Internet' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
2: 00:3a:98:a0:30:50 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
3: 00:3a:98:a0:30:52 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
4: 00:3a:98:a0:30:53 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
5: 00:3a:98:a0:70:42 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:3a:98:a0:70:40 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
7: 00:3a:98:a0:70:43 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
8: 00:3a:98:7d:27:32 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
9: 00:3a:98:7d:27:33 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
10: 00:3a:98:7d:27:30 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
11: 00:1b:11:e7:33:c7 ssid='glink' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
12: 00:3a:98:a0:72:62 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
13: 00:1e:79:d6:eb:73 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
14: 00:3a:98:a0:72:63 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
15: 00:1b:9e:90:d8:cd ssid='VOIP' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
16: 00:3a:98:a0:30:51 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
17: 00:3a:98:a0:70:41 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
18: 00:3a:98:7d:27:31 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
Try to find non-WPA AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:1b:9e:90:d8:cc ssid='Internet' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
2: 00:3a:98:a0:30:50 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
3: 00:3a:98:a0:30:52 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
4: 00:3a:98:a0:30:53 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
5: 00:3a:98:a0:70:42 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:3a:98:a0:70:40 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
7: 00:3a:98:a0:70:43 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
8: 00:3a:98:7d:27:32 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
9: 00:3a:98:7d:27:33 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
10: 00:3a:98:7d:27:30 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
11: 00:1b:11:e7:33:c7 ssid='glink' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
12: 00:3a:98:a0:72:62 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
13: 00:1e:79:d6:eb:73 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
14: 00:3a:98:a0:72:63 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
15: 00:1b:9e:90:d8:cd ssid='VOIP' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
16: 00:3a:98:a0:30:51 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
17: 00:3a:98:a0:70:41 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
18: 00:3a:98:7d:27:31 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
No APs found - clear blacklist and try again
Removed BSSID 00:00:00:00:00:00 from blacklist (clear)
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:1b:9e:90:d8:cc ssid='Internet' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
2: 00:3a:98:a0:30:50 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
3: 00:3a:98:a0:30:52 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
4: 00:3a:98:a0:30:53 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
5: 00:3a:98:a0:70:42 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:3a:98:a0:70:40 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
7: 00:3a:98:a0:70:43 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
8: 00:3a:98:7d:27:32 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
9: 00:3a:98:7d:27:33 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
10: 00:3a:98:7d:27:30 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
11: 00:1b:11:e7:33:c7 ssid='glink' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
12: 00:3a:98:a0:72:62 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
13: 00:1e:79:d6:eb:73 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
14: 00:3a:98:a0:72:63 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
15: 00:1b:9e:90:d8:cd ssid='VOIP' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
16: 00:3a:98:a0:30:51 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
17: 00:3a:98:a0:70:41 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
18: 00:3a:98:7d:27:31 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
Try to find non-WPA AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:1b:9e:90:d8:cc ssid='Internet' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
2: 00:3a:98:a0:30:50 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
3: 00:3a:98:a0:30:52 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
4: 00:3a:98:a0:30:53 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
5: 00:3a:98:a0:70:42 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:3a:98:a0:70:40 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
7: 00:3a:98:a0:70:43 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
8: 00:3a:98:7d:27:32 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
9: 00:3a:98:7d:27:33 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
10: 00:3a:98:7d:27:30 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
11: 00:1b:11:e7:33:c7 ssid='glink' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
12: 00:3a:98:a0:72:62 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
13: 00:1e:79:d6:eb:73 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
14: 00:3a:98:a0:72:63 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
15: 00:1b:9e:90:d8:cd ssid='VOIP' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
16: 00:3a:98:a0:30:51 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
17: 00:3a:98:a0:70:41 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
18: 00:3a:98:7d:27:31 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (specific SSID)
Scan SSID - hexdump_ascii(len=12):
     70 65 61 72 74 72 65 65 5f 6e 35 30               peartree_n50    
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 10165 bytes of scan results (20 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3f ssid='peartree_n50'
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_supplicant_set_state: canceling DISCONNECT spam handler
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_psk
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RSN: Ignored PMKID candidate without preauth flag
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=28
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 10163 bytes of scan results (20 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3f ssid='peartree_n50'
Already associated with the selected AP.
RSN: Ignored PMKID candidate without preauth flag
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8c08 len=175
AssocResp IE wireless event - hexdump(len=159): 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 6e 08 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 00 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6e 08 1b ff ff 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:23:69:35:d1:3f
Association info event
resp_ies - hexdump(len=159): 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 6e 08 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 00 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6e 08 1b ff ff 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATING -> ASSOCIATED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=00:23:69:35:d1:3f
No keys have been configured - skip key clearing
Associated with 00:23:69:35:d1:3f
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 06 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 27 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 06
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 27
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 06 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 27 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 14 ff 6e 6d 55 0d 0b 82 7c 44 a8 0d 3a a5 9b 41 b7 57 39 7d ac 2f de 2b 64 71 62 52 e7 7c 7d fe
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 06 14 ff 6e 6d 55 0d 0b 82 7c 44 a8 0d 3a a5 9b 41 b7 57 39 7d ac 2f de 2b 64 71 62 52 e7 7c 7d fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 28 fb 65 ce 68 99 e9 8a e3 91 10 a8 8b ae 72 6a 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 00 00 07 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 27 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 6c 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 15 0c ce 96 8b 40 4f 1a ba 42 3c 4a 65 86 72 f2 00 38 71 1c d7 b5 3c 16 28 4f 99 aa 6c e2 b9 7e 45 e9 46 2a 41 7c ea 33 33 e4 ee d3 8d 73 aa 1f 9e c1 28 f1 1b 32 74 17 99 69 f0 97 97 2c c4 47 bc 55 07 e2 39 69 58 12 b1 c5
IEEE 802.1X RX: version=2 type=3 length=151
  EAPOL-Key type=2
  key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
  key_length=16 key_data_length=56
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 07
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 27
  key_iv - hexdump(len=16): cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28
  key_rsc - hexdump(len=8): 6c 03 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 15 0c ce 96 8b 40 4f 1a ba 42 3c 4a 65 86 72 f2
WPA: RX EAPOL-Key - hexdump(len=155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 00 00 07 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 27 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 6c 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 15 0c ce 96 8b 40 4f 1a ba 42 3c 4a 65 86 72 f2 00 38 71 1c d7 b5 3c 16 28 4f 99 aa 6c e2 b9 7e 45 e9 46 2a 41 7c ea 33 33 e4 ee d3 8d 73 aa 1f 9e c1 28 f1 1b 32 74 17 99 69 f0 97 97 2c c4 47 bc 55 07 e2 39 69 58 12 b1 c5
RSN: encrypted key data - hexdump(len=56): 71 1c d7 b5 3c 16 28 4f 99 aa 6c e2 b9 7e 45 e9 46 2a 41 7c ea 33 33 e4 ee d3 8d 73 aa 1f 9e c1 28 f1 1b 32 74 17 99 69 f0 97 97 2c c4 47 bc 55 07 e2 39 69 58 12 b1 c5
WPA: decrypted EAPOL-Key key data - hexdump(len=48): [REMOVED]
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 3 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
WPA: IE KeyData - hexdump(len=48): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00 dd 16 00 0f ac 01 02 00 15 67 50 82 8c 0a f1 f6 03 4e bd 2b 1a 48 c7 74 dd 00
WPA: Sending EAPOL-Key 4/4
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 00 00 00 00 00 00 00 00 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 96 17 5d 96 5f 86 ca c2 a6 ce 0d 50 3e 43 0c 85 00 00
WPA: Installing PTK to the driver.
wpa_driver_wext_set_key: alg=3 key_idx=0 set_tx=1 seq_len=6 key_len=16
EAPOL: External notification - portValid=1
State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RSN: received GTK in pairwise handshake - hexdump(len=18): [REMOVED]
WPA: Group Key - hexdump(len=16): [REMOVED]
WPA: Installing GTK to the driver (keyidx=2 tx=0 len=16).
WPA: RSC - hexdump(len=6): 6c 03 00 00 00 00
wpa_driver_wext_set_key: alg=3 key_idx=2 set_tx=0 seq_len=6 key_len=16
WPA: Key negotiation completed with 00:23:69:35:d1:3f [PTK=CCMP GTK=CCMP]
Cancelling authentication timeout
State: GROUP_HANDSHAKE -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3f completed (reauth) [id=0 id_str=]
wpa_driver_wext_set_operstate: operstate 0->1 (UP)
WEXT: Operstate: linkmode=-1, operstate=6
EAPOL: External notification - portValid=1
EAPOL: External notification - EAP success=1
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state SUCCESS
EAP: EAP entering state DISABLED
EAPOL: SUPP_PAE entering state AUTHENTICATED
EAPOL: SUPP_BE entering state IDLE
EAPOL authentication completed successfully
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Ignore event for foreign ifindex 2
EAPOL: startWhen --> 0
EAPOL: disable timer tick
wpa_driver_wext_disassociate
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
State: COMPLETED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 1->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:00:00:00:00:00
Added BSSID 00:00:00:00:00:00 into blacklist
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_supplicant_event_disassoc: scheduled DISCONNECT spam handler
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=48
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
key_mgmt: 0x2
scan_ssid=1 (0x1)
PSK (ASCII passphrase) - hexdump_ascii(len=8): [REMOVED]
ssid - hexdump_ascii(len=12):
     70 65 61 72 74 72 65 65 5f 6e 32 34               peartree_n24    
PSK (from passphrase) - hexdump(len=32): [REMOVED]
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3e ssid='peartree_n24'
Trying to associate with 00:23:69:35:d1:3e (SSID='peartree_n24' freq=2412 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=30): dd 1c 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02 0c 00
WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00
WPA: using GTK TKIP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: DISCONNECTED -> ASSOCIATING
wpa_supplicant_set_state: canceling DISCONNECT spam handler
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_psk
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=28
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 9664 bytes of scan results (19 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3e ssid='peartree_n24'
Already associated with the selected AP.
RSN: Ignored PMKID candidate without preauth flag
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8c08 len=181
AssocResp IE wireless event - hexdump(len=165): 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 2d 1a 6c 18 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6c 18 1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:23:69:35:d1:3e
Association info event
resp_ies - hexdump(len=165): 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 2d 1a 6c 18 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6c 18 1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATING -> ASSOCIATED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=00:23:69:35:d1:3e
No keys have been configured - skip key clearing
Associated with 00:23:69:35:d1:3e
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RX EAPOL from 00:23:69:35:d1:3e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 06 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 06
  key_nonce - hexdump(len=32): 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2b
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 06 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 72 1c f2 43 9a 43 ef c7 6d d5 11 84 d3 c2 23 36 55 d5 a4 05 5d d4 1c c4 5a 40 8a e4 fe b7 a5 57
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 06 72 1c f2 43 9a 43 ef c7 6d d5 11 84 d3 c2 23 36 55 d5 a4 05 5d d4 1c c4 5a 40 8a e4 fe b7 a5 57 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 27 d1 79 93 99 1a f8 24 c6 93 0d 65 47 9f 0f 70 00 16 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 06 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 06
  key_nonce - hexdump(len=32): 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2c
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 06 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 06 72 1c f2 43 9a 43 ef c7 6d d5 11 84 d3 c2 23 36 55 d5 a4 05 5d d4 1c c4 5a 40 8a e4 fe b7 a5 57 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9b c5 70 47 32 99 a0 7f d6 bb ec 67 4b f1 2d eb 00 16 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3e
RX EAPOL - hexdump(len=179): 02 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 07 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2c 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2d d7 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a1 a3 0f 30 03 25 45 71 3a 63 49 1b a9 47 8e a8 00 50 c3 af fc 16 37 6e 02 1f 96 44 c3 84 ea 6c d3 16 62 c8 40 93 c9 f9 a4 2e 11 81 2d 0a da 36 e8 4e a9 ca aa 7e 28 fa 02 0d e4 6c 74 3b d5 27 12 b5 e3 d3 71 ce 50 42 3b 7a 1b 32 1e da 7a fb 1f aa 42 bf b4 50 5e e4 be b2 18 de b8 21 3e bb a2 99
IEEE 802.1X RX: version=2 type=3 length=175
  EAPOL-Key type=2
  key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
  key_length=16 key_data_length=80
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 07
  key_nonce - hexdump(len=32): 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2c
  key_iv - hexdump(len=16): 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2d
  key_rsc - hexdump(len=8): d7 02 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): a1 a3 0f 30 03 25 45 71 3a 63 49 1b a9 47 8e a8
WPA: RX EAPOL-Key - hexdump(len=179): 02 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 07 22 f6 c5 b1 bb 1b 3f 4f ac d2 19 4f 08 b3 6b 97 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2c 90 92 b2 73 07 f6 d0 88 46 eb 0c f6 ff 08 97 2d d7 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a1 a3 0f 30 03 25 45 71 3a 63 49 1b a9 47 8e a8 00 50 c3 af fc 16 37 6e 02 1f 96 44 c3 84 ea 6c d3 16 62 c8 40 93 c9 f9 a4 2e 11 81 2d 0a da 36 e8 4e a9 ca aa 7e 28 fa 02 0d e4 6c 74 3b d5 27 12 b5 e3 d3 71 ce 50 42 3b 7a 1b 32 1e da 7a fb 1f aa 42 bf b4 50 5e e4 be b2 18 de b8 21 3e bb a2 99
RSN: encrypted key data - hexdump(len=80): c3 af fc 16 37 6e 02 1f 96 44 c3 84 ea 6c d3 16 62 c8 40 93 c9 f9 a4 2e 11 81 2d 0a da 36 e8 4e a9 ca aa 7e 28 fa 02 0d e4 6c 74 3b d5 27 12 b5 e3 d3 71 ce 50 42 3b 7a 1b 32 1e da 7a fb 1f aa 42 bf b4 50 5e e4 be b2 18 de b8 21 3e bb a2 99
WPA: decrypted EAPOL-Key key data - hexdump(len=72): [REMOVED]
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 3 of 4-Way Handshake from 00:23:69:35:d1:3e (ver=2)
WPA: IE KeyData - hexdump(len=72): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00 dd 26 00 0f ac 01 01 00 65 86 03 a6 05 0c b0 37 80 e1 0e 25 78 89 3d dc 76 0b 9d ad 37 d2 59 7b 5d 08 26 3d 72 e3 3e af dd 00 00 00 00 00
WPA: Sending EAPOL-Key 4/4
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 00 00 00 00 00 00 00 00 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 29 f4 f5 f6 57 fc 4d 1d 3b 36 ec 32 2f e8 de f5 00 00
WPA: Installing PTK to the driver.
wpa_driver_wext_set_key: alg=3 key_idx=0 set_tx=1 seq_len=6 key_len=16
EAPOL: External notification - portValid=1
State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RSN: received GTK in pairwise handshake - hexdump(len=34): [REMOVED]
WPA: Group Key - hexdump(len=32): [REMOVED]
WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32).
WPA: RSC - hexdump(len=6): d7 02 00 00 00 00
wpa_driver_wext_set_key: alg=2 key_idx=1 set_tx=0 seq_len=6 key_len=32
WPA: Key negotiation completed with 00:23:69:35:d1:3e [PTK=CCMP GTK=TKIP]
Cancelling authentication timeout
State: GROUP_HANDSHAKE -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to 00:23:69:35:d1:3e completed (reauth) [id=0 id_str=]
wpa_driver_wext_set_operstate: operstate 0->1 (UP)
WEXT: Operstate: linkmode=-1, operstate=6
EAPOL: External notification - portValid=1
EAPOL: External notification - EAP success=1
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state SUCCESS
EAP: EAP entering state DISABLED
EAPOL: SUPP_PAE entering state AUTHENTICATED
EAPOL: SUPP_BE entering state IDLE
EAPOL authentication completed successfully
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Ignore event for foreign ifindex 2
EAPOL: startWhen --> 0
EAPOL: disable timer tick
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
Ignore event for foreign ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 8684 bytes of scan results (17 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_driver_wext_disassociate
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
State: COMPLETED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 1->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:00:00:00:00:00
BSSID 00:00:00:00:00:00 blacklist count incremented to 2
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_supplicant_event_disassoc: scheduled DISCONNECT spam handler
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=48
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Received 4076 bytes of scan results (8 BSSes)
CTRL-EVENT-SCAN-RESULTS 
Ignore event for foreign ifindex 2
key_mgmt: 0x2
scan_ssid=1 (0x1)
PSK (ASCII passphrase) - hexdump_ascii(len=8): [REMOVED]
ssid - hexdump_ascii(len=12):
     70 65 61 72 74 72 65 65 5f 6e 35 30               peartree_n50    
PSK (from passphrase) - hexdump(len=32): [REMOVED]
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3f ssid='peartree_n50'
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: DISCONNECTED -> ASSOCIATING
wpa_supplicant_set_state: canceling DISCONNECT spam handler
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_psk
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=28
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Received 4075 bytes of scan results (8 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3f ssid='peartree_n50'
Already associated with the selected AP.
RSN: Ignored PMKID candidate without preauth flag
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8c08 len=175
AssocResp IE wireless event - hexdump(len=159): 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 6e 08 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6e 08 1b ff ff 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:23:69:35:d1:3f
Association info event
resp_ies - hexdump(len=159): 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 6e 08 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6e 08 1b ff ff 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATING -> ASSOCIATED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=00:23:69:35:d1:3f
No keys have been configured - skip key clearing
Associated with 00:23:69:35:d1:3f
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 07 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 07
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 07 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 58 e8 27 92 97 dc 16 b6 9e e5 a5 01 e3 d8 8c 49 9c 7d 1f 6b 0c 84 bd 28 cc 6a a3 f6 60 f4 7b 28
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 07 58 e8 27 92 97 dc 16 b6 9e e5 a5 01 e3 d8 8c 49 9c 7d 1f 6b 0c 84 bd 28 cc 6a a3 f6 60 f4 7b 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f1 bb 7a 99 ab ed 32 92 72 ea 31 cb 00 b7 54 9f 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 08 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 08
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 08 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 08 58 e8 27 92 97 dc 16 b6 9e e5 a5 01 e3 d8 8c 49 9c 7d 1f 6b 0c 84 bd 28 cc 6a a3 f6 60 f4 7b 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 de e0 66 c3 e5 3c 1a 68 22 e6 b8 cb e6 90 c0 c0 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 09 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 09
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 09 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 09 58 e8 27 92 97 dc 16 b6 9e e5 a5 01 e3 d8 8c 49 9c 7d 1f 6b 0c 84 bd 28 cc 6a a3 f6 60 f4 7b 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 17 19 7d 2e 56 38 63 a0 8e 99 4b e2 12 25 15 0a 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 0a 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 0a
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 0a 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 0a 58 e8 27 92 97 dc 16 b6 9e e5 a5 01 e3 d8 8c 49 9c 7d 1f 6b 0c 84 bd 28 cc 6a a3 f6 60 f4 7b 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 5c 34 46 1f b6 47 31 37 12 89 52 15 ab 11 38 d3 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 0b 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 0b
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 0b 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 0b 58 e8 27 92 97 dc 16 b6 9e e5 a5 01 e3 d8 8c 49 9c 7d 1f 6b 0c 84 bd 28 cc 6a a3 f6 60 f4 7b 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9a a6 e4 86 ce f2 b0 02 1d 11 30 6a 73 fc 58 48 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 0c 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 0c
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 0c 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 0c 58 e8 27 92 97 dc 16 b6 9e e5 a5 01 e3 d8 8c 49 9c 7d 1f 6b 0c 84 bd 28 cc 6a a3 f6 60 f4 7b 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 74 3c 0a c0 8d f8 08 cc ed 24 30 1d 61 ec 3d 51 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 0d 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 0d
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 0d 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 0d 58 e8 27 92 97 dc 16 b6 9e e5 a5 01 e3 d8 8c 49 9c 7d 1f 6b 0c 84 bd 28 cc 6a a3 f6 60 f4 7b 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 8e 28 09 09 5d 9e 40 dc df f6 e1 b2 56 a2 d5 08 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 0e 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 0e
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 0e 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 0e 58 e8 27 92 97 dc 16 b6 9e e5 a5 01 e3 d8 8c 49 9c 7d 1f 6b 0c 84 bd 28 cc 6a a3 f6 60 f4 7b 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 8e 9b 23 60 2e 19 7c b6 fb d0 3f 27 b3 81 05 5a 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:00:00:00:00:00
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
Setting scan request: 0 sec 100000 usec
Added BSSID 00:23:69:35:d1:3f into blacklist
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
State: 4WAY_HANDSHAKE -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Ignore event for foreign ifindex 2
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
Authentication with 00:00:00:00:00:00 timed out.
BSSID 00:00:00:00:00:00 blacklist count incremented to 3
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (specific SSID)
Scan SSID - hexdump_ascii(len=12):
     70 65 61 72 74 72 65 65 5f 6e 35 30               peartree_n50    
Scan requested (ret=-1) - scan timeout 30 seconds
Failed to initiate AP scan.
Setting scan request: 10 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 10170 bytes of scan results (20 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3f ssid='peartree_n50'
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_psk
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=28
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8c08 len=175
AssocResp IE wireless event - hexdump(len=159): 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 6e 08 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 00 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6e 08 1b ff ff 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:23:69:35:d1:3f
Association info event
resp_ies - hexdump(len=159): 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 6e 08 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 00 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6e 08 1b ff ff 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATING -> ASSOCIATED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=00:23:69:35:d1:3f
No keys have been configured - skip key clearing
Associated with 00:23:69:35:d1:3f
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 00 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 00 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): e5 f3 8c 8d b8 f9 bd 95 e3 e9 55 58 ba f2 95 6f e8 06 53 0a b9 20 38 c7 30 c6 63 90 63 fa 81 21
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 00 e5 f3 8c 8d b8 f9 bd 95 e3 e9 55 58 ba f2 95 6f e8 06 53 0a b9 20 38 c7 30 c6 63 90 63 fa 81 21 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a0 7d 2f 96 13 72 e5 15 47 55 93 7e a5 c0 d6 9b 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 e5 f3 8c 8d b8 f9 bd 95 e3 e9 55 58 ba f2 95 6f e8 06 53 0a b9 20 38 c7 30 c6 63 90 63 fa 81 21 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 23 a5 d8 9a 41 f5 3e 7b f1 0c 02 a0 4d 17 e2 81 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 02 e5 f3 8c 8d b8 f9 bd 95 e3 e9 55 58 ba f2 95 6f e8 06 53 0a b9 20 38 c7 30 c6 63 90 63 fa 81 21 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e8 44 5e f7 15 5b 14 96 d3 a2 d3 d7 7a c3 4a 06 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 03
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 03 e5 f3 8c 8d b8 f9 bd 95 e3 e9 55 58 ba f2 95 6f e8 06 53 0a b9 20 38 c7 30 c6 63 90 63 fa 81 21 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7e f0 ac 72 5e 1c 1b 38 89 b6 53 68 47 2d 5d 20 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 04
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 04 e5 f3 8c 8d b8 f9 bd 95 e3 e9 55 58 ba f2 95 6f e8 06 53 0a b9 20 38 c7 30 c6 63 90 63 fa 81 21 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0d af 49 2f bb f7 ca b4 3b 9a 99 05 dc b6 51 87 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 05 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 05
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 05 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 05 e5 f3 8c 8d b8 f9 bd 95 e3 e9 55 58 ba f2 95 6f e8 06 53 0a b9 20 38 c7 30 c6 63 90 63 fa 81 21 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 88 57 3b 6c 7f 57 85 91 f4 d9 2e a6 f3 c1 ba b0 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 06 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 06
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 06 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 06 e5 f3 8c 8d b8 f9 bd 95 e3 e9 55 58 ba f2 95 6f e8 06 53 0a b9 20 38 c7 30 c6 63 90 63 fa 81 21 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08 22 e9 96 2f ed b0 54 bb 47 6c 67 17 63 6d 63 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 07 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 07
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 07 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 07 e5 f3 8c 8d b8 f9 bd 95 e3 e9 55 58 ba f2 95 6f e8 06 53 0a b9 20 38 c7 30 c6 63 90 63 fa 81 21 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ba 59 d3 98 89 b3 fc 41 df f2 51 c0 9b 00 4f 3e 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:00:00:00:00:00
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
Setting scan request: 0 sec 100000 usec
BSSID 00:23:69:35:d1:3f blacklist count incremented to 2
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
State: 4WAY_HANDSHAKE -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Ignore event for foreign ifindex 2
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
Authentication with 00:00:00:00:00:00 timed out.
BSSID 00:00:00:00:00:00 blacklist count incremented to 4
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (specific SSID)
Scan SSID - hexdump_ascii(len=12):
     70 65 61 72 74 72 65 65 5f 6e 35 30               peartree_n50    
Scan requested (ret=-1) - scan timeout 30 seconds
Failed to initiate AP scan.
Setting scan request: 10 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 10643 bytes of scan results (21 BSSes)
CTRL-EVENT-SCAN-RESULTS 
wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - blacklisted
2: 00:1b:9e:90:d8:cc ssid='Internet' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
3: 00:3a:98:a0:30:50 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
4: 00:3a:98:a0:30:53 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
5: 00:3a:98:a0:30:52 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:3a:98:a0:70:40 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
7: 00:3a:98:a0:70:43 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
8: 00:3a:98:a0:70:42 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
9: 00:3a:98:7d:27:32 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
10: 00:3a:98:7d:27:30 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
11: 00:3a:98:7d:27:33 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
12: 00:3a:98:a0:72:60 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
13: 00:3a:98:a0:72:63 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
14: 00:1b:11:e7:33:c7 ssid='glink' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
15: 00:3a:98:a0:72:62 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
16: 00:3a:98:a0:30:51 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
17: 00:1b:9e:90:d8:cd ssid='VOIP' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
18: 00:3a:98:a0:70:41 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
19: 00:3a:98:7d:27:31 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
20: 00:3a:98:a0:72:61 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
Try to find non-WPA AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - blacklisted
2: 00:1b:9e:90:d8:cc ssid='Internet' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
3: 00:3a:98:a0:30:50 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
4: 00:3a:98:a0:30:53 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
5: 00:3a:98:a0:30:52 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:3a:98:a0:70:40 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
7: 00:3a:98:a0:70:43 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
8: 00:3a:98:a0:70:42 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
9: 00:3a:98:7d:27:32 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
10: 00:3a:98:7d:27:30 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
11: 00:3a:98:7d:27:33 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
12: 00:3a:98:a0:72:60 ssid='RH_WLAN_TRUST' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
13: 00:3a:98:a0:72:63 ssid='Red Hat Guest' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
14: 00:1b:11:e7:33:c7 ssid='glink' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
15: 00:3a:98:a0:72:62 ssid='Red Hat' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
16: 00:3a:98:a0:30:51 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
17: 00:1b:9e:90:d8:cd ssid='VOIP' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
18: 00:3a:98:a0:70:41 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
19: 00:3a:98:7d:27:31 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
20: 00:3a:98:a0:72:61 ssid='rh-wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
No APs found - clear blacklist and try again
Removed BSSID 00:23:69:35:d1:3f from blacklist (clear)
Removed BSSID 00:00:00:00:00:00 from blacklist (clear)
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:23:69:35:d1:3e ssid='peartree_n24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:23:69:35:d1:3f ssid='peartree_n50' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:23:69:35:d1:3f ssid='peartree_n50'
Trying to associate with 00:23:69:35:d1:3f (SSID='peartree_n50' freq=5180 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_psk
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=28
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8c08 len=175
AssocResp IE wireless event - hexdump(len=159): 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 6e 08 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 00 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6e 08 1b ff ff 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:23:69:35:d1:3f
Association info event
resp_ies - hexdump(len=159): 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 6e 08 1b ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00 00 00 00 00 00 00 00 3d 16 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 00 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 6e 08 1b ff ff 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 24 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATING -> ASSOCIATED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=00:23:69:35:d1:3f
No keys have been configured - skip key clearing
Associated with 00:23:69:35:d1:3f
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 00 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 2a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 2a
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 00 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 2a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 65 29 ff af 6b 00 aa b7 82 13 49 4d 21 ed e9 07 59 4c 60 cd de ea 16 35 19 49 c5 cb cf 32 97 cd
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 00 65 29 ff af 6b 00 aa b7 82 13 49 4d 21 ed e9 07 59 4c 60 cd de ea 16 35 19 49 c5 cb cf 32 97 cd 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 37 8b 9a 9e ef 75 06 43 25 c0 3a 0d a6 ff b9 6e 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 2a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 2a
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 2a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 65 29 ff af 6b 00 aa b7 82 13 49 4d 21 ed e9 07 59 4c 60 cd de ea 16 35 19 49 c5 cb cf 32 97 cd 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 09 10 e0 a5 cc 35 40 a4 4a 94 68 48 90 57 e4 36 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:23:69:35:d1:3f
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 2a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 2a
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 0b a4 31 b4 1c f2 e3 bb 89 4a 9c b9 32 2a 08 a2 cc 77 65 c2 da 71 3c 49 a4 46 2e 40 7b cd 0a 2a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:23:69:35:d1:3f (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:24:d7:13:21:d4 A2=00:23:69:35:d1:3f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 02 65 29 ff af 6b 00 aa b7 82 13 49 4d 21 ed e9 07 59 4c 60 cd de ea 16 35 19 49 c5 cb cf 32 97 cd 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4e c9 9f 6f 30 46 f0 be 72 9e f9 04 f3 02 f9 db 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
wpa_driver_wext_disassociate
No keys have been configured - skip key clearing
State: 4WAY_HANDSHAKE -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:00:00:00:00:00
Added BSSID 00:00:00:00:00:00 into blacklist
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_supplicant_event_disassoc: scheduled DISCONNECT spam handler
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Ignore event for foreign ifindex 2
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b1a len=48
Ignore event for foreign ifindex 2
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Scan results did not fit - trying larger buffer (16384 bytes)
Received 10142 bytes of scan results (20 BSSes)
CTRL-EVENT-SCAN-RESULTS 
Ignore event for foreign ifindex 2
wpa_disconnect_spam_handle: 1 disconnect events in 6 seconds
Authentication with 00:00:00:00:00:00 timed out.
BSSID 00:00:00:00:00:00 blacklist count incremented to 2
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Setting scan request: 0 sec 0 usec
Setting scan request: 0 sec 0 usec
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
Ignore event for foreign ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Received 5932 bytes of scan results (11 BSSes)
CTRL-EVENT-SCAN-RESULTS 

--x+6KMIRAuhnl3hBn--
