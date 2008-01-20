Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:51736 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYATKna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 05:43:30 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1562054fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jan 2008 02:43:29 -0800 (PST)
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Sun, 20 Jan 2008 11:43:09 +0100
Cc: "Bruno Randolf" <bruno@thinktube.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Ulrich Kunitz" <kune@deine-taler.de>,
	"Daniel Drake" <dsd@gentoo.org>
References: <20080118125252.6455.41047.stgit@one> <43e72e890801200217i7a7e5349uebf56d42c63cf48e@mail.gmail.com>
In-Reply-To: <43e72e890801200217i7a7e5349uebf56d42c63cf48e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801201143.09488.IvDoorn@gmail.com> (sfid-20080120_104342_593583_0044D574)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Adding Johill and Michael as they are maintainers of mac80211 and they
> need to review this. Please add them on further mac80211 patches.
> 
> Note to driver authors: zd1211rw, rt2x00 drivers and adm8211 will need
> to set mactime if they want IBSS merge to work as this functionality
> would be added with this. I believe all other drivers set it, but
> didn't do a thorough grep.

Then there is a problem for rt2x00. Since the mactime isn't known.
rt2400pci is the _only_ device which has a RX_END_TIME field in the
RX descriptor.

Ivo
