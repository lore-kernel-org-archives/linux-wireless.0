Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35065 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab2FTIwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:52:25 -0400
Message-ID: <1340182340.4655.46.camel@jlt3.sipsolutions.net> (sfid-20120620_105232_654664_515C4913)
Subject: Re: [PATCH v2] mac80211: initialize sta pointer to avoid
 false-positive warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tony@atomide.com
Date: Wed, 20 Jun 2012 10:52:20 +0200
In-Reply-To: <1340023971-9754-1-git-send-email-coelho@ti.com>
References: <1340023971-9754-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-18 at 15:52 +0300, Luciano Coelho wrote:
> Some compilers (eg. gcc 4.4.1 for ARM) report a false positive warning
> in mlme.c:
> 
> net/mac80211/mlme.c: In function 'ieee80211_prep_connection':
> net/mac80211/mlme.c:3035: warning: 'sta' may be used uninitialized in this function
> 
> This is a false positive because the place where 'sta' is used is
> inside an if with the same condition of where it is set:

I still think it's a workaround, but what the hell ... applied.

johannes

