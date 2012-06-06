Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53149 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab2FFXDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 19:03:24 -0400
Received: by dady13 with SMTP id y13so9429638dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 16:03:24 -0700 (PDT)
Date: Wed, 6 Jun 2012 16:03:09 -0700
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] Improvement to initial mesh metric
Message-ID: <20120606230309.GA7262@hemlock> (sfid-20120607_010328_113680_E9481692)
References: <1339022932-14240-1-git-send-email-jason@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339022932-14240-1-git-send-email-jason@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 06, 2012 at 03:48:46PM -0700, Jason Abele wrote:
> I am submitting this patch set on behalf of the cozybit team after
> testing them with the wireless-testing tag master-2012-06-06
> 
> The first patch was previously submitted by Timo Lindhorst and adds
> important features to hwsim.
> 
> The remaining patches add a feature to initialize the link rate metric
> with a guess based off of RSSI when insufficient traffic has passed to
> allow actual calculation of the link rate.

Actually, let me squash 5 and 6 real quick, my apologies for sending
this a bit too quick

v2 patch set coming soon

Jason

> 
> 
> Javier Cardona (4):
>   mac80211: Remove unused variable
>   mac80211: Keep tx rate averages for mesh peers for better metric
>     calculation.
>   mac80211: Rename stainfo variable for the more common sta
>   mac80211: Change rssi_get_rate to interpolated data rates.
> 
> Thomas Pedersen (1):
>   mac80211: Use signal strength as a proxy for expected datarate.
> 
> Timo Lindhorst (1):
>   mac80211_hwsim: Report rate info in tx status
> 
>  drivers/net/wireless/mac80211_hwsim.c |   21 +++++++
>  net/mac80211/mesh_hwmp.c              |   99 +++++++++++++++++++++++++++------
>  net/mac80211/sta_info.c               |    1 +
>  net/mac80211/sta_info.h               |    1 +
>  4 files changed, 106 insertions(+), 16 deletions(-)
> 
> -- 
> 1.7.9.5
> 
