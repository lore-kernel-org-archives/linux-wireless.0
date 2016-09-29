Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60492 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754390AbcI2N6b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Sep 2016 09:58:31 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Rob Herring <robh@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Wei-Ning Huang <wnhuang@chromium.org>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH] mwifiex: parse device tree node for PCIe
Date: Thu, 29 Sep 2016 13:58:23 +0000
Message-ID: <0fb142f41f764496bc1242507717f0f7@SC-EXCH04.marvell.com> (sfid-20160929_155835_338929_C87C0C38)
References: <1473434254-16782-1-git-send-email-akarwar@marvell.com>
 <20160919212753.GA16598@rob-hp-laptop>
In-Reply-To: <20160919212753.GA16598@rob-hp-laptop>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rob,

> From: Rob Herring [mailto:robh@kernel.org]
> Sent: Tuesday, September 20, 2016 2:58 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> devicetree@vger.kernel.org; Wei-Ning Huang; Xinming Hu
> Subject: Re: [PATCH] mwifiex: parse device tree node for PCIe
> 
> On Fri, Sep 09, 2016 at 08:47:34PM +0530, Amitkumar Karwar wrote:
> > From: Xinming Hu <huxm@marvell.com>
> >
> > This patch derives device tree node from pcie bus layer framework.
> > Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
> > marvell-8xxx.txt) to accomodate PCIe changes.
> >
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> >  .../bindings/net/wireless/marvell-8xxx.txt         | 64
> ++++++++++++++++++++++
> >  .../bindings/net/wireless/marvell-sd8xxx.txt       | 63 -------------
> --------
> 
> Resend using -M option so I do have to figure out if you added 1 line or
> changed a bunch.
> 
> >  drivers/net/wireless/marvell/mwifiex/pcie.c        | 19 +++++++
> >  drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  3 +-
> >  4 files changed, 85 insertions(+), 64 deletions(-)  create mode
> > 100644 Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
> >  delete mode 100644
> > Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
> >
> > diff --git
> > a/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
> > b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
> > new file mode 100644
> > index 0000000..a8a95aa
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
> > @@ -0,0 +1,64 @@
> > +Marvell 8897/8997 (sd8897/sd8997/pcie8997) SDIO/PCIE devices
> > +------
> > +
> > +This node provides properties for controlling the marvell sdio/pcie
> wireless device.
> > +The node is expected to be specified as a child node to the SDIO/PCIE
> > +controller that connects the device to the system.
> > +
> > +Required properties:
> > +
> > +  - compatible : should be one of the following:
> > +	* "marvell,sd8897"
> > +	* "marvell,sd8997"
> > +	* "marvell,pcie8997"
> 
> PCIe uses vendor and product IDs for compatible strings. Please read the
> OF PCI bus bindings doc.
> 

Thanks for review. I have submitted updated version(V3) with this change.

Regards,
Amitkumar Karwar
