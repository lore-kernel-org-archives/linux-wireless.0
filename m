Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:32466 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753015Ab1AKJTD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 04:19:03 -0500
Received: from vs3010.wh2.ocn.ne.jp (125.206.180.173)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0833037541
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 18:19:01 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 2/4] iw: Add channel busy time to survey
Date: Tue, 11 Jan 2011 18:20:00 +0900
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	linux-wireless@vger.kernel.org
References: <20110111005107.10231.81618.stgit@localhost6.localdomain6> <20110111005112.10231.46375.stgit@localhost6.localdomain6> <1294734744.3611.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1294734744.3611.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101111820.00815.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue January 11 2011 17:32:24 Johannes Berg wrote:
> I've fixed it up, but two things: You should've lost the "original
> author" crap after you fixed up the git author field.

Sorry for that.
 
> Secondly,
> 
> > +               printf("\tchannel receive time:\t\t%llu ms\n",
> > +                      
> > (uint64_t)nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_RX]));
> 
> caused warnings:
> survey.c: In function ‘print_survey_handler’:
> survey.c:55: warning: format ‘%llu’ expects type ‘long long unsigned int’,
> but argument 2 has type ‘uint64_t’ survey.c:58: warning: format ‘%llu’
> expects type ‘long long unsigned int’, but argument 2 has type ‘uint64_t’
> survey.c:61: warning: format ‘%llu’ expects type ‘long long unsigned int’,
> but argument 2 has type ‘uint64_t’ survey.c:64: warning: format ‘%llu’
> expects type ‘long long unsigned int’, but argument 2 has type ‘uint64_t’
> survey.c:67: warning: format ‘%llu’ expects type ‘long long unsigned int’,
> but argument 2 has type ‘uint64_t’
> 
> 
> because uint64_t isn't guaranteed to be unsigned long long (in fact, it
> is unsigned long on many machines). Please look at the commit and check.

Looks good & compiles on my platforms (x86, mips).

Thanks,
bruno
