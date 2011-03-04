Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46653 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759868Ab1CDRGW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 12:06:22 -0500
Message-ID: <4D711C04.8030309@openwrt.org>
Date: Fri, 04 Mar 2011 18:06:12 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH 2/2] mac80211: Shortcut minstrel_ht rate setup for non-MRR
 capable devices
References: <1299241892-6719-1-git-send-email-helmut.schaa@googlemail.com> <1299241892-6719-2-git-send-email-helmut.schaa@googlemail.com>
In-Reply-To: <1299241892-6719-2-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-04 1:31 PM, Helmut Schaa wrote:
> Devices without multi rate retry support won't be able to use all rates
> as specified by mintrel_ht. Hence, we can simply skip setting up further
> rates as the devices will only use the first one.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> 
> has_mrr is true if the device is able to make use of at least four rates. Not
> sure if we might want to consider further special cases for devices with for
> example a maximum of two rates.
I think we should add a special case for handling a maximum of two
rates. Right now this is being used by brcm80211, so applying this patch
might make things worse there.

- Felix
