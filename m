Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D571E3469F6;
	Wed, 22 Jul 2026 13:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784728612; cv=none; b=j/3vEprRxbVNYzUIIqolfJFBChg70BEpmBN3ygdi8+CIza5wuCA6OmSZT5yWzT4wTEh79aY2h4gCChdqVJDdAFz6qau6nlr3n27GKPZ+L6qatfbDD+mA2hln1oMrRDaW2wHCiZwheukF1l38OQ9xcjcoAxGifmBL5UsPxlghLsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784728612; c=relaxed/simple;
	bh=c/7N6KbADqM0WgN320UPrjz3skJFAld4wBD9sgg7JaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T4/9XIcshb0aaEQRxo4QESppA1zVEiJuKz7Z9fi0c3CDZMQdpedEv8SDNvSrPk/cCkvG5sPSLYPcWP449zjMCvZosPk+bPDTMvjNZGsKnrJfvGSMuA50lE1IYpJAVOxjCbwYEZ89dVNLEunQo6bUXPyQVcpHOHHmesd28WEuRic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aM4rVYxw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aM4rVYxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742BE1F000E9;
	Wed, 22 Jul 2026 13:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784728610;
	bh=sehDTWB0q5frYBeNUuht2aeeZDtQWH6OWbqVSpxsbs4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aM4rVYxwFhpdESVNtNEH0TL19rF/Ph+vLZLrEzmEh+nq2M52/uJlNSVyTwUkWbLA3
	 WbLKcWcQeIRu0SXOKP45pQQS+cNUS6JE3tHPuQyumc/K7ZkaOmbEGASa+je8cmfWvE
	 V934w3dNxldNFSAMHNutcTpLW3sxy9cU6+hGFrGRzPqth4bBfuB0iM1H6OBaCt21LG
	 3Oz/E18Hr2KL+/IiFKrR+PPm+Tsp/YjK+A/HWTmyRBWhiNPeqd7T/gzUAkdAw5ylth
	 DDE54SjkJCghE5f5Kh/I2wyc9ntGzbL592c83Umm4pjriXC+sVXrWVx/HYnIsL9NDk
	 wD+xJd5JJs1Hw==
Message-ID: <3d954cdd-6dde-4be6-84c9-2f2f7d008f5b@kernel.org>
Date: Wed, 22 Jul 2026 14:56:41 +0100
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/9] Support for block device NVMEM providers
To: Loic Poulain <loic.poulain@oss.qualcomm.com>,
 Ulf Hansson <ulfh@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Johannes Berg <johannes@sipsolutions.net>, Jeff Johnson
 <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
 Marcel Holtmann <marcel@holtmann.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
 Rocky Liao <quic_rjliao@quicinc.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Srinivas Kandagatla <srini@kernel.org>,
 Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Saravana Kannan
 <saravanak@kernel.org>, Christian Marangi <ansuelsmth@gmail.com>
Cc: linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-block@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org,
 netdev@vger.kernel.org, daniel@makrotopia.org,
 Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
 Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20260703-block-as-nvmem-v8-0-98ae32bfc49a@oss.qualcomm.com>
Content-Language: en-US
From: Srinivas Kandagatla <srini@kernel.org>
In-Reply-To: <20260703-block-as-nvmem-v8-0-98ae32bfc49a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/3/26 2:45 PM, Loic Poulain wrote:
> On embedded devices, it is common for factory provisioning to store
> device-specific information, such as Ethernet or WiFi MAC addresses,
> in a dedicated area of an eMMC partition. This avoids the need for
> and additional EEPROM/OTP and leverages the persistence of eMMC.
> 
> One example is the Arduino UNO-Q, where the WiFi MAC address and the
> Bluetooth Device address are stored in the eMMC Boot1 partition.
> 
> Until now, accessing this information required a custom bootloader
> to read the data and inject it into the Device Tree before handing
> control over to the kernel. This approach is fragile and leads to
> device-specific workarounds.
> 
> Rather than adding a new NVMEM provider specifically to the eMMC
> subsystem, the new support operates at the block layer, allowing any
> block device to behave like other non-volatile memories such as EEPROM
> or OTP.
> 
> This series builds on earlier work by Daniel Golle that enables block
> devices to act as NVMEM providers:
> https://lore.kernel.org/all/6061aa4201030b9bb2f8d03ef32a564fdb786ed1.1709667858.git.daniel@makrotopia.org/
> 
> It also introduces an NVMEM layout description for the Arduino UNO-Q,
> allowing device-specific data stored in the eMMC Boot1 partition to
> be accessed in a standard way.
> 
> WiFi and Ethernet already support retrieving MAC addresses from NVMEM.
> Bluetooth requires similar support, which is also addressed.
> 
> Note that this is currently limited to MMC-backed block devices, as
> only the MMC core associates a firmware node with the block device
> (add_disk_fwnode). This can be easily extended in the future to
> support additional block drivers.
> 
> Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>

What is the merge strategy here, Am happy to take it via nvmem tree if
all the non nvmem patches are acked or reviewed-by.

--srini
> ---
> Changes in v8:
> - block: Fix bdev->bd_nvmem on registering failure (sashiko)
> - net: of_net: of_get_nvmem_eui48() now also rejects all-ones cells (sashiko)
> - Bluetooth: mgmt: account for HCI_QUIRK_USE_BDADDR_NVMEM in
>   is_configured() and get_missing_options() (sashiko)
> - Reword blk-nvmem KCONFIG help text to satisfy checkpatch
> - Link to v7: https://lore.kernel.org/r/20260701-block-as-nvmem-v7-0-3fe8205ef0a8@oss.qualcomm.com
> 
> Changes in v7:
> - Rework bindings/dts so that the eMMC boot partition can be a nvmem fixed-layout
>   and not a child of fixed-partition. (Rob)
> - Add Support for fixed-layout as the nvmem device node itself
> - Remove "block: partitions: of: Skip child nodes without reg property"
>   This is no more required in this series and will be submitted separately (Rob)
> - Add missing linux/cleanup.h and linux/device.h includes (Bartosz)
> - simplify nvmem_register() error path using dev_err_probe() (Bartosz)
> - nvmem_device forward declaration to blk_types.h (Bartosz)
> - Add hci_dev_get_bd_addr_from_nvmem() kernel-doc for return value (Piotr)
> - Link to v6: https://lore.kernel.org/r/20260629-block-as-nvmem-v6-0-f02513dcd46d@oss.qualcomm.com
> 
> Changes in v6:
> - blk_nvmem_add() returns int, error properly propagated (Bartosz)
> - Redundant if (bdev->bd_nvmem) guard removed in blk_nvmem_del() (Bartosz)
> - Size guard changed from UINT_MAX → INT_MAX to avoid signed overflow in config.size (sashiko)
> - BLK_OPEN_RESTRICT_WRITES removed from blk_nvmem_reg_read() (sashiko)
> - Link to v5: https://lore.kernel.org/r/20260612-block-as-nvmem-v5-0-95e0b30fff90@oss.qualcomm.com
> 
> Changes in v5:
> - Fixed ath10k binding issue + extended commit message (Krzysztof)
> - Moved blk-nvmem handling to block core instead of a class_interface
>   This allows correct/robust integration with block device life cycle (Bartosz).
> - block: partitions: of: Skip child nodes without reg property (sashiko)
> - Link to v4: https://lore.kernel.org/r/20260609-block-as-nvmem-v4-0-45712e6b22c6@oss.qualcomm.com
> 
> Changes in v4:
> - Fix squash issue (dts commit incorrectly squashed) (Konrad)
> - Use devres for nvmem resources (Bartosz)
> - use __free() destructor helper when possible (Bartosz)
> - Fix value return checking for bdev_file_open_by_dev
> - Link to v3: https://lore.kernel.org/r/20260608-block-as-nvmem-v3-0-82681f50aa35@oss.qualcomm.com
> 
> Changes in v3:
> - Fixed missing 'fixed-partitions' compatible in partition (Rob)
> - Fixed clashing nvmem cells, document calibration along mac (Sashiko)
> - Remove workaround to handle dangling nvmem references after
>   unregistering, this is a generic nvmem framework issue handled
>   in Bartosz's series:
>    https://lore.kernel.org/all/20260429-nvmem-unbind-v3-0-2a694f95395b@oss.qualcomm.com/
> - Validate mac (is_valid_ether_addr) before copying to output buffer
> - Link to v2: https://lore.kernel.org/r/20260507-block-as-nvmem-v2-0-bf17edd5134e@oss.qualcomm.com
> 
> Changes in v2:
> - Fix example nvmem-layout cells to use compatible = "mac-base"
> - Squash WiFi MAC and Bluetooth BD address consumer patches into the nvmem layout patch
> - Fix possible use-after-free in blk-nvmem: bnv (nvmem priv) linked to nvmem lifetime
> - Simplify nvmem-cell-names from items: - const: to plain const:
> - Factor out common NVMEM EUI-48 retrieval logic
> - Reorder changes
> - Link to v1: https://lore.kernel.org/r/20260428-block-as-nvmem-v1-0-6ad23e75190a@oss.qualcomm.com
> 
> ---
> Daniel Golle (1):
>       block: implement NVMEM provider
> 
> Loic Poulain (8):
>       dt-bindings: mmc: Document fixed-layout NVMEM provider support
>       dt-bindings: net: wireless: qcom,ath10k: Document NVMEM cells
>       dt-bindings: bluetooth: qcom: Add NVMEM BD address cell
>       nvmem: layouts: Support fixed-layout as the nvmem device node itself
>       net: of_net: Add of_get_nvmem_eui48() helper for EUI-48 lookup
>       Bluetooth: hci_sync: Add NVMEM-backed BD address retrieval
>       Bluetooth: qca: Set NVMEM BD address quirks when address is invalid
>       arm64: dts: qcom: arduino-imola: Describe NVMEM layout for WiFi/BT addresses
> 
>  .../devicetree/bindings/mmc/mmc-card.yaml          |  23 ++++-
>  .../net/bluetooth/qcom,bluetooth-common.yaml       |   9 ++
>  .../bindings/net/wireless/qcom,ath10k.yaml         |  16 +++
>  arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts |  32 ++++++
>  block/Kconfig                                      |  11 +++
>  block/Makefile                                     |   1 +
>  block/blk-nvmem.c                                  | 110 +++++++++++++++++++++
>  block/blk.h                                        |   8 ++
>  block/genhd.c                                      |   4 +
>  drivers/bluetooth/btqca.c                          |   5 +-
>  drivers/nvmem/layouts.c                            |  13 ++-
>  include/linux/blk_types.h                          |   4 +
>  include/linux/of_net.h                             |   7 ++
>  include/net/bluetooth/hci.h                        |  18 ++++
>  net/bluetooth/hci_sync.c                           |  41 +++++++-
>  net/bluetooth/mgmt.c                               |   6 +-
>  net/core/of_net.c                                  |  52 +++++++---
>  17 files changed, 342 insertions(+), 18 deletions(-)
> ---
> base-commit: dffcfe75c722be66aa2669fb335528edb0590671
> change-id: 20260428-block-as-nvmem-4b308e8bda9a
> 
> Best regards,

