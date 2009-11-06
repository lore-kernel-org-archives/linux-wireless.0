Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:42980 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550AbZKFSRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 13:17:09 -0500
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH 00/41] rewritten rt2800 drivers
Date: Fri, 6 Nov 2009 19:15:59 +0100
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <14add3d10911041219j6ab25282re4f98d14029b1f68@mail.gmail.com> <646765f40911041455m7a6f55b8ka3ce95de7dd6ac6c@mail.gmail.com>
In-Reply-To: <646765f40911041455m7a6f55b8ka3ce95de7dd6ac6c@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200911061915.59381.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009 23:55:39 Julian Calaby wrote:
> Bart,
> 
> FWIW, this all looks good to me, except for these comments:
> 
> 1. When you introduce struct rt2800_ops, it may telegraph your
> intentions more clearly if you introduce rt2800lib.h at the same time
> - this also means that we don't have (if only for a single patch)
> duplicate versions of this structure and it's associated code.

The current order is mostly the result of incremental steps leading to
the final conclusions so indeed it can be polished a bit now.

> 2. Patches #26-28 should arguably come before the conversions to use
> the struct rt2800_ops methods.

Done, also the patch adding rt2800lib.h has been moved in front the ones
adding rt2800_ops.

[ I've kept all ACKs in affected patches, I hope people are fine with it. ]

> 3. I don't get the reasoning behind patch #37 (remove useless ifdefs
> from rt2x00leds.h) but I'm going to assume that it's all right.

struct rt2x00_led is referenced in rt2800lib.h so instead of adding more
ifdefs to fix build I removed needless ones.

> 4. Patch #39 should arguably come earlier in the patch set as it's a
> general cleanup.

This was also needed to fix build (for patch #40 IIRC).

I've moved #37 and #39 near the beginning of the patch series (after
"rt2x00: fix rt2x00usb_register_read() comment" patch).

The rt2800 tree has been updated to reflect above changes (rt2800-v2.1
branch is now the current one), if somebody would like to see patches
please ping me (I think that such minor updates don't justify spamming
mailing list w/ 41 patches but that's just me).

Thanks.
-- 
Bartlomiej Zolnierkiewicz
