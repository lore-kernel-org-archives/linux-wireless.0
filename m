Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hmm.wantstofly.org ([138.201.34.84]:50516 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbcFRIsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2016 04:48:30 -0400
Date: Sat, 18 Jun 2016 11:48:28 +0300
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: David Gilman <dgilman@gilslotd.com>
Cc: linux-wireless@vger.kernel.org,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: Troubleshooting mwl8k driver issue
Message-ID: <20160618084828.GN20238@wantstofly.org> (sfid-20160618_104836_933959_8A244952)
References: <20160604035452.GA5925@dar.local>
 <20160606065146.GK8402@wantstofly.org>
 <20160610040247.GA16190@dar.local>
 <20160617194303.GA33130@dar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160617194303.GA33130@dar.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 17, 2016 at 02:43:03PM -0500, David Gilman wrote:

> > As an aside I semi-bricked my router and I'm currently unable to flash
> > new images
> 
> I've got my hardware and toolchain back up and running.  Here's the
> output from the unpatched `iw event -t':
> 
> 1466191960.919661: wlan1: del station fc:c2:de:ac:b1:72
> 1466191966.842698: wlan1 (phy #1): mgmt TX status (cookie 2b): acked
> 1466192016.283846: wlan1 (phy #1): mgmt TX status (cookie 2c): acked
> 1466192016.284036: wlan1 (phy #1): mgmt TX status (cookie 2d): acked
> 1466192016.285194: wlan1 (phy #1): mgmt TX status (cookie 2e): acked
> 1466192016.313091: wlan1 (phy #1): mgmt TX status (cookie 2f): acked
> 1466192016.369315: wlan1 (phy #1): mgmt TX status (cookie 30): acked
> 1466192016.390064: wlan1 (phy #1): mgmt TX status (cookie 31): acked
> 1466192016.392064: wlan1: new station fc:c2:de:ac:b1:72
> 
> And the corresponding syslog output:
> 
> Fri Jun 17 19:32:40 2016 kern.debug kernel: [ 3027.270339] ieee80211 phy1: Deleted BA stream index 0
> Fri Jun 17 19:32:40 2016 kern.debug kernel: [ 3027.270367] ieee80211 phy1: Remove stream for fc:c2:de:ac:b1:72 0
> Fri Jun 17 19:32:43 2016 daemon.info hostapd: wlan1: STA fc:c2:de:ac:b1:72 IEEE 802.11: deauthenticated due to local deauth request
> Fri Jun 17 19:33:36 2016 daemon.info hostapd: wlan1: STA fc:c2:de:ac:b1:72 IEEE 802.11: authenticated
> Fri Jun 17 19:33:36 2016 daemon.info hostapd: wlan1: STA fc:c2:de:ac:b1:72 IEEE 802.11: associated (aid 1)
> Fri Jun 17 19:33:36 2016 daemon.info hostapd: wlan1: STA fc:c2:de:ac:b1:72 WPA: pairwise key handshake completed (RSN)
> Fri Jun 17 19:33:37 2016 daemon.info dnsmasq-dhcp[2668]: DHCPREQUEST(br-lan) 192.168.1.138 fc:c2:de:ac:b1:72
> Fri Jun 17 19:33:37 2016 daemon.info dnsmasq-dhcp[2668]: DHCPACK(br-lan) 192.168.1.138 fc:c2:de:ac:b1:72 android-63ebbc936f7b53af
> 
> So where to go from here?

Nothing in here seems particularly bad.  So whatever the problem is,
I don't think it can be diagnosed from these messages alone.

I went back to the email thread, and it seems that the problem is that
you're trying to run the card in AP mode but no traffic is making it
through?  Is AP association working at all, or is that failing too?
