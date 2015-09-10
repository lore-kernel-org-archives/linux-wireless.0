Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58068 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbbIJINN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 04:13:13 -0400
Message-ID: <1441872785.2108.2.camel@sipsolutions.net> (sfid-20150910_101338_815909_29F7512C)
Subject: Re: [PATCH] net/mac80211/rate.c: fix wrong sizeof()
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergei Trofimovich <slyich@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: Sergei Trofimovich <siarheit@google.com>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Thu, 10 Sep 2015 10:13:05 +0200
In-Reply-To: <1441832214-6939-1-git-send-email-slyich@gmail.com>
References: <1441832214-6939-1-git-send-email-slyich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-09 at 21:56 +0100, Sergei Trofimovich wrote:
> From: Sergei Trofimovich <siarheit@google.com>
> 
> Noticed by gcc-5.2.0:
> 
>     net/mac80211/rate.c: In function 'rate_control_cap_mask':
>     net/mac80211/rate.c:719:25: warning: 'sizeof' on array function 
> parameter 'mcs_mask' will return size of 'u8 * {aka unsigned char *}' 
> [-Wsizeof-array-argument]
>        for (i = 0; i < sizeof(mcs_mask); i++)
>                              ^
> 
We already merged a fix for this.

johannes
