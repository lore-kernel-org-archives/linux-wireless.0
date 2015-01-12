Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35199 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbbALJmi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 04:42:38 -0500
Message-ID: <1421055751.1891.10.camel@sipsolutions.net> (sfid-20150112_104241_351678_BC1DB4A2)
Subject: Re: [PATCH net-next] Allow to set net namespace for wireless device
 via RTM_LINK
From: Johannes Berg <johannes@sipsolutions.net>
To: Vadim Kochan <vadim4j@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 12 Jan 2015 10:42:31 +0100
In-Reply-To: <CAMw6YJJgPJw7jizR=Qe_2SOK=S0UKrm9AyE7MHUg1-wODEab2g@mail.gmail.com> (sfid-20150112_100748_746925_589D0E40)
References: <1410467723-2550-1-git-send-email-vadim4j@gmail.com>
	 <1411075535.2034.5.camel@jlt4.sipsolutions.net>
	 <20141014121627.GA5115@angus-think.lan>
	 <1413798437.10246.12.camel@jlt4.sipsolutions.net>
	 <128188DF-5A9B-47A5-8A89-974CF7CF9064@holtmann.org>
	 <1413802344.10246.20.camel@jlt4.sipsolutions.net>
	 <CAMw6YJKLWQmT-fqg1QLDHbCxnpxWyJUSX+wvOB_pFyE=8HfSfQ@mail.gmail.com>
	 <1420449724.1898.1.camel@sipsolutions.net>
	 <CAMw6YJJgPJw7jizR=Qe_2SOK=S0UKrm9AyE7MHUg1-wODEab2g@mail.gmail.com>
	 (sfid-20150112_100748_746925_589D0E40)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-12 at 11:07 +0200, Vadim Kochan wrote:

> Would you please explain why wireless devs related to the same phy
> can't live in separated network namespaces ?

Well, they interact very deeply, for example the # of virtual interfaces
is often severely limited, and they often have to be using a single
channel, etc. It thus doesn't really make sense to try to separate them.

Also, if you really want to use it reliably, you should use a single
hostapd or wpa_supplicant process controlling all virtual interfaces,
which clearly isn't possible in multiple network namespaces.

johannes

