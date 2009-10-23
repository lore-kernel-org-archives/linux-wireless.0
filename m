Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55876 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbZJWEHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 00:07:37 -0400
Date: Thu, 22 Oct 2009 21:07:30 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] cfg80211: sme: deauthenticate on assoc failure
Message-ID: <20091023040623.GA8786@jm.kir.nu>
References: <1256018933.4475.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1256018933.4475.6.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 20, 2009 at 03:08:53PM +0900, Johannes Berg wrote:
> When the in-kernel SME gets an association failure from
> the AP we don't deauthenticate, and thus get into a very
> confused state which will lead to warnings later on. Fix
> this by actually deauthenticating when the AP indicates
> an association failure.

While this may be a reasonable change to resolve an issue now, this may
not be the best long term solution. There are some association failure
cases which should really be handled by trying association again instead
of deauthenticating. The main example would be the association comeback
time use in IEEE 802.11w. In general, association failure should not
result in deauthentication in every case.

-- 
Jouni Malinen                                            PGP id EFC895FA
