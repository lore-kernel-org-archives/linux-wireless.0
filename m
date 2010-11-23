Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41638 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab0KWMOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 07:14:46 -0500
Received: by iwn33 with SMTP id 33so37822iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 04:14:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290475383-26911-2-git-send-email-lrodriguez@atheros.com>
References: <1290475383-26911-1-git-send-email-lrodriguez@atheros.com>
	<1290475383-26911-2-git-send-email-lrodriguez@atheros.com>
Date: Tue, 23 Nov 2010 13:14:45 +0100
Message-ID: <AANLkTi=LBVHDZSygYA9rF6zWS1JEM3WtP9rA7zpfjNP=@mail.gmail.com>
Subject: Re: [PATCH 2/3] ath9k: avoid aggregation for VO traffic
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Matt Smith <matt.smith@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 23, 2010 at 2:23 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This should help with latency issues which can happen when
> using aggregation.

Wouldn't it be better to fix the TXOP limit handling in
ath_lookup_rate() instead?

>From xmit.c:

        /*
         * Find the lowest frame length among the rate series that will have a
         * 4ms transmit duration.
         * TODO - TXOP limit needs to be considered.
         */
        max_4ms_framelen = ATH_AMPDU_LIMIT_MAX;

/Björn
