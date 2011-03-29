Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57599 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab1C2Use convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 16:48:34 -0400
Received: by iwn34 with SMTP id 34so519396iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 13:48:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D923FC3.3010309@lockie.ca>
References: <4D91697C.2050603@lockie.ca> <AANLkTikUfjM1eDprL_YDFuasVvTdpRoAzKXStJf-5C7e@mail.gmail.com>
 <4D923FC3.3010309@lockie.ca>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 29 Mar 2011 13:48:13 -0700
Message-ID: <AANLkTimbxYgtSH9t75s9QCSb892QR1yBoOJUPToDCyCV@mail.gmail.com>
Subject: Re: regdomain
To: James <bjlockie@lockie.ca>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 29, 2011 at 1:23 PM, James <bjlockie@lockie.ca> wrote:
> On 03/29/11 14:06, Luis R. Rodriguez wrote:
>> country CA:
>>         (2402 - 2472 @ 40), (3, 27)
>>         (5170 - 5250 @ 40), (3, 17)
>>         (5250 - 5330 @ 40), (3, 20), DFS
>>         (5490 - 5710 @ 40), (3, 20), DFS
>>         (5735 - 5835 @ 40), (3, 30)

> It is using CO, not US.

Ah yes, sorry so you use this then:

country CO:
        (2402 - 2472 @ 40), (3, 27)
        (5170 - 5250 @ 20), (3, 17)
        (5250 - 5330 @ 20), (3, 23), DFS
        (5735 - 5835 @ 20), (3, 30)

So you loose out on 5490 - 5710 range given that the card has been
programmed for that regulatory domain. You cannot override this, this
built into the EEPROM and due to regulatory restrictions this cannot
be changed or left to the user to say where they are. On Linux we
however do enable the user to restrict the device further, but never
enable more than what the card was calibrated / designed for.

> I am trying to debug this card since it works on kernel-2.6.36.2 but not
> any later one.

Define "works" and "not works". You can bisect if you know two kernel
releases that you can use a bisection points, a good one and a bad
one. Please review how to do that.

  Luis
