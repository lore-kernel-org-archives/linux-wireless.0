Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59611 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbbBIGYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 01:24:31 -0500
Received: by mail-wi0-f181.google.com with SMTP id fb4so14662866wid.2
        for <linux-wireless@vger.kernel.org>; Sun, 08 Feb 2015 22:24:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54D4E89A.7040602@candelatech.com>
References: <1423224354-24955-1-git-send-email-michal.kazior@tieto.com>
	<54D4E89A.7040602@candelatech.com>
Date: Mon, 9 Feb 2015 07:24:30 +0100
Message-ID: <CA+BoTQ=HqyGKOBdOmpWOn_VjH1UTWF9nN_PE0uanaGsdeJmB6Q@mail.gmail.com> (sfid-20150209_072435_109204_FA12D939)
Subject: Re: [RFT] ath10k: restart fw on tx-credit timeout
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matti Laakso <malaakso@elisanet.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 February 2015 at 17:15, Ben Greear <greearb@candelatech.com> wrote:
> On 02/06/2015 04:05 AM, Michal Kazior wrote:
>>
>> It makes little sense to continue and let
>> firmware-host state become inconsistent if a WMI
>> command can't be submitted to firmware.
>>
>> This effectively prevents after-affects of
>> tx-credit starvation bug which include spurious
>> sta kickout events and inability to associate new
>> stations after some time when acting as AP.
>>
>> This should also speed up recovery/teardown in
>> some cases when firmware stops responding for some
>> reason.
>
>
> I have not seen a WMI timeout since I added keep-alive
> and CE polling in my firmware, but the patch looks OK
> to me.

This is mainly aimed at the tx-credit starvation due to mgmt-tx being
stuck on client powersave buffering.


> You might add something about 'WMI' in that warning
> message to make it more clear what is not being
> responsive.

Good point.


> At least in my tests, I could continue
> to receive network traffic while WMI was blocked.

Yeah. Traffic works with the tx-credit starvation as well but what
good is this if you have inconsistent driver-firmware state after
failing to send a few commands?


Michał
