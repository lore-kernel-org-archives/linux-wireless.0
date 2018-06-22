Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:36115 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbeFVVax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jun 2018 17:30:53 -0400
Message-ID: <dc3e8b7272240b2650f5ed55a6e2954a765a96de.camel@intel.com> (sfid-20180622_233109_353698_33EA874F)
Subject: Re: [PATCH] net: drivers/net: Convert random_ether_addr to
 eth_random_addr
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Joe Perches <joe@perches.com>,
        Derek Chickles <derek.chickles@caviumnetworks.com>,
        Satanand Burla <satananda.burla@caviumnetworks.com>,
        Felix Manlunas <felix.manlunas@caviumnetworks.com>,
        Raghu Vatsavayi <raghu.vatsavayi@caviumnetworks.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Harish Patil <harish.patil@cavium.com>,
        Manish Chopra <manish.chopra@cavium.com>,
        Dept-GELinuxNICDev@cavium.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Bert Kenward <bkenward@solarflare.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Wingman Kwok <w-kwok2@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>
Cc: Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        intel-wired-lan@lists.osuosl.org, linux-omap@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Date: Fri, 22 Jun 2018 14:30:43 -0700
In-Reply-To: <c558b59181756dfe647bcdeaf659c386701c0948.1529689773.git.joe@perches.com>
References: <c558b59181756dfe647bcdeaf659c386701c0948.1529689773.git.joe@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-D9yGWhKjkfSXPDF363Vy"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D9yGWhKjkfSXPDF363Vy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-06-22 at 10:51 -0700, Joe Perches wrote:
> random_ether_addr is a #define for eth_random_addr which is
> generally preferred in kernel code by ~3:1
>=20
> Convert the uses of random_ether_addr to enable removing the #define
>=20
> Miscellanea:
>=20
> o Convert &vfmac[0] to equivalent vfmac and avoid unnecessary line
> wrap
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

For i40e change

> ---
>  drivers/net/ethernet/cavium/liquidio/lio_main.c          | 5 ++---
>  drivers/net/ethernet/cortina/gemini.c                    | 2 +-
>  drivers/net/ethernet/hisilicon/hip04_eth.c               | 2 +-
>  drivers/net/ethernet/intel/i40e/i40e_main.c              | 2 +-
>  drivers/net/ethernet/microchip/lan743x_main.c            | 2 +-
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 2 +-
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c          | 2 +-
>  drivers/net/ethernet/sfc/ef10_sriov.c                    | 2 +-
>  drivers/net/ethernet/ti/cpsw.c                           | 2 +-
>  drivers/net/ethernet/ti/netcp_core.c                     | 4 ++--
>  drivers/net/ntb_netdev.c                                 | 2 +-
>  drivers/net/usb/lan78xx.c                                | 2 +-
>  drivers/net/wireless/ath/ath9k/hw.c                      | 2 +-
>  net/batman-adv/bridge_loop_avoidance.c                   | 2 +-
>  14 files changed, 16 insertions(+), 17 deletions(-)

--=-D9yGWhKjkfSXPDF363Vy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlstaoMACgkQ5W/vlVpL
7c5zcA//cQWZG35VbKuQPLIA9U/A2P5yF6jB+gGXUMsOhElBsgMAWL+3uu2FxrM7
3D46GWwjvxvEmh1t/Bf4hIIXTaQD1JlitxNfiYM/oFp9QqM/gl17VVWu1bLefUuS
/oLv9RmQy4sPsvjtuRjis3LzujNtuQFL/ynhr1NlVnU66ZJPXZDxBd2pXLgTC6/U
u9a/gJX04MVXlbsM/CyB6eXl+G8S0HnDdRC8tps5XWcb0uFwicmMBnCa27euBPtO
9fh5Dm55Ks39Ngu8GsdJP0Fxj1VudmlvfIeuzph3GHzEpHjYvAKo+zWTyGCffWka
CelgVYf59Cy1HVsp4dJoQsl5jFANanMn9dc7skTo+dISaye9YoLQIS5ZVG0GzLF9
cI2hCj4hoM7LW4PfJRl+Jf7HahhJENeZZgR+0m9fXQYLxCAjfMFKuuxgNaEB+9h5
MTz3K2OajdyAb/Fr5kU/4RcQckxBM23AhcjRlDea3AjJNYILJ3Dx3qlnTWl2who3
OS+JGw+jG3deGaryues5yVqFNYRsh+vbXtCLMMD9eKjd07AfVnBq62TWYyWAVbMW
dqQJfEjavwX8VMJCqXypEDMEGgz1duRl/dtcCVhuZ2eNLS3Y01Xa2SdduWh9X1YV
zoI0/WCjo9N1LmvRhLHBcnChcVw3Jd7MKupTZSjyT/vKWNAGZ8Y=
=qAR1
-----END PGP SIGNATURE-----

--=-D9yGWhKjkfSXPDF363Vy--
