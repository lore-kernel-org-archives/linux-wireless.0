Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f196.google.com ([209.85.217.196]:33919 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933691AbcAYRuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 12:50:19 -0500
Received: by mail-lb0-f196.google.com with SMTP id oe3so7233462lbb.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2016 09:50:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151229190357.GJ16437@tuxbot>
References: <1451266467-15377-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1451266467-15377-5-git-send-email-bjorn.andersson@sonymobile.com>
	<20151229183440.GC12450@rob-hp-laptop>
	<20151229190357.GJ16437@tuxbot>
Date: Mon, 25 Jan 2016 09:50:17 -0800
Message-ID: <CAJAp7OjVBkBQTsmg5JUcmeA+ZQO=NCATn0zRj3ipdkB2qGPuhA@mail.gmail.com> (sfid-20160125_185024_448898_54663CA7)
Subject: Re: [PATCH 4/4] dt: binding: Add Qualcomm wcn36xx WiFi binding
From: Bjorn Andersson <bjorn@kryo.se>
To: Rob Herring <robh@kernel.org>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kalle Valo <kvalo@codeaurora.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <pawel.moll@arm.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	yfw <fengwei.yin@linaro.org>,
	linux-arm-msm <linux-arm-msm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 29, 2015 at 11:03 AM, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Tue 29 Dec 10:34 PST 2015, Rob Herring wrote:
>
>> On Sun, Dec 27, 2015 at 05:34:27PM -0800, Bjorn Andersson wrote:
>> > Add binding representing the Qualcomm wcn3620/60/80 WiFi block.
>> > Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>> > ---
>> >  .../bindings/net/wireless/qcom,wcn36xx-wifi.txt    | 76 ++++++++++++++++++++++
>> >  1 file changed, 76 insertions(+)
>> >  create mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,wcn36xx-wifi.txt
>> >
>> > diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,wcn36xx-wifi.txt b/Documentation/devicetree/bindings/net/wireless/qcom,wcn36xx-wifi.txt
>> > new file mode 100644
>> > index 000000000000..7b314b9f30af
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/net/wireless/qcom,wcn36xx-wifi.txt
>> > @@ -0,0 +1,76 @@
>> > +Qualcomm WCN36xx WiFi Binding
>> > +
>> > +This binding describes the Qualcomm WCN36xx WiFi hardware. The hardware block
>> > +is part of the Qualcomm WCNSS core, a WiFi/BT/FM combo chip, found in a variety
>> > +of Qualcomm platforms.
>>
>> Are BT/FM functions completely separate? If so, separate bindings are
>> okay. If not, then we need to describe the full chip.
>>
>
> It's three different hardware blocks (WiFi, BT and FM-radio) with shared
> RF-hardware and an ARM core for control logic.
>
> There seems to be some control commands going towards the BT part that
> controls coexistence properties of the RF-hardware, but other than that
> I see it as logically separate blocks.
>
>
> So I think it's fine to model this as separate pieces in DT.
>

After more testing I've concluded that there is a timing dependency
between the WiFi driver and the wcnss_ctrl driver. If the WiFi driver
starts communicating with the WLAN subsystem in the WCNSS block before
we have finished uploading the NV data to the WCNSS core further
communication will fail.

So looks like I need to remodel this slightly to take this into account :/

Regards,
Bjorn
