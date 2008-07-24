Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:32690 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYGXVzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 17:55:22 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3101352rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 14:55:21 -0700 (PDT)
Message-ID: <b6c5339f0807241455s31697c8ctfcb9e78a486a28ea@mail.gmail.com> (sfid-20080724_235525_689913_61E62C51)
Date: Thu, 24 Jul 2008 17:55:21 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/12] ath5k: Update register list
Cc: "Pavel Roskin" <proski@gnu.org>, jirislaby@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Nick Kossifidis" <mick@madwifi.org>
In-Reply-To: <40f31dec0807241435x2e9f6ae1x1d136c1b0d20c874@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080720033041.GA7440@makis> <1216934605.3094.5.camel@dv>
	 <40f31dec0807241435x2e9f6ae1x1d136c1b0d20c874@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2008 at 5:35 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>>> -                     ath5k_hw_reg_write(ah, 0x0002a002, AR5K_PHY(11));
>>> +                     ath5k_hw_reg_write(ah, 0x0002a002, 0x982c);
>>
>> You are replacing macros with numbers in several places.  Maybe you
>> could introduce another macro?  Or is it the case when you had
>> interpretation of the registers, but now realize that it was wrong?
>>
>
> Helps me with rev. engineering, i'll hopefully introduce a macro for
> these registers soon...

Probably stating the obvious, but ath9k demystifies some of these registers
perhaps?  I'm not sure how much the phy register location changes each
revision, but the bit pattern looks like 0x982c could easily be
AR_PHY_ADC_CTL...

-- 
Bob Copeland %% www.bobcopeland.com
