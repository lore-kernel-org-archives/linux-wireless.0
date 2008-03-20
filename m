Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:52325 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbYCTStJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 14:49:09 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [regression: 2.6.25-rc6: iwl3945]
Date: Thu, 20 Mar 2008 11:44:33 -0700
Message-ID: <D936D925018D154694D8A362EEB0892003F6F7A4@orsmsx416.amr.corp.intel.com> (sfid-20080320_184914_648040_284A23AD)
In-Reply-To: <47E1953F.9020202@gawab.com>
References: <47E1953F.9020202@gawab.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Justin Madru" <jdm64@gawab.com>, <linux-wireless@vger.kernel.org>,
	<linux@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, March 19, 2008 3:36 PM, Justin Madru  wrote:

> Mar 18 11:00:02 dell kernel: printk: 1 messages suppressed.
> Mar 18 11:00:02 dell kernel: wlan0_rename: RX too short data
> frame payload

These messages are printed by the mac80211 stack when it receives little
more than a 802.11 header ...
 
> A 1-min Wireshark network dump (my address was 10.68.1.211):
>    http://jdserver.homelinux.org/linux/wireshark-1min

This capture does not show the 802.11 headers ... the frames start with
their 802.3 (Ethernet) headers. Did you take this capture on the host
self? If so, the capture will only show frames received by this host,
but unfortunately the frames that cause the message to be displayed have
already been dropped at this point. Is it possible to get a capture of
everything that goes over the air? You will need a second wireless
device that is in monitor mode in order to see this traffic. 

Thanks!

Reinette
