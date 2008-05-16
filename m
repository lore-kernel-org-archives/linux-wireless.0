Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbYEPWGK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 18:06:10 -0400
Subject: Re: mrv8k vs. mac80211
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1210969372.6381.40.camel@johannes.berg>
References: <1210694421.24737.19.camel@localhost.localdomain>
	 <20080516172535.GA9880@tuxdriver.com>
	 <1210969372.6381.40.camel@johannes.berg>
Content-Type: text/plain; charset=utf8
Date: Fri, 16 May 2008 18:05:20 -0400
Message-Id: <1210975520.6805.8.camel@localhost.localdomain> (sfid-20080517_000616_313338_C3508736)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-16 at 22:22 +0200, Johannes Berg wrote:
> On Fri, 2008-05-16 at 13:25 -0400, John W. Linville wrote:
> > On Tue, May 13, 2008 at 12:00:21PM -0400, Dan Williams wrote:
> > > Hi,
> > >=20
> > > mrv8k has commands that should be sent before a scan is started, =
and
> > > after a scan has finished.  There aren't really pre/post scan hoo=
ks in
> > > mac80211, though there certainly could be without too much troubl=
e.  The
> > > other possibility is to inspect the filter flags when
> > > ops->configure_filter gets called, since FIF_BCN_PRBRESP_PROMISC =
gets
> > > flipped before and after the scan.  But that seems ugly and unsta=
ble.
> > >=20
> > > Any objections to adding ops->pre_scan and ops->post_scan hooks? =
 Or
> > > should I just use the configure_filter hack...  or is there a bet=
ter
> > > way?
> >=20
> > The pre/post hooks make sense to me...Johannes?
>=20
> I don't know, sort of makes sense, but on the other hand the userspac=
e
> MLME just does it all manually anyway! What exactly do you have to do=
 to
> the hardware for scanning?

Hell if I know; but the BSD malo driver sends the pre-scan command when
the station state changes to scanning, and sends post-scan when the
station starts the association process.  I haven't gotten scanning to
return any results yet, so before anyone patches mac80211 I or Markus
need to do more work and see exactly how the pre/post scan commands are
supposed to work.

I tried to call pre and post-scan from ops->configure_filter based on
=46IF_BCN_PRBRESP_PROMISC, but turns out that configure_filter is calle=
d
from atomic context?  That means we can't send synchronous commands to
the firmware.

=EF=BB=BFBUG: scheduling while atomic: mrv8k/30507/0x10000100
Pid: 30507, comm: mrv8k Not tainted 2.6.25-14.fc9.i686 #1
[<c0424a7c>] __schedule_bug+0x4b/0x50
[<c0629c18>] schedule+0x97/0x6db
[<c0424e66>] __cond_resched+0x25/0x3b
[<c062a349>] _cond_resched+0x24/0x2f
[<f8a54152>] mrv_send_cmd_sync+0x29/0x176 [mrv8k]
[<f8a543c5>] mrv_configure_filter+0xb9/0xe4 [mrv8k]
[<f8acc2d7>] ieee80211_sta_start_scan+0x1c1/0x1fb [mac80211]
[<f8acfc1f>] ieee80211_sta_work+0x140c/0x1728 [mac80211]
[<c043cd2b>] ? getnstimeofday+0x34/0xd1
[<c043b6d6>] ? ktime_get_ts+0x45/0x49
[<c043b6ed>] ? ktime_get+0x13/0x2f
[<c043cd2b>] ? getnstimeofday+0x34/0xd1
[<c043b4ed>] ? hrtimer_start+0x124/0x12f
[<c0424bbe>] ? hrtick_set+0x97/0xe5
[<c062a22a>] ? schedule+0x6a9/0x6db
[<f8ace813>] ? ieee80211_sta_work+0x0/0x1728 [mac80211]
[<c0435ad1>] run_workqueue+0x7c/0xfb
[<c0435c06>] worker_thread+0xb6/0xc2
[<c04387e7>] ? autoremove_wake_function+0x0/0x33
[<c0435b50>] ? worker_thread+0x0/0xc2
[<c0438585>] kthread+0x3b/0x61
[<c043854a>] ? kthread+0x0/0x61
[<c0406833>] kernel_thread_helper+0x7/0x10
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


dan

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
