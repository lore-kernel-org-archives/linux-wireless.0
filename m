Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbXDBEIb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 00:08:31 -0400
Subject: Re: WPA does not connect to bcm43xx-mac80211 when using  NetworkManager
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46107D79.3060706@lwfinger.net>
References: <460E2B8C.4030002@gmail.com>
	 <200703311503.53445.flamingice@sourmilk.net>
	 <f6ca9fed0703311256m1b14ec35p836a62de532dd804@mail.gmail.com>
	 <200703311700.52792.flamingice@sourmilk.net>
	 <1175388624.10282.0.camel@localhost.localdomain>
	 <46107D79.3060706@lwfinger.net>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 00:12:04 -0400
Message-Id: <1175487124.30381.16.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-04-01 at 22:50 -0500, Larry Finger wrote:
> Dan,
> 
> My bcm43xx-mac80211 system generates the following log entries when trying to connect using WPA-PSK
> TKIP controlled by NetworkManager. The same configuration works with bcm43xx-softmac.

So what you're saying here is that NM works with softmac, but doesn't
work with mac80211?

> eth1: Initial auth_alg=0
> eth1: authenticate with AP 00:14:bf:85:49:fa
> eth1: RX authentication from 00:14:bf:85:49:fa (alg=0 transaction=2 status=0)
> eth1: authenticated
> eth1: associate with AP 00:14:bf:85:49:fa
> eth1: RX AssocResp from 00:14:bf:85:49:fa (capab=0x31 status=0 aid=2)
> eth1: associated
> wmaster0: Added STA 00:14:bf:85:49:fa
> eth1: RX deauthentication from 00:14:bf:85:49:fa (reason=15)
> eth1: deauthenticated
> eth1: set_encrypt - unknown addr 00:00:00:00:00:00
> eth1: authenticate with AP 00:14:bf:85:49:fa
> eth1: RX authentication from 00:14:bf:85:49:fa (alg=0 transaction=2 status=0)
> eth1: authenticated
> eth1: associate with AP 00:14:bf:85:49:fa
> eth1: RX ReassocResp from 00:14:bf:85:49:fa (capab=0x31 status=0 aid=2)
> eth1: associated
> eth1: starting scan
> 
> It does the original open authentication and associates, but the final WPA authentication times out.

Hmm; any idea why that happens?  Can we figure out more about the
association process inside the driver?  If it works with wpa_supplicant,
can you increase the debugging output of wpa_supplicant in the NM
sources in nm-device-802-11-wireless.c in supplicant_exec() by adding
another argument to argv with the value '-ddd'?

Thanks!
Dan

> I'm using Michael Buesch's "mb" tree with the "mac80211: use IWEVGENIE" and "mac80211: set enc_capa"
> patches by Michael Wu. My distro is openSUSE 10.2 on an x86_64 system.
> 
> Please advise on any further information I should provide.
> 
> Thanks,
> 
> Larry

