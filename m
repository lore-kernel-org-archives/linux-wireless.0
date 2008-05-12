Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:20436 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbYELXSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 19:18:49 -0400
Received: by an-out-0708.google.com with SMTP id d40so519020and.103
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 16:18:48 -0700 (PDT)
Message-ID: <40f31dec0805121618j4a2f8bedw78e2ce36d8158649@mail.gmail.com> (sfid-20080513_011901_139408_CF2ACAB0)
Date: Tue, 13 May 2008 02:18:48 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: Fix loop variable initializations
Cc: mcgrof@gmail.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <E1JvZ2x-0005kb-TH@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <E1JvZ2x-0005kb-TH@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Have you checked this one...

1838                         if (rs.rs_status & AR5K_RXERR_MIC) {
1839                                 rxs.flag |= RX_FLAG_MMIC_ERROR;
1840                                 goto accept;

are you sure that doesn't happen ?

Also why initialize rxs.flag here?
> rxs.flag = RX_FLAG_TSFT;

Why not doing a simple
rxs.flag = 0 ;
or a check of flags set by mac80211 at the start of the loop ?

This way we'll also have a clean rxs.flag when doing
rxs.flag |= RX_FLAG_MMIC_ERROR
and we won't clear RX_FLAG_MMIC_ERROR when doing
rxs.flag = RX_FLAG_TSFT;

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
