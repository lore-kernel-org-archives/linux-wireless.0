Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab2ADQbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 11:31:03 -0500
Subject: Re: iwl3945: disassociating from current AP on rescan with kernels
 > 3.0
From: Dan Williams <dcbw@redhat.com>
To: Mike Edenfield <kutulu@kutulu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <012e01ccc67b$bfe90be0$3fbb23a0$@kutulu.org>
References: <012e01ccc67b$bfe90be0$3fbb23a0$@kutulu.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jan 2012 10:31:02 -0600
Message-ID: <1325694662.2622.7.camel@d430> (sfid-20120104_173108_366563_3329B43D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-29 at 17:46 -0500, Mike Edenfield wrote:
> After upgrading to a v3.0 kernel, my Intel wireless adapter stopped working
> when used with any UI-based wpa_supplicant front-end that does periodic
> scans, such as NetworkManager and wicd. Whenever the software asks for an AP
> scan, the device disconnects from its current AP and blacklists it, making
> it impossible to reconnect until I kill wpa_supplicant. If I manually
> configure wpa_supplicant and launch it directly, the adapter stays
> associated with the AP properly.
> 
> I was able to reproduct this behavior with kernel version 3.0.4, 3.1.4, and
> 3.1.5, but downgrading to 2.6.39 or lower solves the problem. I haven't seen
> any other reports of this problem specific to 3.x -- did I miss some other
> step I need to do when upgrading?

There shouldn't be any; the driver should be ensuring that the current
association stays valid across scans as long as the AP is still in
range.  This sounds like a driver or mac80211 bug.

Dan


