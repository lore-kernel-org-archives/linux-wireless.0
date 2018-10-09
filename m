Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8F3C67879
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 01:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22EE721476
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 01:07:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OycQHvQx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22EE721476
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbeJIIVj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 04:21:39 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45436 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbeJIIVj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 04:21:39 -0400
Received: by mail-pf1-f196.google.com with SMTP id u12-v6so6026073pfn.12
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 18:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zMjslepzakTLo3e6QKPDkzI3w1kDi1qg8wBr+Kn9rJk=;
        b=OycQHvQxh7F6wT1ZKUL+PBdNqQZjRdIIGaCndb78uyL53gludte9HqEvsAs/OxTw0P
         okqlouidCri/pJ4QzpyfKXj4p9Vv38oUaHfcJOVhOoiN0omRT1hh/0IwTvnTBjawF3Gv
         pn9VdI5VjSZ3jIM4D7PqdbITptlbSvb19dY1U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zMjslepzakTLo3e6QKPDkzI3w1kDi1qg8wBr+Kn9rJk=;
        b=EfS+gsg57bCzP7jSI3gRAYHeJKSA1JElfjykopDaQ9n/XNKRDaMQosAZaIU0y06N9Z
         erzmwCrOpZuPfuZ2+cQu/H5WG3MDAUdXdw32YGLi1v9lOwA6xWyzgeiWqilK1WpI75g7
         qMZEpqbTlGQ0UbdTr7rwBRohcXuqSM/TooH5OwzL25HmlniN8huZvFuAUIC4MydR3eKz
         LtR0XirPIdSQ2tSM0BZ3H4+A6FaQf3x/kEUpf0E0jHFbcACCxk3bgUgMwf3Hm4XL31R9
         0YQg+8gZC0m/H08U6hPmz197oQFjD8wS8oQa20YZ5QBS8TzDVmuK+PAB9+4oRQ4a6mij
         hErg==
X-Gm-Message-State: ABuFfoiB1g/whUSJ4QnkYW3onYfR+bCBxvm+noLjJ3u2GQCvRGF6obJ4
        cA5KQEG+NSomhxTznXmHzPJnRQ==
X-Google-Smtp-Source: ACcGV61XcYLBAd2t2YqT6mRggGVW4Qfaz8sJjLTV2mGHoXgkeWK6gOVq/NRk3mm1CqZMGSOPNU1bBA==
X-Received: by 2002:a63:6d83:: with SMTP id i125-v6mr22741818pgc.215.1539047236053;
        Mon, 08 Oct 2018 18:07:16 -0700 (PDT)
Received: from ban.mtv.corp.google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id h88-v6sm43113399pfa.184.2018.10.08.18.07.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Oct 2018 18:07:15 -0700 (PDT)
Date:   Mon, 8 Oct 2018 18:07:13 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org,
        netdev@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] dt-bindings: Add bindings for aliases node
Message-ID: <20181009010711.GA1577@ban.mtv.corp.google.com>
References: <20180925210255.172734-1-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180925210255.172734-1-mka@chromium.org>
User-Agent: Mutt/1.10.1+48 (1f3a9df87d11) (2018-07-22)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-spi, linux-wireless, netdev
+ others from previous conversations

Hi,

On Tue, Sep 25, 2018 at 02:02:55PM -0700, Matthias Kaehlcke wrote:
> Add a global binding for the 'aliases' node. This includes an initial list
> of standardized alias names for some hardware components that are commonly
> found in 'aliases'.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
>  Documentation/devicetree/bindings/aliases.txt | 47 +++++++++++++++++++
>  1 file changed, 47 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/aliases.txt
> 
> diff --git a/Documentation/devicetree/bindings/aliases.txt b/Documentation/devicetree/bindings/aliases.txt
> new file mode 100644
> index 000000000000..d64ed1c7eb34
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/aliases.txt
> @@ -0,0 +1,47 @@
> +The aliases node
> +----------------

I like the idea in general, and it might be good to note (e.g., commit
message) that this was inspired by this thread:

https://lore.kernel.org/lkml/20180815221601.GB24830@rob-hp-laptop/

where we were interested in firmware-to-device-tree path stability --
and the answer was basically: don't memorize paths, just use aliases
instead. But then, it was clear that aliases were not documented very
formally at all.

So here we are!

> +
> +The aliases node contains properties that represent aliases to device tree
> +nodes. The name of the property is the alias name, the value is the path of
> +a the device tree node that corresponds to the alias. The path may be
> +specified as a string or a phandle.
> +
> +Alias names are often suffixed with a numeric ID, especially when there may
> +be multiple instances of the same type. The ID typically corresponds to the
> +hardware layout, it may also be used by drivers for a stable mapping of
> +device names and hardware entities.
> +
> +Alias names
> +-----------
> +
> +The devicetree specification doesn't require the use of specific alias
> +names to refer to hardware entities of a given type, however the Linux
> +kernel aims for a certain level of consistency.
> +
> +The following standardized alias names shall be used for their
> +corresponding hardware components:
> +
> +  bluetoothN		Bluetooth controller
> +  ethernetN		Ethernet interface
> +  gpioN			GPIO controller
> +  i2cN			i2c bus
> +  mmcN			MMC bus
> +  rtcN			Real time clock
> +  serialN		UART port
> +  spiN			SPI bus
> +  wifiN			Wireless network interface

For the network-device-related names (bluetooth, ethernet, and wifi), I
think there's a clear documented reason for this (supporting MAC address
plumbing from a DT-aware bootloader). I'm not quite as sure about all
the others, and unfortunately, I'm aware of at least one subsystem owner
that explicitly does NOT like the aliases usage that is currently
supported (spi), and shot down a patch where I tried to use it in a DTS
file (despite its regular usage in many other DTS files).

So I guess I'm saying: perhaps we should get buy-in from various
subsystems before we include them? So maybe it's wiser to start
small(er) and only add once we're sure they are useful? Or perhaps Rob
has other thoughts.

> +
> +The above list is not exhaustive and will be extended over time. Please
> +send patches to devicetree@vger.kernel.org if you think a hardware
> +component and its alias name should be on the list.
> +
> +Example
> +-------
> +
> +aliases {
> +	bluetooth0 = "/soc/serial@fdf01000/bluetooth";
> +	rtc0 = &rtc0;
> +	wifi0 = &wlcore;
> +};
> +
> +(based on arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts)

What is the relevance of this line? This doesn't look anything like that
hikey DTS. Maybe the "based on" line should just be removed? The example
seems fine though.

Anyway, perhaps with a trimmed list of supported alias names:

Reviewed-by: Brian Norris <briannorris@chromium.org>
