Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm25-vm7.bullet.mail.ird.yahoo.com ([212.82.109.208]:43481 "HELO
	nm25-vm7.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761722Ab2EQLtb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 07:49:31 -0400
Message-ID: <1337254979.3782.YahooMailClassic@web29405.mail.ird.yahoo.com> (sfid-20120517_134935_469690_4C3DFB5C)
Date: Thu, 17 May 2012 12:42:59 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: ->brightness_set can not sleep
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@canonical.com>
In-Reply-To: <4FB3BD4A.5020509@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



--- On Wed, 16/5/12, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 05/16/2012 04:06 AM, Stanislaw
> Gruszka wrote:
> > Fix:
> >
> > BUG: sleeping function called from invalid context at
> kernel/workqueue.c:2547
> > in_atomic(): 1, irqs_disabled(): 0, pid: 629, name:
> wpa_supplicant
> > 2 locks held by wpa_supplicant/629:
> >   #0:  (rtnl_mutex){+.+.+.}, at:
> [<c08b2b84>] rtnl_lock+0x14/0x20
> >   #1: 
> (&trigger->leddev_list_lock){.+.?..}, at:
> [<c0867f41>] led_trigger_event+0x21/0x80
> > Pid: 629, comm: wpa_supplicant Not tainted
> 3.3.0-0.rc3.git5.1.fc17.i686
> > Call Trace:
> >   [<c046a9f6>]
> __might_sleep+0x126/0x1d0
> >   [<c0457d6c>]
> wait_on_work+0x2c/0x1d0
> >   [<c045a09a>]
> __cancel_work_timer+0x6a/0x120
> >   [<c045a160>]
> cancel_delayed_work_sync+0x10/0x20
> >   [<f7dd3c22>]
> rtl8187_led_brightness_set+0x82/0xf0 [rtl8187]
> >   [<c0867f7c>]
> led_trigger_event+0x5c/0x80
> >   [<f7ff5e6d>]
> ieee80211_led_radio+0x1d/0x40 [mac80211]
> >   [<f7ff3583>]
> ieee80211_stop_device+0x13/0x230 [mac80211]
> >
> > Removing _sync is ok, because if led_on work is
> currently running
> > it will be finished before led_off work start to
> perform, since
> > they are always queued on the same mac80211
> local->workqueue.
> >
> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=795176
> >
> > Signed-off-by: Stanislaw Gruszka<sgruszka@redhat.com>
> > ---
> 
> ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

I haven't had any problem with suspend though, mostly because I don't have an Led'ed device.

Hin-Tak


