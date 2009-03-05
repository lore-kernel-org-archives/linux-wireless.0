Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:53894 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZCEPBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 10:01:45 -0500
Received: by ti-out-0910.google.com with SMTP id d10so3834710tib.23
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 07:01:41 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18863.59687.412529.867286@gargle.gargle.HOWL> (sfid-20090305_160149_529983_D5CE4E2F)
Date: Thu, 5 Mar 2009 20:30:55 +0530
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: use correct init values for ar9100
 devices
In-Reply-To: <49AFACC4.4060500@openwrt.org>
References: <1236103846-1672-1-git-send-email-juhosg@openwrt.org>
	<18862.1025.217829.656599@gargle.gargle.HOWL>
	<18862.4870.138381.234256@gargle.gargle.HOWL>
	<49AE8466.3040906@openwrt.org>
	<18862.36430.959276.440720@gargle.gargle.HOWL>
	<49AEAA34.8080806@openwrt.org>
	<18863.12192.871072.649460@gargle.gargle.HOWL>
	<49AFACC4.4060500@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> >> @@ -658,7 +657,7 @@ static const u32 ar5416Addac_9100[][2] = {
> >>      {0x0000989c,  0x00000000 },
> >>      {0x0000989c,  0x00000000 },
> >>      {0x0000989c,  0x00000000 },
> >> -    {0x000098cc,  0x00000000 },
> >> +    {0x000098c4,  0x00000000 },
> >>  };
> >>
> >>  static const u32 ar5416Modes[][6] = {
> >> @@ -862,7 +861,7 @@ static const u32 ar5416Common[][2] = {
> >>      { 0x00008134, 0x00000000 },
> >>      { 0x00008138, 0x00000000 },
> >>      { 0x0000813c, 0x00000000 },
> >> -    { 0x00008144, 0x00000000 },
> >> +    { 0x00008144, 0xffffffff },
> >>      { 0x00008168, 0x00000000 },
> >>      { 0x0000816c, 0x00000000 },
> >>      { 0x00008170, 0x32143320 },
> >>
> > 
> > Heh. :-)
> > Dunno if those 2 values make any difference.
> 
> Indeed, these 2 values does not make too much difference.
> 
> The first one reverts this commit:
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=6753ddb4bebecab1039a2a2c8d51d6656d0d0513
> 
> With the second one we will use the same initial value (which is in the
> ar5416Common_9100, ar5416Common_9160  ar5416Common_9280_2 and
> ar5416Common_9285_1_2 arrays currently) for the AR_PHY_ERR_EIFS_MASK register.
> 
> Hm, the ar5416Common_9280 and ar5416Common_9285 arrays are using 0x00000000 for
> the same register. By any chance, these values would be wrong in them also?

We would be updating the initvals for all chipsets shortly,
so if any value in the existing arrays is wrong, it would be fixed.

> > Feel free to send a patch fixing this, and the macro cleanup.
> > I'll just update the initvals, fix the check for AR9100 in HW attach 
> 
> Well, the _AR9100_OR_LATER would be the right one, simply the macro itself is
> wrong. According to Luis' request, I would send a new patchset, then we can
> discuss it further based on that.

Sure, either way those initvals are meant only for AR91xx chipsets.

> > and the typo for AR9285 chipsets.
> 
> This one can go with a separated patch?

Sure.

Sujith
