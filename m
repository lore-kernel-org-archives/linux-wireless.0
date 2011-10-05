Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:60910 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812Ab1JESJj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 14:09:39 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RBVuT-0003Ii-UE
	for linux-wireless@vger.kernel.org; Wed, 05 Oct 2011 20:09:37 +0200
Received: from 207.59.80.172 ([207.59.80.172])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 20:09:37 +0200
Received: from viscous.liquid by 207.59.80.172 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 20:09:37 +0200
To: linux-wireless@vger.kernel.org
From: Daniel Smith <viscous.liquid@gmail.com>
Subject: Re: [PATCH v13 5/5] ath9k: implement .get_antenna and .set_antenna
Date: Wed, 05 Oct 2011 14:09:23 -0400
Message-ID: <4E8C9D53.1080307@gmail.com> (sfid-20111005_200943_274180_B66824C4)
References: <1315006827-81443-1-git-send-email-nbd@openwrt.org> <1315006827-81443-2-git-send-email-nbd@openwrt.org> <1315006827-81443-3-git-send-email-nbd@openwrt.org> <1315006827-81443-4-git-send-email-nbd@openwrt.org> <1315006827-81443-5-git-send-email-nbd@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Felix Fietkau <public-nbd-p3rKhJxN3npAfugRpC6u6w@lo.gmane.org>
In-Reply-To: <1315006827-81443-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/2/2011 7:40 PM, Felix Fietkau wrote:
> On MIMO chips this can be used to enable/disable hardware chains, ensuring
> that the MCS information is updated accordingly.
> On non-MIMO chips with rx diversity (e.g. 9285), this configures the rx
> input antenna.

I have been working with this patch as I needed the ability to select 
the rx chain/antenna on an AR9820.. A problem I have ran into is that 
regardless of what I set the antenna chain to, the radiotap header 
always reports antenna 1. I know this originates from the rx status 
descriptor, but is this really what should be used to report the antenna 
when using chains to select the antenna?

V/r,
Daniel

