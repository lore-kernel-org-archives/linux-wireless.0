Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:26732 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYJIQd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 12:33:29 -0400
Received: by fg-out-1718.google.com with SMTP id 19so66775fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2008 09:33:27 -0700 (PDT)
Message-ID: <1ba2fa240810090933x2e473416i2d5c9120128c8ead@mail.gmail.com> (sfid-20081009_183332_930059_B51C68E1)
Date: Thu, 9 Oct 2008 18:33:27 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: HT capabilities IE
Cc: "Nils Bagge" <nbagge@bandspeed.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223546085.22490.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223460098.3618.53.camel@johannes.berg>
	 <6EACAD9615B47B42A780C005414307E1014956B2@mars.bandspeed.com>
	 <1223546085.22490.29.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 9, 2008 at 11:54 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-10-08 at 10:33 -0500, Nils Bagge wrote:
>> My humble opinion is yes, the HT capabilities field should be constant,
>> from the perspective of a typical AP.
>
> Yeah I totally agree.
>
>> Practically speaking, I doubt that an AP would want to toggle SM power
>> save at all, let alone on a per-beacon basis, as historically power
>> consumption is not as critical at the AP vs. at the client.
>
> True.
>
>> But, if you want to be 'green'... (I can see how this would benefit a
>> 'low power AP') The only problem I see is with the AP entering 'static
>> SM power save'. You might run into interoperability trouble with varying
>> behavior of client STA's, due to different interpretations of the
>> standard or assumptions. It wouldn't surprise me if some clients ignore
>> changes to the HT capabilities IE once associated, or if some ignore the
>> SM power save field in beacons entirely. Hence, they could transmit a
>> 2-stream MCS which would not be decodable with a single RX chain.
>>
>> Theoretically, the only SM power save mode I'd recommend for an AP is
>> dynamic SM power save.

I would say that recommended mode is SM disabled, Dynamic only in case
u want to be green.

> Right, but if you enter dynamic SM PS then it doesn't matter much
> anyway, does it? I mean, there's no protection requirement in that case,
> is there? Or am I reading it wrong? I _think_ I will handle the SM PS
> change in mac80211, but I'm not entirely sure right now.

If AP announce dynamic it requires STA to precede SM packet with
legacy one preferable RTS.
See the iwlagn implementation

Tomas
