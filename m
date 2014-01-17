Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaAQP3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 10:29:19 -0500
Message-ID: <1389972543.10404.5.camel@jlt4.sipsolutions.net> (sfid-20140117_162935_596578_484FE6E5)
Subject: Re: [PATCH v3 1/2] b43: fix the wrong assignment of status.freq in
 b43_rx()
From: Johannes Berg <johannes@sipsolutions.net>
To: ZHAO Gang <gamerh2o@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	Jonas Gorski <jogo@openwrt.org>, Luca Coelho <luca@coelho.fi>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Stable <stable@vger.kernel.org>
Date: Fri, 17 Jan 2014 16:29:03 +0100
In-Reply-To: <b28b37da08e43e0f459c5094ed210649ab1f7090.1389970392.git.gamerh2o@gmail.com> (sfid-20140117_161955_063280_BEA8D929)
References: <b28b37da08e43e0f459c5094ed210649ab1f7090.1389970392.git.gamerh2o@gmail.com>
	 (sfid-20140117_161955_063280_BEA8D929)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-17 at 23:19 +0800, ZHAO Gang wrote:
> Use the right function to update status.freq. The wrong frequency
> value can cause problem that bss info can't be updated when it
> should be.
> 
> This bug is introduced by commit 8318d78a44d49ac1edf2bdec7299de3617c4232e
> "cfg80211 API for channels/bitrates, mac80211 and driver conversion".
> 
> Cc: Stable <stable@vger.kernel.org>
> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
> ---
> v3: change commit log
>     suggested by Luca Coelho, Rafał Miłecki and Jonas Gorski
> 
> I'm not very familiar with wireless subsystem yet. If commit message needs
> more changes, feel free to point it out.

In general, you should also put a Fixes: pseudo-header (with 12-digit
commit ID and commit subject) into such commits, so this would be:

Cc: stable@vger.kernel.org
Fixes: 8318d78a44d4 ("cfg80211 API for channels/bitrates, mac80211 and driver conversion")
Signed-off-by: ...


Thanks for fixing this!

johannes

