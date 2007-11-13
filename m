Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbXKMPZO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 10:25:14 -0500
Subject: Re: Help with wireless on Fedora 8
From: Dan Williams <dcbw@redhat.com>
To: Ruggiero <rugg.argos@tiscali.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <001001c8237a$0f0b9a20$0601a8c0@ruggiero>
References: <000b01c8231a$b78c82a0$0601a8c0@ruggiero>
	 <001001c8231c$04413d60$0601a8c0@ruggiero> <4734E1BC.1060608@lwfinger.net>
	 <20071110002158.GB32472@tuxdriver.com>
	 <001001c8237a$0f0b9a20$0601a8c0@ruggiero>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 10:21:21 -0500
Message-Id: <1194967281.2955.23.camel@localhost.localdomain> (sfid-20071113_152527_551325_565230F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-11-10 at 10:14 +0100, Ruggiero wrote:
> here there are new informations after
> upgrading the kernel,i tried to connect first with NetworkManager and then 
> with
> System->Administration->Network and then activating interface :

First off, try isolating the issue.  Make sure that NetworkManager is
stopped before you start debugging the issue.  Next, power off your AP
and power it back on.  Consumer APs really suck and often get into weird
states.

Then, try using iwconfig to do the association manually, and see if that
completes.  Next, try setting up a config for wpa_supplicant and see if
that works.  If wpa_supplicant works (even for unencrypted!), then
NetworkManager will work.

Dan

> 
> 
> b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
> Registered led device: b43-phy0:tx
> Registered led device: b43-phy0:rx
> b43-phy0 debug: Chip initialized
> b43-phy0 debug: 32-bit DMA initialized
> input: Unspecified device as /class/input/input10
> b43-phy0 debug: Wireless interface started
> b43-phy0 debug: Adding Interface type 2
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [drm] Initialized drm 1.1.0 20060810
> [drm] Initialized i915 1.6.0 20060119 on minor 0
> wlan0: Initial auth_alg=0
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authentication with AP 00:0c:41:19:2d:c1 timed out
> wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
> authenticate state - ignored
> wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
> authenticate state - ignored
> wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
> authenticate state - ignored
> wlan0: Initial auth_alg=0
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authentication with AP 00:0c:41:19:2d:c1 timed out
> wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
> authenticate state - ignored
> wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
> authenticate state - ignored
> wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
> authenticate state - ignored
> wlan0: Initial auth_alg=0
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: RX authentication from 00:0c:41:19:2d:c1 (alg=0 transaction=2
> status=0)
> wlan0: authenticated
> wlan0: associate with AP 00:0c:41:19:2d:c1
> wlan0: associate with AP 00:0c:41:19:2d:c1
> wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
> authenticate state - ignored
> wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
> authenticate state - ignored
> wlan0: RX AssocResp from 00:0c:41:19:2d:c1 (capab=0x1 status=0 aid=2)
> wlan0: associated
> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> wlan0: disassociate(reason=3)
> wlan0: association frame received from 00:0c:41:19:2d:c1, but not in
> associate state - ignored
> wlan0: RX deauthentication from 00:0c:41:19:2d:c1 (reason=6)
> wlan0: deauthenticated
> wlan0: RX deauthentication from 00:0c:41:19:2d:c1 (reason=6)
> wlan0: RX deauthentication from 00:0c:41:19:2d:c1 (reason=6)
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: RX authentication from 00:0c:41:19:2d:c1 (alg=0 transaction=2
> status=0)
> wlan0: authenticated
> wlan0: associate with AP 00:0c:41:19:2d:c1
> wlan0: RX ReassocResp from 00:0c:41:19:2d:c1 (capab=0x1 status=0 aid=3)
> wlan0: associated
> wlan0: disassociate(reason=3)
> wlan0: RX deauthentication from 00:0c:41:19:2d:c1 (reason=6)
> wlan0: deauthenticated
> wlan0: RX deauthentication from 00:0c:41:19:2d:c1 (reason=6)
> wlan0: RX deauthentication from 00:0c:41:19:2d:c1 (reason=6)
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: RX authentication from 00:0c:41:19:2d:c1 (alg=0 transaction=2
> status=0)
> wlan0: authenticated
> wlan0: associate with AP 00:0c:41:19:2d:c1
> wlan0: associate with AP 00:0c:41:19:2d:c1
> wlan0: associate with AP 00:0c:41:19:2d:c1
> wlan0: association with AP 00:0c:41:19:2d:c1 timed out
> wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
> authenticate state - ignored
> wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
> authenticate state - ignored
> wlan0: association frame received from 00:0c:41:19:2d:c1, but not in
> associate state - ignored
> wlan0: association frame received from 00:0c:41:19:2d:c1, but not in
> associate state - ignored
> wlan0: association frame received from 00:0c:41:19:2d:c1, but not in
> associate state - ignored
> wlan0: no IPv6 routers present
> 
> thanks u all for helping
> 
> 

