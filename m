Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38528 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2GSFID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 01:08:03 -0400
Received: by obbuo13 with SMTP id uo13so3185659obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 22:08:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn31Y5U2A2vDt_WBb_pGghoXqMZGYW5+DFFT+TPwsv-pcw@mail.gmail.com>
References: <20120706125043.GA23189@pandem0nium>
	<CAD2nsn1=PDBTRXumDh93DzvmFcBnyFeLD-5c5oSJmv3OO6LWGw@mail.gmail.com>
	<5244861.J1Tyef1FCX@bentobox>
	<4991617.K7XqcvhjBY@bentobox>
	<CAD2nsn2m1wizCw6WY-k0KRY2NJTaqqxdoA_d_+K-kqrhw+FZ3w@mail.gmail.com>
	<CAD2nsn1-ZrKQxTYc_YZ6ETxovD9o7=Ygd2j2MxJiq8Vsiu19QQ@mail.gmail.com>
	<CAD2nsn2_16KcE2g5gysc5XwVtns5jAwD+doRzqTQdsim8xbchQ@mail.gmail.com>
	<20120707185953.GA3911@pandem0nium>
	<CAD2nsn31Y5U2A2vDt_WBb_pGghoXqMZGYW5+DFFT+TPwsv-pcw@mail.gmail.com>
Date: Thu, 19 Jul 2012 10:38:02 +0530
Message-ID: <CAD2nsn16+4gq6Di1CVcHxViYC_J8Et160xww+vGJJpJf6wgv2Q@mail.gmail.com> (sfid-20120719_070809_485052_2E21F137)
Subject: Re: ath9k: Problems with diversity on AR9330
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Sven Eckelmann <sven@narfation.org>, ath9k-devel@lists.ath9k.org,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Marek Lindner <lindner_marek@yahoo.de>,
	linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>> we had this checked out before, the EEPROM/EEP_ANT_DIV_CTL1 value is set to 000000c9,
>> so bit 6 and 7 are on (as checked in this function).
>>

with inputs from Felix Bitterli,

-128 means: no measurement performed on this antenna.This will happen
with strong signals where too many gain-changes are needed to bring
the input signal into range, after which there is no time left to take
a measurement at the alternate antenna.

So:
1) to see diversity at work, increase the distance (dramatically).
2) There is no problem, the system is working correctly.

will provide some updates when i find some time to test.

-- 
thanks,
shafi
