Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52303 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409AbcBINoW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 08:44:22 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Nishant Sarmukadam" <nishants@marvell.com>,
	"wnhuang@chromium.com" <wnhuang@chromium.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Xinming Hu <huxm@marvell.com>, Cathy Luo <cluo@marvell.com>
Subject: RE: [PATCH v3 1/3] mwifiex: register platform specific driver
Date: Tue, 9 Feb 2016 13:44:16 +0000
Message-ID: <5ef981436ee64f67beef7ca1e2470c69@SC-EXCH04.marvell.com> (sfid-20160209_144426_301503_9CDAB405)
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com>
 <8264177.UI5sMC7XWi@wuerfel>
In-Reply-To: <8264177.UI5sMC7XWi@wuerfel>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arnd,

Thanks for your review.

> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Arnd Bergmann
> Sent: Monday, February 08, 2016 5:40 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Nishant Sarmukadam;
> wnhuang@chromium.com; devicetree@vger.kernel.org; Xinming Hu
> Subject: Re: [PATCH v3 1/3] mwifiex: register platform specific driver
> 
> On Monday 08 February 2016 02:15:26 Amitkumar Karwar wrote:
> > diff --git a/Documentation/devicetree/bindings/mwifiex.txt
> > b/Documentation/devicetree/bindings/mwifiex.txt
> > new file mode 100644
> > index 0000000..39b6a74
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mwifiex.txt
> > @@ -0,0 +1,29 @@
> > +mwifiex
> > +------
> > +
> > +Required properties:
> > +
> > +  - name : must be "mwifiex"
> 
> This is a very unusual requirement.
> 
> Can you use one of the standard device names instead?
> 

We will make use of marvell-sd8xxx in updated version as per Rob Herring's suggestions.
It includes vendor name and a chipset/device name.


> > +  - compatible : must be "marvell,mwifiex"
> > +
> > +Optional properties:
> > +
> > +  - mwifiex,caldata* : A series of properties with marvell,caldata
> prefix,
> > +                     represent Calibration data downloaded to the
> device during
> > +                     initialization. This is an array of unsigned
> values.
> > +
> > +
> > +Example:
> > +
> > +Tx power limit calibration data is configured in below example.
> > +The calibration data is an array of unsigned values, the length can
> > +vary between hw versions.
> > +
> > +mwifiex {
> > +       compatible = "marvell,mwifiex";
> > +
> > +       mwifiex,caldata_00_txpwrlimit_2g_cfg_set = /bits/ 8 <
> > +0x01 0x00 0x06 0x00 0x08 0x02 0x89 0x01 ...>;
> > +
> > +};
> 
> Should we list the mac-address here as well, or is there always an
> eeprom for that but not the calibration data?

Yes. we do get MAC address along with other info from EEPROM.

Regards,
Amitkumar Karwar
