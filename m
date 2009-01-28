Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:35741 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZA1LwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 06:52:21 -0500
Received: by fg-out-1718.google.com with SMTP id 13so526705fge.17
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 03:52:17 -0800 (PST)
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
Date: Wed, 28 Jan 2009 13:52:17 +0200
Message-ID: <1ba2fa240901280352o56ccbc07h50c7a4bfcd0ac9ab@mail.gmail.com> (sfid-20090128_125224_933169_1DA3A10E)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Tomas Winkler <tomasw@gmail.com>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: Jason Andryuk <jandryuk@gmail.com>,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 1:37 PM, Samuel Ortiz <samuel@sortiz.org> wrote:
> On Wed, Jan 28, 2009 at 09:12:48AM +0200, Tomas Winkler wrote:
>> On Wed, Jan 28, 2009 at 1:31 AM, Jason Andryuk <jandryuk@gmail.com> wrote:
>> >> No, that's just a consequence of the bug, not the bug itself.
>> >> Would you mind applying this patch on top of your latest wireless-testing tree
>> >> and testing 3945 with it ? Thanks for your patience.
>> >
>> > The patch did not cleanly apply, but I just removed the lines
>> > indicated in the patch.  It crashed with a NULL pointer dereference.
>>
>> Samuel
>> It was really wrong try, you cannot just leave place where firmware
>> updated read pointer unallocated. I would rather focus on differences
>> introduced by this patch.
> Well, that's what I did. I neglected to check if rb_stts were actually used.
>
>
>> commit 738910c064ff461051cd37e17199f270ff88a9a3 iwl3945: use rx queue
>> management infrastructure from iwlcore is the first to trigger the
>> BUG_ON. However, prior versions would dereference a NULL pointer
>> before the driver could get far enough to trigger the BUG_ON.
> I know, that's what Jason described.
> I think I now understand why. Prior to
> 738910c064ff461051cd37e17199f270ff88a9a3, you introduced
> c2a0aa3cb733452e749727680e380dca6cc10a68 without actually allocating the
> rb_stts pointer, which was really wrong too.

Yes I made mistake then I tought that 3945 take also init path of agn
already... Now it's hard to besect :(.
I suspect the rx queue managment infrastructure more because we brohgt
iwlagn bug into 3945 I guess it wrong rx buffer index handling. It's
really important we nail it now this will solve also our troubles in
iwlagn, where it get lost upon tons of patches.

Thanks
Tomas
