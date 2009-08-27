Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbZH0OJC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 10:09:02 -0400
Subject: Re: [PATCH] rndis_wlan: increase scan timer delay
From: Dan Williams <dcbw@redhat.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20090827134340.190465b7qixz4wao@naisho.dyndns.info>
References: <20090827073854.27662.68095.stgit@fate.lan>
	 <20090827134340.190465b7qixz4wao@naisho.dyndns.info>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 09:09:13 -0500
Message-Id: <1251382153.11788.3.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-27 at 13:43 +0300, Jussi Kivilinna wrote:
> Please, don't merge this after all. Blocks scan too long and breaks  
> NetworkManager/wpa_supplicant.

Hmm, it shouldn't.  I've seen other cards (ath5k a/b/g) take 5 to 8
seconds to scan when they scan all the bands.  iwlwifi sometimes takes 5
seconds to scan as well.  That should all be valid.

Can you get some wpa_supplicant runs with "-dddt" that show the problem
you're having?  NM uses the supplicant for all scanning activity.  It
shouldn't really "break" NM, so if it does I'd like to fix that.

Dan

