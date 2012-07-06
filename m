Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50655 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab2GFOCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 10:02:43 -0400
Received: by qadb17 with SMTP id b17so422449qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2012 07:02:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120706125043.GA23189@pandem0nium>
References: <20120706125043.GA23189@pandem0nium>
Date: Fri, 6 Jul 2012 19:32:41 +0530
Message-ID: <CAD2nsn1=PDBTRXumDh93DzvmFcBnyFeLD-5c5oSJmv3OO6LWGw@mail.gmail.com> (sfid-20120706_160246_669310_5C61E676)
Subject: Re: ath9k: Problems with diversity on AR9330
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: ath9k-devel@lists.ath9k.org,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Sven Eckelmann <sven@narfation.org>,
	Marek Lindner <lindner_marek@yahoo.de>,
	linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Simon,

On Fri, Jul 6, 2012 at 6:20 PM, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> Hey,
>
> we have trouble with an AR9330 (Hornet) based AP. This device has 2 antennas, and is supposed to support diversity (2 RX, 1 TX). However, diversity is not really enabled because the "alternative" antenna is not considered as "good", because not enough frames are received. It seems that at 99% of the time, alt_rssi (read from rs->rs_rssi_ctl1) is invalid (set to ATH9K_RSSI_BAD, -128), while main_rssi (read from rs->rs_rssi_ctl0) usually has sane values.

its been some good amount of time i had taken/tested take a look at
this. actually Gabor Juhos added the support for AR9330.
seems AR9003 family chipsets can exhibit this behaviour. i quickly
checked with AR9285(AR9002) which seems to have a positive RSSI
regulary in ctl0/ctl1.
i also have a AR9485(AR9003 family) which might be similar to AR9330.
just checked with removing the antenna in chain0 seems to bring
positive values in rssi_ctl1.
I just also observer the chain0 is "preferred" unless the RSSI is so
poor in it so chain1 is taken.
Please check if this work out for your case too.
also please see the throughput difference with/without antenna
diversity with one antenna broken.

I will check out the proper technical reason for such a
preference/compare with AR9285 (or) if its a bug in the code itself.
thanks for looking into this feature!

>
> We test by sending from a 1m distance (Laptop), and both antennas are connected, so the alternative antenna should usually get some sane frames too.
>
> We have also tried to swap the antenna configuration of main and alt (LNA1 and LNA2), but only the alt_rssi will be invalid, and we then receive via the alternative antenna. We therefore think that the antenna wiring is not the problem.
>
> We have also checked EEPROM values, which seem to be correct as well. FYI, register set after reading the EEPROM are:
> AR_PHY_MC_GAIN_CTRL = 13EF0200
> AR_PHY_CCK_DETECT = 803E6788
>
> Any ideas/pointers/suggestions?
>
> Thanks!
>         Simon
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAk/23yMACgkQrzg/fFk7axZ86wCg8A5QQH+H+8H8lMiqBeCpYIyN
> fhEAnjs+pcyM462tbkre2M342k8DEX0C
> =i53p
> -----END PGP SIGNATURE-----
>



-- 
thanks,
shafi
