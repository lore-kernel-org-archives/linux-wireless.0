Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:37650 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753178AbeDRPCw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 11:02:52 -0400
Received: by mail-wr0-f169.google.com with SMTP id f14-v6so5744735wre.4
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2018 08:02:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87o9ig1s3o.fsf@toke.dk>
References: <660b1538-0ccb-8f1a-ebe0-632b0e14a46b@web.de> <87o9ig1s3o.fsf@toke.dk>
From: Steve deRosier <derosier@gmail.com>
Date: Wed, 18 Apr 2018 08:02:10 -0700
Message-ID: <CALLGbRJ5RL1POFDcJp9A-1Vb4cq1yHxOCZ-vTwRgq9UWsSSZuw@mail.gmail.com> (sfid-20180418_170314_076002_EDFC3901)
Subject: Re: ath confusing log message "country IE"
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Bernhard Gabler <Bernhard_Gabler@web.de>,
        Linux-Wireless mailing list <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 18, 2018 at 7:55 AM, Toke H=C3=B8iland-J=C3=B8rgensen <toke@tok=
e.dk> wrote:
> Bernhard Gabler <Bernhard_Gabler@web.de> writes:
>
>> Dear all,
>>
>> would it be possible to re-write the log message from
>>     "regdomain ... dynamically updated by country IE"
>> in a less ambiguous way, e.g. to:
>>     "regdomain ... dynamically updated by country-IE"
>>     "regdomain ... dynamically updated by country information element"
>> , please?
>>
>> To the occasional reader, the following system log messages seem to
>> convey that
>>   -  "DE" (Germany) was intended to be used, but
>>   -  "IE" (Ireland) was configured as regdomain.
>>
>>      [ 2723.739071] ath: EEPROM regdomain: 0x8114
>>      [ 2723.739072] ath: EEPROM indicates we should expect a country cod=
e
>>      [ 2723.739073] ath: doing EEPROM country->regdmn map search
>>      [ 2723.739074] ath: country maps to regdmn code: 0x37
>>      [ 2723.739075] ath: Country alpha2 being used: DE
>>      [ 2723.739076] ath: Regpair used: 0x37
>>      [ 2723.739077] ath: regdomain 0x8114 dynamically updated by country=
 IE
>>
>> Only after intense googling, I now know that IE stands for "information
>> element", not for Ireland. But this is not obvious at. To prevent others
>> from confusion and wasting time on a non-problem, could please someone
>> rewrite the log message?
>
> Heh, that is a good point, I think. The patch below should fix it; but I
> worry that the log lines become quite long, then? Maybe better to use
> "country-IE", but that could also be confused. "country inf.elem"
> perhaps?
>

Instead of just rewording the message, perhaps adjusting it to show
more information would make it more clear:

    `regdomain 0x8114 dynamically updated by country I.E. to DE`

Assuming the message two lines higher is related, I know the
information is already there, but this way the line stands on its own,
is more information rich, and is also clear.

- Steve
