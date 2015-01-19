Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:62174 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbASAYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 19:24:42 -0500
Received: by mail-qa0-f42.google.com with SMTP id dc16so21959753qab.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2015 16:24:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <878uh06ulp.fsf@kamboji.qca.qualcomm.com>
References: <20150118050741.31866.36490.stgit@114-36-241-182.dynamic.hinet.net>
	<20150118051043.31866.53087.stgit@114-36-241-182.dynamic.hinet.net>
	<878uh06ulp.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 19 Jan 2015 08:24:41 +0800
Message-ID: <CAAfg0W4cns51+B_imf1jGWOmA0S8jqNFR+6epRxv8qqTgvBAgg@mail.gmail.com> (sfid-20150119_012451_713381_43330150)
Subject: Re: [PATCH 1/7] net: wireless: wcn36xx: add wcn3620 chip type definition
From: Andy Green <andy.green@linaro.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 January 2015 at 22:17, Kalle Valo <kvalo@codeaurora.org> wrote:
> Andy Green <andy.green@linaro.org> writes:
>
>> Convert the list of chip types to an enum, add the default
>> UNKNOWN type and a type for WCN3620 chip
>>
>> Signed-off-by: Andy Green <andy.green@linaro.org>
>
> Please just use "wcn36xx: ", you should drop "net: wireless: " entirely.

OK.

Can you help me understand what you'd like to see happen with the chip
variant detection stuff?

There's a comment sent to one list only saying it might be preferable
to keep the old detection code as the default.  But there are no
in-tree users of wcn36xx (mainly due to PIL not being in mainline, I
guess).

The old test's equivalence that AC == 3680 seems kind of weak to me
and establishing the type must be passed in from platform code
reflects the situation that there's no public way to detect the chip
type from Qualcomm.  In the second not-for-upstream series I use that
to pass it in from DT, which is how it'd be normally used.

-Andy

> --
> Kalle Valo
