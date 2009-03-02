Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:56408 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZCBDiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2009 22:38:00 -0500
Received: by yw-out-2324.google.com with SMTP id 5so1412763ywh.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Mar 2009 19:37:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090128113751.GA3197@sortiz.org>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <20090126114453.GB3197@sortiz.org>
	 <c4d76b3b0901261913s23427b19tbbe34ee7b4261068@mail.gmail.com>
	 <c4d76b3b0901261935n1846b675w72cfa7308d198080@mail.gmail.com>
	 <20090127162437.GA3596@sortiz.org>
	 <c4d76b3b0901271531q19578871idbc59b5a23ac868e@mail.gmail.com>
	 <1ba2fa240901272312j270eedb5x33534a9703d26e06@mail.gmail.com>
	 <20090128113751.GA3197@sortiz.org>
Date: Sun, 1 Mar 2009 22:37:57 -0500
Message-ID: <c4d76b3b0903011937p6538adbfpc0dab859a6742394@mail.gmail.com> (sfid-20090302_043806_408022_4F66CFEB)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: Tomas Winkler <tomasw@gmail.com>,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 6:37 AM, Samuel Ortiz <samuel@sortiz.org> wrote=
:
> On Wed, Jan 28, 2009 at 09:12:48AM +0200, Tomas Winkler wrote:
>> On Wed, Jan 28, 2009 at 1:31 AM, Jason Andryuk <jandryuk@gmail.com> =
wrote:
>> >> No, that's just a consequence of the bug, not the bug itself.
>> >> Would you mind applying this patch on top of your latest wireless=
-testing tree
>> >> and testing 3945 with it ? Thanks for your patience.
>> >
>> > The patch did not cleanly apply, but I just removed the lines
>> > indicated in the patch. =A0It crashed with a NULL pointer derefere=
nce.
>>
>> Samuel
>> It was really wrong try, you cannot just leave place where firmware
>> updated read pointer unallocated. I would rather focus on difference=
s
>> introduced by this patch.
> Well, that's what I did. I neglected to check if rb_stts were actuall=
y used.
>
>
>> commit 738910c064ff461051cd37e17199f270ff88a9a3 iwl3945: use rx queu=
e
>> management infrastructure from iwlcore is the first to trigger the
>> BUG_ON. However, prior versions would dereference a NULL pointer
>> before the driver could get far enough to trigger the BUG_ON.
> I know, that's what Jason described.
> I think I now understand why. Prior to
> 738910c064ff461051cd37e17199f270ff88a9a3, you introduced
> c2a0aa3cb733452e749727680e380dca6cc10a68 without actually allocating =
the
> rb_stts pointer, which was really wrong too.

I tested c2a0aa3cb733452e749727680e380dca6cc10a68 "iwl3945: use
iwl_rb_status" with the additional patches to initialize rb_stts
(copied from iwl_rx_queue_alloc) and to convert the BUG_ON to a
WARN_ON.

The driver runs without segfaulting.  So far the WARN_ON has not been
triggered, but the driver fails to finish authentication with the AP.
I receive "wlan0: authentication with AP 00:30:bd:c0:90:24 timed out"

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
