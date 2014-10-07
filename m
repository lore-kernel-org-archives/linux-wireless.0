Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46331 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaJGNn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 09:43:29 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so9343269wgh.22
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2014 06:43:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412671748.1825.4.camel@jlt4.sipsolutions.net>
References: <1412232304-7588-1-git-send-email-michal.kazior@tieto.com>
	<1412671748.1825.4.camel@jlt4.sipsolutions.net>
Date: Tue, 7 Oct 2014 15:43:27 +0200
Message-ID: <CA+BoTQmrsA9Sk12ePaSaNqox2YOPjG0yqB2avRcB+a4qFgmz+w@mail.gmail.com> (sfid-20141007_154332_870967_77DD1282)
Subject: Re: [RFC] mac80211: enable DFS with channel contexts
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 October 2014 10:49, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-10-02 at 08:45 +0200, Michal Kazior wrote:
>> It is okay to enable DFS for channel contexts
>> based drivers as long as no combination advertises
>> radar detection and multi-channel operation at the
>> same time.
>
> Don't we already check the latter in cfg80211?

Correct. However ieee80211_radar_detected() takes only ieee80211_hw as
an argument now. Skipping this check in mac80211 might bite later if
someone extends cfg80211 later for multi-channel radar detection with
non-mac80211 driver in mind and forgets about updating mac80211.

Or are you okay with relying on the cfg80211 check alone? If so I'll
update the patch.


Michał
