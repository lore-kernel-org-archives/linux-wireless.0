Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49748 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932704Ab0AFWD1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 17:03:27 -0500
Message-ID: <4B4508A5.8050501@openwrt.org>
Date: Wed, 06 Jan 2010 23:03:17 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Thomas Backlund <tmb@mandriva.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
References: <1262710858.28653.5.camel@johannes.local>	 <4B450004.9050601@mandriva.org> <1262814684.4437.0.camel@johannes.local>
In-Reply-To: <1262814684.4437.0.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-06 10:51 PM, Johannes Berg wrote:
> On Wed, 2010-01-06 at 23:26 +0200, Thomas Backlund wrote:
> 
>> With this patch applied to 2.6.33-rc3 kernel crashes at boot...
>> 
>> I have a iwl4965 connecting to a wpa2-psk encrypted network, arch is 
>> x86_64, distro Mandriva Linux and the kernel has preempt enabled.
>> 
>> Am I only missing some patches, or did I hit a real bug ?
> 
> It'd help if you said what crashes and how since nobody else seems to be
> having that particular problem with this patch.
I have an idea.
The patch adds the following chunk of code:
> +	if (!sta && ra && !is_multicast_ether_addr(ra)) {
> +		sta = sta_info_get(sdata, ra);
> +		if (sta)
> +			sta_flags = get_sta_flags(sta);
In wireless-testing, sta_info_get takes sdata as first argument, in
2.6.33-rc3 it expects a pointer to local. This should have emitted a
compiler warning... I saw the same thing when applying the patch to an
older compat-wireless snapshot.

- Felix
