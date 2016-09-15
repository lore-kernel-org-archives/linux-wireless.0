Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752553AbcIOOmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 10:42:21 -0400
Message-ID: <1473950537.25907.8.camel@redhat.com> (sfid-20160915_164237_741872_09B81D42)
Subject: brcmfmac MAC address change delay and 500ms down delay
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Date: Thu, 15 Sep 2016 09:42:17 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

While refining NetworkManager's MAC address randomization behavior we
came across two issues with brcmfmac:

1) when changing the MAC address, the driver schedules work for the new
change and returns success, but doesn't actually change the MAC until
the work is scheduled.  Because it returns 0 from the
ndo_set_mac_address hook the net core will generate a NETDEV_CHANGEADDR
event and rtnetlink will send out an RTM_NEWLINK with the old MAC
address.  No event for the new address will be sent.  So it's pretty
hard to figure out when the address actually changed, and when its safe
to associate, without polling the device's MAC address.  Ugly.

2) when closing the device (eg, set !IFF_UP) the driver unconditionally
blocks for 500ms in __brcmf_cfg80211_down():

	if (check_vif_up(ifp->vif)) {
		brcmf_link_down(ifp->vif, WLAN_REASON_UNSPECIFIED);

		/* Make sure WPA_Supplicant receives all the event
		   generated due to DISASSOC call to the fw to keep
		   the state fw and WPA_Supplicant state consistent
		 */
		brcmf_delay(500);
	}

Should I dump these into kernel bugzilla, or is there some internal bug
tracker they could get stuffed into?

Thanks!
Dan
