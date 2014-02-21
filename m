Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35991 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaBUI2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:28:23 -0500
Message-ID: <1392971299.4346.20.camel@jlt4.sipsolutions.net> (sfid-20140221_092826_361424_4C2CDF1D)
Subject: Re: [PATCH] cfg80211: regulatory, introduce NL80211_RRF_AUTO_BW
 rule flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	John Linville <linville@tuxdriver.com>
Date: Fri, 21 Feb 2014 09:28:19 +0100
In-Reply-To: <CALhHN=oXr+PpiGv47sVzoi2cW_PYDME63sZ7euwtDaoVwnarTA@mail.gmail.com> (sfid-20140221_092320_949861_A75C5CB5)
References: <1392900736-2808-1-git-send-email-janusz.dziedzic@tieto.com>
	 <CALhHN=oXr+PpiGv47sVzoi2cW_PYDME63sZ7euwtDaoVwnarTA@mail.gmail.com>
	 (sfid-20140221_092320_949861_A75C5CB5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-21 at 09:23 +0100, Janusz Dziedzic wrote:

> # must match <linux/nl80211.h> enum nl80211_reg_rule_flags

Well, it already doesn't:

> flag_definitions = {
>     'NO-OFDM': 1<<0,
>     'NO-CCK': 1<<1,
>     'NO-INDOOR': 1<<2,
>     'NO-OUTDOOR': 1<<3,
>     'DFS': 1<<4,
>     'PTP-ONLY': 1<<5,
>     'PTMP-ONLY': 1<<6,

Those are fine, and have been like this forever.

>     'NO-IR':        1<<7,
>     # hole at bit 8

These used to be PASSIVE-SCAN and NO-IBSS, but bit 8 is still reserved
in the kernel.

>     # hole at bit 9. FIXME: Where is NO-HT40 defined?
>     'NO-HT40': 1<<10,

Neither bit 9 nor bit 10 were ever used by the kernel.

Did old userspace create them?

> Which definition is correct now? Should I remove bit9 and bit10 from
> wireless-regdb or skip them in nl80211.h?

Since it's safer to not even have to worry about it, I'll change your
patch to use bit 11.

However, Luis, please sort out this situation, and if bits 9/10 were
ever used by userspace (they were never used by the kernel!) then please
submit a kernel patch that marks them as reserved in nl80211.h. The
kernel header file should be the master file defining the API, not some
"random" userspace tool.

johannes

