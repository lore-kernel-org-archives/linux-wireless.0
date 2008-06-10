Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbYFJOXY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 10:23:24 -0400
Subject: Re: mac80211_hwsim - simulator of 802.11 radios for mac80211
From: Dan Williams <dcbw@redhat.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080610105058.GA6961@jm.kir.nu>
References: <20080610105058.GA6961@jm.kir.nu>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 10:22:57 -0400
Message-Id: <1213107777.27260.16.camel@localhost.localdomain> (sfid-20080610_162329_911830_1CF1BC5F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-10 at 13:50 +0300, Jouni Malinen wrote:
> hostapd and wpa_supplicant include a test driver interface that allows
> them to be tested on a single host without any wireless hardware for
> development purposes. I have found this very valuable both for
> developing new functionality and for testing existing code.
> 
> In order to provide similar mechanism for mac80211 developers and to
> extend the scope of suitable test cases for hostapd/wpa_supplicant, I've
> written a Linux kernel module that provides a similar test interface at
> a lower layer. mac80211_hwsim simulates WLAN hardware and the air
> interface between the radios by acting as a low-level radio driver for
> mac80211. Neither mac80211 nor user space programs need any changes to
> work with the simulated radios.

Awesome.  I was going to write a basic WEXT driver so I could get some
better tests going for NetworkManager, but you've beaten me to it :)

Thanks!
Dan

> The initial version of mac80211_hwsim is available from the
> mac80211_hwsim subdirectory of my hostap Git tree:
> git://w1.fi/srv/git/hostap.git
> http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=tree;f=mac80211_hwsim
> 
> If there is interest in moving mac80211_hwsim module into the Linux
> kernel tree, I'm open to doing that, too.
> 
> I've included some more information about the code in the README file
> (see below) and there are also example configuration files for hostapd
> and wpa_supplicant to show how a WPA2-Personal connection can be opened
> with mac80211_hwsim.
> 
> mac80211_hwsim is still very minimal, but I have added couple of TODO
> comments to the source code to indicate areas that I'm hoping to add for
> more complete support of mac80211 features. I would also be interested
> in feedback from other mac80211 developers on what kind of functionality
> would be useful to have in this kind of simulated test setup. I'm first
> looking into using this to develop IEEE 802.11w (management frame
> protection) support into mac80211 and I would expect that the current
> minimal design is enough for that, but there is certainly room for much
> more, e.g., in the area of simulating signal strength and packet loss
> for testing TX rate control, retransmission, and power save
> functionality.
> 
> 
> 
> README:
> 
> Introduction
> 
> mac80211_hwsim is a Linux kernel module that can be used to simulate
> arbitrary number of IEEE 802.11 radios for mac80211 on a single
> device. It can be used to test most of the mac80211 functionality and
> user space tools (e.g., hostapd and wpa_supplicant) in a way that
> matches very closely with the normal case of using real WLAN
> hardware. From the mac80211 view point, mac80211_hwsim is yet another
> hardware driver, i.e., no changes to mac80211 are needed to use this
> testing tool.
> 
> The main goal for mac80211_hwsim is to make it easier for developers
> to test their code and work with new features to mac80211, hostapd,
> and wpa_supplicant. The simulated radios do not have the limitations
> of real hardware, so it is easy to generate an arbitrary test setup
> and always reproduce the same setup for future tests. In addition,
> since all radio operation is simulated, any channel can be used in
> tests regardless of regulatory rules.
> 
> mac80211_hwsim kernel module has a parameter 'radios' that can be used
> to select how many radios are simulates (default 2). This allows
> configuration of both very simply setups (e.g., just a single access
> point and a station) or large scale tests (multiple access points with
> hundreds of stations).
> 
> mac80211_hwsim works by tracking the current channel of each virtual
> radio and copying all transmitted frames to all other radios that are
> currently enabled and on the same channel as the transmitting
> radio. Software encryption in mac80211 is used so that the frames are
> actually encrypted over the virtual air interface to allow more
> complete testing of encryption.
> 
> 
> Simple example
> 
> This example shows how to use mac80211_hwsim to simulate two radios:
> one to act as an access point and the other as a station that
> associates with the AP. hostapd and wpa_supplicant are used to take
> care of WPA2-PSK authentication. In addition, hostapd is also
> processing access point side of association.
> 
> Please note that the currently released Linux kernel (2.6.25) does not
> enable AP mode, so a simple patch is needed to enable AP mode selection:
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/006-allow-ap-vlan-modes.patch
> 
> 
> # Build mac80211_hwsim:
> make
> 
> # Load the module
> insmod ./mac80211_hwsim.ko
> 
> # Run hostapd (AP) for wlan0
> hostapd hostapd.conf
> 
> # Run wpa_supplicant (station) for wlan1
> wpa_supplicant -Dwext -iwlan1 -c wpa_supplicant.conf
> 

