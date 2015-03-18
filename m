Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33789 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319AbbCRVYP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 17:24:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YYLRi-0007K2-Ib
	for linux-wireless@vger.kernel.org; Wed, 18 Mar 2015 22:24:10 +0100
Received: from p5793855B.dip0.t-ipconnect.de ([87.147.133.91])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2015 22:24:10 +0100
Received: from Juergen.Bausa by p5793855B.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2015 22:24:10 +0100
To: linux-wireless@vger.kernel.org
From: =?utf-8?b?SsO8cmdlbg==?= Bausa <Juergen.Bausa@online.de>
Subject: Re: Broadcom 43340
Date: Wed, 18 Mar 2015 21:24:03 +0000 (UTC)
Message-ID: <loom.20150318T222315-999@post.gmane.org> (sfid-20150318_222419_226686_C7606C29)
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com> 	<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com> 	<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir>  <5504B29F.8000305@gmail.com> <55056EFB.9020100@broadcom.com>  <loom.20150315T213441-211@post.gmane.org> <5505F651.3060607@broadcom.com>  <loom.20150317T214603-379@post.gmane.org> <1426634407.11120.50.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@...> writes:

> 
> > 
> > Thanks, that worked. Now I have firmware and nvram-file and the driver 
seems
> > to load ok. At least I have an interface wlan0.
> > 
> > However, I am not able to connect.Network-manager just says "interface is
> > being set up ..." forever. I have no idea howto debug this. In the other
> > post you said that the nl80211 driver should be used instead of wext. I
> > found that nl80211 is the default for network-manager. So, whats going 
wrong
> > here?
> 
> Could you provide more NetworkManager logs?  They should look like this;
> where do your logs stop?
> 


Mar 18 22:16:40 lina NetworkManager[532]: <info> Activation (wlan0) starting 
connection 'tuxgang'
Mar 18 22:16:40 lina NetworkManager[532]: <info> Activation (wlan0) Stage 1 
of 5 (Device Prepare) scheduled...
Mar 18 22:16:40 lina NetworkManager[532]: <info> Activation (wlan0) Stage 1 
of 5 (Device Prepare) started...
Mar 18 22:16:40 lina NetworkManager[532]: <info> (wlan0): device state 
change: disconnected -> prepare (reason 'none') [30 40 0]
Mar 18 22:16:40 lina NetworkManager[532]: <info> NetworkManager state is now 
CONNECTING
Mar 18 22:16:40 lina NetworkManager[532]: <info> Activation (wlan0) Stage 2 
of 5 (Device Configure) scheduled...
Mar 18 22:16:40 lina NetworkManager[532]: <info> Activation (wlan0) Stage 1 
of 5 (Device Prepare) complete.
Mar 18 22:16:40 lina NetworkManager[532]: <info> Activation (wlan0) Stage 2 
of 5 (Device Configure) starting...
Mar 18 22:16:40 lina NetworkManager[532]: <info> (wlan0): device state 
change: prepare -> config (reason 'none') [40 50 0]
Mar 18 22:16:40 lina NetworkManager[532]: <info> Activation (wlan0/wireless): 
connection 'tuxgang' has security, and secrets exist.  No new secrets needed.
Mar 18 22:16:40 lina NetworkManager[532]: <info> Config: added 'ssid' value 
'tuxgang'
Mar 18 22:16:40 lina NetworkManager[532]: <info> Config: added 'scan_ssid' 
value '1'
Mar 18 22:16:40 lina NetworkManager[532]: <info> Config: added 'key_mgmt' 
value 'WPA-PSK'
Mar 18 22:16:40 lina NetworkManager[532]: <info> Config: added 'auth_alg' 
value 'OPEN'
Mar 18 22:16:40 lina NetworkManager[532]: <info> Config: added 'psk' value 
'<omitted>'
Mar 18 22:16:40 lina NetworkManager[532]: <info> Activation (wlan0) Stage 2 
of 5 (Device Configure) complete.
Mar 18 22:16:40 lina NetworkManager[532]: <info> Config: set interface 
ap_scan to 1
Mar 18 22:16:40 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: inactive -> scanning
Mar 18 22:16:50 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: scanning -> associating
Mar 18 22:17:00 lina NetworkManager[532]: <warn> Connection disconnected 
(reason -3)
Mar 18 22:17:00 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: associating -> disconnected
Mar 18 22:17:00 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Mar 18 22:17:05 lina NetworkManager[532]: <warn> Activation (wlan0/wireless): 
association took too long.
Mar 18 22:17:05 lina NetworkManager[532]: <info> (wlan0): device state 
change: config -> need-auth (reason 'none') [50 60 0]
Mar 18 22:17:05 lina NetworkManager[532]: <warn> Activation (wlan0/wireless): 
asking for new secrets
Mar 18 22:17:05 lina NetworkManager[532]: <warn> Couldn't disconnect 
supplicant interface: This interface is not connected.
Mar 18 22:17:05 lina NetworkManager[532]: <warn> Couldn't disconnect 
supplicant interface: This interface is not connected.
Mar 18 22:17:29 lina NetworkManager[532]: (NetworkManager:532): libnm-util-
CRITICAL **: get_secret_flags: assertion 'is_secret_prop (setting, 
secret_name, error)' failed
Mar 18 22:17:29 lina NetworkManager[532]: <info> Activation (wlan0) Stage 1 
of 5 (Device Prepare) scheduled...
Mar 18 22:17:29 lina NetworkManager[532]: <info> Activation (wlan0) Stage 1 
of 5 (Device Prepare) started...
Mar 18 22:17:29 lina NetworkManager[532]: <info> (wlan0): device state 
change: need-auth -> prepare (reason 'none') [60 40 0]
Mar 18 22:17:29 lina NetworkManager[532]: <info> Activation (wlan0) Stage 2 
of 5 (Device Configure) scheduled...
Mar 18 22:17:29 lina NetworkManager[532]: <info> Activation (wlan0) Stage 1 
of 5 (Device Prepare) complete.
Mar 18 22:17:29 lina NetworkManager[532]: <info> Activation (wlan0) Stage 2 
of 5 (Device Configure) starting...
Mar 18 22:17:29 lina NetworkManager[532]: <info> (wlan0): device state 
change: prepare -> config (reason 'none') [40 50 0]
Mar 18 22:17:29 lina NetworkManager[532]: <info> Activation (wlan0/wireless): 
connection 'tuxgang' has security, and secrets exist.  No new secrets needed.
Mar 18 22:17:29 lina NetworkManager[532]: <info> Config: added 'ssid' value 
'tuxgang'
Mar 18 22:17:29 lina NetworkManager[532]: <info> Config: added 'scan_ssid' 
value '1'
Mar 18 22:17:29 lina NetworkManager[532]: <info> Config: added 'key_mgmt' 
value 'WPA-PSK'
Mar 18 22:17:29 lina NetworkManager[532]: <info> Config: added 'auth_alg' 
value 'OPEN'
Mar 18 22:17:29 lina NetworkManager[532]: <info> Config: added 'psk' value 
'<omitted>'
Mar 18 22:17:29 lina NetworkManager[532]: <info> Activation (wlan0) Stage 2 
of 5 (Device Configure) complete.
Mar 18 22:17:29 lina NetworkManager[532]: <warn> Couldn't disconnect 
supplicant interface: This interface is not connected.
Mar 18 22:17:29 lina NetworkManager[532]: <info> Config: set interface 
ap_scan to 1
Mar 18 22:17:29 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: scanning -> associated
Mar 18 22:17:29 lina NetworkManager[532]: <warn> Connection disconnected 
(reason -3)
Mar 18 22:17:29 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: associated -> disconnected
Mar 18 22:17:29 lina NetworkManager[532]: <warn> Connection disconnected 
(reason 6)
Mar 18 22:17:29 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Mar 18 22:17:39 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: scanning -> associating
Mar 18 22:17:49 lina NetworkManager[532]: <warn> Connection disconnected 
(reason -3)
Mar 18 22:17:49 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: associating -> disconnected
Mar 18 22:17:49 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Mar 18 22:17:54 lina NetworkManager[532]: <warn> Activation (wlan0/wireless): 
association took too long.
Mar 18 22:17:54 lina NetworkManager[532]: <info> (wlan0): device state 
change: config -> need-auth (reason 'none') [50 60 0]
Mar 18 22:17:54 lina NetworkManager[532]: <warn> Activation (wlan0/wireless): 
asking for new secrets
Mar 18 22:17:54 lina NetworkManager[532]: <warn> Couldn't disconnect 
supplicant interface: This interface is not connected.
Mar 18 22:17:54 lina NetworkManager[532]: <warn> Couldn't disconnect 
supplicant interface: This interface is not connected.
Mar 18 22:18:00 lina NetworkManager[532]: (NetworkManager:532): libnm-util-
CRITICAL **: get_secret_flags: assertion 'is_secret_prop (setting, 
secret_name, error)' failed
Mar 18 22:18:00 lina NetworkManager[532]: <info> Activation (wlan0) Stage 1 
of 5 (Device Prepare) scheduled...
Mar 18 22:18:00 lina NetworkManager[532]: <info> Activation (wlan0) Stage 1 
of 5 (Device Prepare) started...
Mar 18 22:18:00 lina NetworkManager[532]: <info> (wlan0): device state 
change: need-auth -> prepare (reason 'none') [60 40 0]
Mar 18 22:18:00 lina NetworkManager[532]: <info> Activation (wlan0) Stage 2 
of 5 (Device Configure) scheduled...
Mar 18 22:18:00 lina NetworkManager[532]: <info> Activation (wlan0) Stage 1 
of 5 (Device Prepare) complete.
Mar 18 22:18:00 lina NetworkManager[532]: <info> Activation (wlan0) Stage 2 
of 5 (Device Configure) starting...
Mar 18 22:18:00 lina NetworkManager[532]: <info> (wlan0): device state 
change: prepare -> config (reason 'none') [40 50 0]
Mar 18 22:18:00 lina NetworkManager[532]: <info> Activation (wlan0/wireless): 
connection 'tuxgang' has security, and secrets exist.  No new secrets needed.
Mar 18 22:18:00 lina NetworkManager[532]: <info> Config: added 'ssid' value 
'tuxgang'
Mar 18 22:18:00 lina NetworkManager[532]: <info> Config: added 'scan_ssid' 
value '1'
Mar 18 22:18:00 lina NetworkManager[532]: <info> Config: added 'key_mgmt' 
value 'WPA-PSK'
Mar 18 22:18:00 lina NetworkManager[532]: <info> Config: added 'auth_alg' 
value 'OPEN'
Mar 18 22:18:00 lina NetworkManager[532]: <info> Config: added 'psk' value 
'<omitted>'
Mar 18 22:18:00 lina NetworkManager[532]: <info> Activation (wlan0) Stage 2 
of 5 (Device Configure) complete.
Mar 18 22:18:00 lina NetworkManager[532]: <warn> Couldn't disconnect 
supplicant interface: This interface is not connected.
Mar 18 22:18:00 lina NetworkManager[532]: <info> Config: set interface 
ap_scan to 1
Mar 18 22:18:00 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: scanning -> 4-way handshake
Mar 18 22:18:00 lina NetworkManager[532]: <warn> Connection disconnected 
(reason 6)
Mar 18 22:18:00 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: 4-way handshake -> disconnected
Mar 18 22:18:00 lina NetworkManager[532]: <info> Activation (wlan0/wireless): 
disconnected during association, asking for new key.
Mar 18 22:18:00 lina NetworkManager[532]: <info> (wlan0): device state 
change: config -> need-auth (reason 'supplicant-disconnect') [50 60 8]
Mar 18 22:18:00 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: disconnected -> inactive
Mar 18 22:18:07 lina NetworkManager[532]: (NetworkManager:532): libnm-util-
CRITICAL **: get_secret_flags: assertion 'is_secret_prop (setting, 
secret_name, error)' failed
Mar 18 22:18:07 lina NetworkManager[532]: <info> Activation (wlan0) Stage 1 
of 5 (Device Prepare) scheduled...
Mar 18 22:18:07 lina NetworkManager[532]: <info> Activation (wlan0) Stage 1 
of 5 (Device Prepare) started...
Mar 18 22:18:07 lina NetworkManager[532]: <info> (wlan0): device state 
change: need-auth -> prepare (reason 'none') [60 40 0]
Mar 18 22:18:07 lina NetworkManager[532]: <info> Activation (wlan0) Stage 2 
of 5 (Device Configure) scheduled...
Mar 18 22:18:07 lina NetworkManager[532]: <info> Activation (wlan0) Stage 1 
of 5 (Device Prepare) complete.
Mar 18 22:18:07 lina NetworkManager[532]: <info> Activation (wlan0) Stage 2 
of 5 (Device Configure) starting...
Mar 18 22:18:07 lina NetworkManager[532]: <info> (wlan0): device state 
change: prepare -> config (reason 'none') [40 50 0]
Mar 18 22:18:07 lina NetworkManager[532]: <info> Activation (wlan0/wireless): 
connection 'tuxgang' has security, and secrets exist.  No new secrets needed.
Mar 18 22:18:07 lina NetworkManager[532]: <info> Config: added 'ssid' value 
'tuxgang'
Mar 18 22:18:07 lina NetworkManager[532]: <info> Config: added 'scan_ssid' 
value '1'
Mar 18 22:18:07 lina NetworkManager[532]: <info> Config: added 'key_mgmt' 
value 'WPA-PSK'
Mar 18 22:18:07 lina NetworkManager[532]: <info> Config: added 'auth_alg' 
value 'OPEN'
Mar 18 22:18:07 lina NetworkManager[532]: <info> Config: added 'psk' value 
'<omitted>'
Mar 18 22:18:07 lina NetworkManager[532]: <info> Activation (wlan0) Stage 2 
of 5 (Device Configure) complete.
Mar 18 22:18:07 lina NetworkManager[532]: <info> Config: set interface 
ap_scan to 1
Mar 18 22:18:07 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: inactive -> associating
Mar 18 22:18:17 lina NetworkManager[532]: <warn> Connection disconnected 
(reason -3)
Mar 18 22:18:17 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: associating -> disconnected
Mar 18 22:18:17 lina NetworkManager[532]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Mar 18 22:18:32 lina NetworkManager[532]: <warn> Activation (wlan0/wireless): 
association took too long.
Mar 18 22:18:32 lina NetworkManager[532]: <info> (wlan0): device state 
change: config -> need-auth (reason 'none') [50 60 0]
Mar 18 22:18:32 lina NetworkManager[532]: <warn> Activation (wlan0/wireless): 
asking for new secrets
Mar 18 22:18:32 lina NetworkManager[532]: <warn> Couldn't disconnect 
supplicant interface: This interface is not connected.
Mar 18 22:18:32 lina NetworkManager[532]: <warn> Couldn't disconnect 
supplicant interface: This interface is not connected.




