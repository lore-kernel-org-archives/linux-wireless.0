Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:45620 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755663AbZAUIpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 03:45:23 -0500
Date: Wed, 21 Jan 2009 10:45:09 +0200
From: Jouni Malinen <j@w1.fi>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] Fixed BSSID step 3: Don't merge with the same BSSID
Message-ID: <20090121084509.GA11265@jm.kir.nu> (sfid-20090121_094528_336122_D7DEBC82)
References: <20090106020130.302750@gmx.net> <20090108091055.GA7009@jm.kir.nu> <20090117221225.301920@gmx.net> <20090120151003.GA8710@jm.kir.nu> <20090120185635.284250@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090120185635.284250@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 07:56:35PM +0100, Alina Friedrichsen wrote:

> Okay, thanks for your notice. Than I think the dummy merge detection code should in the ieee80211_sta_join_ibss() function and if so only call reset_tsf()?!
> Should it make any other thinks too in this case?

That is probably enough, but I have to admit I have not gone through all
the details here. It certainly should not need to remove existing STA
entries or reconfigure beacon data etc. that may have been there in the
past.

-- 
Jouni Malinen                                            PGP id EFC895FA
