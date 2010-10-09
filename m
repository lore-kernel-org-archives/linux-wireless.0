Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62817 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab0JIPiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 11:38:07 -0400
Received: by bwz15 with SMTP id 15so888250bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Oct 2010 08:38:05 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/3] cfg80211: add channel utilization stats to the survey command
Date: Sat, 9 Oct 2010 17:37:16 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, br1@einfach.org
References: <1286584771-76663-1-git-send-email-nbd@openwrt.org> <201010091417.25727.helmut.schaa@googlemail.com> <4CB06966.9070905@openwrt.org>
In-Reply-To: <4CB06966.9070905@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010091737.17000.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag 09 Oktober 2010 schrieb Felix Fietkau:
> On 2010-10-09 2:17 PM, Helmut Schaa wrote:
> > Am Samstag 09 Oktober 2010 schrieb Felix Fietkau:
> >> Using these, user space can calculate a relative channel utilization
> >> with arbitrary intervals by regularly taking snapshots of the survey
> >> results.
> > 
> > What if you've got multiple consumers, wouldn't that mess up the
> > survey results?
> > 
> > I mean, for example mac80211 and/or hostapd might want to use the busy time
> > statistics for the BSS load IE while a different userspace process might
> > want to monitor the channel utilization in order to detect a worsening
> > channel condition.
> > 
> > If the consumers happen to use the same interval and request the survey
> > very soon after each other one consumer will get the values on a nice (close
> > to the query interval) time base while the other one will get the values
> > based on a very small interval (which might lower the value's
> > representativeness).
> Multiple consumers work just fine, since the survey results are relative
> to the time the hardware started using the channel, not relative to the
> last request. Maybe my description was a bit unclear on that part.

Ah, thanks Felix, I only read the comment, not the code :)

So, the busy time statistics for channel i are gathered starting with the
switch to i. Hence, if a user space process would like to measure multiple
channels it will just switch through all of them and call get survey right
before switching to the next one, right?

However, if we think about the BSS load IE we might want to measure the busy
times without switching the channel? But we'd like have a somewhat actual
value and not an average throughout the last minute/hour or so. Any ideas how
to integrate that into your approach?

Helmut
