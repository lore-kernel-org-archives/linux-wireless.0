Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39481 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2IIL7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2012 07:59:39 -0400
Received: by iahk25 with SMTP id k25so967926iah.19
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2012 04:59:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXffd4DcP+8PQa=meV0AADS-WY0um=xOQmwZnqaR=DPjGkg@mail.gmail.com>
References: <1347029656-41430-1-git-send-email-nbd@openwrt.org>
 <1347029656-41430-2-git-send-email-nbd@openwrt.org> <CA+XVXffd4DcP+8PQa=meV0AADS-WY0um=xOQmwZnqaR=DPjGkg@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 9 Sep 2012 14:59:24 +0300
Message-ID: <CA+XVXffRW-r6xqsh8GhfvMxxEiCfk-5QJO+CEQcapSXY8SBsYg@mail.gmail.com> (sfid-20120909_135943_251911_AF37F4B4)
Subject: Re: [PATCH 2/2] mac80211: prevent work queueing while quiescing on suspend
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 9, 2012 at 12:15 PM, Arik Nemtsov <arik@wizery.com> wrote:
> On Fri, Sep 7, 2012 at 5:54 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Do not emit a warning in that case, since there is nothing else in mac80211
>> that would effectively prevent more work from being queued.
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>
> This is a bit problematic. You see we rely on this always working
> (prior to the suspend handler) to handle the case of HW reconfig
> before suspend.
>
> The better option for wlcore would be to flush the workqueue again
> after setting suspended = true, but i'm not sure if it's possible.
>
> At the very least we'll have to know the work was not queued (via a ret val?).

Actually this is problematic in general, as lower level driver use
ieee80211_queue_work for day to day stuff, and are not aware of
mac80211 state (was pointed out by Eliad).

While it makes sense to expect a driver to not queue work after its
suspend handler is called, you're doing something quite different
here.
So adding a retval is not good enough, as it's a big API change for
the drivers, that suddenly have to check every queue_work call.

Maybe turning this into a freezable wq is a good idea? Maybe just fail
works queued from within mac80211? (but that can be done from inside
by just checking the quiescing flag inside the work)
