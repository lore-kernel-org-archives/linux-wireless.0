Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36318 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753399AbcLSWbN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 17:31:13 -0500
Date: Mon, 19 Dec 2016 16:31:11 -0600
From: Rob Herring <robh@kernel.org>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgreer@animalcreek.com, justin@kuvee.com
Subject: Re: [PATCH 1/3] NFC: trf7970a: add device tree option for 27MHz clock
Message-ID: <20161219223111.itu77g7wsqtj6cvs@rob-hp-laptop> (sfid-20161219_233228_395475_6B001BAE)
References: <1481841044-4314-1-git-send-email-glansberry@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1481841044-4314-1-git-send-email-glansberry@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2016 at 05:30:42PM -0500, Geoff Lansberry wrote:
> From: Geoff Lansberry <geoff@kuvee.com>
> 
> ---
>  .../devicetree/bindings/net/nfc/trf7970a.txt       |  3 ++
>  drivers/nfc/trf7970a.c                             | 42 ++++++++++++++++------
>  2 files changed, 34 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
> index 32b35a0..9dda879 100644
> --- a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
> +++ b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
> @@ -21,6 +21,8 @@ Optional SoC Specific Properties:
>  - t5t-rmb-extra-byte-quirk: Specify that the trf7970a has the erratum
>    where an extra byte is returned by Read Multiple Block commands issued
>    to Type 5 tags.
> +- crystal_27mhz: Set to specify that the input frequency to the trf7970a is 27.12MHz
> +

Can't you use 'clock-frequency = "27000000";'?

>  
>  Example (for ARM-based BeagleBone with TRF7970A on SPI1):
>  
> @@ -43,6 +45,7 @@ Example (for ARM-based BeagleBone with TRF7970A on SPI1):
>  		irq-status-read-quirk;
>  		en2-rf-quirk;
>  		t5t-rmb-extra-byte-quirk;
> +		crystal_27mhz;
>  		status = "okay";
>  	};
>  };
