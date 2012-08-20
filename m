Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33600 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2HTGf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 02:35:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120817212007.6a77cbb8@emcraft.com>
References: <20120817212007.6a77cbb8@emcraft.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 20 Aug 2012 11:35:06 +0500
Message-ID: <CAB=NE6WRP3eZQ6ZZTGy_9=v1hf05evH4fAEjPMMWAkcNEXt0yg@mail.gmail.com> (sfid-20120820_083532_436587_7DE16BC2)
Subject: Re: [PATCH] compat-wireless:rt2800usb: Added rx packet length
 validity check
To: Sergei Poselenov <sposelenov@emcraft.com>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	backports@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 17, 2012 at 9:20 PM, Sergei Poselenov
<sposelenov@emcraft.com> wrote:
>
> On our system (ARM Cortex-M3 SOC running linux-2.6.33 with
> compat-wireless-3.4-rc3-1 modules configured for rt2x00) frequent
> crashes were observed in rt2800usb module because of the invalid
> length of the received packet (3392, 46920...). This patch adds
> the sanity check on the packet legth. In case of the bad length,
> mark the packet as with CRC error.

Nice find! However this is a *real* patch that must go upstream, so
you should submit it to the rt2800usb maintainers and also mark the
patch as a stable fix. You mark the patch as a stable fix by appending
at the bottom of the commit log message: Cc: stable@vger.kernel.org.
For example:

commit e19f15ac6437624b6214b2f0ec0d69fb7eb205fa
Author: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Date:   Thu Aug 9 12:37:26 2012 +0530

    ath9k: stop btcoex on device suspend

    During suspend, the device will be moved to FULLSLEEP state.
    As btcoex is never been stopped, the btcoex timer is running
    and tries to access hw on fullsleep state. Fix that.

    Cc: stable@vger.kernel.org
    Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Once you submit if you want it merged into a stable compat-wireless
release even before Greg Kroah-Hartman can apply it and make a new
3.4.10 release (by the time you submit maybe 3.4.11 maybe) you can
send the patch to be applied to the driver in compat-wirelss by
submitting it to be part of the linux-next-pending/ directory. In
there are patches that are at least posted publicly. The format of the
patch there is to be in a full patch. If you have doubts check out the
compat-wireless-3.5.1-1-snpc.tar.bz2 release which has patches in all
of these directories:

  * pending-stable/
  * linux-next-pending/
  * linux-next-cherry-picks/
  * crap/

At this point you may also want to consider upgrading to
compat-wireless-3.5.1-1-snpc.tar.bz2. I should note that to send
patches for the 3.4 stable release of compat-wireless you should use
the linux-3.4.y branch. The same applies to the 3.5 release, you'd use
the linux-3.5.y branch. Except for patches for files in the above
directories I also require all patches merged into the stable branches
to be in the master branch first -- this follows the kernel's on
policy on stable releases.

The compat-wireless project is also now renamed to "compat-drivers"
and we have a new mailing list and home page for the project. New
releases based under the new name will start as of the v3.7 releases.
For more details please see:

https://backports.wiki.kernel.org

Please have a read here with regards for documentation of the
additional patches for compat-drivers.

https://backports.wiki.kernel.org/index.php/Documentation/compat-drivers/additional-patches

  Luis
