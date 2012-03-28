Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223Ab2C1NQY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 09:16:24 -0400
Date: Wed, 28 Mar 2012 15:15:44 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Jakub Kicinski <kubakici@wp.pl>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 2/4] rt2x00: move disabling of DMA before
 loading firmware
Message-ID: <20120328131543.GD3333@redhat.com> (sfid-20120328_151627_657213_17CD565C)
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
 <1332859867-27921-3-git-send-email-kubakici@wp.pl>
 <4F7202BB.4000904@gmail.com>
 <20120328121428.GA3333@redhat.com>
 <20120328145359.4bd5d098@north>
 <CAGRGNgWCDo7GpSOC5H-HE_uiF05wGh7FSQw5HL68XB9f8Xg5nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGRGNgWCDo7GpSOC5H-HE_uiF05wGh7FSQw5HL68XB9f8Xg5nA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wed, Mar 28, 2012 at 11:58:45PM +1100, Julian Calaby wrote:
> > Hm. I obviously did check whether FW load does overwrite WPDMA_GLO_CFG
> > and it didn't. Maybe it's device dependent? What bothers me is that now
> > we have a (very) short window between FW load and disabling DMA.
> 
> Stupid question: why not disable DMA before the FW load, then disable
> it afterwards just to make sure the hardware's in a known state after
> the FW load? - this will catch any errant firmwares out there and
> (mostly) eliminate the window between FW load and DMA disabling.

Yep, that seems to be the best approach.

Stanislaw
