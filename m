Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:52442 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbcGBV20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jul 2016 17:28:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Jonas Gorski <jonas.gorski@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Priit Laes <plaes@plaes.org>,
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
Date: Sat, 02 Jul 2016 23:30:21 +0200
Message-ID: <7975990.MvNRQ06u39@wuerfel> (sfid-20160702_232836_120708_3824B47B)
In-Reply-To: <ced2a770-2724-bdc9-7e2a-3dc9f76abf29@broadcom.com>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com> <CAOiHx=m8Zf0T4=BTG6BMRjj3kOHzt4YaQa3yzutmrhFSOyZMmA@mail.gmail.com> <ced2a770-2724-bdc9-7e2a-3dc9f76abf29@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, July 2, 2016 8:20:35 PM CEST Arend Van Spriel wrote:
> > If you want a separate property, then I repeat my very first
> > suggestion, the well defined model property.
> > e.g.
> > 
> > brcmf@0 {
> >         model = "ampak,ap6210";
> >         compatible = "brcm,bcm4329-fmac";
> >         ...
> > };
> > 
> > All device nodes may have a model property, not just the top "machine" one.
> 
> I heard you the first time  I just was not sure what the implications
> would be to use it. Hence I suggested a vendor specific property.
> However, looking up and reading the definition in ePAPRv1.1 I suppose it
> is fine to use the model property:
> 
> Property: model
> Value type: <string>
> Description:
> The model property value is a <string> that specifies the manufacturer’s
> model number of the device.
> 
> The recommended format is: “manufacturer,model”, where manufacturer is a
> string describing the name of the manufacturer (such as a stock ticker
> symbol), and model specifies the model number.

The model property is very similar to compatible, except that there is
only one entry rather than a list of entries from most specific to
most generic.

I think by writing the above example as

	compatible = "ampak,ap6210", "brcm,bcm4329-fmac";

we can provide the same functionality in a slightly simpler way, the driver
then just goes on to look for the nvram file for each entry in sequence until
it finds one.

	Arnd
