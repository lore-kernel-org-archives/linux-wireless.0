Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:52300 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020Ab0LZOvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 09:51:53 -0500
Message-ID: <20101226165146.19173ihiyy3hyjy8@hayate.sektori.org>
Date: Sun, 26 Dec 2010 16:51:46 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: =?utf-8?b?UmFmYcWCIA==?= =?utf-8?b?TWnFgmVja2k=?=
	<zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	zd1211-devs@lists.sourceforge.net,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [RFC PATCH 5/6] zd1211rw: implement beacon fetching and
 handling ieee80211_get_buffered_bc()
References: <20101226112404.31775.77854.stgit@fate.lan>
 <20101226112452.31775.12810.stgit@fate.lan>
 <AANLkTi=yN485OSM+TSPoZrG=h3M0vhAAmVgmndxp-BrG@mail.gmail.com>
In-Reply-To: <AANLkTi=yN485OSM+TSPoZrG=h3M0vhAAmVgmndxp-BrG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Rafał Miłecki <zajec5@gmail.com>:

> 2010/12/26 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>:
>> +       if (mac->vif || mac->vif->type == NL80211_IFTYPE_UNSPECIFIED)
>> +               return;
>
> That's smelly. I think you meant negation in first part of condition.

Heh.. well that fixed broadcast/multicast buffering. Thanks.

>
>
>> -       if (int_status & INT_CFG_NEXT_BCN)
>> +       if (int_status & INT_CFG_NEXT_BCN) {
>>                dev_dbg_f_limit(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");
>> -       else
>> +               zd_beacon_done(mac);
>> +       } else
>>                dev_dbg_f(zd_mac_dev(mac), "Unsupported interrupt\n");
>
> Minor thing, check http://www.kernel.org/doc/Documentation/CodingStyle
>
>> This does not apply if one branch of a conditional statement is a single
>> statement. Use braces in both branches.
>
> Use brackets for "else" as well please.
>

Ok.

-Jussi

