Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60843 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab0LIRaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 12:30:07 -0500
Date: Thu, 9 Dec 2010 12:19:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tim Harvey <harvey.tim@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix NULL-pointer deference on ibss merge when
 not ready
Message-ID: <20101209171951.GB2339@tuxdriver.com>
References: <1291913039-20801-1-git-send-email-harvey.tim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291913039-20801-1-git-send-email-harvey.tim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 09, 2010 at 08:43:59AM -0800, Tim Harvey wrote:
> dev_open will eventually call ieee80211_ibss_join which sets up the
> skb used for beacons/probe-responses however it is possible to
> receive beacons that attempt to merge before this occurs causing
> a null pointer dereference.
> 
> This occurs quite easily in the presence of adhoc nodes with hidden SSID's
> ---
>  net/mac80211/ibss.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Signed-off-by?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
