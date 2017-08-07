Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36168 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdHGMnK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 08:43:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH v2 09/12] qtnfmac: implement scan timeout
References: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
        <20170727230654.30850-10-sergey.matyukevich.os@quantenna.com>
        <87r2wtugco.fsf@purkki.adurom.net>
        <20170804205356.4qyfj4wnlnrnvx5d@bars>
Date: Mon, 07 Aug 2017 15:43:06 +0300
In-Reply-To: <20170804205356.4qyfj4wnlnrnvx5d@bars> (Sergey Matyukevich's
        message of "Fri, 4 Aug 2017 23:53:57 +0300")
Message-ID: <87o9rrlfad.fsf@kamboji.qca.qualcomm.com> (sfid-20170807_144313_821010_2A96425B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

>> > +     if (timer_pending(&mac->scan_timeout))
>> > +             del_timer_sync(&mac->scan_timeout);
>> 
>> What if the device is removed while the timer is pending, is that
>> handled?
>
> Good point. I took another look at this kind of corner cases. Timer is not disabled
> explicitely. But ongoing scan request is explicitely aborted in relevant
> cfg80211 ops, e.g. on virtual interface change or removal. Though it looks like
> some of AP usecases are not handled: e.g. when AP is stopped while scan is
> in progress. I will queue the fix into the next cleanup/bugfix patch series
> if it is needed to abort scan in such a case.

Good, thanks for checking.

-- 
Kalle Valo
