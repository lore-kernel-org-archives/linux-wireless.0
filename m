Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbcGGAsA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 20:48:00 -0400
Date: Thu, 7 Jul 2016 02:47:57 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	lede-dev@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@kernel.org>,
	ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, nbd@nbd.name, mark.rutland@arm.com,
	robh+dt@kernel.org, arend.vanspriel@broadcom.com,
	Mathias Kresin <dev@kresin.me>, kvalo@codeaurora.org
Subject: Re: [PATCH RFC v3 3/3] ath9k: parse the device configuration from an
 OF node
Message-ID: <20160707004757.GE31219@wotan.suse.de> (sfid-20160707_024805_076014_1A4BB4BA)
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
 <2421107.Vh3zsAgVDf@debian64>
 <CAFBinCBtjv4XoUyO6007hs0Aiut-mFxeq9jdEBq9d22dqzTvLw@mail.gmail.com>
 <1973511.3caevZ3pSB@debian64>
 <CAFBinCAh+mdG3Lh6+aS2oAZXxhuapSf34eDfxgUjmCSvWeg-fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFBinCAh+mdG3Lh6+aS2oAZXxhuapSf34eDfxgUjmCSvWeg-fw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 27, 2016 at 01:38:43AM +0200, Martin Blumenstingl wrote:
> On Sat, Jun 25, 2016 at 9:26 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > I've added lede-dev and Luis since this is relevant for them.
> > Maybe between the sysloadfw.sh and owl-loader, there's another
> > solution we overlooked so far? I know Luis has been digging
> > around in the firmware_class and added the sysdata API. But
> > from what I can tell, this would ?break? LEDE/OpenWRT's
> > userspace helper, since the sysfs interface in
> > /sys/class/firmware which is used by procd to upload the data
> > is gone with sysdata or am I wrong?
> good idea to keep lede-dev in the loop, as they will be affected (in
> my opinion: positively) by this change.

We cannot remove the /sys/class/firmware usermode helper, it however should be
compartamentalized to only a few device drivers that we *know* definitely need
it. So far there are only 2 device drivers that we've identified as needing it
and as such only those drivers should implicate use of it.

In the future, should the sysdata API get merged, the implications are that the
further features of the firmware API will be added for sysdata users, but
perhaps not for the old API as that entails silly collateral evolutions to
the API or new exported symbols.

I highly encourage use of the usermode helper to be reconsidered and simply
abandoned. There are many reasons why it was a bad idea, for details refer to
the thread [0].

[0] https://lkml.kernel.org/r/1466117661-22075-1-git-send-email-mcgrof@kernel.org

  Luis
