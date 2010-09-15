Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39085 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab0IODKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 23:10:10 -0400
Received: by wyf22 with SMTP id 22so8136537wyf.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 20:10:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=uaJd3VTZ8cT0YHdE5awsmJaiO+607OLTWrt1E@mail.gmail.com>
References: <AANLkTim+Q773KvA7Et1s2Zf8yMx36RGS2LsoJsX1Wtt9@mail.gmail.com>
 <201009151130.15165.br1@einfach.org> <AANLkTi=uaJd3VTZ8cT0YHdE5awsmJaiO+607OLTWrt1E@mail.gmail.com>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 15 Sep 2010 13:09:48 +1000
Message-ID: <AANLkTimSvEDZL_AdepZLerpxALYpEgn=HJsn4mJKwAfa@mail.gmail.com>
Subject: Re: [ath5k-devel] [ath5k] Incorrect value for ACK_TIMEOUT
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 1:01 PM, Jonathan Guerin <jonathan@guerin.id.au> wrote:

>>
>> on 5212 this is 1000 in A mode and 1760 in G mode, which would result in a
>> timeout of 25 and 40.
>
> We have a 5213 chip - does this default to the 5212 branch inside ath5k?
>

Never mind, I found it...
$$ attach.c
else if (srev == AR5K_SREV_AR5213A &&
		ah->ah_phy_revision == AR5K_SREV_PHY_5212B) {
			ah->ah_radio = AR5K_RF5112;
			ah->ah_single_chip = false;
			ah->ah_radio_5ghz_revision = AR5K_SREV_RAD_5112B;

> Thanks,
>
> Jonathan
>
