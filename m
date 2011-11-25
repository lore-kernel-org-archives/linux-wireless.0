Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41593 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1KYBD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 20:03:56 -0500
Received: by wwp14 with SMTP id 14so2667833wwp.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 17:03:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322147800.5366.24.camel@jlt3.sipsolutions.net>
References: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
 <1322080347-7644-5-git-send-email-thomas@cozybit.com> <1322147800.5366.24.camel@jlt3.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 24 Nov 2011 17:03:34 -0800
Message-ID: <CAG6hwVNrOcfjx8HVEz=-mmMCp0QZjuyQKRS2YWUBNzD-kXJLxg@mail.gmail.com> (sfid-20111125_020359_261532_7DD2582B)
Subject: Re: [PATCH 4/7] mac80211: fix forwarded mesh frame queue mapping
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 24, 2011 at 7:16 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> +/* Indicate which queue to use for this fully formed 802.11 frame */
>> +u16 ieee80211_select_queue_cooked(struct ieee80211_local *local,
>> +                               struct sk_buff *skb,
>> +                               struct ieee80211_hdr *hdr) {
>
> Where's that opening brace? ;-)

Good catch, looked fine to me :)
>
> Can't say I like the name -- maybe select_queue_80211 or so would be
> better? The "cooked" term is really only relevant for the special case
> of monitor interfaces for AP mode that I'm even trying to get rid of ...
>

OK, I understood "cooked" to be analogous to "802.11 frame", but
_80211 is probably clearer. v2 coming shortly.

Thanks!
Thomas
