Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:52552 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbATCoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 21:44:30 -0500
Received: by mail-ob0-f169.google.com with SMTP id va8so7925194obc.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 18:44:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150116133152.GC10300@localhost>
References: <CAFk-A4kzcC9BhCtwqxjprRiXZeVPepBDXr3TvqvL6hn6J37UGw@mail.gmail.com>
	<1421389121-2841-1-git-send-email-masashi.honma@gmail.com>
	<20150116133152.GC10300@localhost>
Date: Tue, 20 Jan 2015 11:44:30 +0900
Message-ID: <CAFk-A4nF4jPiFR1c9fx-+sa=YWUZseEOKtut7rKWHihmLWp02w@mail.gmail.com> (sfid-20150120_034434_212765_6BEF43B8)
Subject: Re: [PATCH v2] mac80211: Avoid STA expiration timer truncation to u32
From: Masashi Honma <masashi.honma@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-01-16 22:31 GMT+09:00 Bob Copeland <me@bobcopeland.com>:
> Nice catch!
> There's a remaining problem on 32-bit platforms: there, unsigned long
> is 32 bits so 0xffffffff * HZ will still truncate to 32 bits.
>
> For normal values of HZ though, result will still be 'a rather large
> number,' so maybe it's not worth caring about that.

Thank you for your review.

I modified my patch.
