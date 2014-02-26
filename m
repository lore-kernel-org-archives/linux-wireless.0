Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:39426 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaBZJH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 04:07:57 -0500
Message-ID: <530DAECD.8010405@broadcom.com> (sfid-20140226_100810_781254_A1F70BFB)
Date: Wed, 26 Feb 2014 10:07:25 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/14] brcmfmac: add delay before unregistering the network
 device
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>	 <1393356639-19169-2-git-send-email-arend@broadcom.com>	 (sfid-20140225_203048_842452_A39499B6) <1393358376.4170.22.camel@jlt4.sipsolutions.net>
In-Reply-To: <1393358376.4170.22.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2014 08:59 PM, Johannes Berg wrote:
> On Tue, 2014-02-25 at 20:30 +0100, Arend van Spriel wrote:
>> Upon deleting the interface a cfg80211_disconnected() is called under
>> rtnl_lock. Right after the unlocking the rtnl_lock we unregister the
>> network device. This patch adds delay before unregister so cfg80211
>> can handle disconnect and notify wpa_supplicant.
> 
>> +				/* make sure cfg80211 can send disconnect event
>> +				 * before unregistering the netdevice below.
>> +				 */
>> +				msleep(100);
> 
> This has got to be one of the worst hacks I've seen in wireless so
> far ... :)

Did you see I removed a sleep as well in this patch :-p

I just don't see how I can assure cfg80211 has actually done the
disconnect work. If we don't do a cfg80211_disconnected() I get a WARN
from the cfg80211 netdev notifier (or at least I did in previous kernel).

Should we consider a clean solution, ie. modify cfg80211 for this scenario?

Gr. AvS


