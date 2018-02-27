Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36256 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753600AbeB0Oce (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 09:32:34 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH v2 4/4] qtnfmac: enable networked standby mode on device inactivity
References: <20180210140420.17013-1-sergey.matyukevich.os@quantenna.com>
        <20180210140420.17013-5-sergey.matyukevich.os@quantenna.com>
Date: Tue, 27 Feb 2018 16:32:30 +0200
In-Reply-To: <20180210140420.17013-5-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Sat, 10 Feb 2018 17:04:20 +0300")
Message-ID: <87inaifqpt.fsf@purkki.adurom.net> (sfid-20180227_153245_065248_B6E90C28)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> From: Sergei Maksimenko <smaksimenko@quantenna.com>
>
> Enable support of networked standby mode (NSM) on qsr10g devices.
> Networked standby is a power saving mode when the device keeps
> all existing network connections and returns to full power mode
> on a network activity. When enabled, device enters standby mode
> after 15 min of inactivity (no associated stations or no trattic).
> This period can be changed by setting sysfs attribute standby_timeout
> (0 disables NSM support). A module parameter auto_standby
> (defaults to 1) controls enabling NSM support on module loading.
>
> Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>

Adding a new sysfs file for a wireless driver is usually a bad idea, I
don't even remember when we had a case where it was ok to do that. In
principle we want everything to go through cfg80211 using nl80211.

Also I'm not really fond of the module parameter just to disable a
feature. And there isn't even any justification why it's needed.

-- 
Kalle Valo
