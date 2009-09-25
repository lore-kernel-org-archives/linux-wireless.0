Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:59310 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463AbZIYIG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 04:06:59 -0400
Date: Fri, 25 Sep 2009 09:06:53 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.31-git wireless broken
In-Reply-To: <1253856038.3868.500.camel@johannes.local>
Message-ID: <Pine.LNX.4.64.0909250838420.3783@sister.anvils>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
 <1253813740.3868.324.camel@johannes.local>  <Pine.LNX.4.64.0909241859020.25022@sister.anvils>
  <1253816614.3868.406.camel@johannes.local>  <Pine.LNX.4.64.0909242036270.7469@sister.anvils>
 <1253856038.3868.500.camel@johannes.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 25 Sep 2009, Johannes Berg wrote:
> 
> Very odd. Haven't really looked at the config, but I see the phy0: idle
> message that indicates you have debug on. However, it's like nothing
> ever tells the kernel to connect to a network.
> 
> Are you running wpa_supplicant?

Should be, but you're right, for whatever reason it is not running
with these recent kernels.

I expect that correlates with iwconfig showing me ESSID:off/any.

I'm thinking that (unless you've a better idea) I should do another
bisect for when that behaviour starts - hoping that whatever problem
led me to your patch, got fixed up later on, but superseded by this
different problem.

The bootup messages on the Aspire One tell me:
    wlan0     device: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
    wlan0     is controlled by ifplugd
    wlan0    
waiting
    wlan0     device: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
    wlan0     ifplugd is running
    wlan0     no cable connected
    wlan0     DHCP4 client NOT running
    wlan0    

And the bootup messages on the Fujitsu Siemens say:
    wlan0     device: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
    wlan0     is controlled by ifplugd
    wlan0    
    wlan0     device: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
    wlan0     ifplugd is running
    wlan0     no cable connected
    wlan0     . . . is just beeing set up
    wlan0    

In each case, "no cable connected".

I wonder, have there been more yet more regdom reworks since 2.6.31?
Would this be the stage at which regdom problems manifest?  I'm not
running whatever-it-is daemon for setting regdom, usually just patch
static char *ieee80211_regdom = "EU";
into my kernels; but in the past have only needed that when the router
decides to use channel 13 or something - currently it's on channel 1.

Hugh
