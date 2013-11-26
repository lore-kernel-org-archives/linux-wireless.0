Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:37711 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3KZUT7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 15:19:59 -0500
Received: by mail-ie0-f169.google.com with SMTP id e14so10503011iej.28
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 12:19:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201311261550.14953.sw@simonwunderlich.de>
References: <1385409372-4229-1-git-send-email-janusz.dziedzic@tieto.com>
	<1385409372-4229-4-git-send-email-janusz.dziedzic@tieto.com>
	<201311261550.14953.sw@simonwunderlich.de>
Date: Tue, 26 Nov 2013 21:19:58 +0100
Message-ID: <CAFED-jmmkA2j4YRhFj7MXgZBgLJrofn1RGnbORtGDzB8wOErfw@mail.gmail.com> (sfid-20131126_212002_708510_91AA0510)
Subject: Re: [PATCH v3 4/4] cfg80211: DFS use 10 minutes CAC when weather channels
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/11/26 Simon Wunderlich <sw@simonwunderlich.de>:
>
>> When nominal bandwidth falls completely or partly
>> within the band 5600MHz to 5650MHz the CAC time shall
>> be 10 minutes.
>> This is ETSI requirement. FCC forbids weather channels usage.
>
> Although it is correct to handle that with longer times and all, I don't think
> we should enable weather channels at all, not even for ETSI. Unlike "normal"
> channels, it requires 99.99% detection rate in CAC, which is (I think)
> practically impossible.
>
> I guess we need ath9k (or other drivers, maybe ath10k too) to disallow CAC on
> these channels, if we know that the drivers can do it? Although I don't think
> it's technically possible ...
>
ath.ko already disable weather channels by default.
But in case driver will pass DFS certification (meet all requirements)
- why not use weather channels?

BR
Janusz
