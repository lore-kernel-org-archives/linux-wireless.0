Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48802 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdGYL4P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 07:56:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 8/8] qtnfmac: implement scan timeout
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
        <20170620195517.18373-9-sergey.matyukevich.os@quantenna.com>
        <87o9t949yu.fsf@purkki.adurom.net>
        <20170629164903.adst7rihexlrb643@bars>
Date: Tue, 25 Jul 2017 14:56:11 +0300
In-Reply-To: <20170629164903.adst7rihexlrb643@bars> (Sergey Matyukevich's
        message of "Thu, 29 Jun 2017 19:49:04 +0300")
Message-ID: <87k22wk9wk.fsf@codeaurora.org> (sfid-20170725_135619_642490_804F2806)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> On Tue, Jun 27, 2017 at 08:27:37PM +0300, Kalle Valo wrote:
>> 
>> External Email
>> 
>> 
>> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
>> 
>> > Userspace tools may hang on scan in the case when scan completion event
>> > is not returned by firmware. This patch implements the scan timeout
>> > to avoid such situation.
>> >
>> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
>> 
>> [...]
>> 
>> > +static __always_inline void qtnf_wmac_lock(struct qtnf_wmac *mac)
>> > +{
>> > +     mutex_lock(&mac->mac_lock);
>> > +}
>> > +
>> > +static __always_inline void qtnf_wmac_unlock(struct qtnf_wmac *mac)
>> > +{
>> > +     mutex_unlock(&mac->mac_lock);
>> > +}
>> 
>> Why? These look pointless to me.
>
> Could you please clarify a bit. You mean, locking/unlocking directly instead of
> using inline wrappers ?

Yeah, these kind of simple locking wrappers should not be used. They
only add confusion.

-- 
Kalle Valo
