Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32372 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0FJFbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 01:31:15 -0400
Subject: Re: [PATCHv4] mac80211: Fix circular locking dependency in ARP
 filter handling
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext reinette chatre <reinette.chatre@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1276147255.5277.34285.camel@wimaxnb.nmp.nokia.com>
References: <1276080206-29562-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1276126067.1835.15473.camel@rchatre-DESK>
	 <1276147255.5277.34285.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 08:30:38 +0300
Message-ID: <1276147838.5277.34297.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-10 at 07:21 +0200, Juuso Oikarinen wrote:
> Hi,
> 
> On Thu, 2010-06-10 at 01:27 +0200, ext reinette chatre wrote:
> > Hi Juuso,
> > 
> > Even so, I tested your new patch and for some reason the BUG returned
> > (even though I am now running with "mac80211: Add netif state checking
> > to ieee80211_ifa_changed"
> 
> This is curious. In your source (mine does not seem to fully match what
> you are using) what is the BUG that is getting triggered, main.c:437 ?

Oh, and did you remember to apply the fix patch for the bug too, as it
seems not yet be integrated to wireless-testing:

"mac80211: Add netif state checking to ieee80211_ifa_changed"

-Juuso

> -Juuso
> 
> > Here is what I get:
> > 
> > [  390.153170] ------------[ cut here ]------------
> > [  390.156016] kernel BUG at /home/wifi/iwlwifi-2.6/net/mac80211/main.c:437!
> > [  390.156016] invalid opcode: 0000 [#1] SMP
> > [  390.156016] last sysfs file: /sys/devices/virtual/misc/rfkill/dev
> > [  390.156016] CPU 0
> > [  390.156016] Modules linked in: iwl3945(+) iwlcore mac80211 cfg80211 rfkill binfmt_misc sbs


