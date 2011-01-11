Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1AKIc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 03:32:28 -0500
Subject: Re: [PATCH v2 2/4] iw: Add channel busy time to survey
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110111005112.10231.46375.stgit@localhost6.localdomain6>
References: <20110111005107.10231.81618.stgit@localhost6.localdomain6>
	 <20110111005112.10231.46375.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 09:32:24 +0100
Message-ID: <1294734744.3611.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 09:51 +0900, Bruno Randolf wrote:
> From: Felix Fietkau <nbd@openwrt.org>
> 
> Print channel busy time in survey dump.
> 
> This patch comes from OpenWRT. Original author: Felix Fietkau.
> Fixed up for unsigned values.

I've fixed it up, but two things: You should've lost the "original
author" crap after you fixed up the git author field.

Secondly,

> 
> +               printf("\tchannel receive time:\t\t%llu ms\n",
> +                       (uint64_t)nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_RX]));

caused warnings:
survey.c: In function ‘print_survey_handler’:
survey.c:55: warning: format ‘%llu’ expects type ‘long long unsigned int’, but argument 2 has type ‘uint64_t’
survey.c:58: warning: format ‘%llu’ expects type ‘long long unsigned int’, but argument 2 has type ‘uint64_t’
survey.c:61: warning: format ‘%llu’ expects type ‘long long unsigned int’, but argument 2 has type ‘uint64_t’
survey.c:64: warning: format ‘%llu’ expects type ‘long long unsigned int’, but argument 2 has type ‘uint64_t’
survey.c:67: warning: format ‘%llu’ expects type ‘long long unsigned int’, but argument 2 has type ‘uint64_t’


because uint64_t isn't guaranteed to be unsigned long long (in fact, it
is unsigned long on many machines). Please look at the commit and check.

johannes

