Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32854 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752949AbdACXJl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 18:09:41 -0500
Date: Tue, 3 Jan 2017 17:08:41 -0600
From: Rob Herring <robh@kernel.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V4 1/2] dt-bindings: document common IEEE 802.11
 frequency limit property
Message-ID: <20170103230841.hs7ebd2recvh6ywx@rob-hp-laptop> (sfid-20170104_000944_499768_D1125BEC)
References: <20170103110340.23249-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170103110340.23249-1-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 03, 2017 at 12:03:38PM +0100, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This new file should be used for properties that apply to all wireless
> devices.

The commit msg should answer the questions I asked on v1.

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Switch to a single ieee80211-freq-limit property that allows specifying
>     *multiple* ranges. This resolves problem with more complex rules as pointed
>     by Felx.
>     Make description implementation agnostic as pointed by Arend.
>     Rename node to wifi as suggested by Martin.
> V3: Use more real-life frequencies in the example.
> ---
>  .../devicetree/bindings/net/wireless/ieee80211.txt     | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/ieee80211.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/ieee80211.txt b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
> new file mode 100644
> index 0000000..0cd1219
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
> @@ -0,0 +1,18 @@
> +Common IEEE 802.11 properties
> +
> +This provides documentation of common properties that are valid for all wireless
> +devices.
> +
> +Optional properties:
> + - ieee80211-freq-limit : list of supported frequency ranges in KHz
> +
> +Example:
> +
> +pcie@0,0 {
> +	reg = <0x0000 0 0 0 0>;
> +	wifi@0,0 {
> +		reg = <0x0000 0 0 0 0>;
> +		ieee80211-freq-limit = <2402000 2482000>,
> +				       <5170000 5250000>;
> +	};
> +};
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
