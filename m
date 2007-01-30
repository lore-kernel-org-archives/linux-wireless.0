Return-path: <wireless-bounces@tuxdriver.com>
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.245])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0UMFIW6028896	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 17:15:43 -0500
Received: by an-out-0708.google.com with SMTP id c38so5020ana	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 14:15:13 -0800 (PST)
Date: Tue, 30 Jan 2007 17:15:12 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: Getting dscape running
Sender: wireless-bounces@tuxdriver.com
To: wireless@lists.tuxdriver.org
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <9e4733910701301415p2ce1042aqcd833c732bc761cb@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

I'd like to get a basic connection working on my system so that I can
check out the dscape stack and do some work on it. I am targeting an
embedded system using USB dongles but right now I am working on my
desktop. Hopefully this new list can provide the guidance that I need.

I have NetworkManager from CVS and the current version of
wpa_supplicant running. Hardware is a rt2570 dongle using the dscape
stack. OS is Ubuntu.

When I use NetworkManager to switch to the wireless device it fails.
It says the access point is unencrypted when it is running actually
WEP. The problem is probably caused by the NULL gobject reference.
What's causing this?

NetworkManager: <info>  Activation (wlan0) started...
NetworkManager: <info>  Activation (wlan0) Stage 1 of 5 (Device
Prepare) scheduled...
NetworkManager: <info>  Activation (wlan0) Stage 1 of 5 (Device
Prepare) started...
NetworkManager: <info>  Activation (wlan0) Stage 2 of 5 (Device
Configure) scheduled...
NetworkManager: <info>  Activation (wlan0) Stage 1 of 5 (Device
Prepare) complete.
NetworkManager: <info>  Activation (wlan0) Stage 2 of 5 (Device
Configure) starting...
NetworkManager: <info>  Activation (wlan0/wireless): access point
'Smirl' is unencrypted, no key needed.

(NetworkManager:22478): GLib-GObject-WARNING **: invalid (NULL) pointer instance

(NetworkManager:22478): GLib-GObject-CRITICAL **:
g_signal_connect_data: assertion `G_TYPE_CHECK_INSTANCE (instance)'
failed
NetworkManager: nm_supplicant_interface_set_config: assertion `self !=
NULL' failed
NetworkManager: <WARN>  real_act_stage2_config(): Activation
(wlan0/wireless): couldn't send wireless configuration to the
supplicant.
NetworkManager: <info>  Activation (wlan0) failure scheduled...
NetworkManager: <info>  Activation (wlan0) Stage 2 of 5 (Device
Configure) complete.
NetworkManager: <info>  Activation (wlan0) failed for access point (Smirl)
NetworkManager: <info>  Activation (wlan0) failed.
NetworkManager: <info>  Deactivating device wlan0.

-- 
Jon Smirl
jonsmirl@gmail.com
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
