Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60546 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1C2SGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 14:06:35 -0400
Received: by qyg14 with SMTP id 14so340819qyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 11:06:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D91697C.2050603@lockie.ca>
References: <4D91697C.2050603@lockie.ca>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 29 Mar 2011 11:06:14 -0700
Message-ID: <AANLkTikUfjM1eDprL_YDFuasVvTdpRoAzKXStJf-5C7e@mail.gmail.com>
Subject: Re: regdomain
To: James <bjlockie@lockie.ca>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 28, 2011 at 10:09 PM, James <bjlockie@lockie.ca> wrote:
> I am in Canada so is 0x10 right?

Nope, CA has these two mappings:

        {CTRY_CANADA, FCC3_FCCA, "CA"},
        {CTRY_CANADA2, FCC6_FCCA, "CA"},


> Is there a tool I can use to read the EEPROM?

The ath driver spits it out for you:

> ath: EEPROM regdomain: 0x10

That's it.

> ath: EEPROM indicates we should expect a direct regpair map
> ath: Country alpha2 being used: CO
> ath: Regpair used: 0x10

Sorry for the confusion, 0x10 is a value that is used for a few
countries, specifically, 0x10 maps to a name "FCC1_FCCA" and all these
countries map to 0x10:

mcgrof@tux ~/wireless-testing (git::master)$ grep FCC1_FCCA
drivers/net/wireless/ath/regd_common.h
	FCC1_FCCA = 0x10,
	{FCC1_FCCA, CTL_FCC, CTL_FCC},
	{CTRY_DEFAULT, FCC1_FCCA, "CO"},
	{CTRY_COLOMBIA, FCC1_FCCA, "CO"},
	{CTRY_DOMINICAN_REPUBLIC, FCC1_FCCA, "DO"},
	{CTRY_GUAM, FCC1_FCCA, "GU"},
	{CTRY_GUATEMALA, FCC1_FCCA, "GT"},
	{CTRY_MEXICO, FCC1_FCCA, "MX"},
	{CTRY_PANAMA, FCC1_FCCA, "PA"},
	{CTRY_PUERTO_RICO, FCC1_FCCA, "PR"},

In reality that print, " ath: Country alpha2 being used: CO" should
say something like this:

 ath: Country alpha2 which can be used: CO, DO, GU, GT, MX, PA, PR

But the Canada regulatory domain is indeed not being used. The differences:

country CA:
        (2402 - 2472 @ 40), (3, 27)
        (5170 - 5250 @ 40), (3, 17)
        (5250 - 5330 @ 40), (3, 20), DFS
        (5490 - 5710 @ 40), (3, 20), DFS
        (5735 - 5835 @ 40), (3, 30)

country US:
        (2402 - 2472 @ 40), (3, 27)
        (5170 - 5250 @ 40), (3, 17)
        (5250 - 5330 @ 40), (3, 20), DFS
        (5490 - 5600 @ 40), (3, 20), DFS
        (5650 - 5710 @ 40), (3, 20), DFS
        (5735 - 5835 @ 40), (3, 30)

In the US 5600-5650 was removed due to this commit:

Author: Luis R. Rodriguez <lrodriguez@atheros.com>
Date:   Thu Nov 5 12:46:25 2009 -0500

    wireless-regdb: update US rules for 5600 MHz - 5650 MHz

    The FCC is trying to assist airports that use Terminal Doppler
    Weather Radar (TDWR) systems in avoiding interference with
    some outdoor wireless systems operating in the 5.4 GHz
    (5470 MHz - 5725 MHz) band. One of the things they have decided
    on is to disallow operation on the 5600 MHz - 5650 MHz frequency
    range inclusive. What this means in practice is 5 GHz 802.11
    devices programmed to operate in the US will have these
    channels now disabled:

     * 5600 MHz [120] (disabled)
     * 5620 MHz [124] (disabled)
     * 5640 MHz [128] (disabled)

    Channel on 5660 MHz (132) will be left enabled as the channel
    bandwidth is 20 MHz for legacy 802.11 networks but note that
    HT40- will be disallowed for that channel. The HT40+ and HT40-
    allowed channel map obviously changes. This is computed
    dynamically on cfg80211 based on your allowed channel list.
    For a US based device this is what you will get now
    (excerpt from on /sys/kernel/debug/ieee80211/phy0):

     .. etc ..
    5540 HT40 -+
    5560 HT40 -+
    5580 HT40 -
    5600 Disabled
    5620 Disabled
    5640 Disabled
    5660 HT40  +
    5680 HT40 -+
     .. etc ..

    The details on which this patch is based on is documented on
    the FCC Knowledge based Publication Number: 443999 [1]

    [1] https://fjallfoss.fcc.gov/oetcf/kdb/forms/FTSSearchResultPage.cfm?switch=P&id=41732

    Cc: Michael Green <Michael.Green@atheros.com>
    Cc: Senthil Balasubramanian <senthilkumar@atheros.com>
    Cc: David Quan <David.Quan@atheros.com>
    Cc: Vivek Natarajan <Vivek.Natarajan@atheros.com>
    Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

So that's all you are missing out on, and I would not be surprised if
CA passed similar rules for their own reguatory domain, but the
important thing is your card remains compliant with CA. Hope this
clarifies things.

  Luis
