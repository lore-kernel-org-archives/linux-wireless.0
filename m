Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:33605 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbcFPL6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 07:58:10 -0400
Received: by mail-vk0-f41.google.com with SMTP id d185so69865260vkg.0
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 04:58:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rya1HMEPBQYs_iJ51gAT+c2gO-jCMndhC2Wiwa9Jkv3Cg@mail.gmail.com>
References: <CADpKk60njba2Y7NNCwVSSBS+eeFP3zt7zLqA3pnjKuo=n5ozqA@mail.gmail.com>
 <CACna6rya1HMEPBQYs_iJ51gAT+c2gO-jCMndhC2Wiwa9Jkv3Cg@mail.gmail.com>
From: Majid Ashoori <majid.it@gmail.com>
Date: Thu, 16 Jun 2016 16:28:07 +0430
Message-ID: <CADpKk62fL3nAhP-g=MufS4615aW8nN3NUmgGPOFVQVDYhOgPiw@mail.gmail.com> (sfid-20160616_135814_966281_CAEC2B4F)
Subject: Re: Getting signal strength of a received packets
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi
thank you very much for quick reply, and parser. I can do by your
proposed way, but if I can use an API to get it directly from kernel
that would make our work more organized and faster.

On Thu, Jun 16, 2016 at 2:51 PM, Rafał Miłecki <zajec5@gmail.com> wrote:
> On 16 June 2016 at 12:10, Majid Ashoori <majid.it@gmail.com> wrote:
>> Hi everyone,
>> I am using OCB mode based on ath9k driver for my wireless connections
>> between different nodes. In this mode there is no BS or established
>> connection to analyze the signal strength of BS. Thus, I need to know
>> the signal strength of received packets in my user-space application
>> to do some calculation based on that.
>>
>> So, here is the question: how can I get signal strength of a received
>> packet in a user-space application? I reached to the point that it may
>> be performed via cfg80211 or nl80211 and I check them but I am not
>> sure how exactly I can get that.
>
> Create monitor interface, read packets from it, parse radiotap header
> manually or using this tiny parser:
> http://git.sipsolutions.net/?p=radiotap.git
>
> --
> Rafał
