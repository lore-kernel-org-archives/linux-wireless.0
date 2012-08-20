Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab2HTKdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 06:33:17 -0400
Message-ID: <1345458792.4459.1.camel@jlt3.sipsolutions.net> (sfid-20120820_123320_632168_85DD39D1)
Subject: Re: [PATCH v3 1/7] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Goldenshtein, Victor" <victorg@ti.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 20 Aug 2012 12:33:12 +0200
In-Reply-To: <20120810162532.GA17559@redhat.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	 <1344426823-1795-2-git-send-email-victorg@ti.com>
	 <20120809115109.GB3516@redhat.com>
	 <CAK80WHYjhBbE5Y2Q_-QhbNmxu76BMRCa9=vFyMXwQJQqsGiPUQ@mail.gmail.com>
	 <20120810162532.GA17559@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-08-10 at 18:25 +0200, Stanislaw Gruszka wrote:
> On Thu, Aug 09, 2012 at 03:08:59PM +0300, Goldenshtein, Victor wrote:
> > On Thu, Aug 9, 2012 at 2:51 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > > On Wed, Aug 08, 2012 at 02:53:37PM +0300, Victor Goldenshtein wrote:
> > >> +     cac_type = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
> > >> +     if (cac_type != NL80211_CHAN_HT20)
> > >> +             return -EOPNOTSUPP;
> > > Since only HT20 is supported, what for we have this variable?
> > >
> > 
> > Security measures and preparation for future HT40.
> 
> I dislike "preparation for future" thing. We have lot of stuff like
> that in kernel, which never get implemented, and only mess up the code.
> 
> How near future is that?

Well, it doesn't really matter -- if you allow specifying the channel
type then you have to validate it in some way, otherwise one could
assume it works with 40 MHz, right?

johannes

