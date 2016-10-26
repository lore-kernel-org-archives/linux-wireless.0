Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36337 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754465AbcJZU4i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 16:56:38 -0400
Received: by mail-pf0-f171.google.com with SMTP id e6so2941689pfk.3
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2016 13:56:37 -0700 (PDT)
Date: Wed, 26 Oct 2016 13:56:34 -0700
From: Brian Norris <briannorris@chromium.org>
To: Rajat Jain <rajatja@google.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Brian Norris <briannorris@google.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh@kernel.org>,
        Rajat Jain <rajatxjain@gmail.com>
Subject: Re: [PATCH v6] mwifiex: parse device tree node for PCIe
Message-ID: <20161026205634.GA13170@localhost> (sfid-20161026_225642_630051_21372761)
References: <1477070156-109965-1-git-send-email-rajatja@google.com>
 <1477084869-15612-1-git-send-email-rajatja@google.com>
 <20161026201735.GA10192@localhost>
 <20161026204648.GD3989@dtor-ws>
 <CACK8Z6H1ACBo7nDxaXR3Vn9cPdyRqxxzdgYz7vNmojiSvjbW5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACK8Z6H1ACBo7nDxaXR3Vn9cPdyRqxxzdgYz7vNmojiSvjbW5A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 26, 2016 at 01:51:48PM -0700, Rajat Jain wrote:
>    On Wed, Oct 26, 2016 at 1:46 PM, Dmitry Torokhov
>    <dmitry.torokhov@gmail.com> wrote:
>      On Wed, Oct 26, 2016 at 01:17:36PM -0700, Brian Norris wrote:
>      Sorry, I just saw this... Why do we need devicetree data for
>      discoverable bus (PCI)? How does the driver work on systems that do not
>      use DT? Why do we need them to behave differently?
> 
>    There are a couple of out-of-band GPIO pins from Marvell chip that can
>    serve as wake-up pins (wake up the CPU when asserted). The Marvell chip
>    has to be told which GPIO pin is to be used as the wake-up pin. The pin to
>    be used is system / platform dependent. (On some systems it could be
>    GPIO13, on others it could be GPIO14 etc depending on how the marvell chip
>    is wired up to the CPU).

There's also calibration data. See "marvell,caldata*" and
"marvell,wakeup-pin" properties. Currently only for SDIO, in
Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt, but
we're adding support for PCIe.

Brian
