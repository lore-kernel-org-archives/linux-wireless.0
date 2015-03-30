Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbbC3OXT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 10:23:19 -0400
Message-ID: <1427725371.1913.2.camel@redhat.com> (sfid-20150330_162325_112452_AEE796AB)
Subject: Re: 14e4:4331 [MacBookPro9,2] b43 802.11 won't connect to Verzion
 Jetpack MiFi 5510L (no secrets provided)
From: Dan Williams <dcbw@redhat.com>
To: "Christopher M. Penalver" <christopher.m.penalver@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	stefano.brivio@polimi.it
Date: Mon, 30 Mar 2015 09:22:51 -0500
In-Reply-To: <CAF4BKcAXZi_dbn-gMvobz7d_0z+dGiB60nt09CQHnWn+OBub=Q@mail.gmail.com>
References: <CAF4BKcAXZi_dbn-gMvobz7d_0z+dGiB60nt09CQHnWn+OBub=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-03-29 at 09:52 -0500, Christopher M. Penalver wrote:
> [1.] One line summary of the problem:
> 14e4:4331 [MacBookPro9,2] b43 802.11 won't connect to Verzion Jetpack
> MiFi 5510L (no secrets provided)
> 
> [2.] Full description of the problem/report:
> The laptop won't connect to an 802.11 g/n WAP. The same device with
> the proprietary bcmwl drivers works, and other devices (and operating
> systems) works fine with the same WAP. Latest router firmware and
> laptop BIOS already applied.

Mar 29 09:34:08 macbookpro kernel: [ 7347.474993] wlan1:
XX:XX:XX:XX:XX:XX denied association (code=27)

27 = Association denied because the requesting STA does not
support HT features

I'll leave it up to Arend to talk about specifics with Broadcom
hardware...

Dan

> Relevant syslog:
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) starting connection 'SSID'
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) scheduled...
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) started...
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: disconnected -> prepare (reason 'none') [30 40 0]
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) scheduled...
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) complete.
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) starting...
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: prepare -> config (reason 'none') [40 50 0]
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> Activation
> (wlan1/wireless): connection 'SSID' has security, and secrets exist.
> No new secrets needed.
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> Config: added
> 'ssid' value 'SSID'
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> Config: added
> 'scan_ssid' value '1'
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> Config: added
> 'key_mgmt' value 'WPA-PSK'
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> Config: added
> 'psk' value '<omitted>'
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) complete.
> Mar 29 09:34:07 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: inactive -> scanning
> Mar 29 09:34:07 macbookpro wpa_supplicant[838]: message repeated 7
> times: [ wlan1: CTRL-EVENT-SCAN-STARTED]
> Mar 29 09:34:08 macbookpro wpa_supplicant[838]: wlan1: SME: Trying to
> authenticate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:34:08 macbookpro kernel: [ 7347.429080] wlan1: authenticate
> with XX:XX:XX:XX:XX:XX
> Mar 29 09:34:08 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: scanning -> authenticating
> Mar 29 09:34:08 macbookpro wpa_supplicant[838]: wlan1: Trying to
> associate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:34:08 macbookpro kernel: [ 7347.468770] wlan1: send auth to
> XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:34:08 macbookpro kernel: [ 7347.470425] wlan1: authenticated
> Mar 29 09:34:08 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: authenticating -> associating
> Mar 29 09:34:08 macbookpro kernel: [ 7347.472671] wlan1: associate
> with XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:34:08 macbookpro kernel: [ 7347.474991] wlan1: RX AssocResp
> from XX:XX:XX:XX:XX:XX (capab=0x431 status=27 aid=0)
> Mar 29 09:34:08 macbookpro kernel: [ 7347.474993] wlan1:
> XX:XX:XX:XX:XX:XX denied association (code=27)
> Mar 29 09:34:08 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-ASSOC-REJECT bssid=XX:XX:XX:XX:XX:XX status_code=27
> Mar 29 09:34:08 macbookpro wpa_supplicant[838]: wlan1: SME: Deauth
> request to the driver failed
> Mar 29 09:34:08 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="SSID" auth_failures=1
> duration=10
> Mar 29 09:34:08 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: associating -> disconnected
> Mar 29 09:34:18 macbookpro wpa_supplicant[838]: wlan1: CTRL-EVENT-SCAN-STARTED
> Mar 29 09:34:18 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: disconnected -> scanning
> Mar 29 09:34:19 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-REENABLED id=0 ssid="SSID"
> Mar 29 09:34:19 macbookpro wpa_supplicant[838]: wlan1: SME: Trying to
> authenticate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:34:19 macbookpro kernel: [ 7358.762637] wlan1: authenticate
> with XX:XX:XX:XX:XX:XX
> Mar 29 09:34:19 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: scanning -> authenticating
> Mar 29 09:34:19 macbookpro wpa_supplicant[838]: wlan1: Trying to
> associate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:34:19 macbookpro kernel: [ 7358.802148] wlan1: send auth to
> XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:34:19 macbookpro kernel: [ 7358.803737] wlan1: authenticated
> Mar 29 09:34:19 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: authenticating -> associating
> Mar 29 09:34:19 macbookpro kernel: [ 7358.805992] wlan1: associate
> with XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:34:19 macbookpro kernel: [ 7358.808291] wlan1: RX AssocResp
> from XX:XX:XX:XX:XX:XX (capab=0x431 status=27 aid=0)
> Mar 29 09:34:19 macbookpro kernel: [ 7358.808293] wlan1:
> XX:XX:XX:XX:XX:XX denied association (code=27)
> Mar 29 09:34:20 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-ASSOC-REJECT bssid=XX:XX:XX:XX:XX:XX status_code=27
> Mar 29 09:34:20 macbookpro wpa_supplicant[838]: wlan1: SME: Deauth
> request to the driver failed
> Mar 29 09:34:20 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="SSID" auth_failures=2
> duration=20
> Mar 29 09:34:20 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: associating -> disconnected
> Mar 29 09:34:30 macbookpro wpa_supplicant[838]: wlan1: CTRL-EVENT-SCAN-STARTED
> Mar 29 09:34:30 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: disconnected -> scanning
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <warn> Activation
> (wlan1/wireless): association took too long.
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: config -> need-auth (reason 'none') [50 60 0]
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <warn> Activation
> (wlan1/wireless): asking for new secrets
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) scheduled...
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: scanning -> disconnected
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <warn> Couldn't
> disconnect supplicant interface: This interface is not connected.
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) started...
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: need-auth -> prepare (reason 'none') [60 40 0]
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) scheduled...
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) complete.
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) starting...
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: prepare -> config (reason 'none') [40 50 0]
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> Activation
> (wlan1/wireless): connection 'SSID' has security, and secrets exist.
> No new secrets needed.
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> Config: added
> 'key_mgmt' value 'WPA-PSK'
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> Config: added
> 'psk' value '<omitted>'
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) complete.
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> Config: set
> interface ap_scan to 1
> Mar 29 09:34:32 macbookpro wpa_supplicant[838]: wlan1: SME: Trying to
> authenticate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:34:32 macbookpro kernel: [ 7371.501734] wlan1: authenticate
> with XX:XX:XX:XX:XX:XX
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: disconnected -> authenticating
> Mar 29 09:34:32 macbookpro wpa_supplicant[838]: wlan1: Trying to
> associate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:34:32 macbookpro kernel: [ 7371.521182] wlan1: send auth to
> XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:34:32 macbookpro kernel: [ 7371.522634] wlan1: authenticated
> Mar 29 09:34:32 macbookpro kernel: [ 7371.524996] wlan1: associate
> with XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: authenticating -> associating
> Mar 29 09:34:32 macbookpro kernel: [ 7371.527223] wlan1: RX AssocResp
> from XX:XX:XX:XX:XX:XX (capab=0x431 status=27 aid=0)
> Mar 29 09:34:32 macbookpro kernel: [ 7371.527226] wlan1:
> XX:XX:XX:XX:XX:XX denied association (code=27)
> Mar 29 09:34:32 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-ASSOC-REJECT bssid=XX:XX:XX:XX:XX:XX status_code=27
> Mar 29 09:34:32 macbookpro wpa_supplicant[838]: wlan1: SME: Deauth
> request to the driver failed
> Mar 29 09:34:32 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="SSID" auth_failures=1
> duration=10
> Mar 29 09:34:32 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: associating -> disconnected
> Mar 29 09:34:42 macbookpro wpa_supplicant[838]: wlan1: CTRL-EVENT-SCAN-STARTED
> Mar 29 09:34:42 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: disconnected -> scanning
> Mar 29 09:34:43 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-REENABLED id=0 ssid="SSID"
> Mar 29 09:34:43 macbookpro wpa_supplicant[838]: wlan1: SME: Trying to
> authenticate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:34:43 macbookpro kernel: [ 7382.790854] wlan1: authenticate
> with XX:XX:XX:XX:XX:XX
> Mar 29 09:34:43 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: scanning -> authenticating
> Mar 29 09:34:43 macbookpro kernel: [ 7382.830511] wlan1: send auth to
> XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:34:43 macbookpro kernel: [ 7382.833948] wlan1: authenticated
> Mar 29 09:34:43 macbookpro wpa_supplicant[838]: wlan1: Trying to
> associate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:34:43 macbookpro kernel: [ 7382.834589] wlan1: associate
> with XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:34:43 macbookpro kernel: [ 7382.836909] wlan1: RX AssocResp
> from XX:XX:XX:XX:XX:XX (capab=0x431 status=27 aid=0)
> Mar 29 09:34:43 macbookpro kernel: [ 7382.836912] wlan1:
> XX:XX:XX:XX:XX:XX denied association (code=27)
> Mar 29 09:34:43 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: authenticating -> associating
> Mar 29 09:34:43 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-ASSOC-REJECT bssid=XX:XX:XX:XX:XX:XX status_code=27
> Mar 29 09:34:43 macbookpro wpa_supplicant[838]: wlan1: SME: Deauth
> request to the driver failed
> Mar 29 09:34:43 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="SSID" auth_failures=2
> duration=20
> Mar 29 09:34:44 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: associating -> disconnected
> Mar 29 09:34:53 macbookpro wpa_supplicant[838]: wlan1: CTRL-EVENT-SCAN-STARTED
> Mar 29 09:34:54 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: disconnected -> scanning
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <warn> Activation
> (wlan1/wireless): association took too long.
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: config -> need-auth (reason 'none') [50 60 0]
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <warn> Activation
> (wlan1/wireless): asking for new secrets
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) scheduled...
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: scanning -> disconnected
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <warn> Couldn't
> disconnect supplicant interface: This interface is not connected.
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) started...
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: need-auth -> prepare (reason 'none') [60 40 0]
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) scheduled...
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) complete.
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) starting...
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: prepare -> config (reason 'none') [40 50 0]
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> Activation
> (wlan1/wireless): connection 'SSID' has security, and secrets exist.
> No new secrets needed.
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> Config: added
> 'ssid' value 'SSID'
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> Config: added
> 'scan_ssid' value '1'
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> Config: added
> 'key_mgmt' value 'WPA-PSK'
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> Config: added
> 'psk' value '<omitted>'
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) complete.
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> Config: set
> interface ap_scan to 1
> Mar 29 09:34:57 macbookpro wpa_supplicant[838]: wlan1: SME: Trying to
> authenticate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:34:57 macbookpro kernel: [ 7396.541915] wlan1: authenticate
> with XX:XX:XX:XX:XX:XX
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: disconnected -> authenticating
> Mar 29 09:34:57 macbookpro wpa_supplicant[838]: wlan1: Trying to
> associate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:34:57 macbookpro kernel: [ 7396.558730] wlan1: send auth to
> XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:34:57 macbookpro kernel: [ 7396.560224] wlan1: authenticated
> Mar 29 09:34:57 macbookpro kernel: [ 7396.562549] wlan1: associate
> with XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: authenticating -> associating
> Mar 29 09:34:57 macbookpro kernel: [ 7396.565282] wlan1: RX AssocResp
> from XX:XX:XX:XX:XX:XX (capab=0x431 status=27 aid=0)
> Mar 29 09:34:57 macbookpro kernel: [ 7396.565285] wlan1:
> XX:XX:XX:XX:XX:XX denied association (code=27)
> Mar 29 09:34:57 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-ASSOC-REJECT bssid=XX:XX:XX:XX:XX:XX status_code=27
> Mar 29 09:34:57 macbookpro wpa_supplicant[838]: wlan1: SME: Deauth
> request to the driver failed
> Mar 29 09:34:57 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="SSID" auth_failures=1
> duration=10
> Mar 29 09:34:57 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: associating -> disconnected
> Mar 29 09:35:07 macbookpro wpa_supplicant[838]: wlan1: CTRL-EVENT-SCAN-STARTED
> Mar 29 09:35:07 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: disconnected -> scanning
> Mar 29 09:35:08 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-REENABLED id=0 ssid="SSID"
> Mar 29 09:35:08 macbookpro wpa_supplicant[838]: wlan1: SME: Trying to
> authenticate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:35:08 macbookpro kernel: [ 7407.844389] wlan1: authenticate
> with XX:XX:XX:XX:XX:XX
> Mar 29 09:35:08 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: scanning -> authenticating
> Mar 29 09:35:08 macbookpro wpa_supplicant[838]: wlan1: Trying to
> associate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:35:08 macbookpro kernel: [ 7407.884145] wlan1: send auth to
> XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:35:08 macbookpro kernel: [ 7407.885777] wlan1: authenticated
> Mar 29 09:35:08 macbookpro kernel: [ 7407.887893] wlan1: associate
> with XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:35:08 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: authenticating -> associating
> Mar 29 09:35:08 macbookpro kernel: [ 7407.890383] wlan1: RX AssocResp
> from XX:XX:XX:XX:XX:XX (capab=0x431 status=27 aid=0)
> Mar 29 09:35:08 macbookpro kernel: [ 7407.890386] wlan1:
> XX:XX:XX:XX:XX:XX denied association (code=27)
> Mar 29 09:35:09 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-ASSOC-REJECT bssid=XX:XX:XX:XX:XX:XX status_code=27
> Mar 29 09:35:09 macbookpro wpa_supplicant[838]: wlan1: SME: Deauth
> request to the driver failed
> Mar 29 09:35:09 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="SSID" auth_failures=2
> duration=20
> Mar 29 09:35:09 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: associating -> disconnected
> Mar 29 09:35:19 macbookpro wpa_supplicant[838]: wlan1: CTRL-EVENT-SCAN-STARTED
> Mar 29 09:35:19 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: disconnected -> scanning
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <warn> Activation
> (wlan1/wireless): association took too long.
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: config -> need-auth (reason 'none') [50 60 0]
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <warn> Activation
> (wlan1/wireless): asking for new secrets
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) scheduled...
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: scanning -> disconnected
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <warn> Couldn't
> disconnect supplicant interface: This interface is not connected.
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) started...
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: need-auth -> prepare (reason 'none') [60 40 0]
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) scheduled...
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) complete.
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) starting...
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: prepare -> config (reason 'none') [40 50 0]
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> Activation
> (wlan1/wireless): connection 'SSID' has security, and secrets exist.
> No new secrets needed.
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> Config: added
> 'ssid' value 'SSID'
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> Config: added
> 'scan_ssid' value '1'
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> Config: added
> 'key_mgmt' value 'WPA-PSK'
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> Config: added
> 'psk' value '<omitted>'
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) complete.
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> Config: set
> interface ap_scan to 1
> Mar 29 09:35:22 macbookpro wpa_supplicant[838]: wlan1: SME: Trying to
> authenticate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:35:22 macbookpro kernel: [ 7421.566392] wlan1: authenticate
> with XX:XX:XX:XX:XX:XX
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: disconnected -> authenticating
> Mar 29 09:35:22 macbookpro wpa_supplicant[838]: wlan1: Trying to
> associate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:35:22 macbookpro kernel: [ 7421.584256] wlan1: send auth to
> XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:35:22 macbookpro kernel: [ 7421.587726] wlan1: authenticated
> Mar 29 09:35:22 macbookpro kernel: [ 7421.588107] wlan1: associate
> with XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:35:22 macbookpro kernel: [ 7421.591068] wlan1: RX AssocResp
> from XX:XX:XX:XX:XX:XX (capab=0x431 status=27 aid=0)
> Mar 29 09:35:22 macbookpro kernel: [ 7421.591071] wlan1:
> XX:XX:XX:XX:XX:XX denied association (code=27)
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: authenticating -> associating
> Mar 29 09:35:22 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-ASSOC-REJECT bssid=XX:XX:XX:XX:XX:XX status_code=27
> Mar 29 09:35:22 macbookpro wpa_supplicant[838]: wlan1: SME: Deauth
> request to the driver failed
> Mar 29 09:35:22 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="SSID" auth_failures=1
> duration=10
> Mar 29 09:35:22 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: associating -> disconnected
> Mar 29 09:35:32 macbookpro wpa_supplicant[838]: wlan1: CTRL-EVENT-SCAN-STARTED
> Mar 29 09:35:32 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: disconnected -> scanning
> Mar 29 09:35:33 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-REENABLED id=0 ssid="SSID"
> Mar 29 09:35:33 macbookpro wpa_supplicant[838]: wlan1: SME: Trying to
> authenticate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:35:33 macbookpro kernel: [ 7432.865809] wlan1: authenticate
> with XX:XX:XX:XX:XX:XX
> Mar 29 09:35:33 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: scanning -> authenticating
> Mar 29 09:35:33 macbookpro kernel: [ 7432.905604] wlan1: send auth to
> XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:35:33 macbookpro wpa_supplicant[838]: wlan1: Trying to
> associate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:35:33 macbookpro kernel: [ 7432.911488] wlan1: authenticated
> Mar 29 09:35:33 macbookpro kernel: [ 7432.913412] wlan1: associate
> with XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:35:33 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: authenticating -> associating
> Mar 29 09:35:34 macbookpro kernel: [ 7433.117632] wlan1: associate
> with XX:XX:XX:XX:XX:XX (try 2/3)
> Mar 29 09:35:34 macbookpro kernel: [ 7433.321864] wlan1: associate
> with XX:XX:XX:XX:XX:XX (try 3/3)
> Mar 29 09:35:34 macbookpro kernel: [ 7433.526094] wlan1: association
> with XX:XX:XX:XX:XX:XX timed out
> Mar 29 09:35:34 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="SSID" auth_failures=2
> duration=20
> Mar 29 09:35:34 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: associating -> disconnected
> Mar 29 09:35:44 macbookpro wpa_supplicant[838]: wlan1: CTRL-EVENT-SCAN-STARTED
> Mar 29 09:35:44 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: disconnected -> scanning
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <warn> Activation
> (wlan1/wireless): association took too long.
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: config -> need-auth (reason 'none') [50 60 0]
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <warn> Activation
> (wlan1/wireless): asking for new secrets
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <warn> Couldn't
> disconnect supplicant interface: This interface is not connected.
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <warn> Couldn't
> disconnect supplicant interface: This interface is not connected.
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) scheduled...
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) started...
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: need-auth -> prepare (reason 'none') [60 40 0]
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) scheduled...
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 1 of 5 (Device Prepare) complete.
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) starting...
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: prepare -> config (reason 'none') [40 50 0]
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> Activation
> (wlan1/wireless): connection 'SSID' has security, and secrets exist.
> No new secrets needed.
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> Config: added
> 'ssid' value 'SSID'
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> Config: added
> 'scan_ssid' value '1'
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> Config: added
> 'key_mgmt' value 'WPA-PSK'
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> Config: added
> 'psk' value '<omitted>'
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> Activation
> (wlan1) Stage 2 of 5 (Device Configure) complete.
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <warn> Couldn't
> disconnect supplicant interface: This interface is not connected.
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> Config: set
> interface ap_scan to 1
> Mar 29 09:35:47 macbookpro wpa_supplicant[838]: wlan1: SME: Trying to
> authenticate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:35:47 macbookpro kernel: [ 7446.599366] wlan1: authenticate
> with XX:XX:XX:XX:XX:XX
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: scanning -> authenticating
> Mar 29 09:35:47 macbookpro wpa_supplicant[838]: wlan1: Trying to
> associate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:35:47 macbookpro kernel: [ 7446.617741] wlan1: send auth to
> XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:35:47 macbookpro kernel: [ 7446.620131] wlan1: authenticated
> Mar 29 09:35:47 macbookpro kernel: [ 7446.621529] wlan1: associate
> with XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:35:47 macbookpro kernel: [ 7446.625475] wlan1: RX AssocResp
> from XX:XX:XX:XX:XX:XX (capab=0x431 status=27 aid=0)
> Mar 29 09:35:47 macbookpro kernel: [ 7446.625479] wlan1:
> XX:XX:XX:XX:XX:XX denied association (code=27)
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: authenticating -> associating
> Mar 29 09:35:47 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-ASSOC-REJECT bssid=XX:XX:XX:XX:XX:XX status_code=27
> Mar 29 09:35:47 macbookpro wpa_supplicant[838]: wlan1: SME: Deauth
> request to the driver failed
> Mar 29 09:35:47 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="SSID" auth_failures=1
> duration=10
> Mar 29 09:35:47 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: associating -> disconnected
> Mar 29 09:35:57 macbookpro wpa_supplicant[838]: wlan1: CTRL-EVENT-SCAN-STARTED
> Mar 29 09:35:57 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: disconnected -> scanning
> Mar 29 09:35:58 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-REENABLED id=0 ssid="SSID"
> Mar 29 09:35:58 macbookpro wpa_supplicant[838]: wlan1: SME: Trying to
> authenticate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:35:58 macbookpro kernel: [ 7457.887321] wlan1: authenticate
> with XX:XX:XX:XX:XX:XX
> Mar 29 09:35:58 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: scanning -> authenticating
> Mar 29 09:35:58 macbookpro wpa_supplicant[838]: wlan1: Trying to
> associate with XX:XX:XX:XX:XX:XX (SSID='SSID' freq=2427 MHz)
> Mar 29 09:35:58 macbookpro kernel: [ 7457.927006] wlan1: send auth to
> XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:35:58 macbookpro kernel: [ 7457.928540] wlan1: authenticated
> Mar 29 09:35:58 macbookpro kernel: [ 7457.930844] wlan1: associate
> with XX:XX:XX:XX:XX:XX (try 1/3)
> Mar 29 09:35:58 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: authenticating -> associating
> Mar 29 09:35:58 macbookpro kernel: [ 7457.933197] wlan1: RX AssocResp
> from XX:XX:XX:XX:XX:XX (capab=0x431 status=27 aid=0)
> Mar 29 09:35:58 macbookpro kernel: [ 7457.933200] wlan1:
> XX:XX:XX:XX:XX:XX denied association (code=27)
> Mar 29 09:35:59 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-ASSOC-REJECT bssid=XX:XX:XX:XX:XX:XX status_code=27
> Mar 29 09:35:59 macbookpro wpa_supplicant[838]: wlan1: SME: Deauth
> request to the driver failed
> Mar 29 09:35:59 macbookpro wpa_supplicant[838]: wlan1:
> CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="SSID" auth_failures=2
> duration=20
> Mar 29 09:35:59 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: associating -> disconnected
> Mar 29 09:36:09 macbookpro wpa_supplicant[838]: wlan1: CTRL-EVENT-SCAN-STARTED
> Mar 29 09:36:09 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: disconnected -> scanning
> Mar 29 09:36:12 macbookpro NetworkManager[755]: <warn> Activation
> (wlan1/wireless): association took too long.
> Mar 29 09:36:12 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: config -> failed (reason 'no-secrets') [50 120 7]
> Mar 29 09:36:12 macbookpro NetworkManager[755]: <warn> Activation
> (wlan1) failed for connection 'SSID'
> Mar 29 09:36:12 macbookpro NetworkManager[755]: <info> (wlan1): device
> state change: failed -> disconnected (reason 'none') [120 30 0]
> Mar 29 09:36:12 macbookpro NetworkManager[755]: <info> (wlan1):
> deactivating device (reason 'none') [0]
> Mar 29 09:36:12 macbookpro NetworkManager[755]: <info> (wlan1):
> supplicant interface state: scanning -> disconnected
> Mar 29 09:36:12 macbookpro NetworkManager[755]: <warn> Couldn't
> disconnect supplicant interface: This interface is not connected.
> 
> [3.] Keywords (i.e., modules, networking, kernel): N/A
> 
> [4.] Kernel version (from /proc/version):
> cat /proc/version
> Linux version 4.0.0-040000rc5-generic (kernel@gomeisa) (gcc version
> 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201503230035 SMP Mon Mar 23
> 04:36:26 UTC 2015
> 
> [5.] Output of Oops.. message (if applicable) with symbolic
> information resolved (see Documentation/oops-tracing.txt) N/A
> 
> [6.] A small shell script or example program which triggers the
> problem (if possible) N/A
> 
> [7.] Environment
> lsb_release -rd
> Description:    Ubuntu Vivid Vervet (development branch)
> Release:        15.04
> 
> [7.1.] Software (add the output of the ver_linux script here)
> sudo bash /usr/src/linux-headers-4.0.0-040000rc5/scripts/ver_linux
> [sudo] password for moniker:
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
> 
> Linux macbookpro 4.0.0-040000rc5-generic #201503230035 SMP Mon Mar 23
> 04:36:26 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
> Gnu C                  4.9.2
> Gnu make               4.0
> binutils               2.25
> util-linux             2.25.2
> mount                  debug
> module-init-tools      18
> e2fsprogs              1.42.12
> pcmciautils            018
> PPP                    2.4.6
> Linux C Library        Dynamic linker (ldd)   2.21
> Procps                 3.3.9
> Net-tools              1.60
> Kbd                    1.15.5
> Sh-utils               8.23
> wireless-tools         30
> Modules Loaded         rfcomm bnep btusb bluetooth r8712u uvcvideo
> arc4 b43 videobuf2_vmalloc videobuf2_memops mac80211 videobuf2_core
> v4l2_common videodev cfg80211 snd_hda_codec_hdmi intel_rapl
> hid_appleir snd_hda_codec_cirrus snd_hda_codec_generic media
> snd_hda_intel snd_hda_controller iosf_mbi joydev bcm5974 ssb
> x86_pkg_temp_thermal intel_powerclamp snd_hda_codec snd_hwdep coretemp
> snd_pcm kvm_intel snd_seq_midi snd_seq_midi_event kvm applesmc
> snd_rawmidi input_polldev snd_seq snd_seq_device crct10dif_pclmul
> crc32_pclmul ghash_clmulni_intel aesni_intel snd_timer aes_x86_64 lrw
> mei_me gf128mul glue_helper bcma mei snd ablk_helper cryptd sbs
> lpc_ich shpchp soundcore apple_gmux sbshc apple_bl mac_hid parport_pc
> ppdev lp parport autofs4 hid_generic hid_apple usbhid hid i915 ahci
> firewire_ohci libahci firewire_core crc_itu_t sdhci_pci tg3
> i2c_algo_bit drm_kms_helper sdhci ptp drm pps_core video
> 
> [7.2.] Processor information (from /proc/cpuinfo):
> cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 58
> model name      : Intel(R) Core(TM) i5-3210M CPU @ 2.50GHz
> stepping        : 9
> microcode       : 0x15
> cpu MHz         : 1230.957
> cache size      : 3072 KB
> physical id     : 0
> siblings        : 4
> core id         : 0
> cpu cores       : 2
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
> xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic
> popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat
> pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep
> erms xsaveopt
> bugs            :
> bogomips        : 4988.49
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 58
> model name      : Intel(R) Core(TM) i5-3210M CPU @ 2.50GHz
> stepping        : 9
> microcode       : 0x15
> cpu MHz         : 1201.269
> cache size      : 3072 KB
> physical id     : 0
> siblings        : 4
> core id         : 1
> cpu cores       : 2
> apicid          : 2
> initial apicid  : 2
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
> xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic
> popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat
> pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep
> erms xsaveopt
> bugs            :
> bogomips        : 4988.49
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 2
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 58
> model name      : Intel(R) Core(TM) i5-3210M CPU @ 2.50GHz
> stepping        : 9
> microcode       : 0x15
> cpu MHz         : 1200.097
> cache size      : 3072 KB
> physical id     : 0
> siblings        : 4
> core id         : 0
> cpu cores       : 2
> apicid          : 1
> initial apicid  : 1
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
> xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic
> popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat
> pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep
> erms xsaveopt
> bugs            :
> bogomips        : 4988.49
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 3
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 58
> model name      : Intel(R) Core(TM) i5-3210M CPU @ 2.50GHz
> stepping        : 9
> microcode       : 0x15
> cpu MHz         : 1203.613
> cache size      : 3072 KB
> physical id     : 0
> siblings        : 4
> core id         : 1
> cpu cores       : 2
> apicid          : 3
> initial apicid  : 3
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
> xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic
> popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat
> pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep
> erms xsaveopt
> bugs            :
> bogomips        : 4988.49
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> [7.3.] Module information (from /proc/modules):
> cat /proc/modules
> rfcomm 77824 8 - Live 0x0000000000000000
> bnep 24576 2 - Live 0x0000000000000000
> btusb 45056 0 - Live 0x0000000000000000
> bluetooth 524288 22 rfcomm,bnep,btusb, Live 0x0000000000000000
> r8712u 184320 0 - Live 0x0000000000000000 (C)
> uvcvideo 94208 0 - Live 0x0000000000000000
> arc4 16384 2 - Live 0x0000000000000000
> b43 434176 0 - Live 0x0000000000000000
> videobuf2_vmalloc 16384 1 uvcvideo, Live 0x0000000000000000
> videobuf2_memops 16384 1 videobuf2_vmalloc, Live 0x0000000000000000
> mac80211 774144 1 b43, Live 0x0000000000000000
> videobuf2_core 53248 1 uvcvideo, Live 0x0000000000000000
> v4l2_common 16384 1 videobuf2_core, Live 0x0000000000000000
> videodev 163840 3 uvcvideo,videobuf2_core,v4l2_common, Live 0x0000000000000000
> cfg80211 581632 2 b43,mac80211, Live 0x0000000000000000
> snd_hda_codec_hdmi 53248 1 - Live 0x0000000000000000
> intel_rapl 20480 0 - Live 0x0000000000000000
> hid_appleir 16384 0 - Live 0x0000000000000000
> snd_hda_codec_cirrus 20480 1 - Live 0x0000000000000000
> snd_hda_codec_generic 73728 1 snd_hda_codec_cirrus, Live 0x0000000000000000
> media 24576 2 uvcvideo,videodev, Live 0x0000000000000000
> snd_hda_intel 32768 3 - Live 0x0000000000000000
> snd_hda_controller 36864 1 snd_hda_intel, Live 0x0000000000000000
> iosf_mbi 16384 1 intel_rapl, Live 0x0000000000000000
> joydev 20480 0 - Live 0x0000000000000000
> bcm5974 20480 0 - Live 0x0000000000000000
> ssb 69632 1 b43, Live 0x0000000000000000
> x86_pkg_temp_thermal 16384 0 - Live 0x0000000000000000
> intel_powerclamp 20480 0 - Live 0x0000000000000000
> snd_hda_codec 147456 5
> snd_hda_codec_hdmi,snd_hda_codec_cirrus,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller,
> Live 0x0000000000000000
> snd_hwdep 16384 1 snd_hda_codec, Live 0x0000000000000000
> coretemp 16384 0 - Live 0x0000000000000000
> snd_pcm 110592 4
> snd_hda_codec_hdmi,snd_hda_intel,snd_hda_controller,snd_hda_codec,
> Live 0x0000000000000000
> kvm_intel 159744 0 - Live 0x0000000000000000
> snd_seq_midi 16384 0 - Live 0x0000000000000000
> snd_seq_midi_event 16384 1 snd_seq_midi, Live 0x0000000000000000
> kvm 512000 1 kvm_intel, Live 0x0000000000000000
> applesmc 20480 0 - Live 0x0000000000000000
> snd_rawmidi 32768 1 snd_seq_midi, Live 0x0000000000000000
> input_polldev 16384 1 applesmc, Live 0x0000000000000000
> snd_seq 69632 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
> snd_seq_device 16384 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
> crct10dif_pclmul 16384 0 - Live 0x0000000000000000
> crc32_pclmul 16384 0 - Live 0x0000000000000000
> ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
> aesni_intel 172032 1 - Live 0x0000000000000000
> snd_timer 32768 2 snd_pcm,snd_seq, Live 0x0000000000000000
> aes_x86_64 20480 1 aesni_intel, Live 0x0000000000000000
> lrw 16384 1 aesni_intel, Live 0x0000000000000000
> mei_me 20480 0 - Live 0x0000000000000000
> gf128mul 16384 1 lrw, Live 0x0000000000000000
> glue_helper 16384 1 aesni_intel, Live 0x0000000000000000
> bcma 61440 1 b43, Live 0x0000000000000000
> mei 90112 1 mei_me, Live 0x0000000000000000
> snd 86016 17 snd_hda_codec_hdmi,snd_hda_codec_cirrus,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
> Live 0x0000000000000000
> ablk_helper 16384 1 aesni_intel, Live 0x0000000000000000
> cryptd 24576 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
> 0x0000000000000000
> sbs 16384 0 - Live 0x0000000000000000
> lpc_ich 24576 0 - Live 0x0000000000000000
> shpchp 40960 0 - Live 0x0000000000000000
> soundcore 16384 2 snd_hda_codec,snd, Live 0x0000000000000000
> apple_gmux 16384 0 - Live 0x0000000000000000
> sbshc 16384 1 sbs, Live 0x0000000000000000
> apple_bl 16384 1 apple_gmux, Live 0x0000000000000000
> mac_hid 16384 0 - Live 0x0000000000000000
> parport_pc 36864 0 - Live 0x0000000000000000
> ppdev 20480 0 - Live 0x0000000000000000
> lp 20480 0 - Live 0x0000000000000000
> parport 45056 3 parport_pc,ppdev,lp, Live 0x0000000000000000
> autofs4 40960 2 - Live 0x0000000000000000
> hid_generic 16384 0 - Live 0x0000000000000000
> hid_apple 16384 0 - Live 0x0000000000000000
> usbhid 53248 0 - Live 0x0000000000000000
> hid 114688 4 hid_appleir,hid_generic,hid_apple,usbhid, Live 0x0000000000000000
> i915 1126400 6 - Live 0x0000000000000000
> ahci 36864 2 - Live 0x0000000000000000
> firewire_ohci 49152 0 - Live 0x0000000000000000
> libahci 32768 1 ahci, Live 0x0000000000000000
> firewire_core 69632 1 firewire_ohci, Live 0x0000000000000000
> crc_itu_t 16384 1 firewire_core, Live 0x0000000000000000
> sdhci_pci 24576 0 - Live 0x0000000000000000
> tg3 180224 0 - Live 0x0000000000000000
> i2c_algo_bit 16384 1 i915, Live 0x0000000000000000
> drm_kms_helper 126976 1 i915, Live 0x0000000000000000
> sdhci 45056 1 sdhci_pci, Live 0x0000000000000000
> ptp 20480 1 tg3, Live 0x0000000000000000
> drm 352256 8 i915,drm_kms_helper, Live 0x0000000000000000
> pps_core 20480 1 ptp, Live 0x0000000000000000
> video 28672 2 apple_gmux,i915, Live 0x0000000000000000
> 
> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
> cat /proc/ioports
> 0000-0cf7 : PCI Bus 0000:00
>   0000-001f : dma1
>   0020-0021 : pic1
>   0040-0043 : timer0
>   0050-0053 : timer1
>   0060-0060 : keyboard
>   0062-0062 : PNP0C09:00
>     0062-0062 : EC data
>   0064-0064 : keyboard
>   0066-0066 : PNP0C09:00
>     0066-0066 : EC cmd
>   0070-0077 : rtc0
>   0080-008f : dma page reg
>   00a0-00a1 : pic2
>   00b2-00b3 : Apple backlight
>   00c0-00df : dma2
>   00f0-00ff : fpu
>     00f0-00f0 : PNP0C04:00
>   0300-031f : APP0001:00
>     0300-031f : applesmc
>   03c0-03df : vesafb
>   0400-0403 : ACPI PM1a_EVT_BLK
>   0404-0405 : ACPI PM1a_CNT_BLK
>   0408-040b : ACPI PM_TMR
>   0410-0415 : ACPI CPU throttle
>   0420-042f : ACPI GPE0_BLK
>   0430-0433 : iTCO_wdt
>   0450-0450 : ACPI PM2_CNT_BLK
>   0460-047f : iTCO_wdt
>   0500-057f : pnp 00:01
> 0cf8-0cff : PCI conf1
> 0d00-ffff : PCI Bus 0000:00
>   1000-100f : pnp 00:01
>   2000-203f : 0000:00:02.0
>   2060-207f : 0000:00:1f.2
>     2060-207f : ahci
>   2090-2097 : 0000:00:1f.2
>     2090-2097 : ahci
>   2098-209f : 0000:00:1f.2
>     2098-209f : ahci
>   20b8-20bb : 0000:00:1f.2
>     20b8-20bb : ahci
>   20bc-20bf : 0000:00:1f.2
>     20bc-20bf : ahci
>   3000-5fff : PCI Bus 0000:04
>     3000-4fff : PCI Bus 0000:05
>       3000-3fff : PCI Bus 0000:08
>       4000-4fff : PCI Bus 0000:39
>   efa0-efbf : 0000:00:1f.3
> 
> cat /proc/iomem
> 00000000-00000fff : reserved
> 00001000-0008dfff : System RAM
> 0008e000-0008ffff : reserved
> 00090000-0009fbff : System RAM
> 0009fc00-000bffff : reserved
>   000a0000-000bffff : PCI Bus 0000:00
> 000c0000-000ce9ff : Video ROM
> 000e0000-000fffff : reserved
>   000f0000-000fffff : System ROM
> 00100000-1fffffff : System RAM
>   01000000-017f1c58 : Kernel code
>   017f1c59-01d1c2ff : Kernel data
>   01e89000-01fcbfff : Kernel bss
> 20000000-201fffff : reserved
>   20000000-201fffff : pnp 00:05
> 20200000-40003fff : System RAM
> 40004000-40004fff : reserved
> 40005000-8ad13fff : System RAM
> 8ad14000-8ad52fff : ACPI Non-volatile Storage
> 8ad53000-8ad68fff : System RAM
> 8ad69000-8ad8efff : ACPI Tables
> 8ad8f000-8af8ffff : System RAM
> 8af90000-8affefff : reserved
> 8afff000-8affffff : System RAM
> 8b000000-8f9fffff : reserved
>   8ba00000-8f9fffff : Graphics Stolen Memory
> 8fa00000-feafffff : PCI Bus 0000:00
>   90000000-9fffffff : 0000:00:02.0
>   a0000000-a03fffff : 0000:00:02.0
>   a0400000-a04fffff : PCI Bus 0000:01
>     a0400000-a040ffff : 0000:01:00.0
>       a0400000-a040ffff : tg3
>     a0410000-a041ffff : 0000:01:00.0
>       a0410000-a041ffff : tg3
>     a0420000-a042ffff : 0000:01:00.1
>       a0420000-a042ffff : mmc0
>   a0500000-a05fffff : PCI Bus 0000:03
>     a0500000-a0500fff : 0000:03:00.0
>       a0500000-a0500fff : firewire_ohci
>   a0600000-a06fffff : PCI Bus 0000:02
>     a0600000-a0603fff : 0000:02:00.0
>       a0600000-a0603fff : bcma-pci-bridge
>   a0700000-a07fffff : PCI Bus 0000:01
>   a0800000-a080ffff : 0000:00:14.0
>     a0800000-a080ffff : xhci-hcd
>   a0810000-a0813fff : 0000:00:1b.0
>     a0810000-a0813fff : ICH HD audio
>   a0816000-a08167ff : 0000:00:1f.2
>     a0816000-a08167ff : ahci
>   a0816800-a0816bff : 0000:00:1d.0
>     a0816800-a0816bff : ehci_hcd
>   a0816c00-a0816fff : 0000:00:1a.0
>     a0816c00-a0816fff : ehci_hcd
>   a0817000-a08170ff : 0000:00:1f.3
>   a0817100-a081710f : 0000:00:16.0
>     a0817100-a081710f : mei_me
>   a0900000-acbfffff : PCI Bus 0000:04
>     a0900000-a8bfffff : PCI Bus 0000:05
>       a0900000-a09fffff : PCI Bus 0000:6a
>       a0a00000-a0afffff : PCI Bus 0000:07
>       a0b00000-a0bfffff : PCI Bus 0000:06
>         a0b00000-a0b3ffff : 0000:06:00.0
>         a0b40000-a0b40fff : 0000:06:00.0
>       a0c00000-a4bfffff : PCI Bus 0000:08
>       a4c00000-a8bfffff : PCI Bus 0000:39
>   acc00000-b8bfffff : PCI Bus 0000:04
>     acc00000-b4bfffff : PCI Bus 0000:05
>       acc00000-b0bfffff : PCI Bus 0000:08
>       b0c00000-b4bfffff : PCI Bus 0000:39
>   e0000000-efffffff : reserved
>     e0000000-efffffff : pnp 00:04
>       e0000000-e9afffff : PCI MMCONFIG 0000 [bus 00-9a]
> fec00000-fec00fff : reserved
>   fec00000-fec003ff : IOAPIC 0
> fed00000-fed03fff : reserved
>   fed00000-fed003ff : HPET 0
>     fed00000-fed003ff : pnp 00:00
> fed10000-fed13fff : reserved
> fed18000-fed19fff : reserved
>   fed18000-fed18fff : pnp 00:04
>   fed19000-fed19fff : pnp 00:04
> fed1c000-fed1ffff : reserved
>   fed1c000-fed1ffff : pnp 00:04
>     fed1f410-fed1f414 : iTCO_wdt
> fed20000-fed3ffff : pnp 00:04
> fed40000-fed44fff : PCI Bus 0000:00
> fed45000-fed8ffff : pnp 00:04
> fee00000-fee00fff : Local APIC
>   fee00000-fee00fff : reserved
> fef00000-fef0ffff : APP0001:00
> ff000000-ffffffff : INT0800:00
>   ff800000-ffffffff : reserved
> 100000000-16f5fffff : System RAM
> 16f600000-16fffffff : RAM buffer
> 
> [7.5.] PCI information ('lspci -vvv' as root)
> lspci -vvv
> 00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM
> Controller (rev 09)
>         Subsystem: Apple Inc. Device 00fa
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ >SERR- <PERR- INTx-
>         Latency: 0
>         Capabilities: <access denied>
>         Kernel driver in use: ivb_uncore
> 
> 00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core
> processor PCI Express Root Port (rev 09) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Bus: primary=00, secondary=04, subordinate=9a, sec-latency=0
>         I/O behind bridge: 00003000-00005fff
>         Memory behind bridge: a0900000-acbfffff
>         Prefetchable memory behind bridge: 00000000acc00000-00000000b8bfffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
> 
> 00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core
> processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
>         Subsystem: Apple Inc. Device 00fa
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 34
>         Region 0: Memory at a0000000 (64-bit, non-prefetchable) [size=4M]
>         Region 2: Memory at 90000000 (64-bit, prefetchable) [size=256M]
>         Region 4: I/O ports at 2000 [size=64]
>         Expansion ROM at <unassigned> [disabled]
>         Capabilities: <access denied>
>         Kernel driver in use: i915
> 
> 00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
> Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])
>         Subsystem: Intel Corporation Device 7270
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 31
>         Region 0: Memory at a0800000 (64-bit, non-prefetchable) [size=64K]
>         Capabilities: <access denied>
>         Kernel driver in use: xhci_hcd
> 
> 00:16.0 Communication controller: Intel Corporation 7 Series/C210
> Series Chipset Family MEI Controller #1 (rev 04)
>         Subsystem: Intel Corporation Device 7270
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 35
>         Region 0: Memory at a0817100 (64-bit, non-prefetchable) [size=16]
>         Capabilities: <access denied>
>         Kernel driver in use: mei_me
> 
> 00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
> Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
>         Subsystem: Intel Corporation Device 7270
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 23
>         Region 0: Memory at a0816c00 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: <access denied>
>         Kernel driver in use: ehci-pci
> 
> 00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset
> Family High Definition Audio Controller (rev 04)
>         Subsystem: Intel Corporation Device 7270
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Interrupt: pin A routed to IRQ 36
>         Region 0: Memory at a0810000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: <access denied>
>         Kernel driver in use: snd_hda_intel
> 
> 00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
> Family PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>         I/O behind bridge: 0000f000-00000fff
>         Memory behind bridge: a0700000-a07fffff
>         Prefetchable memory behind bridge: 00000000a0400000-00000000a04fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
> 
> 00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
> Family PCI Express Root Port 2 (rev c4) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>         I/O behind bridge: 0000f000-00000fff
>         Memory behind bridge: a0600000-a06fffff
>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
> 
> 00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
> Family PCI Express Root Port 3 (rev c4) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>         I/O behind bridge: 0000f000-00000fff
>         Memory behind bridge: a0500000-a05fffff
>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
> 
> 00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
> Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
>         Subsystem: Intel Corporation Device 7270
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 22
>         Region 0: Memory at a0816800 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: <access denied>
>         Kernel driver in use: ehci-pci
> 
> 00:1f.0 ISA bridge: Intel Corporation HM77 Express Chipset LPC
> Controller (rev 04)
>         Subsystem: Intel Corporation Device 7270
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Capabilities: <access denied>
>         Kernel driver in use: lpc_ich
> 
> 00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family
> 6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
>         Subsystem: Intel Corporation Device 7270
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 33
>         Region 0: I/O ports at 2098 [size=8]
>         Region 1: I/O ports at 20bc [size=4]
>         Region 2: I/O ports at 2090 [size=8]
>         Region 3: I/O ports at 20b8 [size=4]
>         Region 4: I/O ports at 2060 [size=32]
>         Region 5: Memory at a0816000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: <access denied>
>         Kernel driver in use: ahci
> 
> 00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family
> SMBus Controller (rev 04)
>         Subsystem: Intel Corporation Device 7270
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Interrupt: pin C routed to IRQ 11
>         Region 0: Memory at a0817000 (64-bit, non-prefetchable) [size=256]
>         Region 4: I/O ports at efa0 [size=32]
> 
> 01:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM57765
> Gigabit Ethernet PCIe (rev 10)
>         Subsystem: Broadcom Corporation NetXtreme BCM57765 Gigabit Ethernet PCIe
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Interrupt: pin A routed to IRQ 16
>         Region 0: Memory at a0400000 (64-bit, prefetchable) [size=64K]
>         Region 2: Memory at a0410000 (64-bit, prefetchable) [size=64K]
>         Capabilities: <access denied>
>         Kernel driver in use: tg3
> 
> 01:00.1 SD Host controller: Broadcom Corporation BCM57765/57785
> SDXC/MMC Card Reader (rev 10) (prog-if 01)
>         Subsystem: Broadcom Corporation Device 0000
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Interrupt: pin B routed to IRQ 17
>         Region 0: Memory at a0420000 (64-bit, prefetchable) [size=64K]
>         Capabilities: <access denied>
>         Kernel driver in use: sdhci-pci
> 
> 02:00.0 Network controller: Broadcom Corporation BCM4331 802.11a/b/g/n (rev 02)
>         Subsystem: Broadcom Corporation BCM4331 802.11a/b/g/n
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Interrupt: pin A routed to IRQ 17
>         Region 0: Memory at a0600000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: <access denied>
>         Kernel driver in use: bcma-pci-bridge
> 
> 03:00.0 FireWire (IEEE 1394): LSI Corporation FW643 [TrueFire] PCIe
> 1394b Controller (rev 08) (prog-if 10 [OHCI])
>         Subsystem: LSI Corporation FW643 [TrueFire] PCIe 1394b Controller
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Interrupt: pin A routed to IRQ 32
>         Region 0: Memory at a0500000 (64-bit, non-prefetchable) [size=4K]
>         Capabilities: <access denied>
>         Kernel driver in use: firewire_ohci
> 
> 04:00.0 PCI bridge: Intel Corporation Device 1513 (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Bus: primary=04, secondary=05, subordinate=6a, sec-latency=0
>         I/O behind bridge: 00003000-00004fff
>         Memory behind bridge: a0900000-a8bfffff
>         Prefetchable memory behind bridge: 00000000acc00000-00000000b4bfffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
> 
> 05:00.0 PCI bridge: Intel Corporation Device 1513 (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Bus: primary=05, secondary=06, subordinate=06, sec-latency=0
>         I/O behind bridge: 0000f000-00000fff
>         Memory behind bridge: a0b00000-a0bfffff
>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
> 
> 05:03.0 PCI bridge: Intel Corporation Device 1513 (prog-if 00 [Normal decode])
>         Physical Slot: 2
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Bus: primary=05, secondary=07, subordinate=07, sec-latency=0
>         I/O behind bridge: 0000f000-00000fff
>         Memory behind bridge: a0a00000-a0afffff
>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
> 
> 05:04.0 PCI bridge: Intel Corporation Device 1513 (prog-if 00 [Normal decode])
>         Physical Slot: 3
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Bus: primary=05, secondary=08, subordinate=38, sec-latency=0
>         I/O behind bridge: 00003000-00003fff
>         Memory behind bridge: a0c00000-a4bfffff
>         Prefetchable memory behind bridge: 00000000acc00000-00000000b0bfffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
> 
> 05:05.0 PCI bridge: Intel Corporation Device 1513 (prog-if 00 [Normal decode])
>         Physical Slot: 4
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Bus: primary=05, secondary=39, subordinate=69, sec-latency=0
>         I/O behind bridge: 00004000-00004fff
>         Memory behind bridge: a4c00000-a8bfffff
>         Prefetchable memory behind bridge: 00000000b0c00000-00000000b4bfffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
> 
> 05:06.0 PCI bridge: Intel Corporation Device 1513 (prog-if 00 [Normal decode])
>         Physical Slot: 5
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Bus: primary=05, secondary=6a, subordinate=6a, sec-latency=0
>         I/O behind bridge: 0000f000-00000fff
>         Memory behind bridge: a0900000-a09fffff
>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport
> 
> 06:00.0 System peripheral: Intel Corporation Device 1513
>         Subsystem: Device 2222:1111
>         Physical Slot: 1
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Interrupt: pin A routed to IRQ 11
>         Region 0: Memory at a0b00000 (32-bit, non-prefetchable) [size=256K]
>         Region 1: Memory at a0b40000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: <access denied>
> 
> [7.6.] SCSI information (from /proc/scsi/scsi)
> cat /proc/scsi/scsi
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: ATA      Model: APPLE HDD TOSHIB Rev: 1B
>   Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi1 Channel: 00 Id: 00 Lun: 00
>   Vendor: MATSHITA Model: DVD-R   UJ-8A8   Rev: HB14
>   Type:   CD-ROM                           ANSI  SCSI revision: 05
> 
> [7.7.] Other information that might be relevant to the problem (please
> look in /proc and include all information that you think to be
> relevant): N/A
> 
> [X.] Other notes, patches, fixes, workarounds:
> WORKAROUND: Use proprietary bcmwl.
> Downstream report: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1437820.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


