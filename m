Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:35532 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbaICNdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:33:32 -0400
Received: from pannekake.samfundet.no ([2001:67c:29f4::50] ident=unknown)
	by cassarossa.samfundet.no with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XPAgi-0002OJ-In
	for linux-wireless@vger.kernel.org; Wed, 03 Sep 2014 15:33:28 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XPAgi-0006b1-8l
	for linux-wireless@vger.kernel.org; Wed, 03 Sep 2014 15:33:28 +0200
Date: Wed, 3 Sep 2014 15:33:28 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 2/2] mac80211: support DTPC IE (from Cisco Client
 eXtensions)
Message-ID: <20140903133328.GC18933@sesse.net> (sfid-20140903_153336_782556_14E19EF4)
References: <20140830184516.GA31497@sesse.net>
 <E1XONJB-0005LB-O8@pannekake.samfundet.no>
 <1409745636.911.13.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1409745636.911.13.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 03, 2014 at 02:00:36PM +0200, Johannes Berg wrote:
> I think for some vendors shipping our stack this might become
> problematic. I think it would make sense to have a Kconfig option for
> this, probably hidden away under "if EXPERT" and defaulting to yes, to
> enable this code, it might be something that interferes with more CCX
> implementations maybe?

Are there any CCX implementations for Linux at this time? Could you even do
that from just userspace? (I sort of doubt it, but it's never easy to know
what illustrious userspace programmers can do :-) )

I can make a config option, but it seems a bit odd, maybe. Are you thinking
there would be problems since this is an undocumented protocol, or because of
the possible conflict?

>> +static bool ieee80211_find_cisco_dtpc(struct ieee80211_sub_if_data
>> *sdata,
> The return value is useless here, so it could be void?

It is useless indeed; I kept it this way for symmetry with the other _find_
function and because it makes for slightly easier code around (you can set
has_cisco_pwr = directly without needing an additional statement to make it
true). But I've changed it so it's void.

I could also change it to use a return instead of an output parameter for
pwr_level_cisco if you want, but I think it might become a bit confusing to
have two so similar functions with different calling style.

>> +                       if (pos[0] != 0x00 || pos[1] != 0x40 ||
>> +                           pos[2] != 0x96 || pos[3] != 0x00) {
>> +                               break;
>> +                       }
> Please remove those useless braces - maybe run ./scripts/checkpatch.pl?

Removed. But I've already run checkpatch and it didn't complain about this
(the patch set is checkpatch-clean).

I'm in a hotel room in Seattle right now whose Wi-Fi is not Cisco-based,
so I can't test the new version as thoroughly as I'd like, but I'll at least
give it a boot test and then send an updated patch series as reply to this
message.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
