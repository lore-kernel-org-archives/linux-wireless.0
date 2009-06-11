Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:62854 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZFKVAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 17:00:39 -0400
Received: by gxk10 with SMTP id 10so2737801gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 14:00:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244747416.29447.2.camel@johannes.local>
References: <1244666131-20031-1-git-send-email-lrodriguez@atheros.com>
	<1244666973.20900.399.camel@rc-desk> <43e72e890906101349t502e9022h16fa79ea512f8b4d@mail.gmail.com>
	<1244667817.20900.402.camel@rc-desk> <43e72e890906101404l6a8bee67r560f7c8a1c5f8c36@mail.gmail.com>
	<1244668077.4706.4.camel@johannes.local> <43e72e890906101542l5064384auf027267a3d19f3ee@mail.gmail.com>
	<43e72e890906101544i22bacc8fxa0a7d045eea50280@mail.gmail.com>
	<43e72e890906111204g18e71720w97cb2ea346e5d663@mail.gmail.com>
	<1244747416.29447.2.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 11 Jun 2009 13:54:06 -0700
Message-ID: <43e72e890906111354r500e8542h684fe47a011fd970@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] mac80211: disassociate when switching bands
	and not scanning
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	reinette chatre <reinette.chatre@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>, "j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2009 at 12:10 PM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-06-11 at 12:04 -0700, Luis R. Rodriguez wrote:
>
>> As expected I was able to reproduce the warning with atht5k and ath9k
>> on 2.6.30. I did not get a crash with ath9k though, which is good. But
>> the warning is still present.
>>
>> Do we want to fix this for stable? If so is the patch I posted reasonable?
>
> Which patch are you talking about now? This disassociate one?

Yes. But I also think this is stable candidates:

mac80211: disable moving between PS modes during scan

This patch would fix the assert we hit in ath9k.

The patch "mac80211: disable PS while probing AP" may also be a stable
candidate but I am not aware of open issues which it fixes so not
sure.

> If yes, I
> think I'd prefer to have mine so we don't diverge much and I can still
> remember what's going on where :)

Works with me -- it seems its missing something as per reinette's testing.

  Luis
