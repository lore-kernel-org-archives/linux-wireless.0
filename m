Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:55231 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZI1IRf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 04:17:35 -0400
Received: by iwn10 with SMTP id 10so2444417iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 01:17:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909280956.23887.hs4233@mail.mn-solutions.de>
References: <200909252054.19762.rene.mayrhofer@gibraltar.at>
	<b6c5339f0909251352s4c30323awa588dd2f9f0d1af5@mail.gmail.com>
	<200909252329.01897.rene.mayrhofer@gibraltar.at> <200909280956.23887.hs4233@mail.mn-solutions.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 28 Sep 2009 01:17:19 -0700
Message-ID: <43e72e890909280117h5b8273a5l1ea048a6fd6a53e3@mail.gmail.com>
Subject: Re: Massive packet loss with ath9k, AR9280, hostapd in 802.11n mode
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Rene Mayrhofer <rene.mayrhofer@gibraltar.at>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 28, 2009 at 12:56 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
>> [ 1698.498801] ath: EEPROM regdomain: 0x0
>>
>> Does this indicate that the EEPROM is locked to country code
>> 0x0 (whatever that is, probably US)? "iw reg" doesn't seem to
>> change anything:
>
> Yep, that's the case.
>
> However, "iw XXX reg set XX" should *STILL* change some things,

For atheros cards 'iw reg set XX' will help compliance further, it
will never enable new channels.

> Regarding the wrong info in your EEPROM: check the README file
> from ath_info (svn co
> http://madwifi-project.org/svn/ath_info/trunk).
>
> I currently have the feeling, that about 50% of all WLAN cards
> bought in Germany have a "wrong" EEPROM country. Maybe importers
> simply don't care about this.

The regulatory domain on most cards actually ship with a world
regulatory domain, if they ship with a different country regulatory
domain that is up to the manufacturer not Atheros, but most likely
they are actually not incorrect. When you do have more channels than
you are supposed you can restrict this further with 'iw reg set' but
enabling new channels is not something that is that easy from a
regulatory perspective which is why this is not something that is
done. A manufacturer typically tests only the channels enabled on
their regulatory domain and programs the EEPROM with CTL information
for those settings, not for other regulatory domains. Modifying the
EEPROM is something up to manufacturers to do under current testing
scenarios and due to current legislation, this is not supported nor it
is intended to be.

If world roaming we provide world roaming enhancements to help with
the default passive scan an no beaconing on some channels. This
currently consists of lifting passive scan flags and no-beaconing
flags from channels you see APs on. This should increase the time it
takes to scan for your AP after the first time or for other APs on
that channel. It also means you can start hostapd or adhoc on these
channels.

  Luis
