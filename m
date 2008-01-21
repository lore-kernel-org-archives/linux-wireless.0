Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:12357 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755202AbYAUBxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 20:53:09 -0500
From: bruno randolf <bruno@thinktube.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Mon, 21 Jan 2008 10:52:40 +0900
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Ulrich Kunitz" <kune@deine-taler.de>,
	"Daniel Drake" <dsd@gentoo.org>
References: <20080118125252.6455.41047.stgit@one> <43e72e890801200217i7a7e5349uebf56d42c63cf48e@mail.gmail.com> <200801201143.09488.IvDoorn@gmail.com>
In-Reply-To: <200801201143.09488.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801211052.41016.bruno@thinktube.com> (sfid-20080121_015323_380041_BBF72356)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 20 January 2008 19:43:09 Ivo van Doorn wrote:
> Hi,
>
> > Adding Johill and Michael as they are maintainers of mac80211 and they
> > need to review this. Please add them on further mac80211 patches.
> >
> > Note to driver authors: zd1211rw, rt2x00 drivers and adm8211 will need
> > to set mactime if they want IBSS merge to work as this functionality
> > would be added with this. I believe all other drivers set it, but
> > didn't do a thorough grep.
>
> Then there is a problem for rt2x00. Since the mactime isn't known.
> rt2400pci is the _only_ device which has a RX_END_TIME field in the
> RX descriptor.

one workaround could be to simply use the current TSF at the time in the 
tasklet or interrupt handler (to be more close to the actual rx time). this 
should be sufficient to catch most cases where an IBSS merge is necessary - 
usually the beacon's TSF will be much higher than the local TSF.

bruno
