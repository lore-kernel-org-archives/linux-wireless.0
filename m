Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:27176 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYHCIHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 04:07:11 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1680991rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 01:07:10 -0700 (PDT)
Message-ID: <1ba2fa240808030107m64b1bc6dxc639665a2a7cc4af@mail.gmail.com> (sfid-20080803_100718_815228_108D233B)
Date: Sun, 3 Aug 2008 11:07:10 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Cc: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200808031012.06554.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
	 <1217703723.8621.50.camel@johannes.berg>
	 <20080802192704.GB24253@khazad-dum.debian.net>
	 <200808031012.06554.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 3, 2008 at 11:12 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Saturday 02 August 2008, Henrique de Moraes Holschuh wrote:
>> Hi Johannes!
>>
>> On Sat, 02 Aug 2008, Johannes Berg wrote:
>>
>> > On Sat, 2008-08-02 at 15:11 -0300, Henrique de Moraes Holschuh wrote:
>> > > Currently, rfkill would stand in the way of properly supporting wireless
>> > > devices that are capable of waking the system up from sleep or hibernation
>> > > when they receive a special wireless message.
>> > >
>> > > Since rfkill attempts to soft-block any transmitters during class suspend,
>> >
>> > why does it interfere with suspend anyway?
>>
>> The class makes sure that all transmitters are blocked on suspend.  You'd
>> have to ask Ivo for the reason, but AFAIK, it is for both safety and to help
>> conserve power.
>
> I think that handler was added by Dmitry, but I see no real reason for
> issuing the BLOCK event during suspend. However the handlers should
> be used to prevent state changes to drivers after they have been suspended.

Sounds reasonable.
Thanks
Tomas
