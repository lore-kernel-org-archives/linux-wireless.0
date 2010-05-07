Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35250 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0EGWaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 18:30:13 -0400
Date: Fri, 7 May 2010 18:04:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: set IEEE80211_TX_CTL_FIRST_FRAGMENT for beacons
Message-ID: <20100507220452.GA11746@tuxdriver.com>
References: <1273171517-6264-1-git-send-email-linville@tuxdriver.com>
 <k2t43e72e891005061501h91e475f6q6cb8bc7c3bbec990@mail.gmail.com>
 <20100507001319.GA6990@tuxdriver.com>
 <20100507023519.GA7240@tuxdriver.com>
 <p2s43e72e891005071443k348a2802u51dcdc8a549ed84c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <p2s43e72e891005071443k348a2802u51dcdc8a549ed84c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 07, 2010 at 02:43:44PM -0700, Luis R. Rodriguez wrote:
> On Thu, May 6, 2010 at 7:35 PM, John W. Linville <linville@tuxdriver.com> wrote:
> > On Thu, May 06, 2010 at 08:13:20PM -0400, John W. Linville wrote:
> >> On Thu, May 06, 2010 at 03:01:25PM -0700, Luis R. Rodriguez wrote:
> >> > On Thu, May 6, 2010 at 11:45 AM, John W. Linville
> >> > <linville@tuxdriver.com> wrote:
> >> >
> >> > Why though?
> >>
> >> Because it is correct, appropriate, and zero additional cost.  And
> >> because if you use the same tx path for beacons as you use for normal
> >> frames and if in that path you manage the sequence number in software
> >> you should be checking that flag before bumping the sequence number.
> >
> > That isn't worded too clearly...  If you manage the sequence number
> > in software then you should be checking that flag before bumping
> > the sequence number.  If you use the same tx path for beacons as is
> > used for normal frames and you don't set that flag for beacons,
> > then beacons will reuse the sequence number from the previous frame.
> >
> > Does that make sense?
> 
> Yeah, thanks, perhaps the documentation should be expanded for this on
> the mac80211.h. This verbiage might also come in handy on the commit
> log. What do you think?

Well, now that you mention it (from mac80211.h):

 * @IEEE80211_TX_CTL_ASSIGN_SEQ: The driver has to assign a sequence
 *      number to this frame, taking care of not overwriting the fragment
 *      number and increasing the sequence number only when the
 *      IEEE80211_TX_CTL_FIRST_FRAGMENT flag is set. mac80211 will properly
 *      assign sequence numbers to QoS-data frames but cannot do so correctly
 *      for non-QoS-data and management frames because beacons need them from
 *      that counter as well and mac80211 cannot guarantee proper sequencing.
 *      If this flag is set, the driver should instruct the hardware to
 *      assign a sequence number to the frame or assign one itself. Cf. IEEE
 *      802.11-2007 7.1.3.4.1 paragraph 3. This flag will always be set for
 *      beacons and always be clear for frames without a sequence number field.

Seems like we should have been setting that for beacons the whole time...

Anyway, I already committed it as it is -- it is a fairly simple patch.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
