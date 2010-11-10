Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44993 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0KJAZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 19:25:30 -0500
Subject: Re: connecting ieee80211_hw and net_device
From: Johannes Berg <johannes@sipsolutions.net>
To: Zoltan Herczeg <zherczeg@inf.u-szeged.hu>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <32995.82.131.221.21.1289334684.squirrel@webmail.inf.u-szeged.hu>
References: <32995.82.131.221.21.1289334684.squirrel@webmail.inf.u-szeged.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 16:26:51 -0800
Message-ID: <1289348811.3660.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-09 at 21:31 +0100, Zoltan Herczeg wrote:

> I can allocate a "wlan0" and "wlan1" platform device with
> ieee80211_alloc_hw, and can initialize it in Ad-Hoc mode. However, I
> realized this is not enough to have a wireless interface, since it has no
> receive operation, only transfer. Looking at the other drivers, I found
> that they allocate a net_device with the common alloc_etherdev.
> Unfortunately the register_netdev registers a new eth interface in my
> case, and this interface is not connected to the wlan interface. I set
> wireless_handlers and ieee80211_ptr for this device, still it is totally
> independent from the wlan interface.
> 
> Am I missing something? (Sorry if this is a trivial question, I tried
> google but no luck so far)

Your question doesn't make any sense. You never need wlan0/1, you only
need alloc_hw/register_hw and then the interfaces will be managed by
mac80211. You should post the code so people can help you.

johannes

