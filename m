Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33712 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752248AbeBFLSs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Feb 2018 06:18:48 -0500
Received: by mail-qt0-f196.google.com with SMTP id d8so1777789qtm.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Feb 2018 03:18:47 -0800 (PST)
Subject: Re: [PATCH 4/6] qtnfmac: fix rmmod for missing firmware
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
References: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
 <20180205150516.16030-5-sergey.matyukevich.os@quantenna.com>
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A798F15.4050703@broadcom.com> (sfid-20180206_121852_029056_847048B0)
Date: Tue, 6 Feb 2018 12:18:45 +0100
MIME-Version: 1.0
In-Reply-To: <20180205150516.16030-5-sergey.matyukevich.os@quantenna.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/5/2018 4:05 PM, Sergey Matyukevich wrote:
> Check that firmware exists prior to starting firmware download.

Why would you do that? It seems expensive given that you obtain the 
firmware and discard it immediately just to check it exists. Especially, 
given that such a call can take 60 seconds to complete depending on 
kernel config.

Apart from that see minor comment below although I would seriously 
reconsider this patch altogether.

> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> ---
>   drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
>
> diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
> index c0d1c5d94ef0..86368e345276 100644
> --- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
> +++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
> @@ -1104,6 +1104,20 @@ static void qtnf_firmware_load(const struct firmware *fw, void *context)
>   	complete(&bus->request_firmware_complete);
>   }
>
> +static int qtnf_fw_exists(struct qtnf_bus *bus)
> +{
> +	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
> +	struct pci_dev *pdev = priv->pdev;
> +	const struct firmware *fw;

I think it is better to initialize fw to NULL here and ...

> +	int ret;
> +
> +	ret = request_firmware(&fw, bus->fwname, &pdev->dev);
> +	if (!ret)

do 'if (fw)' here instead.

Regards,
Arend

> +		release_firmware(fw);
> +
> +	return !ret;
> +}
> +
