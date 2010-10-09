Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41817 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab0JISqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 14:46:16 -0400
Received: by fxm14 with SMTP id 14so1020499fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Oct 2010 11:46:15 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/3] cfg80211: add channel utilization stats to the survey command
Date: Sat, 9 Oct 2010 20:45:26 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, br1@einfach.org
References: <1286584771-76663-1-git-send-email-nbd@openwrt.org> <201010091737.17000.helmut.schaa@googlemail.com> <4CB09937.7040001@openwrt.org>
In-Reply-To: <4CB09937.7040001@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010092045.26840.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag 09 Oktober 2010 schrieb Felix Fietkau:
> On 2010-10-09 5:37 PM, Helmut Schaa wrote:
> > However, if we think about the BSS load IE we might want to measure the busy
> > times without switching the channel? But we'd like have a somewhat actual
> > value and not an average throughout the last minute/hour or so. Any ideas how
> > to integrate that into your approach?
> Just grab a survey dump when starting up, then another after a
> minute/hour, and subtract the values of the last one.
> Right now there's still an overflow issue in the internal counters in
> the current ath9k implementation, so the stats are off unless you poll
> survey stats regularly. I'll send a fix for that later.

Thanks, looks alright to me then. I'll try to add a similar implementation
for rt2800 once these patches go in.

Helmut

