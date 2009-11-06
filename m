Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:44834 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641AbZKFQ5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 11:57:44 -0500
Received: by iwn10 with SMTP id 10so922516iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 08:57:49 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 6 Nov 2009 08:57:28 -0800
Message-ID: <43e72e890911060857l6e383578nc1c7d0f2ba63529f@mail.gmail.com>
Subject: Changing the way we handle region codes on Linux (public thread)
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Jeffrey Baker <jwbaker@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Quan <David.Quan@atheros.com>,
	Michael Green <Michael.Green@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note: this e-mail is on a public mailing list.

So Jeffrey pointed out a regression introduced by a recent patch to
update our regulatory domain information on the Atheros driver common
module, ath.ko. Of relevance the patch added Aruba "AW" and made "AW"
the first alpha2 to which the ETSI1_WORLD region code maps to. This
region code used to first map to "AT". The wireless-regdb did not
however yet get an update for "AW" so the next logical step is to add
it to wireless-regdb based on the "AT" for example (or any other
country on the region, as all of those countries are expected to be on
the same region and hence the same regulatory domain). That missing
patch would address the issues reported by Jeffrey, which is that he
was unable to use AP mode of operation as no channels when world
roaming are allowed to start IBSS/AP mode unless you are world roaming
(not the case when a region code is used) and find a nearby AP.

Users tend to get confused by the current region code mapping though
so alternatives we can consider are:

1) If a user selects a regulatory domain manually (either before or
after the wireless driver is loaded) check to see if the alpha2 the
user selected fits in the region of the currently programmed region
code. This would be to search the allCountries[] array, and see if the
programmed region code has a match for the alpha2 the user selected at
all in the array. If this is true then allow the usage of that
regulatory domain for the driver.

2) Treat region codes as world roaming regulatory domains and define
them statically in the ath.ko module as we do with the other 12 world
regulatory domains. The advantage to this solution is these regions
would then *world roam* and this means being able to use the world
roaming features of finding a channel on a passive-scan/no-beaconing
channel and lifting those restrictions. The down side to this is we'd
increase ath.ko in size with however many region codes we support.

I think that sums it up. I'd like to hear input on these on
linux-wireless. I'll address this internally at Atheros also to to see
what we think too and get back to this thread with a path. In th
meantime I'll send a patch for wireless-regdb for AW just to get a
quick resolution to this.

  Luis
