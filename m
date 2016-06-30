Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:57687 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbcF3L3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 07:29:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans de Goede <hdegoede@redhat.com>
Cc: jonas.gorski@gmail.com, Kalle Valo <kvalo@codeaurora.org>,
	Priit Laes <plaes@plaes.org>,
	Arend Van Spriel <arend.vanspriel@broadcom.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name dt property
Date: Thu, 30 Jun 2016 13:31:07 +0200
Message-ID: <3960223.GqB9zXL8s8@wuerfel> (sfid-20160630_132928_983155_E765BDB4)
In-Reply-To: <8d8bd933-717b-48e4-f002-7b834abed6fd@redhat.com>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com> <CAOiHx==82LHOeQMNVD+dybFifXX690Q6AJTcMBMynjSfUOyGUw@mail.gmail.com> <8d8bd933-717b-48e4-f002-7b834abed6fd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, June 30, 2016 12:25:15 PM CEST Hans de Goede wrote:
> > So then how about making use of a more specific compatible string?
> >
> > e.g.
> >
> > brcmf {
> >         compatible = "foo,ap6210", "brcm,bcm4329-fmac";
> >         ...
> > };
> >
> > and if the compatible has more than one element you request
> > FW_NAME_<compatible>.txt as the nvram file. Or try each comptible (and
> > lastly no suffix) until you get a match. (AFAICT, this is what the
> > "model" property was originally intended for anyway, but almost nobody
> > did it right, and everyone put a user readable string into "model" for
> > boards instead of the ePAPR defined compatible string).
> 
> Hmm, interesting idea. Not sure how easy / hard it will be to implement
> this, but from a dt binding point of view it seems elegant.
> 
> Kalle, Arend, what do you think of this ?

I think that's reasonable. Also, we have precedent for using things like
the boardid as part of the compatible string, which would help do what
Kalle suggested earlier with "nvram-<boardtype>-<boardrev>.txt",
as we get that for free by trying out all the compatible strings.

	Arnd

