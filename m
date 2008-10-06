Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:32909 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbYJFSXG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 14:23:06 -0400
Date: Mon, 6 Oct 2008 21:22:13 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dave <kilroyd@googlemail.com>, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: Re: [PATCH] mac80211: avoid "Wireless Event too big" message for
	assoc response
Message-ID: <20081006182213.GH4941@jm.kir.nu> (sfid-20081006_202310_790142_1B8B6124)
References: <1222890302-32486-1-git-send-email-linville@linville-t61.local> <48E53C1F.4040909@gmail.com> <20081006175357.GB3448@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081006175357.GB3448@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2008 at 01:53:57PM -0400, John W. Linville wrote:

> Honestly, I don't know.  I think we would prefer not to use the
> IWEVCUSTOM method, but my memory is not 100% clear on what triggered
> the 32-/64-bit problem.  Perhaps Jouni can comment?

IWEVCUSTOM is the wrong way of doing this. However, the problem here is
that IWEVASSOCREQIE and IWEVASSOCRESPIE can trigger wpa_supplicant to
behave incorrectly in 64-bit kernel, 32-bit userspace case (64/64 and
32/32 work fine). This is worked around in the current 0.6.x devel
branch, but not in any of the released versions.

-- 
Jouni Malinen                                            PGP id EFC895FA
