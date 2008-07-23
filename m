Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:51384 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYGWQn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 12:43:26 -0400
Received: by an-out-0708.google.com with SMTP id d40so532509and.103
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 09:43:25 -0700 (PDT)
Message-ID: <43e72e890807230943u1d39d70eo1b95ee4a38b9bcd8@mail.gmail.com> (sfid-20080723_184330_747652_8E9C86B5)
Date: Wed, 23 Jul 2008 09:43:24 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: ath9k: some more yummy patches
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20080723162956.GA8742@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890807230913v10198fbcqeecfe770490aef65@mail.gmail.com>
	 <20080723162956.GA8742@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 9:29 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jul 23, 2008 at 09:13:37AM -0700, Luis R. Rodriguez wrote:
>> Some more yummmy patches, specially if you are interested in IBSS.
>> These are committed into ath9k git as well.
>>
>> http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2008-07-23/
>
> Btw I had a quick look over the driver, and it's quite huge..

Tell me about it.

> Why does
> the driver have it's own regdomain support?

It still needs a good scrubbing, just as well as the driver in general
in many areas, but basically what will be kept in terms of regulatory
is our own internal eeprom regulatory domain to support channel
mapping. This is because we have no firmware to do magic vodoo there
like others do. This is how we can support Linux. Also although CRDA
(not yet merged even) can provide a thorough and updated database
sometimes vendors want to support regulatory settings for clients
based on SKUs. The callback for setting a regulatory domain through
CRDA will allow us to review the central regulatory information and
override it if necessary, this is useful for cases where customers we
have may want to support channels 1-11 and if the regulatory domain
allows then channel 14 we'll keep the device stuck to 1-11 as that is
what the customer certified their devices for in terms of support or
testing. This exactly why a callback is part of the design for CRDA --
the central db provides the complete regulatory solution for drivers
with none but yet it allows vendors to enhance regulatory to meet
business and legal requirements.

> Also there seems to be
> quite some useless hal style abstractions and types.  Do you plan to
> kill those?

Absolutely.

> And a lot of macros that want replacing by proper C code.

Sure thing. We figure we get users supported first with a decent first
patch post so we're following the 'release early, review early'
technique. Further cleanup and enhancements can come through as we
move along.

  Luis
