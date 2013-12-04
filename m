Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34695 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab3LDTPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 14:15:54 -0500
Received: by mail-wi0-f182.google.com with SMTP id en1so8706636wid.3
        for <linux-wireless@vger.kernel.org>; Wed, 04 Dec 2013 11:15:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386092034-13442-3-git-send-email-mcgrof@do-not-panic.com>
References: <1386092034-13442-1-git-send-email-mcgrof@do-not-panic.com> <1386092034-13442-3-git-send-email-mcgrof@do-not-panic.com>
From: Mihir Shete <mihirsht@gmail.com>
Date: Thu, 5 Dec 2013 00:45:33 +0530
Message-ID: <CAOHe==HZrDHCA+L5-2+y-p68mRzpD1Vwye+1N48zhxoQEhU57A@mail.gmail.com> (sfid-20131204_201609_047038_A48D293B)
Subject: Re: [RFT 2/2] cfg80211: make regulatory_hint() remove REGULATORY_CUSTOM_REG
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: c_manoha@qca.qualcomm.com, linville@tuxdriver.com,
	johannes@sipsolutions.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> @@ -1826,6 +1826,8 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
>         if (WARN_ON(!alpha2 || !wiphy))
>                 return -EINVAL;
>
> +       wiphy->regulatory_flags &= ~REGULATORY_STRICT_REG;
> +
Clear REGULATORY_CUSTOM_REG



-- 
~Mihir~
