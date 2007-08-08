Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33209 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509AbXHHWhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 18:37:46 -0400
Date: Wed, 8 Aug 2007 15:37:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: arm allmodconfig
Message-Id: <20070808153707.eda9a3b2.akpm@linux-foundation.org>
In-Reply-To: <20070808153208.49fb7211.akpm@linux-foundation.org>
References: <20070808145705.756597b0.akpm@linux-foundation.org>
	<200708090013.06846.mb@bu3sch.de>
	<20070808152606.9ea3010f.akpm@linux-foundation.org>
	<20070808153208.49fb7211.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 8 Aug 2007 15:32:08 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Probably a dependency on HAS_IOMEM will fix that uup.

So to get around this I deleted the CONFIG_SSB=m from .config and ran
oldconfig.  Whoop, it magically reappeared!  Irritating.  Investigates.

omg.

 Symbol: SSB [=m]
  x Prompt: Sonics Silicon Backplane support
  x   Defined at drivers/ssb/Kconfig:3
  x   Depends on: EXPERIMENTAL && HAS_IOMEM
  x   Location:
  x     -> Device Drivers
  x       -> Sonics Silicon Backplane
  x   Selected by: B44 && NETDEVICES && NET_ETHERNET && HAS_IOMEM || BCM43XX_MAC80211 && NETDEVICES && !S390 && MAC80211 && WLAN_80211 && EXPERIMENTAL

you'll never be able to get that to work.  If by some miracle you do, you
will not be able to maintain it.  select is just that bad, and that
expression!!!

We've been struggling with SSB Kconfig for weeks and it's nowhere near
right yet.

Please, do consider switching the whole lot to `depends on'.
