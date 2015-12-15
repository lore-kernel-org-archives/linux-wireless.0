Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34865 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965034AbbLOMJw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2015 07:09:52 -0500
Message-ID: <1450181385.3356.6.camel@sipsolutions.net> (sfid-20151215_130955_784141_9AE53FA9)
Subject: Re: [PATCH] nl80211: Potential memory leaks in reg.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Tue, 15 Dec 2015 13:09:45 +0100
In-Reply-To: <1450030323-6637-1-git-send-email-ola1olsson@gmail.com> (sfid-20151213_191210_429467_A915DC81)
References: <1450030323-6637-1-git-send-email-ola1olsson@gmail.com>
	 (sfid-20151213_191210_429467_A915DC81)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-12-13 at 19:12 +0100, Ola Olsson wrote:
> The first leak occurs when entering the default case
> in the switch for the initiator in set_regdom.
> The second leaks a platform_device struct if the
> platform registration in regulatory_init succeeds but
> the sub sequent regulatory hint fails due to no memory.

Applied, thanks. How are you finding these?? They seems so obscure :)

johannes
