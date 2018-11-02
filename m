Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_MUTT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1376C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 18:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8903B20854
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 18:43:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fVR61dcc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8903B20854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbeKCDve (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 23:51:34 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43101 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729508AbeKCDve (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 23:51:34 -0400
Received: by mail-pg1-f193.google.com with SMTP id n10-v6so1338280pgv.10
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 11:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WnwvQXKad+rRy44n/FbLXHvNboM8G9FjxnswRyPS3pg=;
        b=fVR61dccUaYRqycDlgWwfF0HrGK3RzHxHE7WuybZ252YSJJkuL5Hs0zxxP/o/8tc7D
         zPr/K1EwA5O1ZQyg3kGrucoTvj35XAQsb/4kkfdIeX2djLVi7sdLKRm9+VZMmfG09EGl
         450eD1U1z4HtUXOiceAJqRs+tIVHz/jGLXutk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WnwvQXKad+rRy44n/FbLXHvNboM8G9FjxnswRyPS3pg=;
        b=Dt4xeOyweN3gEE4etSNxKroTD4FuCeg/NRUVsDEpnGtdbzHmJZsmWAyk6ZO4T9LYya
         SeEfsWwI18AiBjlRcYSCB8QUrZp/BCsYHXpGKvE5Bqv7PccUMbZ9AxOGHY0FPyOIRy1t
         TTrwehIN5Trvux3ZbB4w33dF0Hjt0IrcPKftPP8DTY71PwLH4MW+CQ0qkxF1bxpD2hK1
         EAkvVwINmK9MsEdlvX30zd1yR/Kv4rw6oI73S9sbkeJmUIY2B97Zj5RvA/AfHOtNaQmP
         l+ny3QsKPd9u4UM86pkJ8TqXrdRJF8zGo6pIpW6sJ1j3vWDZQ6weY5djXCaatYSjvrXz
         ZlaA==
X-Gm-Message-State: AGRZ1gJKrGApcJspm+RJG8kzOxhXj6aZpyRrZa0fJGm+EIVeLov45tBR
        Vq4FERqUbk4RvSCQzzDJtg1OMg==
X-Google-Smtp-Source: AJdET5dAB+UEpvLVNThWduF/euLVYxLrJsrRjO8HZDfwvkuFBjsVljGyXrvyT/2PR5R27pVKrHJBUw==
X-Received: by 2002:a63:d14a:: with SMTP id c10-v6mr11981435pgj.384.1541184201459;
        Fri, 02 Nov 2018 11:43:21 -0700 (PDT)
Received: from google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id g123-v6sm71329406pfc.67.2018.11.02.11.43.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 02 Nov 2018 11:43:19 -0700 (PDT)
Date:   Fri, 2 Nov 2018 11:43:17 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     Govind Singh <govinds@codeaurora.org>, andy.gross@linaro.org,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-wireless@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH v3 1/3] dt: bindings: add missing dt properties for
 WCN3990 wifi node
Message-ID: <20181102184315.GA130458@google.com>
References: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
 <1539172376-19269-2-git-send-email-govinds@codeaurora.org>
 <153976208916.5275.15753381614937010537@swboyd.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153976208916.5275.15753381614937010537@swboyd.mtv.corp.google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Stephen and Govind,

I was chatting with Govind, and he seemed to be a bit stalled on this.
I'd encourage him to reply with whatever knowledge he has, because it's
a bit hard to give definitive answers when I don't know all the inner
workings here. (In fact, you, Stephen, probably know more than me about
how Qualcomm MSM chips work.)

First of all, I'll explain the limited bits I do know, and see how they
fit in below. I may be wrong.

WCN3990 is an external module, for supporting BT and Wifi RF components.
It has a host interface for the Wifi, but it's not something the host
knows how to talk to directly at all -- it's an "Analog IQ" interface,
between an internal SoC MAC and PHY processor. Instead, we talk to this
module via the System NOC (?). So while there are basically 2 distinct
hardware components (on-SoC coprocessors, various internal communication
buses, various shared memory regions, etc.; and the external WCN3990
module), there is almost no way for the main processor to "talk" to the
WCN3990 directly.

Another data point to throw into the mix: WCN3990 can apparently be used
on multiple different SoCs -- I see public announcments about SDM835
(and 660?), and I'm currently playing with it on SDM845. So perhaps
there is some value in understanding "WCN3990" as being distinct from
"WiFi MAC/PHY hardware and communication logic found on a MSM SoC." But
they do seem to be very tightly coupled...

Side note: there is also a BT component on the WCN3990 module, and we
*can* talk to that directly over UART. There's a separate binding going
in for that, and it's a much clearer separation to divide "UART
controller" and "BT/UART interface on WCN3990."

On Wed, Oct 17, 2018 at 12:41:29AM -0700, Stephen Boyd wrote:
> Quoting Govind Singh (2018-10-10 04:52:54)
> > --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> > +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt

> > @@ -55,7 +63,8 @@ Optional properties:
> >  - qcom,ath10k-pre-calibration-data : pre calibration data as an array,
> >                                      the length can vary between hw versions.
> >  - <supply-name>-supply: handle to the regulator device tree node
> > -                          optional "supply-name" is "vdd-0.8-cx-mx".
> > +                          optional "supply-name" are "vdd-0.8-cx-mx",
> > +                          "vdd-1.8-xo", "vdd-1.3-rfa" and "vdd-3.3-ch0".
> 
> Why can't the wifi firmware manage these regulators itself?

In my understanding:
At least 3 of those (all the supplies Govind is adding) are external
pins on the RF module. Why do you assume these are something the
firmware can control? In the schematics I'm looking at, this seems to be
connected to a PMIC. While it's certainly possible this is something the
Q6 processor (running modem and Wifi firmware) can control, it doesn't
seem obvious to me that they *must* be able to.

So I guess I'd say: why not represent these regulators in the device
tree? It seems like a valid hardware description (like I said, 3 power
rail pins on an external module).

Now, your *next* paragraph might have hairier points :)

> And these names don't seem to match any sort of schematic or really

Which names? I see these pin names on the WCN3990 datasheets I see:

 VDD18_IO
 VDD18_XO
 VDD33_CH0
 VDD33_CH1
 VDD13_RFA

3 of those match the 3 Govind is adding, and they appear to line up with
what I see in schematics.

> describe what this device is. From what I can tell, we've combined the

I've described "waht the device is" above to the best of my knowledge.
If you're just looking at schematics, you might possibly be thrown by
the fact that WCN3990 is packaged in a module provided by other vendors,
so it might be labeled by that vendor on the schematic, not by the
Qualcomm WCN3990 name.

> off-SoC wifi module with the on-SoC wifi I/O space into one DT node here
> and then relied on that node to make some driver probe in the kernel to
> do wifi stuff. Can we model this properly by actually showing that

I'll remind you that "properly" is often highly subjective :)

> there's something in the SoC, and there's something outside the SoC, and
> these two things are connected by having two nodes and a phandle between
> them?

Why phandle? Under what bus would you place the WCN3990? As per my
description above, there is really no way to talk to it directly. So if
anything, it seems like it would be a subnode of the node we're
describing here.

In favor of your separation though: there are many ways to utilize
WCN3990 apparently, and I'd imagine the binding might change a bit
depending on the SoC (e.g., different clocks?). So there might be value
in describing the SDM{835,845,...whatever}-wifi-soc-components vs.
external WCN3990. Additionally, I don't know if it's even possible to
utilize a different RF module with the same SoC (is there a possibility
of a, e.g., WCN3991 that can use the same SoC logic?).

But I'm still not totally convinced that splitting this up really makes
much sense. Is there other precedent for splitting out a separate node
for something that we don't talk to at all (no digital interface)? Or do
we just need a more accurate compatible property, that describes the
fact that this is a SDM845+WCN3990 combination? The only thing that
software would ever do with the separate node is look it up to find the
regulators to power it on.

Brian

> >  
> >  Example (to supply the calibration data alone):
> >  
> > @@ -133,8 +142,10 @@ wifi@18000000 {
> >                 compatible = "qcom,wcn3990-wifi";
> >                 reg = <0x18800000 0x800000>;
> >                 reg-names = "membase";
> > -               clocks = <&clock_gcc clk_aggre2_noc_clk>;
> > -               clock-names = "smmu_aggre2_noc_clk"
> > +               clocks = <&clock_gcc clk_aggre2_noc_clk>,
> > +                        <&clock_gcc clk_rf_clk2_pin>;
> > +               clock-names = "smmu_aggre2_noc_clk",
> > +                             "cxo_ref_clk_pin";
> >                 interrupts =
> >                            <0 130 0 /* CE0 */ >,
> >                            <0 131 0 /* CE1 */ >,
