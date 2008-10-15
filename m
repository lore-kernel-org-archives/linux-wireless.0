Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:1210 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYJOXbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 19:31:22 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2883105fkq.5
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 16:31:20 -0700 (PDT)
Message-ID: <1ba2fa240810151631t37edc367hfe59c76926c7b82e@mail.gmail.com> (sfid-20081016_013133_479263_B8382951)
Date: Thu, 16 Oct 2008 01:31:20 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: New Regulatory Domain Api.
Cc: "Marcel Holtmann" <holtmann@linux.intel.com>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081015131622.GH6509@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224018957.3027.9.camel@johannes.berg>
	 <1224019662.3027.13.camel@johannes.berg>
	 <1224085609.4764.18.camel@californication>
	 <1224086374.735.4.camel@johannes.berg>
	 <1224091577.28173.9.camel@californication>
	 <43e72e890810151039s34ad8d79nd2744847dd254b4e@mail.gmail.com>
	 <1224092868.28173.21.camel@californication>
	 <20081015112517.GF6509@tesla>
	 <1224098748.28173.32.camel@californication>
	 <20081015131622.GH6509@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 3:16 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Oct 15, 2008 at 12:25:48PM -0700, Marcel Holtmann wrote:
>> > The problem here is not this though the problem here is the case
>> > where people are using 2.6.28 without no iw or crda *and* have more
>> > than two cards :)
>>
>> it might sound like an unlikely case and it will most likely only be the
>> A-band usage anyway, but it is a valid case. People with old laptops do
>> use newer wireless cards in PCMCIA or USB form factor to get better WiFi
>> performance and/or stability. In some cases you can just replace your
>> internal card, but with the switch from MiniPCI to half-MiniPCI this is
>> not as likely anymore. So the use of a second external card becomes more
>> likely.
>
> Right, and the proposed solution I had was to use an intersection
> between two regulatory domains. This solution just doesn't currently
> work well with Intel cards due to the capability <-> regulatory one to
> one mapping.

This  might be viewed this way but this is not concept behind it.
First Intel HW enforce regulatory domain written in the EEPROM, which
makes it in your sense capability even it's not.
Second Intel uses special regulatory domains called MOW1 and MOW2
(most of the world 1 and 2) + possible restriction to BG. These 3
domains/capabilities should be restrictive enough comply with most of
the world regulatory restrictions. There is no real hint for specific
regulatory domain that can be applied form this, the concept is that
you should be move relatively freely around the globe without changing
anything.
You really have to use some other source to specify regulatory domain
it's cannot be retrieved from the MOW SKU's. The only exception in
Intel cards are JP and KR SKU's which are real regulatory domains.

Just my two cents, probably didn't help to solve the problem,
Tomas
