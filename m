Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f172.google.com ([209.85.214.172]:52795 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab0LJP46 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 10:56:58 -0500
Received: by iwn40 with SMTP id 40so5482506iwn.3
        for <linux-wireless@vger.kernel.org>; Fri, 10 Dec 2010 07:56:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101210093258.GA4703@basil.fritz.box>
References: <20101210093258.GA4703@basil.fritz.box>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 10 Dec 2010 07:56:37 -0800
Message-ID: <AANLkTimnfAbDnKQbxLrwOHTD-CFXn1TJh91PuC=2QuUM@mail.gmail.com>
Subject: Re: [ath9k-devel] .36 ath9k patches for .35-longterm
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 10, 2010 at 1:32 AM, Andi Kleen <andi@firstfloor.org> wrote:
> I sent this to the athk9 maintainers earlier, but it looks like
> Atheros' mailserver doesn't like my mailserver and I got a bounce.
> Resending to the lists.

Heh, odd.

> -Andi
>
> ----- Forwarded message from Andi Kleen <andi@firstfloor.org> -----
>
> Date: Thu, 9 Dec 2010 19:34:12 +0100
> From: Andi Kleen <andi@firstfloor.org>
> To: lrodriguez@atheros.com, nbd@openwrt.org, bjorn.smedman@venatech.se,
>        mshajakhan@atheros.com, senthilkumar@atheros.com,
>        vasanth@atheros.com, rmanoharan@atheros.com
> Cc: stable@kernel.org
> Subject: .36 ath9k patches for .35-longterm
> User-Agent: Mutt/1.5.20 (2009-06-14)
>
> Hi,
>
> I've been looking at the extremly large number of ath9k patches which are in the
> 2.6.36 stable queue:
>
> ath9k-add-locking-for-starting-the-pcu-on-rx.patch
> ath9k-add-locking-for-stopping-rx.patch
> ath9k-a-mpdu-rate-control-info-fix.patch
> ath9k-built-in-rate-control-a-mpdu-fix.patch
> ath9k-clean-up-fix-aggregation-session-flush.patch
> ath9k-fix-an-aggregation-start-related-race-condition.patch
> ath9k-fix-channel-flag-regd-issues-with-multiple-cards.patch
> ath9k-fix-enabling-ani-tx-monitor-after-bg-scan.patch
> ath9k-fix-incorrect-access-of-rate-flags-in-rc.patch
> ath9k-fix-power-save-race-conditions.patch
> ath9k-fix-regression-on-beacon-loss-after-bgscan.patch
> ath9k-fix-regression-which-disabled-ps-on-ath9k.patch
> ath9k-fix-regression-which-prevents-chip-sleep-after-cab-data.patch
> ath9k-fix-spurious-mic-failure-reports.patch
> ath9k-fix-timeout-on-stopping-rx-dma.patch
>
> Some of them apply to .35, but a lot of others do not and I found
> it difficult to decide which ones are suitable for 2.6.36

You mean for 2.6.35?

> and what
> their dependencies are.
>
> Could you guys please indicate:
> - Which patches are needed for 2.6.35
> - If they have additional dependencies for .35 please note the upstream
> commit in the standard format.

Eek, um OK, we'll give this a some good review and get back to you.
I'd like to also point out we have a few directories in the
compat-wireless-2.6.36.y branch which are used to add extra patches on
top of the stable 2.6.36.y kernel release, some of them are dragging
in pending stable patches (pending-stable/ directory), some are cherry
picked patches from linux-next (linux-next-cherry-picks/) and some are
patches posted to linux-wireless which at that time had yet to be
merged into linux-next (linux-next-pending/ ). The
compat-wireless-2.6.36-5-spn.tar.bz2 release for example contains all
of these three patch series. I should not the pending-stable patches
are *all* pending-stable patches for linux-wireless and bluetooth.

http://git.kernel.org/?p=linux/kernel/git/mcgrof/compat-wireless-2.6.git;a=tree;h=refs/heads/linux-2.6.36.y;hb=refs/heads/linux-2.6.36.y

> Right now I didn't merge any ath9x patches until this is resolved.

This will take a bit of time, as some of these patches may require
manual backport and as you noted some dependencies. Given that this is
for long term we will do some work to get this to you. Its too bad we
can't get AR9003 support in there, that's a huge set of patches
though.

  Luis
