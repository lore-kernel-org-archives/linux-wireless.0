Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:21855 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbYHESF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 14:05:58 -0400
Received: by nf-out-0910.google.com with SMTP id d3so970274nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2008 11:05:56 -0700 (PDT)
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
Date: Tue, 5 Aug 2008 20:30:05 +0200
Cc: Will Dyson <will.dyson@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
References: <200808041636.41189.IvDoorn@gmail.com> <8e6f94720808041821q760f8596g70a8ebc4c142989a@mail.gmail.com> <4897B037.5040300@lwfinger.net>
In-Reply-To: <4897B037.5040300@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808052030.05748.IvDoorn@gmail.com> (sfid-20080805_200605_598486_9DE4CE3D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 05 August 2008, Larry Finger wrote:
> Will Dyson wrote:
> > On Mon, Aug 4, 2008 at 10:36 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> >> Hi John,
> >>
> >> Only 5 patches, but they do bump rt2x00 to a new version: 2.2.0
> >> This series will add HW crypto support to rt2x00, by default it
> >> has been enabled for rt61pci and rt73usb.
> > 
> > Seems to work well on my rt61pci card!
> > 
> > In fact, it reports a higher link quality (and maintains a higher
> > bitrate) than the version in current wireless-testing. The quality
> > report also fluctuates less than previously. This is consistent over a
> > few hours of testing with streaming PCM audio.
> > 
> > I do get a lockdep warning when bringing up the device, however.
> > 
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.27-rc1-rt2-wl #1
> > ---------------------------------------------
> > rt61pci/4405 is trying to acquire lock:
> >  (_xmit_IEEE80211#2){-...}, at: [<ffffffffa014cc52>]
> > ieee80211_scan_completed+0x172/0x320 [mac80211]
> > 
> > but task is already holding lock:
> >  (_xmit_IEEE80211#2){-...}, at: [<ffffffffa014cc52>]
> > ieee80211_scan_completed+0x172/0x320 [mac80211]
> > 
> 
> I get that same lockdep warning when using the mainline kernel with b43. It 
> doesn't seem to cause any problems.

Sounds like a mac80211 bug then, can't find something obvious at first glance,
but perhaps Johannes has an idea?

Ivo
