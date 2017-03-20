Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:35856 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754356AbdCTPi1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 11:38:27 -0400
Date: Mon, 20 Mar 2017 10:07:33 -0500
From: Rob Herring <robh@kernel.org>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        ext.waldemar.rymarkiewicz@tieto.com, kvalo@codeaurora.org
Subject: Re: [PATCH 1/2] dt: bindings: add new dt entry for ath10k
 calibration variant
Message-ID: <20170320150733.25bufnzrhh7xabml@rob-hp-laptop> (sfid-20170320_163853_897085_23EF09B6)
References: <20170310080615.22958-1-sven.eckelmann@openmesh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170310080615.22958-1-sven.eckelmann@openmesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 10, 2017 at 09:06:14AM +0100, Sven Eckelmann wrote:
> The bus + bmi-chip-id + bmi-board-id is not enough to identify the correct
> board data file on QCA4019 based devices. Multiple different boards share
> the same values. Only the original reference designs can currently be
> identified and loaded from the board-2.bin. But these will not result in
> the correct calibration data when combined with the pre-calibration data
> from the device.
> 
> An additional "variant" information has to be provided (via SMBIOS or DT)
> to select the correct board data for a design which was modified by an ODM.
> 
> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
> ---
> Since RFC:
> 
>  - Split patch in DT doc and ath10k part (thanks Christian Lamparter)
>  - Remove the words "bmi-chip-id" and "bmi-board-id" and replace them with
>    more generic "device specific ids"
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index 74d7f0af209c..3d2a031217da 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -41,6 +41,9 @@ Optional properties:
>  - qcom,msi_addr: MSI interrupt address.
>  - qcom,msi_base: Base value to add before writing MSI data into
>  		MSI address register.
> +- qcom,ath10k-calibration-variant: string to search for in the board-2.bin
> +				   variant list with the same bus and device
> +				   specific ids

Sounds like you should use a more specific compatible string.

>  - qcom,ath10k-calibration-data : calibration data + board specific data
>  				 as an array, the length can vary between
>  				 hw versions.
> -- 
> 2.11.0
> 
