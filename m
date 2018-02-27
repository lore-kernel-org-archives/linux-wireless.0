Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbeB0QMx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:12:53 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH v2 4/4] qtnfmac: enable networked standby mode on device inactivity
References: <20180210140420.17013-1-sergey.matyukevich.os@quantenna.com>
        <20180210140420.17013-5-sergey.matyukevich.os@quantenna.com>
        <87inaifqpt.fsf@purkki.adurom.net>
        <20180227151339.xlvxqb7d36s4og6k@bars>
Date: Tue, 27 Feb 2018 18:12:48 +0200
In-Reply-To: <20180227151339.xlvxqb7d36s4og6k@bars> (Sergey Matyukevich's
        message of "Tue, 27 Feb 2018 18:13:39 +0300")
Message-ID: <87k1uys96n.fsf@kamboji.qca.qualcomm.com> (sfid-20180227_171256_231281_C1080EFD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

>> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
>> 
>> > From: Sergei Maksimenko <smaksimenko@quantenna.com>
>> >
>> > Enable support of networked standby mode (NSM) on qsr10g devices.
>> > Networked standby is a power saving mode when the device keeps
>> > all existing network connections and returns to full power mode
>> > on a network activity. When enabled, device enters standby mode
>> > after 15 min of inactivity (no associated stations or no trattic).
>> > This period can be changed by setting sysfs attribute standby_timeout
>> > (0 disables NSM support). A module parameter auto_standby
>> > (defaults to 1) controls enabling NSM support on module loading.
>> >
>> > Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
>> 
>> Adding a new sysfs file for a wireless driver is usually a bad idea, I
>> don't even remember when we had a case where it was ok to do that. In
>> principle we want everything to go through cfg80211 using nl80211.
>> 
>> Also I'm not really fond of the module parameter just to disable a
>> feature. And there isn't even any justification why it's needed.
>
> Ok, noted. Then we will take a break and look for better ways to integrate
> this feature. Meanwhile, if you have no concerns regarding the first three
> patches in the series, is it possible to apply them ? Or I better send v3 ?

Yeah, patches 1-3 are on my queue and I should apply them soon.

-- 
Kalle Valo
