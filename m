Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61322 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756204AbcBIOAN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 09:00:13 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Rob Herring <robh@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Nishant Sarmukadam" <nishants@marvell.com>,
	"wnhuang@chromium.com" <wnhuang@chromium.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v3 1/3] mwifiex: register platform specific driver
Date: Tue, 9 Feb 2016 14:00:04 +0000
Message-ID: <5347bd8a22ab4fc78ccc5d5d80cbd4b0@SC-EXCH04.marvell.com> (sfid-20160209_150018_891533_4B9E7876)
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com>
 <20160208215614.GB9036@rob-hp-laptop>
In-Reply-To: <20160208215614.GB9036@rob-hp-laptop>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rob,

Thanks for your review.

> From: Rob Herring [mailto:robh@kernel.org]
> Sent: Tuesday, February 09, 2016 3:26 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Nishant Sarmukadam;
> wnhuang@chromium.com; devicetree@vger.kernel.org; Xinming Hu
> Subject: Re: [PATCH v3 1/3] mwifiex: register platform specific driver
> 
> On Mon, Feb 08, 2016 at 02:15:26AM -0800, Amitkumar Karwar wrote:
> > From: Xinming Hu <huxm@marvell.com>
> >
> > Platform device and driver provides easy way to interact with
> > device-tree-enabled system.
> >
> > This patch registers platform driver and reorganise existing device
> > tree specific code.
> > Corresponding device tree binding file is also created.
> 
> Wrap you lines at 72 columns.

Ack.

> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> > v3: Don't update adapter->dt_node if mwifiex_plt_dev is NULL
> > ---
> >  Documentation/devicetree/bindings/mwifiex.txt      | 29 +++++++++++
> 
> This doesn't belong at top level of bindings. bindings/net/wireless/
> 
> Also, mwifiex is a linux driver name. Name it after the chips.
> marvell-sd8xxx?

Sure. I will rename as marvell-sd8xxx and move it to bindings/net/wireless/

> 
> >  drivers/net/wireless/marvell/mwifiex/Makefile      |  1 +
> >  drivers/net/wireless/marvell/mwifiex/main.c        |  2 +
> >  drivers/net/wireless/marvell/mwifiex/main.h        | 14 +++++
> >  .../net/wireless/marvell/mwifiex/platform_drv.c    | 59
> ++++++++++++++++++++++
> >  drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  6 +--
> >  drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |  2 +-
> >  7 files changed, 109 insertions(+), 4 deletions(-)  create mode
> > 100644 Documentation/devicetree/bindings/mwifiex.txt
> >  create mode 100644
> > drivers/net/wireless/marvell/mwifiex/platform_drv.c
> >
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
> > +  - compatible : must be "marvell,mwifiex"
> 
> The naming should be named after the actual chip.

Ok. How about having names as below?

+  - name : can be "sd8897", "sd8787" or "sd8797"
+  - compatible : must be "marvell,sd8xxx"

> 
> > +
> > +Optional properties:
> > +
> > +  - mwifiex,caldata* : A series of properties with marvell,caldata
> > + prefix,
> 
> mwifiex is not a vendor.

Got it. We will use "marvell,caldata*" here.

> 
> > +  		      represent Calibration data downloaded to the device
> during
> > +		      initialization. This is an array of unsigned values.
> > +
> > +
> > +Example:
> > +
> > +Tx power limit calibration data is configured in below example.
> > +The calibration data is an array of unsigned values, the length can
> > +vary between hw versions.
> > +
> > +mwifiex {
> 
> These chips are SDIO devices, right? This should be a child node of the
> SDIO controller.
> 

Yes. They are SDIO devices. We will have the node as child node of SDIO controller.

Regards,
Amitkumar Karwar
