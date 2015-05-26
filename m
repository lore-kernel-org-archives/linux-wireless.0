Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41711 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbbEZHQk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 03:16:40 -0400
Message-ID: <1432624593.2141.1.camel@sipsolutions.net> (sfid-20150526_091643_108979_49B0B9FC)
Subject: Re: [PATCHv2 0/2] add mt7601u driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakub =?UTF-8?Q?Kici=C5=84ski?= <moorray3@wp.pl>
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Date: Tue, 26 May 2015 09:16:33 +0200
In-Reply-To: <20150525113527.5b8b31c0@north>
References: <1430571690-9054-1-git-send-email-moorray3@wp.pl>
	 <1430857363-30844-1-git-send-email-moorray3@wp.pl>
	 <87fv6l3wib.fsf@kamboji.qca.qualcomm.com> <20150525113527.5b8b31c0@north>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-25 at 11:35 +0200, Jakub Kiciński wrote:

> I just dropped the line configuring HW promisc for now like Johannes
> did in his removal patch.  However, the right fix is to configure it
> based on IEEE80211_CONF_MONITOR, correct?

The two aren't equivalent, so no.

FIF_PROMISC_IN_BSS was meant to receive frames promiscuously *within*
the BSS, i.e. everything with the right BSSID. This functionality
clearly cannot work with encryption etc. nor with a lot of HW etc. so I
decided to remove it. It seems unlikely that anyone could have used it
successfully.

Monitor mode, on the other hand, supposedly receives *everything* that
decodes correctly on the receiver.

johannes

