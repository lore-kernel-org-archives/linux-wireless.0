Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:52971 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbcFDQlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 12:41:24 -0400
Subject: Re: [PATCH] rtlwifi: Change long delays to sleeps
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
References: <1455574327-2591-1-git-send-email-Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Jan Kiszka <jan.kiszka@web.de>
Message-ID: <57530495.50302@web.de> (sfid-20160604_184147_698471_439A6438)
Date: Sat, 4 Jun 2016 18:40:53 +0200
MIME-Version: 1.0
In-Reply-To: <1455574327-2591-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oWHqui7TVmN29giGxax0BSNlPU16Pammk"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oWHqui7TVmN29giGxax0BSNlPU16Pammk
Content-Type: multipart/mixed; boundary="LCCSrXg6kCv61fqafNwvq1Ob3DB13lfCj"
From: Jan Kiszka <jan.kiszka@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <57530495.50302@web.de>
Subject: Re: [PATCH] rtlwifi: Change long delays to sleeps
References: <1455574327-2591-1-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1455574327-2591-1-git-send-email-Larry.Finger@lwfinger.net>

--LCCSrXg6kCv61fqafNwvq1Ob3DB13lfCj
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2016-02-15 23:12, Larry Finger wrote:
> Routine rtl_addr_delay() uses delay statements in code that can
> sleep. To improve system responsiveness, the various delay statements
> are changed.
>=20
> In addition, routines rtl_rfreg_delay() and rtl_bb_delay() are
> rewritten to use the code in rtl_addr_delay() for most of their
> input values.
>=20
> Suggested-by: Byeoungwook Kim <quddnr145@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>=20
> Kalle,
>=20
> This patch will interfere with a set of 3 patches submitted by Byeoungw=
ook Kim
> <quddnr145@gmail.com> on Feb. 3, 2016 that are currently in the deferre=
d list
> at patchwork.
>=20
> Larry
>=20
>  drivers/net/wireless/realtek/rtlwifi/core.c | 44 ++++++++-------------=
--------
>  1 file changed, 12 insertions(+), 32 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/=
wireless/realtek/rtlwifi/core.c
> index 02eba0e..16ad0d6 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
> @@ -54,59 +54,39 @@ EXPORT_SYMBOL(channel5g_80m);
>  void rtl_addr_delay(u32 addr)
>  {
>  	if (addr =3D=3D 0xfe)
> -		mdelay(50);
> +		msleep(50);
>  	else if (addr =3D=3D 0xfd)
> -		mdelay(5);
> +		msleep(5);
>  	else if (addr =3D=3D 0xfc)
> -		mdelay(1);
> +		msleep(1);
>  	else if (addr =3D=3D 0xfb)
> -		udelay(50);
> +		usleep_range(50, 100);
>  	else if (addr =3D=3D 0xfa)
> -		udelay(5);
> +		usleep_range(5, 10);
>  	else if (addr =3D=3D 0xf9)
> -		udelay(1);
> +		usleep_range(1, 2);
>  }
>  EXPORT_SYMBOL(rtl_addr_delay);
> =20
>  void rtl_rfreg_delay(struct ieee80211_hw *hw, enum radio_path rfpath, =
u32 addr,
>  		     u32 mask, u32 data)
>  {
> -	if (addr =3D=3D 0xfe) {
> -		mdelay(50);
> -	} else if (addr =3D=3D 0xfd) {
> -		mdelay(5);
> -	} else if (addr =3D=3D 0xfc) {
> -		mdelay(1);
> -	} else if (addr =3D=3D 0xfb) {
> -		udelay(50);
> -	} else if (addr =3D=3D 0xfa) {
> -		udelay(5);
> -	} else if (addr =3D=3D 0xf9) {
> -		udelay(1);
> +	if (addr >=3D 0xf9 && addr <=3D 0xfe) {
> +		rtl_addr_delay(addr);
>  	} else {
>  		rtl_set_rfreg(hw, rfpath, addr, mask, data);
> -		udelay(1);
> +		usleep_range(1, 2);
>  	}
>  }
>  EXPORT_SYMBOL(rtl_rfreg_delay);
> =20
>  void rtl_bb_delay(struct ieee80211_hw *hw, u32 addr, u32 data)
>  {
> -	if (addr =3D=3D 0xfe) {
> -		mdelay(50);
> -	} else if (addr =3D=3D 0xfd) {
> -		mdelay(5);
> -	} else if (addr =3D=3D 0xfc) {
> -		mdelay(1);
> -	} else if (addr =3D=3D 0xfb) {
> -		udelay(50);
> -	} else if (addr =3D=3D 0xfa) {
> -		udelay(5);
> -	} else if (addr =3D=3D 0xf9) {
> -		udelay(1);
> +	if (addr >=3D 0xf9 && addr <=3D 0xfe) {
> +		rtl_addr_delay(addr);
>  	} else {
>  		rtl_set_bbreg(hw, addr, MASKDWORD, data);
> -		udelay(1);
> +		usleep_range(1, 2);
>  	}
>  }
>  EXPORT_SYMBOL(rtl_bb_delay);
>=20

This breaks spectacularly when turning on a little bit of correctness
checking:

BUG: scheduling while atomic: wpa_supplicant/1116/0x00000002
[...]
Call Trace:
 [<ffffffff81030009>] dump_trace+0x59/0x340
 [<ffffffff810303ec>] show_stack_log_lvl+0xfc/0x190
 [<ffffffff81031191>] show_stack+0x21/0x40
 [<ffffffff813827ae>] dump_stack+0x5c/0x7e
 [<ffffffff81181337>] __schedule_bug+0x4b/0x59
 [<ffffffff81680f12>] thread_return+0x562/0x6b0
 [<ffffffff8168109c>] schedule+0x3c/0x90
 [<ffffffff81683dfb>] schedule_hrtimeout_range_clock+0xab/0x130
 [<ffffffff8168386b>] usleep_range+0x3b/0x40
 [<ffffffffa0951ee4>] rtl92c_phy_config_rf_with_headerfile+0x104/0x2f0 [r=
tl8192ce]
 [<ffffffffa0953d30>] rtl92ce_phy_rf6052_config+0x1b0/0x310 [rtl8192ce]
 [<ffffffffa095055b>] rtl92ce_hw_init+0xa8b/0x17e0 [rtl8192ce]
 [<ffffffffa060f22b>] rtl_ps_enable_nic+0x3b/0xc0 [rtlwifi]
 [<ffffffffa0952d39>] rtl92c_phy_set_rf_power_state+0x509/0x760 [rtl8192c=
e]
 [<ffffffffa060f3d4>] rtl_ps_set_rf_state+0xd4/0x200 [rtlwifi]
 [<ffffffffa060f538>] _rtl_ps_inactive_ps+0x38/0xb0 [rtlwifi]
 [<ffffffffa060f628>] rtl_ips_nic_on+0x78/0xb0 [rtlwifi]
 [<ffffffffa060c678>] rtl_op_config+0x278/0x440 [rtlwifi]
 [<ffffffffa072c9b6>] ieee80211_hw_config+0x56/0x3a0 [mac80211]
 [<ffffffffa076123a>] ieee80211_add_chanctx+0x17a/0x1c0 [mac80211]
 [<ffffffffa0761e2d>] ieee80211_new_chanctx+0x2d/0x80 [mac80211]
 [<ffffffffa0763f6b>] ieee80211_vif_use_channel+0x1fb/0x250 [mac80211]
 [<ffffffffa0776718>] ieee80211_prep_connection+0x188/0x8e0 [mac80211]
 [<ffffffffa077cb0a>] ieee80211_mgd_auth+0x22a/0x330 [mac80211]
 [<ffffffffa0453e57>] cfg80211_mlme_auth+0x117/0x230 [cfg80211]
 [<ffffffffa043a917>] nl80211_authenticate+0x2a7/0x300 [cfg80211]
 [<ffffffff815d4c56>] genl_family_rcv_msg+0x1b6/0x380
 [<ffffffff815d4e99>] genl_rcv_msg+0x79/0xb0
 [<ffffffff815d3ea2>] netlink_rcv_skb+0x92/0xa0
 [<ffffffff815d44b4>] genl_rcv+0x24/0x40
 [<ffffffff815d3896>] netlink_unicast+0x146/0x1f0
 [<ffffffff815d3c63>] netlink_sendmsg+0x323/0x3a0
 [<ffffffff81588c80>] sock_sendmsg+0x30/0x40
 [<ffffffff81589529>] ___sys_sendmsg+0x279/0x290
 [<ffffffff81589d81>] __sys_sendmsg+0x41/0x70
 [<ffffffff81003aa9>] do_syscall_64+0x59/0xb0
 [<ffffffff81684da5>] entry_SYSCALL64_slow_path+0x25/0x25

So please revert this commit. I agree with the general goal, but this
approach does not work. I had to in order to make my wifi work again.

Then, when looking deeper, those local_irq_enable constructs in the
hw_init handlers are making me nervous. Are you sure that no task
context that did something like spin_lock_irq* enters this code? Please
redesign this. I'm not really into the various code paths to make safe
suggestions, sorry.

Jan


--LCCSrXg6kCv61fqafNwvq1Ob3DB13lfCj--

--oWHqui7TVmN29giGxax0BSNlPU16Pammk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAldTBJoACgkQitSsb3rl5xT4RgCgrKkvAQYWuRn3X0xXlVa+uEVv
A+EAn2qC4nsHInGSYj+1YZoJRrrmcbRr
=tIW4
-----END PGP SIGNATURE-----

--oWHqui7TVmN29giGxax0BSNlPU16Pammk--
