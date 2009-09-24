Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:40784 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZIXNgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 09:36:08 -0400
Received: by bwz6 with SMTP id 6so1292608bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 06:36:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253775657.3868.8.camel@johannes.local>
References: <1253775657.3868.8.camel@johannes.local>
Date: Thu, 24 Sep 2009 06:36:10 -0700
Message-ID: <da94abde0909240636s45694cc6nda7118108d72c5da@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: don't set privacy w/o key
From: Kalle Valo <kalle.valo@iki.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 12:00 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> When wpa_supplicant is used to connect to open networks,
> it causes the wdev->wext.keys to point to key memory, but
> that key memory is all empty. Only use privacy when there
> is a default key to be used.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Thanks, this fixes the issue I reported yesterday evening.

Tested-by: Kalle Valo <kalle.valo@iki.fi>

> Never happened of course with iw ...

This is just the reason why I still use stock wpa_supplicant from debian :)

Kalle
