Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:34227 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933304AbcJZVRE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 17:17:04 -0400
Received: by mail-yw0-f182.google.com with SMTP id w3so21303684ywg.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2016 14:17:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161026210805.GA14423@localhost>
References: <1477070156-109965-1-git-send-email-rajatja@google.com>
 <1477084869-15612-1-git-send-email-rajatja@google.com> <20161026201735.GA10192@localhost>
 <20161026204648.GD3989@dtor-ws> <CACK8Z6H1ACBo7nDxaXR3Vn9cPdyRqxxzdgYz7vNmojiSvjbW5A@mail.gmail.com>
 <20161026205634.GA13170@localhost> <20161026210648.GE3989@dtor-ws> <20161026210805.GA14423@localhost>
From: Rajat Jain <rajatja@google.com>
Date: Wed, 26 Oct 2016 14:16:22 -0700
Message-ID: <CACK8Z6GHv6Fm20EExRWh+QafOF8jg7te9aXoZo5GdNNiOxvv6g@mail.gmail.com> (sfid-20161026_231708_845001_5C2537C9)
Subject: Re: [PATCH v6] mwifiex: parse device tree node for PCIe
To: Brian Norris <briannorris@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Brian Norris <briannorris@google.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh@kernel.org>,
        Rajat Jain <rajatxjain@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 26, 2016 at 2:08 PM, Brian Norris <briannorris@chromium.org> wrote:
> On Wed, Oct 26, 2016 at 02:06:48PM -0700, Dmitry Torokhov wrote:
>> On Wed, Oct 26, 2016 at 01:56:34PM -0700, Brian Norris wrote:
>> > On Wed, Oct 26, 2016 at 01:51:48PM -0700, Rajat Jain wrote:
>> > >    On Wed, Oct 26, 2016 at 1:46 PM, Dmitry Torokhov
>> > >    <dmitry.torokhov@gmail.com> wrote:
>> > >      On Wed, Oct 26, 2016 at 01:17:36PM -0700, Brian Norris wrote:
>> > >      Sorry, I just saw this... Why do we need devicetree data for
>> > >      discoverable bus (PCI)? How does the driver work on systems that do not
>> > >      use DT? Why do we need them to behave differently?
>> > >
>> > >    There are a couple of out-of-band GPIO pins from Marvell chip that can
>> > >    serve as wake-up pins (wake up the CPU when asserted). The Marvell chip
>> > >    has to be told which GPIO pin is to be used as the wake-up pin. The pin to
>> > >    be used is system / platform dependent. (On some systems it could be
>> > >    GPIO13, on others it could be GPIO14 etc depending on how the marvell chip
>> > >    is wired up to the CPU).
>>
>> So wakeup pin is not wired to PCIe WAKE?
>
> Not in our case.
>
>> > There's also calibration data. See "marvell,caldata*" and
>> > "marvell,wakeup-pin" properties. Currently only for SDIO, in
>> > Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt, but
>> > we're adding support for PCIe.
>>
>> How would it all work if I moved the PCIe module from one device to
>> another?
>
> These boards are soldered down, at least in the case I care about.

That is right. Since the out of band wake-up pin is not standard on
the PCIe connector - this feature is for soldered chips only.


>
> Brian
