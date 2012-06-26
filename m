Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:59166 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925Ab2FZJBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 05:01:19 -0400
Date: Tue, 26 Jun 2012 16:56:07 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Wei Ni <wni@nvidia.com>, Mursalin Akon <makon@nvidia.com>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	'Mark Brown' <broonie@opensource.wolfsonmicro.com>,
	"'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
	"'frankyl@broadcom.com'" <frankyl@broadcom.com>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	'Philip Rakity' <prakity@marvell.com>,
	Rakesh Kumar <krakesh@nvidia.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, <r64343@freescale.com>,
	<b29397@freescale.com>, <b20223@freescale.com>,
	<r65037@freescale.com>
Subject: Re: Where to power on the wifi device before loading the driver.
Message-ID: <20120626085605.GA6047@shlinux2.ap.freescale.net> (sfid-20120626_110130_478362_A29DA53F)
References: <20120614121234.GC3913@opensource.wolfsonmicro.com>
 <4FDA092E.10301@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C377BFFE8D@HKMAIL01.nvidia.com>
 <4FDB5976.20809@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C6EE2DD61F@HKMAIL01.nvidia.com>
 <43E4817426ED174AA81263BCECB4351D138E8ACD6B@sc-vexch3.marvell.com>
 <6B4D417B830BC44B8026029FD256F7F1C6EE2DD622@HKMAIL01.nvidia.com>
 <20120619091719.GZ3974@opensource.wolfsonmicro.com>
 <6B4D417B830BC44B8026029FD256F7F1C6EE2DD626@HKMAIL01.nvidia.com>
 <4FE112F2.7000506@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FE112F2.7000506@wwwdotorg.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 19, 2012 at 06:01:54PM -0600, Stephen Warren wrote:
> On 06/19/2012 03:44 AM, Wei Ni wrote:
> > On Tue, Jun 19, 2012 at 17:17:19, Mark Brown wrote:
> >> * PGP Signed by an unknown key
> >>
> >> On Tue, Jun 19, 2012 at 12:25:58PM +0800, Wei Ni wrote:
> >>
> >> As Stephen previously said please fix your mail formatting - word 
> >> wrapping within paragraphs is important!
> >>
> >>> On Tue, Jun 19, 2012 at 09:23:35, Philip Rakity wrote:
> >>>> Why can't you use the regulator notify to get called back on power 
> >>>> or voltage change options to plumb in the manipulation of the gpio. 
> >>>> I can imagine you might need to add a notify call in core.c if you 
> >>>> need to assert the gpio before power is applied
> >>>
> >>> Yes, we can use the regulator notify, but the Tegra30 support is via 
> >>> device tree, I think there have no special board file to run the call 
> >>> back.
> >>
> >> You can mix board files with device tree for cases where device tree is 
> >> not yet up to the job, though the goal should be to come up with a way of expressing things in device tree.
> > 
> > I think we wish to use the device tree to handle these gpios, pass them to the related driver to assert them.
> > If we mix the board files, we even can set these gpio directly, not use the notify. But I think this is not a goog way.
> 
> Yes, I would definitely not want to add this to a board file; there is
> no board file for Cardhu, and we're getting close to deleting all the
> board files that are left for other boards.
> 
> I think what we need is some way of matching a DT node to a device even
> when that device was instantiated through some probing mechanism such as
> SDIO or USB (and I've heard hints that one can already do this for PCI;
> I should investigate).
> 
> So, we start off with the plain SDHCI controller node:
> 
> sdhci@78000000 {
> 	compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
> 	reg = <0x78000000 0x200>;
> 	interrupts = <0 14 0x04>;
> };
> 
> Then, we add a child node to represent the device that's attached:
> 
> sdhci@78000000 {
> 	compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
> 	reg = <0x78000000 0x200>;
> 	interrupts = <0 14 0x04>;
> 
> 	sdio-device {
> 		reset-gpios = <...>;
> 		enable-gpios = <...>;
> 	};
> };
> 
> When the SDHCI controller/core instantiates the child device it finds on
> the HW bus, it initializes that struct device's of_node with a pointer
> to the sdio-device node above. From there, the child device can get DT
> properties such as GPIOs in the usual way.
> 
> However, there are still some issues that need thought here; what if (as
> is I believe the case on Cardhu) we can in fact plug in multiple
> different types of device into the socket? Might we end up with
> something like:
> 
> sdhci@78000000 {
> 	compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
> 	reg = <0x78000000 0x200>;
> 	interrupts = <0 14 0x04>;
> 
> 	sdio-device-option@0 {
> 		compatible = "broadcom,bcm4239";
> 		reset-gpios = <...>;
> 		enable-gpios = <...>;
> 	};
> 
> 	sdio-device-option@1 {
> 		compatible = "broadcom,bcm4330";
> 		reset-gpios = <...>;
> 		enable-gpios = <...>;
> 	};
> };
> 
> and match on compatible value?
> 
I like this idea.
We may extend the sdio_device_id to contain a compatible string,
then sdio core is responsible to pass the corresponding device node to the
sdio function driver once a match device found, this is sdio function independent.
The sdio function driver then are responsible to parse the device node to
fetch the needed information like reset-gpios and enable-gpios to do correct
initialization sequence.

However, one known question for this model is that some WiFi may need reset the chip
via gpio first before being able to be enumerated.
Then this model may not work for such devices since it can not enumerate this device
before completing the sdio function specific initialization, neither passing node to its
driver.
(i'm not sure this is a correct behavior since per my understanding, the sdio io function
(function 1-7) specific initialization should not affect the normal sdio common function
(function 0) enumeration, but i did not find a clear definition in sdio spec.
Anyone see such real devices?)

Then for such devices, that is definitely a problem.
If the sdio function specific initialization affects the normal enumeration,
then it definitely need to be put into sdio core as an interface like sdio_prepare before the
enumeration.
But it seems not reasonable since we did not know prepare for which sdio device
before the sdio device enumeration completes.
Maybe the possible solution is still do it in platform specific code via
of_machine_is_compatible(....).

For your question that user may plug multi types of sdio device with difference
gpio using,
did we see such a real device that the pluggable sdio devices need
some extra gpio to work? I did not meet it before.
If it real exists, can we rather consider it an integrated sdio devices on board?
Then we can only define the integrated sdio device node on board under sdio controller.

> But in this case, at least some of the data those two drivers want from
> that node is the same; the 2 GPIOs that control the reset and enable
> signals. Do we just make the bindings for those two devices happen to
> share the same properties so that we can get away with just one node
> irrespective of what device type has been found? What we're really
Maybe no.
These things are board specific and should be put in board dts file.
If really using the same gpios by chance, then add them for each board may
be reasonable.

> modeling is the card slot, and the services it provides, so perhaps we
> should really end up with:
> 
> sdhci@78000000 {
> 	compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
> 	reg = <0x78000000 0x200>;
> 	interrupts = <0 14 0x04>;
> 
> 	socket {
> 		reset-gpios = <...>;
> 		enable-gpios = <...>;
> 
> 		sdio-device-option@0 {
> 			compatible = "broadcom,bcm4239";
> 		};
> 
> 		sdio-device-option@1 {
> 			compatible = "broadcom,bcm4330";
> 		};
> 	};
> };
> 
> Where somehow the WiFi drivers can obtain the reset/enable service from
> the socket that hosts them, but still have nodes for the attached device
> itself in case any additional driver-specific configuration is needed.
> 
> That sounds somewhat similar to the virtual platform device that was
> mentioned earlier in this thread by Broadcom, although I'm not sure
> whether explicitly modeling it as a platform device makes sense, rather
> than the socket providing services to the WiFi module, not necessarily
> through a device.
> 
> Unfortunately, it should be noted that the WiFi device socket on Cardhu
> apparently isn't some standardized thing (like PCIe) but something
> rather more custom, although there are apparently devices available to
> plug into it from multiple module vendors which contain WiFi chips from
> multiple chip vendors.
That seems should be cared by the corresponding WiFi function driver
rather than the binding itself no matter which is plugged in.
The binding just pass the node to driver, then everything else is driver
specific. Is that reasonable?

Regards
Dong Aisheng
> 
> Anyway, these are just some quick thoughts on the topic - obviously more
> flesh is needed.
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 

