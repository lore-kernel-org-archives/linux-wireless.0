Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbcCSJAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2016 05:00:39 -0400
Date: Sat, 19 Mar 2016 09:58:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] rt2x00usb: Use usb anchor to manage URB
Message-ID: <20160319085820.GB29771@redhat.com> (sfid-20160319_100045_526989_14393CA7)
References: <1458318591-14921-1-git-send-email-vishalthanki@gmail.com>
 <20160319080627.GA29771@redhat.com>
 <CAC3a_SAz0EdriULfGqnpVqQ+jfKDqsSgQEgy9KKovLBzMktg5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAC3a_SAz0EdriULfGqnpVqQ+jfKDqsSgQEgy9KKovLBzMktg5Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 19, 2016 at 09:21:52AM +0100, Vishal Thanki wrote:
> On Sat, Mar 19, 2016 at 9:06 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Fri, Mar 18, 2016 at 05:29:51PM +0100, Vishal Thanki wrote:
> >>
> >> @@ -1001,6 +1002,9 @@ struct rt2x00_dev {
> >>
> >>       /* Extra TX headroom required for alignment purposes. */
> >>       unsigned int extra_tx_headroom;
> >> +
> >> +     struct usb_anchor *anchor;
> >> +     void (*kill_anchored_urbs)(struct rt2x00_dev *);
> > ...
> >> @@ -1423,6 +1423,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
> >>       cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
> >>       cancel_work_sync(&rt2x00dev->sleep_work);
> >>       if (rt2x00_is_usb(rt2x00dev)) {
> >> +             rt2x00dev->kill_anchored_urbs(rt2x00dev);
> > ...
> >>
> >> +static void rt2x00usb_kill_anchored_usb(struct rt2x00_dev *rt2x00dev)
> >> +{
> >> +     usb_kill_anchored_urbs(rt2x00dev->anchor);
> >> +}
> > ...
> >> +     rt2x00dev->kill_anchored_urbs = rt2x00usb_kill_anchored_usb;
> >
> > Why do you complicate things, instead of call usb_kill_anchored_urbs()
> > directly?
> >
> 
> I tried to compile by disabling the CONFIG_USB from kernel, and was getting
> error for missing symbol usb_kill_anchored_urbs.

Ok, just around if(rt2x00_is_usb) section by #ifdef RT2X00_LIB_USB. Or
you can try to modify rt2x00_is_usb to always return false if RT2X00_LIB_USB
is not configured - perhaps that will also prevent compilation failure
without USB support.

Stanislaw
