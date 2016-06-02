Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33933 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbcFBHNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 03:13:25 -0400
Received: by mail-oi0-f54.google.com with SMTP id e72so64306959oib.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2016 00:13:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF7Mx6qsf3WRj8e2yR1e44Hz5fyth832VcaLJQ0tqp199cWQYg@mail.gmail.com>
References: <1464815616-21551-1-git-send-email-arend@broadcom.com>
	<CACna6ryjUjwBerzq3L8Fd2HHw-GAkLsnuh=POOW9EDxCymtYyg@mail.gmail.com>
	<CAF7Mx6qsf3WRj8e2yR1e44Hz5fyth832VcaLJQ0tqp199cWQYg@mail.gmail.com>
Date: Thu, 2 Jun 2016 09:13:24 +0200
Message-ID: <CACna6rzPFO3qa2Fqz+Jf2NxX3UvVweasNPvSK+fSLQ6mAeUSfA@mail.gmail.com> (sfid-20160602_091328_980480_7F2CF702)
Subject: Re: [PATCH for-4.7] brcmfmac: add eth_type_trans back for PCIe full dongle
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Arend van Spriel <arend@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 June 2016 at 07:20, Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> Op 2 jun. 2016 06:55 schreef "Rafał Miłecki" <zajec5@gmail.com>:
>>
>> On 1 June 2016 at 23:13, Arend van Spriel <arend@broadcom.com> wrote:
>> > From: Franky Lin <franky.lin@broadcom.com>
>> >
>> > A regression was introduced in commit 9c349892ccc9 ("brcmfmac: revise
>> > handling events in receive path") which moves eth_type_trans() call
>> > to brcmf_rx_frame(). Msgbuf layer doesn't use brcmf_rx_frame() but
>> > invokes
>> > brcmf_netif_rx() directly. In such case the Ethernet header was not
>> > stripped out resulting in null pointer dereference in the networking
>> > stack.
>> >
>> > (...)
>> >
>> > Reported-by: Grey Christoforo <grey@christoforo.net>
>>
>> Well, I reported this as well, over a month ago :(
>
> Hi Rafał,
>
> Dived into my emails and shameful to admit you are right. Totally missed it.
> Sorry for unintended disregard.

It happens, thanks for the fix! :)

-- 
Rafał
