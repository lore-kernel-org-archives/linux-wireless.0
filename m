Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab1EaJcb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 05:32:31 -0400
Date: Tue, 31 May 2011 11:32:02 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-2.6] rt2x00: fix rmmod crash
Message-ID: <20110531093201.GA15266@redhat.com> (sfid-20110531_113235_918522_09C586DF)
References: <20110529104529.GA2769@localhost.localdomain>
 <BANLkTinABm=J0eZnwAjkYPwA1e3AgoFW6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTinABm=J0eZnwAjkYPwA1e3AgoFW6Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

On Mon, May 30, 2011 at 08:25:37PM +0200, Ivo Van Doorn wrote:
> On Sun, May 29, 2011 at 12:45 PM, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> > Do not destroy workqueue, which still can be used by autowakeup_work,
> > before ieee80211_unregister_hw() is called.
> 
> Well isn't the bug then that autowakeup_work isn't cancelled using
> cancel_work_sync
> like the other workqueue tasks?
> 
> I rather add the call to cancel_work_sync then moving the killing of
> the workqueue.
> The position where the workqueue is destroyed should be the place
> where we cancel
> all scheduled work, that way we can assume no rt2x00-related threads ater this
> position.

rt2x00lib_config() could be running simultaneously to rt2x00lib_remove_dev()
and queue just canceled autowake_work again into (just destroyed) workqueue.
Other solution to fix, would be use ieee80211_queue_work() instead of custom
workqueue, is that better?

Stanislaw
