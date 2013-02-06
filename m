Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56252 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab3BFRzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:55:00 -0500
Message-ID: <511298E8.7090801@candelatech.com> (sfid-20130206_185548_201888_40B543D4)
Date: Wed, 06 Feb 2013 09:54:48 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Cong Ding <dinggnu@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mac80211/cfg.c: fix error using of sizeof()
References: <1360167826-29265-1-git-send-email-dinggnu@gmail.com>  (sfid-20130206_172354_765098_665D60D0) <1360168022.7910.22.camel@jlt4.sipsolutions.net>
In-Reply-To: <1360168022.7910.22.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2013 08:27 AM, Johannes Berg wrote:
> On Wed, 2013-02-06 at 17:23 +0100, Cong Ding wrote:
>> Using 'sizeof' on array given as function argument returns size of a pointer
>> rather than the size of array.
>
> Oops, yeah, Stephen Hemminger pointed this out a month or so ago and I
> forgot to change it, thanks.

This needs to be back-ported for 3.7 stable?  Perhaps the code below
corresponds (from copy_mesh_setup)?


	/* mcast rate setting in Mesh Node */
	memcpy(sdata->vif.bss_conf.mcast_rate, setup->mcast_rate,
						sizeof(setup->mcast_rate));

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

