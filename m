Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:45428 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZKFPyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 10:54:07 -0500
Received: by iwn10 with SMTP id 10so867814iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 07:54:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m3hbt7kgdb.wl%holgerschurig@gmail.com>
References: <fd145f7d0911060004j55b06482tca088685d0626249@mail.gmail.com>
	<m3ws246ky4.wl%holgerschurig@gmail.com> <m3hbt7kgdb.wl%holgerschurig@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 6 Nov 2009 07:53:52 -0800
Message-ID: <43e72e890911060753s3c55c660x2a9cc0ab5210e231@mail.gmail.com>
Subject: Re: Getting random regulatory domains on boot-up with ath9k
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: Jeffrey Baker <jwbaker@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 4:05 AM, Holger Schurig
<holgerschurig@googlemail.com> wrote:
> Hmm, maybe it's not a bug after all.

Right.

> The card's eeprom just have a region, 0x37 is ETSI World. Now the
> kernel looks for the first country with this region and uses this for
> crda.

The atheros driver does this, that is right. This is just one way in
which the EEPROM can be programmed on Atheros cards, a way which I
hope will disappear as this obviously can confuse users.

> There have been changes to drivers/net/wireless/ath/regd_common.h
> recently, so maybe on one kernel-version "DK" is the first ETSI World,
> on the next "AW" is the first and on some other again some different
> country.

Right, this is exactly what happens.

So the search is for any alpha2 for 0x37 (ETSI1_WORLD) on the Atheros
regulatory table allCountries[]. There are a few and recently the
first alpha2 was made 'AW' as noted. Reason for searching for the
first one is all of the alpha2s that match ETSI1_WORLD all have the
same regulatory domain so the way to think about these is more of a
region code and that region code maps to a certain number of alpha2s
which all happen to have the same exact regulatory domain definitions.
This obviously can change over time but for Windows driver this
behavior is static as the driver remains static unless a change is
requested by an ODM. For Linux this is different -- we get all the
updates, and IMHO this is good but this also means this one way of
programming the EEPROM should be avoided and eventually dropped. That
will take time but I had already started poking internally for a
change.

In the meantime I've tried to document the regulatory details on the
wiki so interested users / developers can understand what is going on.

So for ETSI1_WORLD we have these mappings, in this order now on
wireless-testing (bleeding edge):

mcgrof@tux ~/wireless-testing (git::my-stuff)$ grep ETSI1_WORLD
drivers/net/wireless/ath/regd_common.h
        ETSI1_WORLD = 0x37,
        {ETSI1_WORLD, CTL_ETSI, CTL_ETSI},
        {CTRY_ARUBA, ETSI1_WORLD, "AW"},
        {CTRY_AUSTRIA, ETSI1_WORLD, "AT"},
        {CTRY_BELARUS, ETSI1_WORLD, "BY"},
        {CTRY_BELGIUM, ETSI1_WORLD, "BE"},
        {CTRY_BOSNIA_HERZ, ETSI1_WORLD, "BA"},
        {CTRY_CAMBODIA, ETSI1_WORLD, "KH"},
        {CTRY_CROATIA, ETSI1_WORLD, "HR"},
        {CTRY_CYPRUS, ETSI1_WORLD, "CY"},
        {CTRY_DENMARK, ETSI1_WORLD, "DK"},
        {CTRY_ESTONIA, ETSI1_WORLD, "EE"},
        {CTRY_FINLAND, ETSI1_WORLD, "FI"},
        {CTRY_FRANCE, ETSI1_WORLD, "FR"},
        {CTRY_GERMANY, ETSI1_WORLD, "DE"},
        {CTRY_GREECE, ETSI1_WORLD, "GR"},
        {CTRY_GREENLAND, ETSI1_WORLD, "GL"},
        {CTRY_HAITI, ETSI1_WORLD, "HT"},
        {CTRY_HUNGARY, ETSI1_WORLD, "HU"},
        {CTRY_ICELAND, ETSI1_WORLD, "IS"},
        {CTRY_IRELAND, ETSI1_WORLD, "IE"},
        {CTRY_ITALY, ETSI1_WORLD, "IT"},
        {CTRY_LATVIA, ETSI1_WORLD, "LV"},
        {CTRY_LIECHTENSTEIN, ETSI1_WORLD, "LI"},
        {CTRY_LITHUANIA, ETSI1_WORLD, "LT"},
        {CTRY_LUXEMBOURG, ETSI1_WORLD, "LU"},
        {CTRY_MALTA, ETSI1_WORLD, "MT"},
        {CTRY_NETHERLANDS, ETSI1_WORLD, "NL"},
        {CTRY_NETHERLANDS_ANTILLES, ETSI1_WORLD, "AN"},
        {CTRY_NORWAY, ETSI1_WORLD, "NO"},
        {CTRY_POLAND, ETSI1_WORLD, "PL"},
        {CTRY_PORTUGAL, ETSI1_WORLD, "PT"},
        {CTRY_SERBIA_MONTENEGRO, ETSI1_WORLD, "CS"},
        {CTRY_SLOVAKIA, ETSI1_WORLD, "SK"},
        {CTRY_SLOVENIA, ETSI1_WORLD, "SI"},
        {CTRY_SPAIN, ETSI1_WORLD, "ES"},
        {CTRY_SWEDEN, ETSI1_WORLD, "SE"},
        {CTRY_SWITZERLAND, ETSI1_WORLD, "CH"},
        {CTRY_UNITED_KINGDOM, ETSI1_WORLD, "GB"},

The assumption of whether or not all of these alpha2s have the same
regulatory definition on db.txt from wireless-regdb may be wrong
already, not sure, but they all should be pretty close. The design of
programming an Atheros card with 0x37 would end up being to use the
same exact regulatory domain for any of these alpha2s as all of these
alpha2s would be mapped internally in the driver to static regulatory
domain definition. In that case the regulatory domain would never
change, the user would not be informed of the alpha2 at all and its
just used. For Linux the alpha2 regulatory database has been moved to
userspace and although countries (alpah2s) can have the same exact
regulatory domain they do not -- they are just split up.

> So it's just misleading, e.g.
>
>    using first country with regdm 0x37: DK
>
> would probably a better dmesg output.

Agreed, maybe better:

ath: region code found 0x37, fist country in region: DK

That or print all the alpha2s in the region. But as I also had
suggested before we could also check the currently set alpha2 on
cfg80211 by the user and if it happens to match an alpha2 in the
region ask CRDA for that alpha2's regulatory domain.

  Luis
