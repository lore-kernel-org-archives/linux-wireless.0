Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:61505 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZHaVpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 17:45:22 -0400
Received: by iwn42 with SMTP id 42so1980656iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 14:45:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251751251.1266.16.camel@localhost.localdomain>
References: <3ace41890908261511i3056c049kca82831015ff2aa0@mail.gmail.com>
	<43e72e890908261645n24a040cds84f012095a40c15b@mail.gmail.com>
	<1251357267.20531.4.camel@johannes.local> <3ace41890908270243i7c1d8ddav322a35c566d2c010@mail.gmail.com>
	<3ace41890908311143q697898a3mcbc681d3941b45c9@mail.gmail.com>
	<43e72e890908311154x51fd9481iea5e10fc5515af80@mail.gmail.com>
	<3ace41890908311215u378951e8j3283037ec6794764@mail.gmail.com>
	<43e72e890908311225r3b0d80bcqcb3e3e11d81a255e@mail.gmail.com>
	<1251749600.5165.1.camel@localhost.localdomain> <1251751251.1266.16.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 31 Aug 2009 14:45:04 -0700
Message-ID: <43e72e890908311445q60c703a3ha8ef8e599e3e712@mail.gmail.com>
Subject: Re: hal, rfkill and compat-wireless (Re: [RFC/RFT] rtl8187: Implement
	rfkill support)
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 31, 2009 at 1:40 PM, Marcel Holtmann<marcel@holtmann.org> wrote:
> Hi Luis,
>
>> > OK not so bad except for:
>> >
>> > > kernel/net/wimax/wimax.ko
>> >
>> > That's touching another subsystem but we could technically merge wimax
>> > into compat-wireless if Inaky thinks that's a good idea. the point
>> > here is to unify anything that uses rfkill for backport usage.
>>
>> Oh boy, can of worms
>>
>> I have my own compat-wimax already, which already handles things for
>> backwards compat (many #ifdef hacks to simplify life) and which is
>> heavily used internally.
>>
>> I don't really know how much worth it might be and I know I don't have
>> resources to support both.
>
> for the wireless-compat tree, I would just remove the RFKILL support for
> WiMAX. It is really not worth to support it.

Works for me, we then still need to address (if we really care) the
platform stuff. If someone is interested feel free to send patches to
add those, I figure as long we get down to the latest supported stable
kernel it should be good. The latest supported stable kernel is always
on display on kernel,org, today being 2.6.27.

  Luis
