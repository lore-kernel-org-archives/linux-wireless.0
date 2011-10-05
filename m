Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34088 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934900Ab1JEWn1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 18:43:27 -0400
Message-ID: <4E8CDD8D.7010607@openwrt.org> (sfid-20111006_004331_116224_169C78B5)
Date: Thu, 06 Oct 2011 00:43:25 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Daniel Smith <viscous.liquid@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Felix Fietkau <public-nbd-p3rKhJxN3npAfugRpC6u6w@lo.gmane.org>
Subject: Re: [PATCH v13 5/5] ath9k: implement .get_antenna and .set_antenna
References: <1315006827-81443-1-git-send-email-nbd@openwrt.org> <1315006827-81443-2-git-send-email-nbd@openwrt.org> <1315006827-81443-3-git-send-email-nbd@openwrt.org> <1315006827-81443-4-git-send-email-nbd@openwrt.org> <1315006827-81443-5-git-send-email-nbd@openwrt.org> <4E8C9D53.1080307@gmail.com>
In-Reply-To: <4E8C9D53.1080307@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-10-05 8:09 PM, Daniel Smith wrote:
> On 9/2/2011 7:40 PM, Felix Fietkau wrote:
>>  On MIMO chips this can be used to enable/disable hardware chains, ensuring
>>  that the MCS information is updated accordingly.
>>  On non-MIMO chips with rx diversity (e.g. 9285), this configures the rx
>>  input antenna.
>
> I have been working with this patch as I needed the ability to select
> the rx chain/antenna on an AR9820.. A problem I have ran into is that
> regardless of what I set the antenna chain to, the radiotap header
> always reports antenna 1. I know this originates from the rx status
> descriptor, but is this really what should be used to report the antenna
> when using chains to select the antenna?
Typically all receive chains are used simultaneously when receiving 
packets, and the antenna field in the rx status is meaningless. I'm 
currently working on a patch that makes per-chain rx signal strength 
available in the status info and puts it in the station info available 
via nl80211.

- Felix
