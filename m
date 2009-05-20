Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37289 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbZETRPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 13:15:15 -0400
Date: Wed, 20 May 2009 13:06:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211: fix managed mode BSSID handling
Message-ID: <20090520170610.GB7604@tuxdriver.com>
References: <1242721949.17164.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242721949.17164.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2009 at 10:32:29AM +0200, Johannes Berg wrote:
> John,
> 
> You asked whether the fix-up was correct, but was there also a problem
> applying that to wireless-testing? It seems to be missing a hunk (below)
> in commit
> 
> commit 4eca27a55d34bc3256fb367842ab225948fa155b
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Thu May 14 13:10:14 2009 +0200
> 
>     mac80211: fix managed mode BSSID handling
> 
> ---
>  net/mac80211/main.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> --- wireless-testing.orig/net/mac80211/main.c	2009-05-18 19:48:04.000000000 +0200
> +++ wireless-testing/net/mac80211/main.c	2009-05-19 10:30:50.000000000 +0200
> @@ -219,18 +219,26 @@ void ieee80211_bss_info_change_notify(st
>  				      u32 changed)
>  {
>  	struct ieee80211_local *local = sdata->local;
> +	static const u8 zero[ETH_ALEN] = { 0 };

Looks like a busted rebase from pending-fixes to master -- that hunk
went to a function that doesn't exist on master.

Thanks for the vigilence!  I'll get a fix-up for this...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
