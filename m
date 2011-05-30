Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab1E3JxV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 05:53:21 -0400
Date: Mon, 30 May 2011 11:52:59 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-2.6] rt2x00: fix rmmod crash
Message-ID: <20110530095259.GB2417@redhat.com> (sfid-20110530_115329_201302_91562E3C)
References: <20110529104529.GA2769@localhost.localdomain>
 <4DE278CD.3030708@gmail.com>
 <20110529204200.GA2472@localhost.localdomain>
 <4DE3380C.2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DE3380C.2@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 30, 2011 at 08:24:12AM +0200, Gertjan van Wingerde wrote:
> On 05/29/11 22:42, Stanislaw Gruszka wrote:
> > On Sun, May 29, 2011 at 06:48:13PM +0200, Gertjan van Wingerde wrote:
> >> On 05/29/11 12:45, Stanislaw Gruszka wrote:
> >>> Do not destroy workqueue, which still can be used by autowakeup_work,
> >>> before ieee80211_unregister_hw() is called.
> >>>
> >>> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
> >>
> >> Could you add some details of the crash here, e.g. the stack trace of when this occurs, so that
> >> we can understand what is exactly happening that is causing the crash, for our education.
> > 
> > Crash is in workqueue code in interrupt context, there is no indication about rt2x00 blame in
> > the calltrace, but crash happen directly after rmmod rt73usb, here is a photo:
> > https://bugzilla.kernel.org/attachment.cgi?id=59992 
> 
> OK. Thanks for the info.
> 
> Could you create a v2 of the patch that:
> 1. Includes a reference to the bugzilla entry that the patch is resolving.

It does not solve the bugzilla,
https://bugzilla.kernel.org/show_bug.cgi?id=32132
I put image there, because of temporally lack of opportunity to put
it in some better place. Sorry.

> 2. Cc's the stable team.

It's not stable fix, this bug was introduced currently by

commit 1c0bcf89d85cc97a0d9ce4cd909351a81fa4fdde
Author: Ivo van Doorn <ivdoorn@gmail.com>
Date:   Sat Apr 30 17:18:18 2011 +0200

    rt2x00: Add autowake support for USB hardware

Thanks
Stanislaw
