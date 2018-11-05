Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68014C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 16:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C77F20866
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 16:33:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVWaGk29"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C77F20866
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387530AbeKFBxc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 20:53:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:35900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387407AbeKFBxc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 20:53:32 -0500
Received: from localhost (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDCA420700;
        Mon,  5 Nov 2018 16:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541435582;
        bh=QlBWMkZidcf7WNcMtynbCR4d6sHMGntXCFEAyKUa+AU=;
        h=To:From:In-Reply-To:Cc:References:Subject:Date:From;
        b=fVWaGk29czj60zyKgIWmoONN7iG29iGi8Ra5ycFd95op0ZsxHpKdMyTb/j9NzX76h
         R1hbzc7I4tYCS7/SV6RTizFhdpqZ+xQFI8aV01SNfjZATUBFlPtGMFTBv2+Bf2chYr
         NYJ3haJiMwZToJWF6iTTydxZ1cG42ZADmq2bYhgA=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To:     Brian Norris <briannorris@chromium.org>
From:   Stephen Boyd <sboyd@kernel.org>
In-Reply-To: <20181102184315.GA130458@google.com>
Cc:     Govind Singh <govinds@codeaurora.org>, andy.gross@linaro.org,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-wireless@vger.kernel.org, robh+dt@kernel.org
References: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
 <1539172376-19269-2-git-send-email-govinds@codeaurora.org>
 <153976208916.5275.15753381614937010537@swboyd.mtv.corp.google.com>
 <20181102184315.GA130458@google.com>
Message-ID: <154143558212.88331.5337286842567829007@swboyd.mtv.corp.google.com>
User-Agent: alot/0.7
Subject: Re: [PATCH v3 1/3] dt: bindings: add missing dt properties for WCN3990 wifi
 node
Date:   Mon, 05 Nov 2018 08:33:02 -0800
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Quoting Brian Norris (2018-11-02 11:43:17)
> Hi Stephen and Govind,
> =

> I was chatting with Govind, and he seemed to be a bit stalled on this.
> I'd encourage him to reply with whatever knowledge he has, because it's
> a bit hard to give definitive answers when I don't know all the inner
> workings here. (In fact, you, Stephen, probably know more than me about
> how Qualcomm MSM chips work.)
> =

> First of all, I'll explain the limited bits I do know, and see how they
> fit in below. I may be wrong.
> =

> WCN3990 is an external module, for supporting BT and Wifi RF components.
> It has a host interface for the Wifi, but it's not something the host
> knows how to talk to directly at all -- it's an "Analog IQ" interface,
> between an internal SoC MAC and PHY processor. Instead, we talk to this
> module via the System NOC (?). So while there are basically 2 distinct
> hardware components (on-SoC coprocessors, various internal communication
> buses, various shared memory regions, etc.; and the external WCN3990
> module), there is almost no way for the main processor to "talk" to the
> WCN3990 directly.
> =

> Another data point to throw into the mix: WCN3990 can apparently be used
> on multiple different SoCs -- I see public announcments about SDM835
> (and 660?), and I'm currently playing with it on SDM845. So perhaps
> there is some value in understanding "WCN3990" as being distinct from
> "WiFi MAC/PHY hardware and communication logic found on a MSM SoC." But
> they do seem to be very tightly coupled...
> =

> Side note: there is also a BT component on the WCN3990 module, and we
> *can* talk to that directly over UART. There's a separate binding going
> in for that, and it's a much clearer separation to divide "UART
> controller" and "BT/UART interface on WCN3990."

Thanks for the background. I wasn't aware of much about this driver but
taking this information and skimming the driver makes my mental model
believe that the register space here is a custom I/O region in the SoC
used to read/write to the BT/WiFi chip that's outside the SoC. Similar
to i2c, SPI, or even PCI, in the way that the I/O region in the SoC is
essentially the controller that is connected to the external chip. It's
like the hardware engineers stuck the PCI hardware blob inside the SoC
and then made special pins and wires for the thing the PCI device used
to do internally. Or is that completely wrong still?

> =

> On Wed, Oct 17, 2018 at 12:41:29AM -0700, Stephen Boyd wrote:
> > Quoting Govind Singh (2018-10-10 04:52:54)
> > > --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> > > +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> =

> > > @@ -55,7 +63,8 @@ Optional properties:
> > >  - qcom,ath10k-pre-calibration-data : pre calibration data as an arra=
y,
> > >                                      the length can vary between hw v=
ersions.
> > >  - <supply-name>-supply: handle to the regulator device tree node
> > > -                          optional "supply-name" is "vdd-0.8-cx-mx".
> > > +                          optional "supply-name" are "vdd-0.8-cx-mx",
> > > +                          "vdd-1.8-xo", "vdd-1.3-rfa" and "vdd-3.3-c=
h0".
> > =

> > Why can't the wifi firmware manage these regulators itself?
> =

> In my understanding:
> At least 3 of those (all the supplies Govind is adding) are external
> pins on the RF module. Why do you assume these are something the
> firmware can control? In the schematics I'm looking at, this seems to be
> connected to a PMIC. While it's certainly possible this is something the
> Q6 processor (running modem and Wifi firmware) can control, it doesn't
> seem obvious to me that they *must* be able to.
> =

> So I guess I'd say: why not represent these regulators in the device
> tree? It seems like a valid hardware description (like I said, 3 power
> rail pins on an external module).

Agreed. I want to specify the regulators in DT. I'm mostly asking if
there is firmware that runs and can control these regulators itself. If
so, then I'm lost why that firmware can't manage these itself and let us
ignore these requirements and never specify them in DT. Presumably there
isn't firmware that can manage it?

> =

> Now, your *next* paragraph might have hairier points :)
> =

> > And these names don't seem to match any sort of schematic or really
> =

> Which names? I see these pin names on the WCN3990 datasheets I see:
> =

>  VDD18_IO
>  VDD18_XO
>  VDD33_CH0
>  VDD33_CH1
>  VDD13_RFA
> =

> 3 of those match the 3 Govind is adding, and they appear to line up with
> what I see in schematics.

Yes those three match up, but the other one, vdd-0.8-cx-mx, looks like
the CX and MX power supplies that are typical of Qualcomm designs so
maybe those regulators are used for the I/O region inside the SoC
instead of the off-SoC chip?

> =

> > describe what this device is. From what I can tell, we've combined the
> =

> I've described "waht the device is" above to the best of my knowledge.
> If you're just looking at schematics, you might possibly be thrown by
> the fact that WCN3990 is packaged in a module provided by other vendors,
> so it might be labeled by that vendor on the schematic, not by the
> Qualcomm WCN3990 name.

Thanks!

> =

> > there's something in the SoC, and there's something outside the SoC, and
> > these two things are connected by having two nodes and a phandle between
> > them?
> =

> Why phandle? Under what bus would you place the WCN3990? As per my
> description above, there is really no way to talk to it directly. So if
> anything, it seems like it would be a subnode of the node we're
> describing here.

I'm not tied to having a phandle at all. I'm mostly trying to make the
following distinction in DT. If a node is under the soc node, it has a
reg property and represents a hardware block inside the SoC. Any
regulators or clocks that the node uses should also either be provided
inside the SoC, or be pins on the SoC that the device can be connected
to. Otherwise, if those regulators aren't going to pins for the SoC,
then it means we have a mash-up of two devices in one place in the DT
hierarchy. This is what doesn't look proper to me, and it's why we would
want to split the node into two nodes, the SoC part and the module part
for the off-SoC WCN chip.

And yes, from what you've told me here it would make sense to make the
WCN chip a subnode of this SoC node instead of a phandle connecting the
two.
 =

> =

> In favor of your separation though: there are many ways to utilize
> WCN3990 apparently, and I'd imagine the binding might change a bit
> depending on the SoC (e.g., different clocks?). So there might be value
> in describing the SDM{835,845,...whatever}-wifi-soc-components vs.
> external WCN3990. Additionally, I don't know if it's even possible to
> utilize a different RF module with the same SoC (is there a possibility
> of a, e.g., WCN3991 that can use the same SoC logic?).

Sure. Does it matter though? Even one-off solutions would be better off
if we described what's going on at the board-level so that it isn't
confusing to readers of the schematic and the dts file. Plus, it would
allow the module creator to deliver a dts file for the module without
having to involve the SoC bits and clearly split things so that the SoC
dts file can be written without board assumptions.

> =

> But I'm still not totally convinced that splitting this up really makes
> much sense. Is there other precedent for splitting out a separate node
> for something that we don't talk to at all (no digital interface)? Or do
> we just need a more accurate compatible property, that describes the
> fact that this is a SDM845+WCN3990 combination? The only thing that
> software would ever do with the separate node is look it up to find the
> regulators to power it on.
> =


Agreed, it may seem like overkill, but I'll argue that this part allows
us to easily see where the division of clocks and regulators is, instead
of having to mentally untangle the external module from the internal SoC
bits. I started to compare the AHB and the SNOC bus types in the ath10k
driver but then I decided they were just a little bit different from
each other to where this split wouldn't help that code.

So like you say, if in the future the same SNOC hardware block will be
used with a different WCN chip that has different clock and power
requirements it would be very easy to integrate that by writing a new
sub-device node and driver and doing this split. I admit that there
would be some new work in the ath10k driver to support sub-device
drivers that the bus layer communicates with and it may conflict with
the way the PCI designs are implemented, but I would still argue this is
better from a DT implementer perspective because we can see what things
are on the board and what things are in the SoC.

