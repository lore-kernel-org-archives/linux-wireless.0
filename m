Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35898 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753580AbcKROoJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 09:44:09 -0500
Date: Fri, 18 Nov 2016 08:44:06 -0600
From: Rob Herring <robh@kernel.org>
To: c_traja@qti.qualcomm.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        tamizhchelvam@codeaurora.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv2 3/4] dt: bindings: add new dt entry for BTCOEX feature
 in qcom,ath10k.txt
Message-ID: <20161118144406.3se7gnckhcmwqytp@rob-hp-laptop> (sfid-20161118_154446_214107_6749258D)
References: <1479383064-25718-1-git-send-email-c_traja@qti.qualcomm.com>
 <1479383064-25718-4-git-send-email-c_traja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479383064-25718-4-git-send-email-c_traja@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 17, 2016 at 05:14:23PM +0530, c_traja@qti.qualcomm.com wrote:
> From: Tamizh chelvam <tamizhchelvam@codeaurora.org>
> 
> There two things done in this patch.
> 
> 1) 'btcoex_support' flag for BTCOEX feature support by the hardware.
> 2) 'wlan_btcoex_gpio' is used to fill wlan priority pin number for
>    BTCOEX priority feature support.
> 
> Signed-off-by: Tamizh chelvam <tamizhchelvam@codeaurora.org>
> ---
>  .../bindings/net/wireless/qcom,ath10k.txt          |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index 74d7f0a..08150e2d 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -46,6 +46,10 @@ Optional properties:
>  				 hw versions.
>  - qcom,ath10k-pre-calibration-data : pre calibration data as an array,
>  				     the length can vary between hw versions.
> +- btcoex_support  : should contain eithr "0" or "1" to indicate btcoex
> +		    support by the hardware.

This is BT coexistence? Make this boolean and n

> +- btcoex_gpio_pin :  btcoex gpio pin number for the device which
> +		     supports BTCOEX.

This is a pin number on the chip, not any pin number Linux GPIO subsys 
cares about, right? Is there a connection to the host too, or this is 
internal between BT and WiFi?

Do you really need 2 properties? Does supporting this feature require 
the GPIO? If so, then the first property is redundant.

Needs vendor prefix and don't use '_'. Should be something like 
'qcom,bt-coexist-gpio-pin'.

Rob
