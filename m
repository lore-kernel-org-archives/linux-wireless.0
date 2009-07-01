Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:39342 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbZGAQ7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 12:59:10 -0400
Received: by qyk31 with SMTP id 31so1183496qyk.33
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2009 09:59:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C7973C2-BAB7-4BE3-AE88-1D59B03E6447@3folded.nl>
References: <4C7973C2-BAB7-4BE3-AE88-1D59B03E6447@3folded.nl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 1 Jul 2009 09:58:53 -0700
Message-ID: <43e72e890907010958v3e046e75m5722bb46cd7aea57@mail.gmail.com>
Subject: Re: [ath9k-devel] monitor mode parametars
To: Vania Toperich <vaniat@3folded.nl>
Cc: ath9k-devel@venema.h4ckr.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 1, 2009 at 8:05 AM, Vania Toperich<vaniat@3folded.nl> wrote:
> Hi,
>
> I am wondering how to configure monitor mode parameters for ath9k,
> specifically if N is using channel bonding and which one, lower or
> higher.
>
> Thanks for help.

I haven't tried this myself with monitor but it should work using iw:

	iw dev <devname> set freq <freq> [HT20|HT40+|HT40-]
	iw phy <phyname> set freq <freq> [HT20|HT40+|HT40-]

When done please help expand the documentation on the iw wiki:

http://wireless.kernel.org/en/users/Documentation/iw

Note that not all channels will be usable with HT40- or HT40+. If the
channel is disabled then you won't be able to use HT40. Then on
certain band edges you won't be able to use an extension channel
towards the end. This is obvious but in case you become confused for
any mac80211 driver you can specifically check the ht40 allow map
through debugfs.

For example, I get:

mcgrof@pogo ~ $ sudo mount -t debugfs debugfs /sys/kernel/debug/
mcgrof@pogo ~ $ cat /sys/kernel/debug/ieee80211/phy0/ht40allow_map
2412 HT40  +
2417 HT40  +
2422 HT40  +
2427 HT40  +
2432 HT40 -+
2437 HT40 -+
2442 HT40 -+
2447 HT40 -
2452 HT40 -
2457 HT40 -
2462 HT40 -
2467 Disabled
2472 Disabled
2484 Disabled

This stuff went in through debugfs and not through a channel flag as
Johannes wants to replaces this stuff later so we preferred to not add
it as exported userspace API, so you can only count on this being
there for the meantime.

  Luis
