Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56897 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753477AbZATS4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 13:56:40 -0500
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=iso-8859-1
Date: Tue, 20 Jan 2009 19:56:35 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090120151003.GA8710@jm.kir.nu>
Message-ID: <20090120185635.284250@gmx.net> (sfid-20090120_195646_050866_769EFD29)
MIME-Version: 1.0
References: <20090106020130.302750@gmx.net> <20090108091055.GA7009@jm.kir.nu>
 <20090117221225.301920@gmx.net> <20090120151003.GA8710@jm.kir.nu>
Subject: Re: [PATCH] Fixed BSSID step 3: Don't merge with the same BSSID
To: Jouni Malinen <j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jouni!

> Some hardware designs require the reset_tsf call to allow the hardwar=
e
> to get back in sync with the TSF based on received timestamp values i=
n
> some cases. I would expect this to be used in ath9k and ath5k. This d=
oes
> not mean that the timestamp would be reset to zero in actual Beacon
> frames, i.e., this is just something done internally in the
> driver/firmware/hardware and the need for reset_tsf() is to just prov=
ide
> the notification to the driver when this special case is needed.

Okay, thanks for your notice. Than I think the dummy merge detection co=
de should in the ieee80211_sta_join_ibss() function and if so only call=
 reset_tsf()?!
Should it make any other thinks too in this case?

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
