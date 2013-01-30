Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43973 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3A3F2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 00:28:16 -0500
Date: Tue, 29 Jan 2013 23:28:08 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 7/7] brcmsmac: Add support for off-channel powersave
Message-ID: <20130130052808.GA21051@thinkpad-t410> (sfid-20130130_062821_777517_E41FA2D0)
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
 <1359503255-18270-8-git-send-email-seth.forshee@canonical.com>
 <CAGRGNgUTSL105OQvF7=W_2CZHWsS-NohJ-tKWfNwVZNuBEJP9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGRGNgUTSL105OQvF7=W_2CZHWsS-NohJ-tKWfNwVZNuBEJP9A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 30, 2013 at 10:56:03AM +1100, Julian Calaby wrote:
> Hi Seth,
> 
> On Wed, Jan 30, 2013 at 10:47 AM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > Broadcom hardware sets the value of the PM flag in frame control based
> > on the value of MCTL_HPS, which seems to include actively clearing PM
> > if MCTL_HPS is not set. brcmsmac needs to suppor the off-channel
> > powersave state in order to enable powersave at the AP at all.
> >
> > Add limited support for powersave to brcmsmac to prevent frame loss
> > during background scans. Full powersave supoprt remains unimplemented,
> > but switching between the off-channel and disabled states is possible.
> >
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > ---
> >  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   15 +++++++++++----
> >  drivers/net/wireless/brcm80211/brcmsmac/main.c     |    9 +++++++++
> >  drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    1 +
> >  3 files changed, 21 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> > index c26992a..3fb71c9 100644
> > --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> > +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> > @@ -7545,6 +7549,11 @@ void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc, u8 interval)
> >                 brcms_c_bcn_li_upd(wlc);
> >  }
> >
> > +void brcms_c_set_ps(struct brcms_c_info *wlc)
> > +{
> > +       brcms_c_set_ps_ctrl(wlc);
> > +}
> > +
> 
> Why not just use brcms_c_set_ps_ctrl() directly?

It's a remnant from an earlier version of the patches. Looks like I just
didn't take things to the logical conclusion when I refactored the code.

Seth
