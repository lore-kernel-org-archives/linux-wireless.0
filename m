Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33240 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbbFAUgJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 16:36:09 -0400
Message-ID: <1433190967.3505.17.camel@sipsolutions.net> (sfid-20150601_223613_838915_E4587257)
Subject: Re: [PATCH V2] mac80211: Fix power save state stuck in ACTIVE
 caused by race between suspend and Tx packet.
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya T K <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 01 Jun 2015 22:36:07 +0200
In-Reply-To: <1433178885-8787-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150601_191550_985047_1F5BDBC6)
References: <1433178885-8787-1-git-send-email-chaitanya.mgit@gmail.com>
	 (sfid-20150601_191550_985047_1F5BDBC6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-06-01 at 22:44 +0530, Chaitanya T K wrote:
> From: Chaitanya T K <chaitanya.mgit@gmail.com>
> 
> If suspended during TX in progress, there can be 
> race where the driver is put of of power-save due
> to TX and during suspend dynamic_ps_time is cancelled
> and TX packet is flushed, leaving the driver in ACTIVE
> even after resuming until dynamic_ps_time puts 
> driver back in DOZE. (Which only happens if there
> is another TX).
> 
> This can lead high power consumption of chipset during (or)
> after resuming also.

This isn't what your patch is actually doing though. You need to mention
WoWLAN at the very least in your commit log; or are you just randomly
changing the code until it fixes your bug? :)

johannes

