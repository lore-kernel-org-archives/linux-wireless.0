Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:35763 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3AVKGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 05:06:49 -0500
Received: by mail-la0-f46.google.com with SMTP id fq12so4636248lab.5
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2013 02:06:47 -0800 (PST)
From: "Sergey V." <sftp.mtuci@gmail.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH 3.8] mwifiex: fix typo in PCIe adapter NULL check
Date: Tue, 22 Jan 2013 14:06:40 +0400
Message-ID: <2880891.ILv0eXOzR2@darkstar> (sfid-20130122_110654_611158_16423E16)
In-Reply-To: <1358831050-3486-1-git-send-email-bzhao@marvell.com>
References: <1358831050-3486-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2102204.D5GtOyUzjE"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart2102204.D5GtOyUzjE
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On 2013-01-21 at 21:04:10, Bing Zhao <bzhao@marvell.com> wrote:
> From: Avinash Patil <patila@marvell.com>
> 
> Add missing "!" as we are supposed to check "!card->adapter"
> in PCIe suspend handler.
> 
> Cc: "3.2+" <stable@vger.kernel.org>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/pcie.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/pcie.c
> b/drivers/net/wireless/mwifiex/pcie.c index 3da89b4..237949c 100644
> --- a/drivers/net/wireless/mwifiex/pcie.c
> +++ b/drivers/net/wireless/mwifiex/pcie.c
> @@ -164,7 +164,7 @@ static int mwifiex_pcie_suspend(struct pci_dev
> *pdev, pm_message_t state)
> 
>  	if (pdev) {
>  		card = (struct pcie_service_card *) 
pci_get_drvdata(pdev);
> -		if (!card || card->adapter) {
> +		if (!card || !card->adapter) {
>  			pr_err("Card or adapter structure is not 
valid\n");
>  			return 0;
>  		}

Looks correct for me.

Reviewed-by: Sergey V. <sftp.mtuci@gmail.com>

Thanks.

--nextPart2102204.D5GtOyUzjE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQ/mSwAAoJEOX1jbAg+8MEOWoP/2gYfl2U7X6mcajY2Dgv603+
wouClE+4z86OOD7pJDgE7OFtV5BvSwV7rg/CxJ55z17oM6zyrllTFiwt5dOFDQcj
aNaZLa6nkSaKEmxZGlt6GiO2rhFFJ6u7+FrKNpW4d0hKhNtep+vOUj+74BU+Wha4
hJT+RdtYhnZdytutNpWOCAulSRzB8k13UXRBF6bCRwMtt/J3lWIoq91Qr+YQBM34
pyMnHXqF8kAP9WGVHviFyO36ZeDQHKWXEYEEsrY9w3UXInrVxnKdywXojilLp0Bp
J7sRHNxJn9pKTN1Oc2LbdI0vVItgpyMnRVWBCtTa275HrRTCSV5u6E22PKfOryLj
Nmd6iOXV+M/+Ps34CPqX28Wm0BQtGigar7XQECy8av+93Ub9scQ7pDs9VcLo5viC
ZDnitvDv1LosloMx0T19AS8WE4oqI49Wrn+11sZR9l4XhbPhtY34r5nKVJBlO0xP
08qbFOWtY15AsCJZo6NslsgfxntvqoVfcKNy33Gw/ZQB+/Cew3dZc1gbYMZxA7LG
inGQydbt2stqpM+djMhdREeUXGPcbilEK0VMktZtCHOI2fifa6sUVlREIjjKyrS5
nFrlZN/PdppX5TT1wBtK0q7nuWssxMF2zZrhMzpi6sP7mxR/S3ww9yJF3NEtCJji
0jGqK6Uxp90D1orZ/dbt
=h21/
-----END PGP SIGNATURE-----

--nextPart2102204.D5GtOyUzjE--

