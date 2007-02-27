Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:5924 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbXB0SzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 13:55:14 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1197451uga
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2007 10:55:13 -0800 (PST)
Message-ID: <43e72e890702271055sc1525ecy54870626125a7fae@mail.gmail.com>
Date: Tue, 27 Feb 2007 13:55:07 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jiri Benc" <jbenc@suse.cz>
Subject: Re: Patch to allow specification of interface name prefix
Cc: "Stephen Hemminger" <shemminger@linux-foundation.org>,
	"Larry Finger" <larry.finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>,
	"Alex Davis" <alex14641@yahoo.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070227111644.784600be@logostar.upir.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <510326.55988.qm@web50211.mail.yahoo.com>
	 <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net>
	 <45E112F7.9090908@lwfinger.net> <20070226150241.1b5b63b2@freekitty>
	 <20070227111644.784600be@logostar.upir.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/27/07, Jiri Benc <jbenc@suse.cz> wrote:
> [removed bcm43xx-dev list]
>
> On Mon, 26 Feb 2007 15:02:41 -0800, Stephen Hemminger wrote:
> > This was hashed out on netdev 2+ years ago and decided that both ethernet
> > and wireless devices should show up as 'eth%d'. For inclusion d80211 needs to conform
> > to existing mainline kernel practice. If this means breaking the expectation of older
> > out of tree wireless support (ie madwifi), sorry.
>
> Decided? I remember just you and hch saying "all existing wireless drivers
> do that, so everybody should". When pointing out that just two drivers do
> that (I think ipw and prism) and everybody else use something different
> (wlan%d most often) there was no reply. "ipw and one other driver do that
> so everybody should" doesn't sound like a strong argument to me.
>
> Wireless devices need different handling (setting SSID, etc.) than Ethernet
> ones. I think it's not so bad idea to show that difference by using a
> different default name. Everybody else who is in some kind different from
> Ethernet use different name than eth%d. I think we should conform to
> existing mainline practice by using something different than eth%d too.

FWIW I remember the discussion too and it wasn't something very
settling. One main reason to keep eth%d convention was the fact that
the wireless net devices at that time (FullMAC) handled and managed
raw ethernet frames and not wireless frames and as such its relfected
with eth%d convention. This was the main reasoning for prism54 to
adopt eth%d convention. With SoftMAC (mac80211) things are a bit
different -- wmaster handles 802.11 frames and wlan%d handles 802.3
frames. The name does not matter much but it does imply at least that
I think. As such perhaps mac80211 should change to use eth%d by
default.

  Luis
