Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33274 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbbCKMM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 08:12:56 -0400
MIME-Version: 1.0
In-Reply-To: <CABxcv=nE_Qd7do+dRyp=fw3wYmWFb+0eEjXYOtdjqE55Cp0zmQ@mail.gmail.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com>
	<20150310173550.GT5264@atomide.com>
	<CABxcv=ndnNj4MhoXeW=GHXT4aEWQYHdbu-Mg4R2Zhf9CJTrJCA@mail.gmail.com>
	<3439869.6umCuOq6SV@wuerfel>
	<CABxcv=nE_Qd7do+dRyp=fw3wYmWFb+0eEjXYOtdjqE55Cp0zmQ@mail.gmail.com>
Date: Wed, 11 Mar 2015 14:12:54 +0200
Message-ID: <CAB3XZEfnZbZqH95suJ9n39aZRr8kxPdj2HZuWKMvQtYmXe3QEQ@mail.gmail.com> (sfid-20150311_131302_131008_97C0D00B)
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
From: Eliad Peller <eliad@wizery.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 11, 2015 at 1:34 PM, Javier Martinez Canillas
<javier@dowhile0.org> wrote:
> I think that patch [0] should not be needed since for external clocks,
> the IP providing the clocks should have its own clock driver and for
> internal clocks, a property should be used instead as you said.
>
>> If there is no external clock provider for this chip and the clocks
>> are provided by the device itself, then all we need is a clock-frequency
>> property in the device node.
>>
>
> Agreed, IIUC Luciano wanted to expose the internal clocks by
> registering in the common clock framework but if those clocks are not
> really accessible from outside the wlan chip, then I also think that a
> device node property should be used instead.
>
how should i describe multiple clock-frequency properties (there are 2
relevant clocks) in this case?

does something like the following makes sense?

wlcore: wlcore@2 {
    ...
    refclock: refclock {
        compatible = "fixed-clock";
        #clock-cells = <0>;
        clock-frequency = <38400000>;
    };
}

Eliad.
