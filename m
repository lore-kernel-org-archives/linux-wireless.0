Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35661 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbcFQTnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 15:43:08 -0400
Received: by mail-oi0-f48.google.com with SMTP id v7so20875318oig.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2016 12:43:06 -0700 (PDT)
Date: Fri, 17 Jun 2016 14:43:03 -0500
From: David Gilman <dgilman@gilslotd.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: Troubleshooting mwl8k driver issue
Message-ID: <20160617194303.GA33130@dar.local> (sfid-20160617_214312_896087_2F34BE1D)
References: <20160604035452.GA5925@dar.local>
 <20160606065146.GK8402@wantstofly.org>
 <20160610040247.GA16190@dar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160610040247.GA16190@dar.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 09, 2016 at 11:02:47PM -0500, David Gilman wrote:
> As an aside I semi-bricked my router and I'm currently unable to flash
> new images

I've got my hardware and toolchain back up and running.  Here's the
output from the unpatched `iw event -t':

1466191960.919661: wlan1: del station fc:c2:de:ac:b1:72
1466191966.842698: wlan1 (phy #1): mgmt TX status (cookie 2b): acked
1466192016.283846: wlan1 (phy #1): mgmt TX status (cookie 2c): acked
1466192016.284036: wlan1 (phy #1): mgmt TX status (cookie 2d): acked
1466192016.285194: wlan1 (phy #1): mgmt TX status (cookie 2e): acked
1466192016.313091: wlan1 (phy #1): mgmt TX status (cookie 2f): acked
1466192016.369315: wlan1 (phy #1): mgmt TX status (cookie 30): acked
1466192016.390064: wlan1 (phy #1): mgmt TX status (cookie 31): acked
1466192016.392064: wlan1: new station fc:c2:de:ac:b1:72

And the corresponding syslog output:

Fri Jun 17 19:32:40 2016 kern.debug kernel: [ 3027.270339] ieee80211 phy1: Deleted BA stream index 0
Fri Jun 17 19:32:40 2016 kern.debug kernel: [ 3027.270367] ieee80211 phy1: Remove stream for fc:c2:de:ac:b1:72 0
Fri Jun 17 19:32:43 2016 daemon.info hostapd: wlan1: STA fc:c2:de:ac:b1:72 IEEE 802.11: deauthenticated due to local deauth request
Fri Jun 17 19:33:36 2016 daemon.info hostapd: wlan1: STA fc:c2:de:ac:b1:72 IEEE 802.11: authenticated
Fri Jun 17 19:33:36 2016 daemon.info hostapd: wlan1: STA fc:c2:de:ac:b1:72 IEEE 802.11: associated (aid 1)
Fri Jun 17 19:33:36 2016 daemon.info hostapd: wlan1: STA fc:c2:de:ac:b1:72 WPA: pairwise key handshake completed (RSN)
Fri Jun 17 19:33:37 2016 daemon.info dnsmasq-dhcp[2668]: DHCPREQUEST(br-lan) 192.168.1.138 fc:c2:de:ac:b1:72
Fri Jun 17 19:33:37 2016 daemon.info dnsmasq-dhcp[2668]: DHCPACK(br-lan) 192.168.1.138 fc:c2:de:ac:b1:72 android-63ebbc936f7b53af

So where to go from here?

-- 
David Gilman  :DG<
http://gilslotd.com
