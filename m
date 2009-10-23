Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35589 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582AbZJWQaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 12:30:22 -0400
Date: Fri, 23 Oct 2009 09:30:01 -0700
From: Jouni Malinen <j@w1.fi>
To: =?utf-8?B?QmrDtnJu?= Smedman <bjorn.smedman@venatech.se>
Cc: Joerg Pommnitz <pommnitz@yahoo.com>,
	Will Dyson <will.dyson@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] mac80211/ath9k/hostapd: Some clients unable to
	associate with AP
Message-ID: <20091023163001.GA4911@jm.kir.nu>
References: <133e8d7e0910200711s7c44b899nbcd5f1037cc5ee49@mail.gmail.com> <133e8d7e0910210448y39551160o7a12a8af2da43f85@mail.gmail.com> <20091022161021.GA5532@jm.kir.nu> <8e6f94720910221645n2b0b1edcq29358f175a41d3ad@mail.gmail.com> <389827.53102.qm@web51401.mail.re2.yahoo.com> <133e8d7e0910230346q176fca69y55d8fb66b61d3fbf@mail.gmail.com> <133e8d7e0910230827x4febf4ccw6920d88830444abd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <133e8d7e0910230827x4febf4ccw6920d88830444abd@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 23, 2009 at 05:27:27PM +0200, Björn Smedman wrote:

> It seems the problem is a typo in net/mac80211/tx.c that causes
> injected frames from hostapd not to be associated with the correct ap
> interface before going into ieee80211_tx_h_sequence(). This tiny patch
> solves my problems (and looks reasonable to me in any case):

Thanks! Would you be able to make the same patch against the
wireless-testing.git repository and add a Signed-off-by line to meet the
kernel submission requirements?

> diff -urN compat-wireless-2009-10-21-before_seqnum_fix/net/mac80211/tx.c
> compat-wireless-2009-10-21/net/mac80211/tx.c
> @@ -1445,7 +1445,7 @@
>                                 if (tmp_sdata->vif.type != NL80211_IFTYPE_AP)
>                                         continue;
>                                 if (compare_ether_addr(tmp_sdata->dev->dev_addr,
> -                                                      hdr->addr2)) {
> +                                                      hdr->addr2) == 0) {
>                                         dev_hold(tmp_sdata->dev);
>                                         dev_put(sdata->dev);
>                                         sdata = tmp_sdata;

This does indeed look like a typo. Though, I'm not sure how this would
have caused a regression between compat-wireless-2009-06-02 and
compat-wireless-2.6.32-rc1. The incorrect compare_ether_addr() use seems
to be there in the original commit that added this code
(25d834e16294c8dfd923dae6bdb8a055391a99a5 from September 12, 2008)..

Johannes: Any idea why the sequence number allocation for injected
frames from hostapd would have changed between 2009-06-02 and now? This
bug seems to be too old to explain that ;-).

-- 
Jouni Malinen                                            PGP id EFC895FA
