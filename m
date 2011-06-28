Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:51439 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252Ab1F1V61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 17:58:27 -0400
Date: Wed, 29 Jun 2011 00:57:57 +0300
From: Jouni Malinen <j@w1.fi>
To: Michel Alexandre Salim <salimma@fedoraproject.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [PATCH] ath9k: add module option for disabling 11n
 functionality
Message-ID: <20110628215757.GA14975@jm.kir.nu> (sfid-20110628_235830_750158_9D76A123)
References: <4E0A2F8A.8010102@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E0A2F8A.8010102@fedoraproject.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 28, 2011 at 09:46:18PM +0200, Michel Alexandre Salim wrote:
> Some wireless base stations implement 802.11n mode in ways that
> open-source drivers cannot handle properly, resulting in very
> unstable connections. This patch introduces an '11n_disable' option
> to the ath9k driver, similar to the same option for the iwlagn
> driver.

What is so special about this that makes it impossible for open source
drivers to handle? The proper approach here would be to figure out what
is causing the interop issue and fix (or more likely, work around) that.

In addition, if this is really needed, why would this be a driver
specific hack rather than providing a shared mechanism in mac80211 to
disable 802.11n support? It would sound strange if there would need to
be a new module parameter in every 802.11n driver to handle something
like this.

-- 
Jouni Malinen                                            PGP id EFC895FA
