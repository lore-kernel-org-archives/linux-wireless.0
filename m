Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59667 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab0C2TXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 15:23:20 -0400
Received: by pwi5 with SMTP id 5so6925629pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 12:23:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m3eij3ym5k.fsf@intrepid.localdomain>
References: <m3tys0tbhk.fsf@intrepid.localdomain> <43e72e891003281645m1da47a1en882df4432733977d@mail.gmail.com>
	<m3eij3ym5k.fsf@intrepid.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 29 Mar 2010 12:22:59 -0700
Message-ID: <43e72e891003291222n5e72a0a5m31dddf2bbf6e06ab@mail.gmail.com>
Subject: Re: CRDA and ath5k with no country code in EEPROM
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 29, 2010 at 12:15 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com> writes:
>
>> I've documented this specific case here:
>>
>> http://wireless.kernel.org/en/users/Drivers/ath/#The_0x0_regulatory_domain
>
> Thanks.
>
> I'm not sure how the modified regulatory.bin could work, though:
> I really don't want to use restricted frequencies etc. when the
> regulatory domain is set to US (i.e. when operating in USA), I only want
> to use the extra channels etc. when in e.g. Europe.

I agree with that wishful thinking, however current legislation does
now allow for dynamic enabling of frequencies on devices certified
under part 15 rules. We can likely work towards changing the
legislation for this but that's something I haven't seen many
companies willing to lobby for. We'd need a big company to help with
this lobby.

> IOW I should be able
> to iw reg set US and get the US freqs only.
>
> A driver modification to ignore the default restrictions (while obeying
> the regulatory.bin, on a 0-country cards only, of course) - that would
> work.

And it would also make our drivers break regulatory rules. We're not
going to do that on Linux because proving that we can be responsible
is in fact what does allow us to get proper vendor support for 802.11
drivers.

See:

http://wireless.kernel.org/en/developers/Regulatory/statement

  Luis
