Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E76C5ACCC
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 22:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F152D2148C
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 22:53:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZmcUBUKD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F152D2148C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbeJQGqa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 02:46:30 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:38313 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbeJQGqa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 02:46:30 -0400
Received: by mail-vk1-f196.google.com with SMTP id w123so641317vkh.5
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 15:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jm4bxFZBK4pXMVRDJpdyn1E4FT4nGELUiGbw/4TP3vw=;
        b=ZmcUBUKDqiaw5f5UPViUOT+u2Ba/eCc+dwCbZjwfjQQYSH3wPkPJOcwBZxeWhyeBF6
         9mWUi0gdLD9nUOK7ri7DFNWjlozcak9yU6naA9PcXv1d5YN/UITz0KlxINqNZAtiFMUN
         h/9sucPZT4Cav6aNlxONUtB94jDzr0+FSohVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jm4bxFZBK4pXMVRDJpdyn1E4FT4nGELUiGbw/4TP3vw=;
        b=FAxXNCmIzw7lKHfOQ7IkNpMbfXKJmfdHaDf33C0cqNh2hcgYwLg8ixhhTlEeIK00S/
         JnRCj8LOPZe5p4M+6GeBPhYuDXzMOzSIBYz+KyPnhV0zxgCvQHOw5Y6vVZ8pdIywJS0n
         wcGb3oD+TZNaOJkfJ5lgml/u4SLhTtwNI0DX4rNB+YfPDXAWOPInoREfCV9In2SYKx0z
         Eqvg6eTg/gVcAU6Jh6fmaZuQ2Ueqea5ze1LTyhv+o2PFHKKAUTPZax97zHdQtyP0bASV
         npVN8kgY9GFw3N1PUsEyZEcReuM5yg8bOEXUqUx+zxbBaLjxHijjhLRzWDNEgvk3S4r7
         fKLQ==
X-Gm-Message-State: ABuFfogVS4W/+UPjDzwgw8Sjq6OZogyIbPXsHZor8ZhRnTL4bssKx/ly
        BeWgT0TrOX3VlgC9M0oU0UyRsnd3FLo=
X-Google-Smtp-Source: ACcGV60WF0xST/nguKHYQ/G3cKpVuwH4iU/tFTfyirU7EU/dFyOFecawMKpb4ZhoaMoBH3ZIF5D4TQ==
X-Received: by 2002:a1f:7cc4:: with SMTP id x187mr10059741vkc.38.1539730432548;
        Tue, 16 Oct 2018 15:53:52 -0700 (PDT)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id v85-v6sm3193728vkd.18.2018.10.16.15.53.51
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Oct 2018 15:53:51 -0700 (PDT)
Received: by mail-ua1-f42.google.com with SMTP id b3so4038622uak.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 15:53:51 -0700 (PDT)
X-Received: by 2002:ab0:7291:: with SMTP id w17mr10526696uao.115.1539730430858;
 Tue, 16 Oct 2018 15:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <1539172376-19269-1-git-send-email-govinds@codeaurora.org> <1539172376-19269-2-git-send-email-govinds@codeaurora.org>
In-Reply-To: <1539172376-19269-2-git-send-email-govinds@codeaurora.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 16 Oct 2018 15:53:39 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WP-Xx+xeCGTxSFcSrmhAv-6F3zm-0hnLxhHi84u-fUkQ@mail.gmail.com>
Message-ID: <CAD=FV=WP-Xx+xeCGTxSFcSrmhAv-6F3zm-0hnLxhHi84u-fUkQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] dt: bindings: add missing dt properties for
 WCN3990 wifi node
To:     Govind Singh <govinds@codeaurora.org>
Cc:     devicetree@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <andy.gross@linaro.org>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Wed, Oct 10, 2018 at 4:53 AM Govind Singh <govinds@codeaurora.org> wrote:
>
> Add missing optional properties in WCN3990 wifi node.
>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  .../bindings/net/wireless/qcom,ath10k.txt          | 28 ++++++++++++++++------
>  1 file changed, 21 insertions(+), 7 deletions(-)

Point of order: please CC LKML on _all_ your patches.  Yes, it's a
firehose.  CCing LKML allows your patches to be found on
lore.kernel.org's patchwork and also allows people to find your
patches via <https://lkml.kernel.org/r/MSG_ID> links.


> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index 7fd4e8c..f831bb1 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -37,12 +37,20 @@ Optional properties:
>  - clocks: List of clock specifiers, must contain an entry for each required
>            entry in clock-names.
>  - clock-names: Should contain the clock names "wifi_wcss_cmd", "wifi_wcss_ref",
> -               "wifi_wcss_rtc".
> -- interrupts: List of interrupt lines. Must contain an entry
> -             for each entry in the interrupt-names property.
> +              "wifi_wcss_rtc" for "qcom,ipq4019-wifi" compatible target and
> +              "cxo_ref_clk_pin", "smmu_aggre2_noc_clk" for "qcom,wcn3990-wifi"
> +              compatible target.

I always get confused with these big bindings patches that hide
everything under a big "Optional properties" section to avoid
specifying which properties are actually optional and which ones are
required.

After your patch and thinking about "qcom,wcn3990-wifi" in particular,
it's unclear to me which of the following is true (or maybe something
totally different I didn't think of)

A) On wcn3990-wifi these clocks should be a required property but it's
only listed under "Optional" because it's not used for some of the
different WiFi drivers using this same bindings.

B) On wcn3990-wifi these clocks should either both be there or neither.

C) On wcm3990-wifi you can specify zero, either, or both of these
clocks.  AKA they are independently optional.

It might make sense to reorganize this bindings to make this clearer?
...not just for clock but for interrupts / regulators as well.  Maybe
you need to break this down into sections per class of compatible
string, or add a list per compatible string down below?

Also: even stranger is that even though you list two clocks here the
current driver I see in linuxnext only has "cxo_ref_clk_pin".


> +- interrupts: reference to the list of 17 interrupt no's for "qcom,ipq4019-wifi"
> +             compatible target.
> +             reference to the list of 12 interrupt no's for "qcom,wcn3990-wifi"
> +             compatible target.
> +             Must contain interrupt-names property per entry for
> +             "qcom,ath10k", "qcom,ipq4019-wifi" compatible targets.

...and just to add some credence to my concerns above, "interrupts"
are currently listed under "Optional" properties but I don't think
that the wcn3990 driver will actually work if you don't specify any of
the interrupts, right?  AKA for wcn3990 they are _not_ optional and
you must have exactly 12 interrupts.


One separate issue I have is with your example, which you didn't
change in this patch.  You should fix the example with the same
feedback that I had to your patch ("dts: arm64/sdm845: Add WCN3990
WLAN module device node").

-Doug
