Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:60575 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbZKFT1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 14:27:12 -0500
Received: by iwn10 with SMTP id 10so1042975iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 11:27:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890911061120mc3f66cbl272adc273a39cb0c@mail.gmail.com>
References: <43e72e890911060857l6e383578nc1c7d0f2ba63529f@mail.gmail.com>
	<b6c5339f0911060929w78d16192o6c48e432e8e8c830@mail.gmail.com>
	<43e72e890911060945s3b00e056u1efe483bd88ebd30@mail.gmail.com>
	<20091106183833.GC2782@tuxdriver.com> <43e72e890911061120mc3f66cbl272adc273a39cb0c@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 6 Nov 2009 11:26:58 -0800
Message-ID: <43e72e890911061126y12c59bc2q4620af8dfd703304@mail.gmail.com>
Subject: Re: Changing the way we handle region codes on Linux (public thread)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Vivek Natarajan <vivek.natraj@gmail.com>,
	Jeffrey Baker <jwbaker@gmail.com>,
	David Quan <David.Quan@atheros.com>,
	Michael Green <Michael.Green@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 11:20 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Nov 6, 2009 at 10:38 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
>>
>> FWIW, I think Bob's suggestion makes a lot of sense.
>
> Patches welcomed then :)

So this could consist probably of adding one more environment variable
to the passed COUNTRY one that the kernel passes before calling crda,
a group I guess, andif the group is passed the crda can read
/path/grop-regulatory.bin where group could be ATHR for example.

BTW -- the region codes are already present on db.txt -- so the only
thing that group thing could do is allow us to move the 12 regulatory
domains to userspace and I'm not sure if this is someone's time,
specially since I managed to squeeze the 12 world regulatory domains
to 5 structures, the slight modifications between a few are handled
internally on ath.ko through the reg notifier, see:

static void ath_reg_apply_world_flags(struct wiphy *wiphy,
                                      enum nl80211_reg_initiator initiator,
                                      struct ath_regulatory *reg)
{
        switch (reg->regpair->regDmnEnum) {
        case 0x60:
        case 0x63:
        case 0x66:
        case 0x67:
                ath_reg_apply_beaconing_flags(wiphy, initiator);
                break;
        case 0x68:
                ath_reg_apply_beaconing_flags(wiphy, initiator);
                ath_reg_apply_active_scan_flags(wiphy, initiator);
                break;
        }
        return;
}


  Luis
