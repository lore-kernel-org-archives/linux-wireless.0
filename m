Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:54039 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753231AbdJMMmC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 08:42:02 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k: Retry pci probe on failure.
Date: Fri, 13 Oct 2017 12:41:57 +0000
Message-ID: <87a80vnrsb.fsf@kamboji.qca.qualcomm.com> (sfid-20171013_144205_442521_E9CBD918)
References: <1507068826-14677-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1507068826-14677-1-git-send-email-greearb@candelatech.com>
        (greearb@candelatech.com's message of "Tue, 3 Oct 2017 15:13:46 -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This works around a problem we see when sometimes the wifi NIC does
> not respond the first time.  This seems to happen especially often on
> some of the 9984 NICs in mid-range platforms.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

[...]

> -static int ath10k_pci_probe(struct pci_dev *pdev,
> -			    const struct pci_device_id *pci_dev)
> +static int __ath10k_pci_probe(struct pci_dev *pdev,
> +			      const struct pci_device_id *pci_dev)
>  {
>  	int ret =3D 0;
>  	struct ath10k *ar;
> @@ -3672,6 +3672,22 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>  	return ret;
>  }
> =20
> +static int ath10k_pci_probe(struct pci_dev *pdev,
> +			    const struct pci_device_id *pci_dev)
> +{
> +	int cnt =3D 0;
> +	int rv;
> +	do {
> +		rv =3D __ath10k_pci_probe(pdev, pci_dev);
> +		if (rv =3D=3D 0)
> +			return rv;
> +		pr_err("ath10k: failed to probe PCI : %d, retry-count: %d\n", rv, cnt)=
;
> +		mdelay(10); /* let the ath10k firmware gerbil take a small break */
> +	} while (cnt++ < 10);
> +	return rv;
> +}

This is a sledgehammer approach and it causes reload for all error
cases, like when hardware is broken or memory allocation is failing.

When the problem happens does it always fail at the the same place? Is
it hw reset or something else? It's better to retry the invidiual action
than to do this hack. Or is it just some more delay needed somewhere?

--=20
Kalle Valo=
