Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62378 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1AZRgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 12:36:49 -0500
Received: by iwn9 with SMTP id 9so1099307iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 09:36:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19776.23002.952371.103267@gargle.gargle.HOWL>
References: <19776.19422.571177.795197@gargle.gargle.HOWL> <AANLkTi=881eHyZEHnjY_XkCGLnzNWz1iuUVoJQA_KkAB@mail.gmail.com>
 <19776.23002.952371.103267@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 Jan 2011 09:36:28 -0800
Message-ID: <AANLkTinL79_40RghiaVKkciOi5AX=w2YKfv-SRARywMk@mail.gmail.com>
Subject: Re: [PATCH] ath9k_hw: Fix INI fixup
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 26, 2011 at 9:28 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Luis R. Rodriguez wrote:
>> On Wed, Jan 26, 2011 at 8:29 AM, Sujith <m.sujith@gmail.com> wrote:
>> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
>> >
>> > Commit "ath9k_hw: move AR9280 PCI EEPROM fix to eeprom_def.c"
>> > changed the behavior of INI overriding which is needed only
>> > for PCI cards. Revert to the original check.
>> >
>> > Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
>>
>> You leave me no option but to come out of e-mail reply slumber. What
>> issues was this causing?
>
> The INI fixup is required only for AR9280 PCI cards. Changing it to a SREV
> check that includes all chipsets above AR9280 would mean changing the initvals
> for other cards too. The couple of cards I have did not hit this check,
> but that doesn't mean that there are no weirdly configured cards out there...

Thanks, the reason I ask was to determine if this was a stable fix.

mcgrof@tux ~/linux-2.6-allstable (git::master)$ git describe
--contains 57b98384e5450996300d77ece61739b58325a84f
v2.6.35-rc1~473^2~167^2~208

  Luis
