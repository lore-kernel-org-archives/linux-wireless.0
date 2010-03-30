Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:60098 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab0C3SVj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 14:21:39 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: CRDA and ath5k with no country code in EEPROM
References: <m3tys0tbhk.fsf@intrepid.localdomain>
	<43e72e891003281645m1da47a1en882df4432733977d@mail.gmail.com>
	<m3eij3ym5k.fsf@intrepid.localdomain>
	<43e72e891003291222n5e72a0a5m31dddf2bbf6e06ab@mail.gmail.com>
	<m339zizz4o.fsf@intrepid.localdomain>
	<43e72e891003291256t7f53dcfck5f8c8cf94128eeb3@mail.gmail.com>
	<m3y6hayhv1.fsf@intrepid.localdomain>
	<43e72e891003291500w632cb789r6860dae9ccdf744c@mail.gmail.com>
	<m3r5n2qbo0.fsf@intrepid.localdomain>
	<43e72e891003300928qdd70de4vc7585d7e19d36dca@mail.gmail.com>
Date: Tue, 30 Mar 2010 20:21:36 +0200
In-Reply-To: <43e72e891003300928qdd70de4vc7585d7e19d36dca@mail.gmail.com>
	(Luis R. Rodriguez's message of "Tue, 30 Mar 2010 09:28:28 -0700")
Message-ID: <m3wrwtoekv.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

> My point was that this is not something meant to be interpreted by
> anyone for what "default country" means, the documentation I pointed
> out clearly states that 0x0 is designed to mean to match the "US" by
> Atheros hardware as per hardware documentation provided to ODMs.

I understand this, but the reality is that I have to work with hardware
and software, not with the docs provided by Atheros to some other
parties.

Software (the official Atheros driver, to be precise) says 0 isn't
exactly US.
Hardware (card) manufacturer says 0 isn't US.

What do you think can I do?

I obviously would go the regulatory.bin way, if it was possible. But
I think regulatory.bin simply describes frequencies etc. valid in
different countries, and if the file contains correct data (and it seems
it does), there is nothing I can "fix" there.

For now I think the best I can do is to add
CONFIG_*80211_DEFAULT_COUNTRY (with default = "US"), and to treat 0 as
this DEFAULT_COUNTRY. This way I don't enable users to disobey the rules
(more than they're already able, since they can patch and recompile
anyway), and at the same time I don't put the (inappropriate for many
people) default country in the sources.
-- 
Krzysztof Halasa
