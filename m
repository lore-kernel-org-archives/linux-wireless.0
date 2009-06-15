Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:52093 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbZFOTs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 15:48:28 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2669347ywb.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2009 12:48:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245092223.15367.9.camel@violet>
References: <1243546565-19404-1-git-send-email-lrodriguez@atheros.com>
	<1244992308.15367.3.camel@violet> <20090615181308.GC22922@tesla>
	<1245092223.15367.9.camel@violet>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 15 Jun 2009 12:48:09 -0700
Message-ID: <43e72e890906151248q197d7bd5xb2cddc24500b7fc7@mail.gmail.com>
Subject: Re: [PATCH 0/2] ar9170: 1-stage firmware support / AVM fritz
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"chunkeey@web.de" <chunkeey@web.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"jal2@gmx.de" <jal2@gmx.de>,
	Peter Grabienski <Peter.Grabienski@atheros.com>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	Michael Fortin <Michael.Fortin@atheros.com>,
	Johnny Cheng <Johnny.Cheng@atheros.com>,
	Yuan-Gu Wei <Yuan-Gu.Wei@atheros.com>,
	"otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>, dwmw2@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 15, 2009 at 11:57 AM, Marcel Holtmann<marcel@holtmann.org> wrote:
> Hi Luis,
>
>> > > This series now works for me on my WNDA31000, it took a newer shiny
>> > > 1-stage firmware to work. I'll push the firmware into linux-firmware
>> > > next.
>> > >
>> > > Should work with the AVM Fritz devices now, haven't tested it but
>> > > I think it should work.
>> >
>> > I happened to have one of these AVM devices. With ar9170.fw firmware it
>> > does work fine with the other ones it doesn't.
>>
>> Excellent, that was the idea behind the patch, to enable these
>> devices. Thanks for testing.
>>
>> > The ar9170.fw is still not in linux-firmware.git, any reason for that?
>>
>> Yes, the patch I sent to David has some funk as objcopy to ihex seems
>> to have some trailing white space. I sent a new patch to him without
>> the ihex file though.
>>
>> > Also since ar9170-1.fw and ar9170-2.fw are not working at all,
>>
>> They work, they won't work for the AVM device though.
>>
>> > we better
>> > not even try and give the user a crypted error message that the device
>> > is in a bad state. Just printk that the firmware might be too old.
>>
>> Agreed, but as I sent the patch in we *require* the 1-stage firmware
>> for the AVM devices, if that is not present we should be bailing out.
>> Is that not what happens?
>
> nope, it tries ar9170-1.fw and then tries to load that and fails with a
> timeout (-110) and a weird message that the device might be in a bad
> state.

Oh interesting, hm, ok doe sit go into a loop with that?

  Luis
