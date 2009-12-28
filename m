Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:52416 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZL1QKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 11:10:31 -0500
Received: by iwn1 with SMTP id 1so7345173iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 28 Dec 2009 08:10:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1261988312.22470.5.camel@johannes.local>
References: <1261970308-22926-1-git-send-email-yi.zhu@intel.com>
	<1261988312.22470.5.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 28 Dec 2009 08:10:10 -0800
Message-ID: <43e72e890912280810o6a2d3f9dye562c75061e1f486@mail.gmail.com>
Subject: Re: [PATCH] mac80211: delete addba_resp_timer when stop Tx BA session
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 28, 2009 at 12:18 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-12-28 at 11:18 +0800, Zhu Yi wrote:
>> We start an one shot addba_resp_timer in ieee80211_start_tx_ba_session
>> but don't delete it in __ieee80211_stop_tx_ba_session. This will cause
>> problem in suspend and resume. When suspend happens without the timer
>> deleted, the timer handler will be called immediately after resume and
>> messes up driver status.
>>
>> See http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2134
>> comment #22 for more details.
>
> Hmm. The timer checks
>
>        if ((*state & (HT_ADDBA_REQUESTED_MSK | HT_ADDBA_RECEIVED_MSK)) !=
>                                                HT_ADDBA_REQUESTED_MSK) {
>
> which /should/ make it a no-op in the case you mention because we tear
> down sessions, or does that not reset their state properly?
>
> Ok, so ___ieee80211_stop_tx_ba_session() doesn't, in fact, clear the
> mask right away, so I think we should add HT_AGG_STATE_REQ_STOP_BA_MSK
> to the code I quoted above?

When the patch addresses the above can you cc stable if applicable.

> In any case the del_timer_sync isn't right there and we also shouldn't
> really use it (per Linus)

Why is that?

  Luis
