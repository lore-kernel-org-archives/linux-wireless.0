Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59085 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab0LAWwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 17:52:11 -0500
Received: by fxm20 with SMTP id 20so587956fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 14:52:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101130022334.GB18971@monopoli.naic.edu>
References: <1290630782-11095-1-git-send-email-kilroyd@googlemail.com>
	<20101129192628.GC8199@tuxdriver.com>
	<AANLkTincC1ETrH=562Ftc5_z-Tdv+fTd4O_HbGZkOccC@mail.gmail.com>
	<20101130022334.GB18971@monopoli.naic.edu>
Date: Wed, 1 Dec 2010 22:52:09 +0000
Message-ID: <AANLkTinnMid0U98x=RSB6Kv8cDZWenGjr2mpFNWV8CL5@mail.gmail.com>
Subject: Re: [PATCH] orinoco: abort scan on interface down
From: Dave Kilroy <kilroyd@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: sedat.dilek@gmail.com, linux-wireless@vger.kernel.org,
	Giacomo Comes <comes@naic.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 30, 2010 at 2:23 AM, Giacomo Comes <comes@naic.edu> wrote:
> On Mon, Nov 29, 2010 at 09:18:27PM +0100, Sedat Dilek wrote:
>> On Mon, Nov 29, 2010 at 8:26 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > On Wed, Nov 24, 2010 at 08:33:02PM +0000, David Kilroy wrote:
>> >> This fixes the problem causing the following trace:
>> >>
>> >> ------------[ cut here ]------------
>> >> WARNING: at linux-2.6.34/net/wireless/core.c:633 wdev_cleanup_work+0xb7/0xe0 [cfg80211]()
>> >> Hardware name: Latitude C840
>> >> Pid: 707, comm: cfg80211 Not tainted 2.6.34.7-0.5-desktop #1
>> >> Call Trace:
>> >>  [<c02065c3>] try_stack_unwind+0x173/0x190
>> >>  [<c02051cf>] dump_trace+0x3f/0xe0
>> >>  [<c020662b>] show_trace_log_lvl+0x4b/0x60
>> >>  [<c0206658>] show_trace+0x18/0x20
>> >>  [<c064e0b3>] dump_stack+0x6d/0x72
>> >>  [<c02443ae>] warn_slowpath_common+0x6e/0xb0
>> >>  [<c0244403>] warn_slowpath_null+0x13/0x20
>> >>  [<e2db5497>] wdev_cleanup_work+0xb7/0xe0 [cfg80211]
>> >>  [<c025cfa9>] run_workqueue+0x79/0x170
>> >>  [<c025d123>] worker_thread+0x83/0xe0
>> >>  [<c025fef4>] kthread+0x74/0x80
>> >>  [<c0203826>] kernel_thread_helper+0x6/0x10
>> >> ---[ end trace 3f0348b3b0c6f4ff ]---
>> >>
>> >> Reported by: Giacomo Comes <comes@naic.edu>
>> >> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
>> >> ---
>> >>
>> >> This patch has only been compile tested. Given the trace, I've
>> >> guessed that cfg80211 would prefer that orinoco abort the scan on
>> >> interface down.
>> >
>> > Any chance we can get a Tested-by on this one, so I can feel good
>> > about sending it for 2.6.37?

> As I reported in another e-mail, with the patch, the trace is gone.
> Unfortunatly it doesn't help make the wireles card work with WPA.

Sorry for the delay in getting back to you, John. I see you've already
added the patch to wireless-2.6

FWIW, I've reproduced the original trace with an orinoco_usb device
and verified that this patch fixes it.

Dave.
