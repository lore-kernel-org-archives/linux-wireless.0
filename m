Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48168 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756020Ab2CTCLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 22:11:52 -0400
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 679B4216F7
	for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 22:11:52 -0400 (EDT)
Date: Mon, 19 Mar 2012 23:11:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Tom Gundersen <teg@jklm.no>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: MAINTAINER NEEDED -- Re: status of ipw2x00
Message-ID: <20120320021148.GA9850@khazad-dum.debian.net> (sfid-20120320_031157_930224_6BCF16E0)
References: <CAG-2HqUqwHo_xgqC79riQF2DA4DPz1Qy5ZARQK8GT+tf_-UKRg@mail.gmail.com>
 <20120130184446.GB2493@tuxdriver.com>
 <CA++WF2PnEzS5CAfryaPrJSs3Xb3s0WK1zR7N5o8+ud2HiU5GCw@mail.gmail.com>
 <20120315110219.GA2335@redhat.com>
 <CA++WF2P8E=0Xym92MuU84RwaP5Y9uyCyqw5jefh25QDz-Cpzkw@mail.gmail.com>
 <20120317143640.GC23594@khazad-dum.debian.net>
 <CA++WF2PCO8ZdhfSMs6_gy2gz5OvTkVrGYXm0X6Aicoe5JmK+pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA++WF2PCO8ZdhfSMs6_gy2gz5OvTkVrGYXm0X6Aicoe5JmK+pg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 19 Mar 2012, Stanislav Yakovlev wrote:
> Hello Henrique,
> On 17 March 2012 07:36, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > On Thu, 15 Mar 2012, Stanislav Yakovlev wrote:
> >> On 15 March 2012 04:02, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >> > Are you plan to fix issues caused on current firmware loading changes on
> >> > linux?
> >>
> >> I was able to reproduce this issue; unfortunately, I don't have a
> >> proper fix for it yet.
> >
> > Maybe you could delay the firmware load to when the device is opened (at
> > which point you can probably change the driver to keep the device in PCI
> > D3 state unless it is opened, which does save power), and just caching
> > the firmware forever after the first load so that you don't need to
> > request_firmware anything more than once.
> >
> > Chances are ipw2xxx firmware will never get a new revision anyway, so
> > reloading the modules is not too large a price to pay if the user does
> > decide he has to force a firmware refresh...
> 
> As far as I know there is no way to force firmware refresh at the
> moment without reloading the driver. If you know any implementations
> of such behavior, please let me know.

You just need to switch modes, which forces it to switch firmwares, and it
always reloads it from disk (unless you've built it in the kernel, maybe.  I
didn't try that).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
