Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailserver.naic.edu ([192.65.176.45]:44647 "EHLO
	mailserver.naic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0K3CXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 21:23:45 -0500
Date: Mon, 29 Nov 2010 22:23:34 -0400
From: Giacomo Comes <comes@naic.edu>
To: sedat.dilek@gmail.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
	David Kilroy <kilroyd@gmail.com>,
	linux-wireless@vger.kernel.org, comes@naic.edu,
	David Kilroy <kilroyd@googlemail.com>
Subject: Re: [PATCH] orinoco: abort scan on interface down
Message-ID: <20101130022334.GB18971@monopoli.naic.edu>
References: <1290630782-11095-1-git-send-email-kilroyd@googlemail.com> <20101129192628.GC8199@tuxdriver.com> <AANLkTincC1ETrH=562Ftc5_z-Tdv+fTd4O_HbGZkOccC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTincC1ETrH=562Ftc5_z-Tdv+fTd4O_HbGZkOccC@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 29, 2010 at 09:18:27PM +0100, Sedat Dilek wrote:
> On Mon, Nov 29, 2010 at 8:26 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Wed, Nov 24, 2010 at 08:33:02PM +0000, David Kilroy wrote:
> >> This fixes the problem causing the following trace:
> >>
> >> ------------[ cut here ]------------
> >> WARNING: at linux-2.6.34/net/wireless/core.c:633 wdev_cleanup_work+0xb7/0xe0 [cfg80211]()
> >> Hardware name: Latitude C840
> >> Pid: 707, comm: cfg80211 Not tainted 2.6.34.7-0.5-desktop #1
> >> Call Trace:
> >>  [<c02065c3>] try_stack_unwind+0x173/0x190
> >>  [<c02051cf>] dump_trace+0x3f/0xe0
> >>  [<c020662b>] show_trace_log_lvl+0x4b/0x60
> >>  [<c0206658>] show_trace+0x18/0x20
> >>  [<c064e0b3>] dump_stack+0x6d/0x72
> >>  [<c02443ae>] warn_slowpath_common+0x6e/0xb0
> >>  [<c0244403>] warn_slowpath_null+0x13/0x20
> >>  [<e2db5497>] wdev_cleanup_work+0xb7/0xe0 [cfg80211]
> >>  [<c025cfa9>] run_workqueue+0x79/0x170
> >>  [<c025d123>] worker_thread+0x83/0xe0
> >>  [<c025fef4>] kthread+0x74/0x80
> >>  [<c0203826>] kernel_thread_helper+0x6/0x10
> >> ---[ end trace 3f0348b3b0c6f4ff ]---
> >>
> >> Reported by: Giacomo Comes <comes@naic.edu>
> >> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
> >> ---
> >>
> >> This patch has only been compile tested. Given the trace, I've
> >> guessed that cfg80211 would prefer that orinoco abort the scan on
> >> interface down.
> >
> > Any chance we can get a Tested-by on this one, so I can feel good
> > about sending it for 2.6.37?
> 
> I was looking for an old PCMCIA orinoco hermes-I or -II card, but I
> found a cheat sheet from my very first Linux book from Michael Kofler.
> Which key on a EN/US keyboard is equivalent to the one on a DE
> keyboard, nice catch :-).
> Will look in the other cartons in the cellar...
> 
As I reported in another e-mail, with the patch, the trace is gone.
Unfortunatly it doesn't help make the wireles card work with WPA.

Giacomo
