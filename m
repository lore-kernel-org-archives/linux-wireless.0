Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26535 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753466AbcIFHju (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 03:39:50 -0400
From: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k:  ensure pdev sta kickout threshold is set.
Date: Tue, 6 Sep 2016 07:39:42 +0000
Message-ID: <1473147582638.99419@qti.qualcomm.com> (sfid-20160906_093955_155466_D264B007)
References: <1472843202-12428-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1472843202-12428-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[...]=0A=
=0A=
> +int ath10k_mac_set_pdev_kickout(struct ath10k *ar)=0A=
> +{=0A=
> +       u32 param =3D ar->wmi.pdev_param->sta_kickout_th;=0A=
> +       int rv;=0A=
> +=0A=
> +       rv =3D ath10k_wmi_pdev_set_param(ar, param,=0A=
> +                                      ar->sta_xretry_kickout_thresh);=0A=
> +       if (rv) {=0A=
> +               ath10k_warn(ar, "failed to set sta kickout threshold to %=
d: %d\n",=0A=
> +                           ar->sta_xretry_kickout_thresh, rv);=0A=
> +       }=0A=
> +       return rv;=0A=
> +}=0A=
>=0A=
Ben,=0A=
=0A=
I plan to get rid of setting station kickout threshold from host. Each firm=
ware revision (i.e qca988x, qca99x0, ipq4019)  follows different logic base=
d on hw capability for station kickout and follows different default paramt=
ers. So configuring common threshold will affect firmware logic. Better to =
get rid of these configuration from host driver and let firmware to work wi=
th default parameters.=0A=
=0A=
Also I could not find out sta_xretry_kickout_thresh definition in upstream =
driver. Have you posted any changes for the same?=0A=
=0A=
-Rajkumar=
