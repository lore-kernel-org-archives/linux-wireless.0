Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:50336 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171AbZDQU2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 16:28:04 -0400
Date: Fri, 17 Apr 2009 23:27:52 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Do not call cfg80211_send_disassoc with rcu
	held
Message-ID: <20090417202752.GA27686@jm.kir.nu> (sfid-20090417_222809_919929_F3F76EF6)
References: <20090417200448.GA24430@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090417200448.GA24430@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 17, 2009 at 11:04:48PM +0300, Jouni Malinen wrote:
> cfg80211_send_mlme_event() uses GFP_KERNEL and could sleep. Better not
> call it with rcu_read_lock held.

Please drop this; moving the deauth/disassoc frame TX here is not the
best idea. I'll figure out something safer to fix this.

-- 
Jouni Malinen                                            PGP id EFC895FA
