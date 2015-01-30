Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33822 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbbA3NWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:22:18 -0500
Received: by mail-wi0-f172.google.com with SMTP id h11so2993253wiw.5
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 05:22:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422623054.1919.18.camel@sipsolutions.net>
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
	<1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
	<1422621086-28970-3-git-send-email-michal.kazior@tieto.com>
	<1422621903.1919.7.camel@sipsolutions.net>
	<CA+BoTQkdszYWbNJcV+1dDFsaSJ3aoTuC=ORUMr_aJx7_aQmcqw@mail.gmail.com>
	<1422623054.1919.18.camel@sipsolutions.net>
Date: Fri, 30 Jan 2015 14:22:16 +0100
Message-ID: <CA+BoTQnkqzHNWTFSc9VB4_itCK_+jC6HC8GmdMKiyrhu-Sz9Cg@mail.gmail.com> (sfid-20150130_142220_996474_92CF6E1F)
Subject: Re: [PATCH v2 2/7] ath10k: implement chanctx API
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 January 2015 at 14:04, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2015-01-30 at 14:02 +0100, Michal Kazior wrote:
>
>> I recall that at least there's one case where using these helpers is
>> impossible: drv_config() which can be called while mac80211 is already
>> holding iflist_mtx. ath10k needs to iterate over vifs and issue
>> blocking commands sometimes so it can't use atomic/rcu versions
>> either.
>
> If you wanted to use it, I wouldn't be averse to adding a locked version
> that can only be used inside a few of such callbacks. With appropriate
> lockdep warnings that would be safe enough, I think.

You'd probably have to add quite a few mutex_lock(iflist_mtx) around
drv_*() calls (not directly but somewhere at their call trees) to
guarantee driver can use lock-free iterate() version (which doesn't
exist yet). This could be tricky.


Michał
