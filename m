Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [128.177.27.249] ([128.177.27.249]:49917 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751559AbZE2TFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 15:05:45 -0400
Date: Fri, 29 May 2009 21:50:55 +0300
From: Jouni Malinen <j@w1.fi>
To: Karl Hiramoto <karl@hiramoto.org>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] hostapd: nl80211 retry creating a interface if it
	fails the first time.
Message-ID: <20090529185055.GC2814@jm.kir.nu>
References: <1242383768-21030-1-git-send-email-karl@hiramoto.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242383768-21030-1-git-send-email-karl@hiramoto.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 15, 2009 at 12:36:08PM +0200, Karl Hiramoto wrote:
> If hostapd segfaults, or is killed with -9, or the interface already exists, when the interface is created, it will fail.

> This patch solves this issue.

Thanks, applied with a change to do this only on ENFILE errors which is
the errno used by __dev_alloc_name() in this particular case where
mac80211 fails to add an interface due to the interface being there
already.

-- 
Jouni Malinen                                            PGP id EFC895FA
