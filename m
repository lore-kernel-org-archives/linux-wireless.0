Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:46547 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757560Ab1ENPiL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 11:38:11 -0400
Date: Sat, 14 May 2011 17:38:07 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: WPA in ad-hoc mode (was: ...with carl9170)
Message-ID: <20110514153807.GA11495@zenon.in.qult.net> (sfid-20110514_173819_936513_9DE58998)
References: <20110513160113.GA14293@zenon.in.qult.net>
 <BANLkTikiWNXnB6NcS48-1x9KYes_o=omjg@mail.gmail.com>
 <20110513174041.GA4690@zenon.in.qult.net>
 <201105132231.48232.chunkeey@googlemail.com>
 <20110513222141.GA11200@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110513222141.GA11200@zenon.in.qult.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 14, 2011 at 12:21:41AM +0200, thus spake Ignacy Gawedzki:
> On Fri, May 13, 2011 at 10:31:47PM +0200, thus spake Christian Lamparter:
> > you should try your setup with mac80211_hwsim first [so we can rule out all
> > driver bugs].
> 
> Good idea indeed.  I'll do that as soon as possible.

Hi again,

I just tried the following:

  Compile and set up mac80211_hwsim from latest compat-wireless (which did not
  go without some hacking, see below).

  Run wpa_supplicant with the following configuration file on both interfaces:

    ap_scan=2
    network={
      ssid="Test1"
      mode=1
      proto=WPA
      key_mgmt=WPA-NONE
      pairwise=NONE
      group=CCMP
      psk="testtesttest"
    }

  Set addresses with /32 prefixes on both interfaces.

  Run ping using -I to bind to one interface and the address of the other as
  destination.

  Run wireshark on hwsim0 to look at what's going on.

I had to force the same BSSID on both interfaces as they tended to create
separate ones.  After that, it appears wpa_supplicant manages to set the keys
correctly:

  Associated to a new BSS: BSSID=00:00:00:00:00:01
  Select network based on association information
  Network configuration found for the current AP
  WPA: Using WPA IE from AssocReq to set cipher suites
  WPA: Selected cipher suites: group 16 pairwise 1 key_mgmt 16 proto 1
  WPA: clearing AP WPA IE
  WPA: clearing AP RSN IE
  WPA: using GTK CCMP
  WPA: using PTK NONE
  WPA: using KEY_MGMT WPA-NONE
  WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50
  f2 04 01 00 00 50 f2 00 01 00 00 50 f2 00
  EAPOL: External notification - EAP success=0
  EAPOL: External notification - EAP fail=0
  EAPOL: External notification - portControl=ForceAuthorized
  Associated with 00:00:00:00:00:01
  WPA: Association event - clear replay counter
  WPA: Clear old PTK
  EAPOL: External notification - portEnabled=0
  EAPOL: SUPP_PAE entering state DISCONNECTED
  EAPOL: Supplicant port status: Unauthorized
  EAPOL: SUPP_BE entering state INITIALIZE
  EAPOL: Supplicant port status: Unauthorized
  EAPOL: External notification - portValid=0
  EAPOL: Supplicant port status: Unauthorized
  EAPOL: External notification - portEnabled=1
  EAPOL: SUPP_PAE entering state S_FORCE_AUTH
  EAPOL: Supplicant port status: Authorized
  EAPOL: SUPP_BE entering state IDLE
  Cancelling authentication timeout
  State: ASSOCIATED -> COMPLETED
  CTRL-EVENT-CONNECTED - Connection to 00:00:00:00:00:01 completed (reauth)
  [id=0 id_str=]
  wpa_driver_wext_set_operstate: operstate 0->1 (UP)
  netlink: Operstate: linkmode=-1, operstate=6
  Cancelling scan request
  RTM_NEWLINK: operstate=1 ifi_flags=0x11003 ([UP][LOWER_UP])
  netlink: Operstate: linkmode=-1, operstate=6
  RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
  RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
  RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added

Same thing on the other interface.

Running ping generates ARP requests, visible in cleartext on hwsim0, which I
suppose is unexpected.  Even if I populate the ARP table by hand (using ip
neigh), the echo requests are visible in cleartext on hwsim0.

By running tcpdump on both interfaces, I can tell that the frames are
discarded on the receiving end (both the broadcast ARP requests and the
unicast echo requests).

Am I doing something wrong or is there a real problem with WPA in ad-hoc mode
regardless of the driver?

As for the hacking I had to do to make mac80211_hwsim work, it is related to
the recent removal of dev_alloc_name() calls, among others in
net/mac80211/iface.c's ieee80211_if_add().  Any new interface ends up being
actually called wlan%d, which in the case of mac80211_hwsim, which creates
more than one interface, leads to clashes (only the first wlan%d is created
successfully).  I'm running kernel 2.6.38-9-generic from Ubuntu, which
obviously lacks what it takes to rename interfaces properly otherwise.

Regards,

Ignacy

-- 
Information wants to be beer, or something like that.
