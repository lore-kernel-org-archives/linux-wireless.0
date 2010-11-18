Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56172 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab0KRRld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 12:41:33 -0500
Received: by vws13 with SMTP id 13so1838394vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 09:41:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com>
References: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com>
Date: Thu, 18 Nov 2010 12:41:19 -0500
Message-ID: <AANLkTikACJ35YFDCS5NucXjhNDFyT7VU9FeYUGY9hMmo@mail.gmail.com>
Subject: Re: [PATCH 0/4] cfg80211: fix bug with multiple cards and a CRDA delay
From: Mark Mentovai <mark@moxienet.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> This series addresses the bug pointed out by Mark Mentovai <mark@moxienet.com>
> when there is a delay on CRDA and you use multiple cards with the same regulatory
> domain. After some testing I realized this also introduced an issue when using
> multiple cards with different regulatory settings. The issue is present only
> when there is a delay in CRDA so technically this is not a regression so I am
> not marking these as stable fixes. It also does not seem to be a regulatory bug
> as when the issue is present you'd end up with an intersected regulatory domain
> (same alpha2s) or get the regulatory domain rejected for the second card if
> the alpha2 was different.
>
> Thanks to Mark for his testing, good ideas on alternative ways to resolve this
> and thorough reports.

Excellent! I’ve read through this patch set and approve. I’ve tested
it out. It definitely does the trick.

The one thing I spotted was that you didn’t revise the @processed
comment in regulatory.h from patch 4.

I don’t know which of Signed-off-by, Acked-by, or Tested-by is
appropriate here, but as far as I’m concerned, this is a winner.
