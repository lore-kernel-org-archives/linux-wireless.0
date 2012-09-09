Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38495 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2IIJQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2012 05:16:00 -0400
Received: by ieje11 with SMTP id e11so1416345iej.19
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2012 02:16:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347029656-41430-2-git-send-email-nbd@openwrt.org>
References: <1347029656-41430-1-git-send-email-nbd@openwrt.org> <1347029656-41430-2-git-send-email-nbd@openwrt.org>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 9 Sep 2012 12:15:44 +0300
Message-ID: <CA+XVXffd4DcP+8PQa=meV0AADS-WY0um=xOQmwZnqaR=DPjGkg@mail.gmail.com> (sfid-20120909_111605_061716_0E692CAD)
Subject: Re: [PATCH 2/2] mac80211: prevent work queueing while quiescing on suspend
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 7, 2012 at 5:54 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Do not emit a warning in that case, since there is nothing else in mac80211
> that would effectively prevent more work from being queued.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

This is a bit problematic. You see we rely on this always working
(prior to the suspend handler) to handle the case of HW reconfig
before suspend.

The better option for wlcore would be to flush the workqueue again
after setting suspended = true, but i'm not sure if it's possible.

At the very least we'll have to know the work was not queued (via a ret val?).
