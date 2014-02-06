Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43848 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbaBFOmL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 09:42:11 -0500
Message-ID: <52F39F41.2010300@openwrt.org> (sfid-20140206_154225_363149_50967E93)
Date: Thu, 06 Feb 2014 15:42:09 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Cedric VONCKEN <cedric.voncken@acksys.fr>,
	linux-wireless@vger.kernel.org
Subject: Re: ATH9K software retry
References: <773DB8A82AB6A046AE0195C68612A3190173371A@sbs2003.acksys.local>
In-Reply-To: <773DB8A82AB6A046AE0195C68612A3190173371A@sbs2003.acksys.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-02-06 14:06, Cedric VONCKEN wrote:
> In xmit.c the function ath_tx_complete_aggr test if the fi->retries <
> ATH_MAX_SW_RETRIES.
> 
> If this condition is true, ATH9K handle software retry. 
> 
> Minstrel set in the frame one or more rates, for each rate minstrel set
> a retries count. I think is sufficient.
> 
> Why ATH9K need to manage the software retries?
The retries configured for minstrel_ht are used for hardware retries of
single frames and full A-MPDU transmissions. Software retries are used
for individual subframes that are sent as part of A-MPDUs.
This is required, because failed subframes are frequent with higher MCS
rates and A-MPDU.

> With the test we have a minimal of 30 retries (ATH_MAX_SW_RETRIES is set
> to 30).
> 
> I plan to remove the software retry int ATH9K, before I would like to
> know if theses retries is necessary.
Removing software retry functionality is a very bad idea.

- Felix

