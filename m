Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57449 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbbKMJwg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 04:52:36 -0500
Message-ID: <1447408352.3271.11.camel@sipsolutions.net> (sfid-20151113_105242_906025_8ED4659E)
Subject: Re: [RFC v5 4/5] mac80211: use Kconfig counters to elide
 unnecessary code
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Marek <mmarek@suse.com>
Date: Fri, 13 Nov 2015 10:52:32 +0100
In-Reply-To: <CAGRGNgUr=ygLh-B1ZZ5ojPeRJVXCEbY3dniAtXZq_29DZzqjCw@mail.gmail.com> (sfid-20151113_104917_989701_911D22D2)
References: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net>
	 <1447365652-23716-5-git-send-email-johannes@sipsolutions.net>
	 <CAGRGNgUr=ygLh-B1ZZ5ojPeRJVXCEbY3dniAtXZq_29DZzqjCw@mail.gmail.com>
	 (sfid-20151113_104917_989701_911D22D2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-11-13 at 20:48 +1100, Julian Calaby wrote:
> 
> Am I missing something or are you not actually doing anything with
> MAC80211_DRIVER_NO_HWFLAGS?
> 

Crap. I meant to pass it to the macro like this (I think):

#define __DEFINE_HWFLAG(_flg, _dyn, _on, _off)                         \
       HWFLAGS_STATE_##_flg = -1 + (!(_dyn)) * (((_on) ^ (_off)) * (1 + (_on))),
#define DEFINE_HWFLAG(_flg)                                            \
       __DEFINE_HWFLAG(_flg,                                           \
                       IS_ENABLED(CONFIG_MAC80211_HW_##_flg##_DYN) ||  \
                       (CONFIG_MAC80211_DRIVER_NO_HWFLAGS > 0),        \
                       CONFIG_MAC80211_HW_##_flg > 0,                  \
                       CONFIG_MAC80211_HW_##_flg < CONFIG_MAC80211_NUM_DRIVERS)

I'll take a closer look.

FWIW, I pushed this into the hwflags-elide branch in mac80211-next.git
(kernel.org) - will update there (also already fixed a compile issue)

johannes
