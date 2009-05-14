Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:64622 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZENAyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 20:54:07 -0400
Received: by wf-out-1314.google.com with SMTP id 26so623438wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 17:54:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242262041.3241.30.camel@maxim-laptop>
References: <43e72e890905131718k739eef2eu35f76d4bf5b03dae@mail.gmail.com>
	<69e28c910905131731t5f708339y3fc87b9035591115@mail.gmail.com>
	<1242262041.3241.30.camel@maxim-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 13 May 2009 17:53:46 -0700
Message-ID: <43e72e890905131753v540411b6n32c0dd68a24453f3@mail.gmail.com>
Subject: Re: [ath5k-devel] WoW for ath5k
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/13 Maxim Levitsky <maximlevitsky@gmail.com>:
> On Thu, 2009-05-14 at 02:31 +0200, G=C3=A1bor Stefanik wrote:
>> On Thu, May 14, 2009 at 2:18 AM, Luis R. Rodriguez <mcgrof@gmail.com=
> wrote:
>> > BTW legacy-hal has this stuff :) Just grep for ATH_WOW
>> >
>> > =C2=A0Luis
>>
>> Wow! :-)
>>
>
> Isn't Wow support platform dependent (BIOS...)

Yes -- and device specific: not all vendors add the link to enable this=
=2E

> I think that only S3, and only if bios doesn't turn (put in D3cold) t=
he
> wireless device, it could work.

In addition to that you also need a link from the wireless device to
the motherboard to turn it on. Not sure of the details here, still
gathering that but a good public read is on wikipedia:

http://en.wikipedia.org/wiki/Wake-on-LAN

> Btw, as I understand, WoW implies that somebody sends a packet with s=
ome
> predefined pattern, and that wakes the system, right?

=46or wireless and at least for Atheros we borrow WOL's magic packet,
Link change, beacon miss and user pattern -- which could be something
like an ARP request so that if someone pings it it'll come up for
example.

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
