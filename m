Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34989 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0LAPVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 10:21:49 -0500
Received: by wwa36 with SMTP id 36so7505119wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 07:21:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012011614.07163.helmut.schaa@googlemail.com>
References: <1291202302-9698-1-git-send-email-helmut.schaa@googlemail.com>
	<AANLkTi=_61HVmSBR-9v3ukVw-mpouoaFwYE8cpfa96wH@mail.gmail.com>
	<201012011540.45031.helmut.schaa@googlemail.com>
	<201012011614.07163.helmut.schaa@googlemail.com>
Date: Wed, 1 Dec 2010 20:51:46 +0530
Message-ID: <AANLkTimEimLN_3_sKaAm8W3aop2+yh+gGugJRfrjquB6@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Update last_tx_rate only for data frames
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 1, 2010 at 8:44 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Mittwoch 01 Dezember 2010 schrieb Helmut Schaa:
>> Am Mittwoch 01 Dezember 2010 schrieb Mohammed Shafi:
>> > On Wed, Dec 1, 2010 at 4:48 PM, Helmut Schaa
>> > <helmut.schaa@googlemail.com> wrote:
>> > > The last_tx_rate field was also updated for non-data frames that are
>> > > often sent with a lower rate (for example management frames at 1 Mbps).
>> > > This is confusing when the data rate is actually much higher.
>> > >
>> > > Hence, only update the last_tx_rate field with tx rate information
>> > > gathered from the last data frames.
>> >
>> > Hi Helmut,
>> >             I have a doubt,ideally should not this be taken care by the driver ?
>>
>> Sorry, I don't get your point. How should that be handled by the driver? Could
>> you please elaborate?
>
> Ahh, did you mean that should be taken care of by the rate control algorithm?
>
I think so but not sure..(for ex: if ministrel is used)

> I agree, if the rate control algortihm returns a rate via txrc.reported_rate
> we should just use that without further validation.
>
> Nevertheless, if the rate control algortihm doesn't fill in txrc.reported_rate
> we should only account data frames.

I agree.

>
> Will send an updated patch.
>
> Helmut
>
