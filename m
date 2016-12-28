Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37239 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751911AbcL1UFH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 15:05:07 -0500
Received: by mail-wm0-f51.google.com with SMTP id t79so317455117wmt.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Dec 2016 12:05:06 -0800 (PST)
Subject: Re: [PATCH 1/2] dt-bindings: document common IEEE 802.11 frequency
 properties
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
References: <20161228155955.25518-1-zajec5@gmail.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>, Arnd Bergmann <arnd@arndb.de>,
        devicetree@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f387d897-a1e9-c932-8317-41246be245b0@broadcom.com> (sfid-20161228_210517_679638_3ACB0F1B)
Date: Wed, 28 Dec 2016 21:05:03 +0100
MIME-Version: 1.0
In-Reply-To: <20161228155955.25518-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 28-12-16 16:59, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This new file should be used for properties handled at higher level and
> so usable with all drivers.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  .../devicetree/bindings/net/wireless/ieee80211.txt       | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/ieee80211.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/ieee80211.txt b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
> new file mode 100644
> index 0000000..c762769
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
> @@ -0,0 +1,16 @@
> +Common IEEE 802.11 properties
> +
> +This provides documentation of common properties that are handled by a proper
> +net layer and don't require extra driver code.

Please do not make any assumptions on how DT properties are handled nor
by what. Just state that these properties apply to all wireless devices
and are applicable to device specific bindings.

> +Optional properties:
> + - ieee80211-min-center-freq : minimal supported frequency in KHz
> + - ieee80211-max-center-freq : maximal supported frequency in KHz
> +
> +Example:
> +
> +pcie@0,0 {
> +	reg = <0x0000 0 0 0 0>;
> +	ieee80211-min-center-freq = <2437000>;
> +	ieee80211-max-center-freq = <2457000>;
> +};

Is this the proper level to define it. I was expecting a child node of
the pci(e) controller. Maybe I am misreading the example.

Regards,
