Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38724 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0JARUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 13:20:30 -0400
Received: by iwn5 with SMTP id 5so4054950iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 10:20:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285949495.3739.39.camel@jlt3.sipsolutions.net>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com> <1285949495.3739.39.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 1 Oct 2010 10:20:08 -0700
Message-ID: <AANLkTintS4GU5-uYjMyY5bA1RaJL5cby1aKEpmZhSBkN@mail.gmail.com>
Subject: Re: [PATCH 1/6] mac80211: perform scan cancel in hw reset work
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 1, 2010 at 9:11 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2010-10-01 at 14:05 +0200, Stanislaw Gruszka wrote:
>> Move ieee80211_scan_cancel() and all other related code to
>> ieee80211_restart_work() as ieee80211_restart_hw() is intended to be
>> callable from any context.
>>
>> Fix a bug that RTNL lock is not taken during ieee80211_cancel_scan().
>>
>> Take local->mtx before WARN(test_bit(SCAN_HW_SCANNING, &local->scanning)
>> to prevent the race condition with __ieee80211_start_scan() described
>> here: http://marc.info/?l=linux-wireless&m=128516716810537&w=2
>>
>> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>
> This one's obvious -- the other ones I need a bit of time to review, and
> it's practically weekend here now. I'll try to get to it ASAP.

I'm going to suck this into linux-next-pending/ on compat-wireless for
today's release as it may fix a deadlock with carl9170.

  Luis
