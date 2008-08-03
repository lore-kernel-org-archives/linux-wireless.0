Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:45183 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbYHCOM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 10:12:57 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1747137rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 07:12:57 -0700 (PDT)
Message-ID: <1ba2fa240808030712k7512b085qc439b41e857a5c5e@mail.gmail.com> (sfid-20080803_161301_341510_3F123B81)
Date: Sun, 3 Aug 2008 17:12:56 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080803134449.GF12118@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
	 <1217703723.8621.50.camel@johannes.berg>
	 <20080802192704.GB24253@khazad-dum.debian.net>
	 <200808031012.06554.IvDoorn@gmail.com>
	 <1ba2fa240808030107m64b1bc6dxc639665a2a7cc4af@mail.gmail.com>
	 <20080803134449.GF12118@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 3, 2008 at 4:44 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sun, 03 Aug 2008, Tomas Winkler wrote:
>> > I think that handler was added by Dmitry, but I see no real reason for
>> > issuing the BLOCK event during suspend. However the handlers should
>> > be used to prevent state changes to drivers after they have been suspended.
>>
>> Sounds reasonable.
>
> Added to TODO list to remove the toggle_radio() calls on the suspend path.

Great.

> Note that rfkill will still call the toggle_radio() callback on the resume
> path with whatever state the radio was before suspend, because we want the
> state set by the user to be preserved across sleeps of any sort, and that's
> not the wireless driver's business to ensure, but rather, rfkill's.

That's align with how I see it.
Thanks
Tomas
