Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:58889 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaEZKjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 06:39:40 -0400
Received: by mail-wi0-f181.google.com with SMTP id n15so4142599wiw.8
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 03:39:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401098065.30496.0.camel@jlt4.sipsolutions.net>
References: <1401089962-10720-1-git-send-email-chaitanya.mgit@gmail.com>
 <1401097086.29704.0.camel@jlt4.sipsolutions.net> <CABPxzYKe5Cy36uc=C5wVEVZV0qiR=55yBw0LtzuRv412p58c9g@mail.gmail.com>
 <1401098065.30496.0.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 26 May 2014 16:09:17 +0530
Message-ID: <CABPxzYLC9fg-P5vP6TRH7CHvfd1Rncgoro3+7b17Bh6agEX=vw@mail.gmail.com> (sfid-20140526_123944_194473_3673EAC5)
Subject: Re: [regdb] Add support to parse 2000mW tx power
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Luis Rodriguez <mcgrof@gmail.com>,
	wireless-regdb@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2014 at 3:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2014-05-26 at 15:16 +0530, Krishna Chaitanya wrote:
>> On Mon, May 26, 2014 at 3:08 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Mon, 2014-05-26 at 13:09 +0530, chaitanya.mgit@gmail.com wrote:
>> >
>> >> @@ -74,7 +74,7 @@ function parse_reg_rule()
>> >>                       power = 23
>> >>               } else if (power == 500) {
>> >>                       power = 27
>> >> -             } else if (power == 1000) {
>> >> +             } else if ((power == 1000) || (power == 2000)) {
>> >>                       power = 30
>> >
>> > This seems like a pretty sick thing to do to start with, and certainly
>>
>> Agree.
>>
>> > power=30 isn't right for 2000mW...
>>
>> Sorry, typo. Its supposed to be 33.
>>
>> > Can't awk calculate the logarithm?
>> Does kernel support log arithmetic/Float operations.?
>
> This script runs at build time.
Ok, understood. I will send in V2 with the algo after some testing.
