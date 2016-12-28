Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45931 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751994AbcL1Vfp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 16:35:45 -0500
Subject: Re: [PATCH 1/2] dt-bindings: document common IEEE 802.11 frequency
 properties
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
References: <20161228155955.25518-1-zajec5@gmail.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <ddd1bb11-eb4d-7a53-c3ea-5ff5e59ae100@nbd.name> (sfid-20161228_223548_706734_C3E6648F)
Date: Wed, 28 Dec 2016 22:35:39 +0100
MIME-Version: 1.0
In-Reply-To: <20161228155955.25518-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-12-28 16:59, Rafał Miłecki wrote:
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
> +
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
I'm not sure that's the best way to deal with enabling/disabling bands.
If we get more bands in the future, there might be unsupported ones in
the middle, which min/max won't cover.

- Felix
