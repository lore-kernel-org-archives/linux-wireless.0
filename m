Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:40898 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab0CXU1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 16:27:11 -0400
Received: by fxm23 with SMTP id 23so482448fxm.21
        for <linux-wireless@vger.kernel.org>; Wed, 24 Mar 2010 13:27:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1269459825.2631.115.camel@mj>
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com>
	<201003230942.15718.br1@einfach.org> <loom.20100323T162144-640@post.gmane.org>
	<201003242015.21409.br1@einfach.org> <1269459825.2631.115.camel@mj>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 24 Mar 2010 21:26:50 +0100
Message-ID: <69e28c911003241326l6e747113t606f50f61eb435b4@mail.gmail.com>
Subject: Re: [Proposal]TX flags
To: Pavel Roskin <proski@gnu.org>
Cc: Bruno Randolf <br1@einfach.org>, Michael Stahn <m1kes@web.de>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 24, 2010 at 8:43 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Wed, 2010-03-24 at 20:15 +0900, Bruno Randolf wrote:
>> On Wednesday 24 March 2010 00:50:31 Michael Stahn wrote:
>> > > similar to this we would also need to be able to specify that the beacon
>> > > TSF should not be overwritten. maybe a general flag like "do not change"
>> > > would do?
>> >
>> > Is TSF really overwritten at manual injection from userspace?
>>
>> Yes, it is, at least on ath5k. And as jouni has pointed out recently this
>> behaviour is expected by hostapd (maybe not for beacons but for probe
>> request/response frames, i dont know).
>>
>> Gabor Stefanik proposed a while ago that frames should only be modified by the
>> driver in cooked monitor mode (COOK_FRAMES), that way we could avoid defining
>> new radiotap flags. What's your view on that, Jouni?
>
> Maybe we could create a socket option that would put a _socket_ into a
> cooked monitor mode?  A "monitor mode socket" would accept and transmit
> packets with radiotap and 802.11 headers and receive the packets that
> the interface already receives, also with radiotap and 802.11 headers.
> That interface could be optimized for use with hostapd and other similar
> programs.  The driver could fill some data from the interface settings.
>
> The monitor mode, on the other hand, could be optimized for the
> "hardcore" stuff when the driver interferes as little as possible.  Then
> no special flags would be needed to pass the frame as is.
>
> --
> Regards,
> Pavel Roskin
>

I don't think that is needed, as we already support multiple monitor
interfaces (including a situation where some are cooked, others are
raw).

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
