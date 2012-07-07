Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42152 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2GGJ6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2012 05:58:46 -0400
Received: by obbuo13 with SMTP id uo13so16584246obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jul 2012 02:58:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4991617.K7XqcvhjBY@bentobox>
References: <20120706125043.GA23189@pandem0nium>
	<CAD2nsn1=PDBTRXumDh93DzvmFcBnyFeLD-5c5oSJmv3OO6LWGw@mail.gmail.com>
	<5244861.J1Tyef1FCX@bentobox>
	<4991617.K7XqcvhjBY@bentobox>
Date: Sat, 7 Jul 2012 15:28:46 +0530
Message-ID: <CAD2nsn2m1wizCw6WY-k0KRY2NJTaqqxdoA_d_+K-kqrhw+FZ3w@mail.gmail.com> (sfid-20120707_115851_061793_89C17300)
Subject: Re: ath9k: Problems with diversity on AR9330
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Sven Eckelmann <sven@narfation.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	ath9k-devel@lists.ath9k.org,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Marek Lindner <lindner_marek@yahoo.de>,
	linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sven,

On Fri, Jul 6, 2012 at 10:05 PM, Sven Eckelmann <sven@narfation.org> wrote:
> On Friday 06 July 2012 17:13:42 Sven Eckelmann wrote:
> [...]
>> > I just also observer the chain0 is "preferred" unless the RSSI is so
>> > poor in it so chain1 is taken.
>> > Please check if this work out for your case too.
>>
>> Removing the antenna on chain0 doesn't change the alt_rssi value for us. We
>> only noticed that frames with alt_rssi != -128 have  the value rx_ant_conf
>> == 1 (LNA2) when only chain1 is attached and rx_ant_conf == 2 (LNA1) when
>> both/chain0-only are attached. Still most of the packets had alt_rssi ==
>> -128 and we saw changes in curr_main_set and curr_alt_set (after lot of
>> data was sent).
>
> Here are some logs. We added some debug printk before first check in
> ath_ant_comb_scan ("if (main_rssi > 0 && alt_rssi > 0) {"). We can see a
> difference in the output after (a more or less long time) both antennas were
> unplugged. The output looks extreme different when at least one antenna is
> attached.

thanks, i saw the logs. i could do some analysis with AR9485/AR9285.
as you had said before
alt_rssi is -128 when one antenna is unplugged, while having both out
seems to bring some
+tive value for alt_rssi.

>
> alt_ant_conf is calculated using
> "alt_ant_conf = (rs->rs_rssi_ctl[2]) & ATH_ANT_RX_MASK;" and could be wrong.
> curr_alt_set and curr_main_set come from div_ant_conf queried using
> ath9k_hw_antdiv_comb_conf_get.

thanks i would check this out.  As the algorithm itself is bit
complex, i would just revisit
and check it out. If i remember correctly Fast antenna diversity was
working fine with AR9485.

>
> Kind regards
>         Sven



-- 
thanks,
shafi
