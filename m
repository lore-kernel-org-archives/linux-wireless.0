Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40739 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932810AbbEOTex (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 15:34:53 -0400
Message-ID: <55564A50.2050004@openwrt.org> (sfid-20150515_213457_388677_B679E706)
Date: Fri, 15 May 2015 21:34:40 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: add phy.c
References: <1431693340-8861-1-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1431693340-8861-1-git-send-email-linux@rempel-privat.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-05-15 14:35, Oleksij Rempel wrote:
> ... and move dup code from ar5008_phy.c and ar9002_phy.c to phy.c
> 
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
We already have base functionality for AR5008-AR9002 provided in some
ar5008_phy.c, and ar5008_hw_attach_phy_ops is called for those chipsets
as well. Please keep the de-duplicated code there instead of adding a
new phy.c, because AR9003+ uses a completely different codepath.

- Felix
