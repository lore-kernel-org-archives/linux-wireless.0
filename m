Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:37200 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZANSeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 13:34:14 -0500
Received: by bwz14 with SMTP id 14so2219590bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2009 10:34:12 -0800 (PST)
To: samuel@sortiz.org
Subject: Re: [PATCH] iwl3945: report killswitch changes even if the interface is down
Date: Wed, 14 Jan 2009 19:39:42 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ipw3945-devel@lists.sourceforge.net, mabbaswireless@gmail.com,
	tomas.winkler@intel.com, yi.zhu@intel.com,
	reinette.chatre@intel.com, dcbw@redhat.com
References: <200901141658.50842.helmut.schaa@gmail.com> <4db8d83d05d00146e1b2ad0921dbaedd@localhost>
In-Reply-To: <4db8d83d05d00146e1b2ad0921dbaedd@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901141939.43292.helmut.schaa@gmail.com> (sfid-20090114_193419_351352_4C84335A)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 14. Januar 2009 schrieb samuel@sortiz.org:
> 
> Hi Helmut,
> 
> On Wed, 14 Jan 2009 16:58:50 +0100, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
> > Currently iwl3945 is not able to report hw-killswitch events while the
> > interface is down. This has implications on user space tools (like
> > NetworkManager) relying on rfkill notifications to bring the interface
> > up once the wireless gets enabled through a hw killswitch.
> > 
> > Thus enable the device already in iwl3945_pci_probe instead of iwl3945_up
> > and poll the CSR_GP_CNTRL register to update the killswitch state every
> > two seconds. The polling is only needed on 3945 hardware as this adapter
> > does not use interrupts to signal rfkill changes to the driver (in case
> no
> > firmware is loaded). The firmware loading is still done in iwl3945_up.

> The patch looks good and makes sense.
> However, it would be nice to cancel the rfkill polling work once the
> firmware is loaded, as we'll then get card state notifications.

Right, missed that somehow. I'll prepare a second version tomorrow.

Thanks,
Helmut
