Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48904 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab0CCITE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 03:19:04 -0500
Date: Wed, 3 Mar 2010 10:18:35 +0200
From: Jouni Malinen <j@w1.fi>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org, netrolller.3d@gmail.com,
	benoit.papillault@free.fr
Subject: Re: [PATCH v2] ath5k: fix injection in monitor mode
Message-ID: <20100303081835.GA1637@jm.kir.nu>
References: <20100302025158.9527.43764.stgit@void>
 <20100302094238.GA24391@jm.kir.nu>
 <201003031010.49887.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201003031010.49887.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 03, 2010 at 10:10:49AM +0900, Bruno Randolf wrote:
> On Tuesday 02 March 2010 18:42:38 Jouni Malinen wrote:
> > If we want to have an option to prevent hardware from touching the frame
> > payload, that really should be an option (a radiotap and TX control
> > flags, etc.), not default functionality for monitor interface.

> yes, we use it for testing IBSS mode (merging, TSF updates) by injecting 
> custom beacons. i guess other packet injectors would also assume that their 
> packets go out untouched.

Like I said, not all packet injectors do and hostapd certainly depends
on the injected packet being updated (both for contents and for
selecting a suitable TX rate and also to encrypt the frame when a key is
set for this).

> so what would be a way to support that properly?
> what about a monitor mode flag?

My preference is shown in the quoted text above, i.e., a new radiotap
(per packet, not per monitor interface) flag and then internally in
mac80211--driver a new TX control flag to indicate that the frame is not
to be updated.

-- 
Jouni Malinen                                            PGP id EFC895FA
