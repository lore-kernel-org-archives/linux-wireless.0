Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:40501 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728442AbeHCKZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 06:25:00 -0400
Date: Fri, 3 Aug 2018 18:29:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: linux-next: build failure after merge of the wireless-drivers-next
 tree
Message-ID: <20180803182942.4de98df2@canb.auug.org.au> (sfid-20180803_103001_439763_0376AA80)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/AFDZMSJVUSXBB0MOIzJXB9l"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/AFDZMSJVUSXBB0MOIzJXB9l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the wireless-drivers-next tree, today's linux-next build
(powerpc allyesconfig) failed like this:

ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x0): =
multiple definition of `__tracepoint_set_shared_key'; drivers/net/wireless/=
mediatek/mt7601u/trace.o:(__tracepoints+0x0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x30):=
 multiple definition of `__tracepoint_set_key'; drivers/net/wireless/mediat=
ek/mt7601u/trace.o:(__tracepoints+0x30): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x60):=
 multiple definition of `__tracepoint_mt_rx_dma_aggr'; drivers/net/wireless=
/mediatek/mt7601u/trace.o:(__tracepoints+0x60): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x90):=
 multiple definition of `__tracepoint_mt_tx_status'; drivers/net/wireless/m=
ediatek/mt7601u/trace.o:(__tracepoints+0x90): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0xc0):=
 multiple definition of `__tracepoint_mt_tx_status_cleaned'; drivers/net/wi=
reless/mediatek/mt7601u/trace.o:(__tracepoints+0xc0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0xf0):=
 multiple definition of `__tracepoint_mt_tx_dma_done'; drivers/net/wireless=
/mediatek/mt7601u/trace.o:(__tracepoints+0xf0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x120)=
: multiple definition of `__tracepoint_mt_tx'; drivers/net/wireless/mediate=
k/mt7601u/trace.o:(__tracepoints+0x120): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x150)=
: multiple definition of `__tracepoint_mt_rx'; drivers/net/wireless/mediate=
k/mt7601u/trace.o:(__tracepoints+0x150): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x180)=
: multiple definition of `__tracepoint_read_temp'; drivers/net/wireless/med=
iatek/mt7601u/trace.o:(__tracepoints+0x1e0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x1b0)=
: multiple definition of `__tracepoint_temp_mode'; drivers/net/wireless/med=
iatek/mt7601u/trace.o:(__tracepoints+0x210): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x1e0)=
: multiple definition of `__tracepoint_bbp_write'; drivers/net/wireless/med=
iatek/mt7601u/trace.o:(__tracepoints+0x240): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x210)=
: multiple definition of `__tracepoint_bbp_read'; drivers/net/wireless/medi=
atek/mt7601u/trace.o:(__tracepoints+0x270): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x240)=
: multiple definition of `__tracepoint_rf_write'; drivers/net/wireless/medi=
atek/mt7601u/trace.o:(__tracepoints+0x2a0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x270)=
: multiple definition of `__tracepoint_rf_read'; drivers/net/wireless/media=
tek/mt7601u/trace.o:(__tracepoints+0x2d0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x2a0)=
: multiple definition of `__tracepoint_ee_read'; drivers/net/wireless/media=
tek/mt7601u/trace.o:(__tracepoints+0x300): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x2d0)=
: multiple definition of `__tracepoint_mt_vend_req'; drivers/net/wireless/m=
ediatek/mt7601u/trace.o:(__tracepoints+0x330): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x300)=
: multiple definition of `__tracepoint_mt_mcu_msg_send'; drivers/net/wirele=
ss/mediatek/mt7601u/trace.o:(__tracepoints+0x360): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x330)=
: multiple definition of `__tracepoint_mt_submit_urb'; drivers/net/wireless=
/mediatek/mt7601u/trace.o:(__tracepoints+0x390): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x360)=
: multiple definition of `__tracepoint_reg_write'; drivers/net/wireless/med=
iatek/mt7601u/trace.o:(__tracepoints+0x3c0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x390)=
: multiple definition of `__tracepoint_reg_read'; drivers/net/wireless/medi=
atek/mt7601u/trace.o:(__tracepoints+0x3f0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o:(.opd+0x30): multiple d=
efinition of `mt76_mac_tx_rate_val'; drivers/net/wireless/mediatek/mt7601u/=
mac.o:(.opd+0x30): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o: in function `.mt76_mac=
_tx_rate_val':
mac.c:(.text.mt76_mac_tx_rate_val+0x0): multiple definition of `.mt76_mac_t=
x_rate_val'; drivers/net/wireless/mediatek/mt7601u/mac.o:mac.c:(.text.mt76_=
mac_tx_rate_val+0x0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o:(.opd+0x48): multiple d=
efinition of `mt76_mac_wcid_set_rate'; drivers/net/wireless/mediatek/mt7601=
u/mac.o:(.opd+0x48): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o: in function `.mt76_mac=
_wcid_set_rate':
mac.c:(.text.mt76_mac_wcid_set_rate+0x0): multiple definition of `.mt76_mac=
_wcid_set_rate'; drivers/net/wireless/mediatek/mt7601u/mac.o:mac.c:(.text.m=
t76_mac_wcid_set_rate+0x0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o:(.opd+0x78): multiple d=
efinition of `mt76_send_tx_status'; drivers/net/wireless/mediatek/mt7601u/m=
ac.o:(.opd+0x78): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o: in function `.mt76_sen=
d_tx_status':
mac.c:(.text.mt76_send_tx_status+0x0): multiple definition of `.mt76_send_t=
x_status'; drivers/net/wireless/mediatek/mt7601u/mac.o:mac.c:(.text.mt76_se=
nd_tx_status+0x0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o:(.opd+0x120): multiple =
definition of `mt76_mac_process_rx'; drivers/net/wireless/mediatek/mt7601u/=
mac.o:(.opd+0x120): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o: in function `.mt76_mac=
_process_rx':
mac.c:(.text.mt76_mac_process_rx+0x0): multiple definition of `.mt76_mac_pr=
ocess_rx'; drivers/net/wireless/mediatek/mt7601u/mac.o:mac.c:(.text.mt76_ma=
c_process_rx+0x0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o:(.opd+0x138): multiple =
definition of `mt76_mac_wcid_set_key'; drivers/net/wireless/mediatek/mt7601=
u/mac.o:(.opd+0x138): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o: in function `.mt76_mac=
_wcid_set_key':
mac.c:(.text.mt76_mac_wcid_set_key+0x0): multiple definition of `.mt76_mac_=
wcid_set_key'; drivers/net/wireless/mediatek/mt7601u/mac.o:mac.c:(.text.mt7=
6_mac_wcid_set_key+0x0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o:(.opd+0x150): multiple =
definition of `mt76_mac_shared_key_setup'; drivers/net/wireless/mediatek/mt=
7601u/mac.o:(.opd+0x150): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o: in function `.mt76_mac=
_shared_key_setup':
mac.c:(.text.mt76_mac_shared_key_setup+0x0): multiple definition of `.mt76_=
mac_shared_key_setup'; drivers/net/wireless/mediatek/mt7601u/mac.o:mac.c:(.=
text.mt76_mac_shared_key_setup+0x0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/util.o:(.opd+0x0): multiple d=
efinition of `mt76_remove_hdr_pad'; drivers/net/wireless/mediatek/mt7601u/u=
til.o:(.opd+0x0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/util.o: in function `.mt76_re=
move_hdr_pad':
util.c:(.text.mt76_remove_hdr_pad+0x0): multiple definition of `.mt76_remov=
e_hdr_pad'; drivers/net/wireless/mediatek/mt7601u/util.o:util.c:(.text.mt76=
_remove_hdr_pad+0x0): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/util.o:(.opd+0x18): multiple =
definition of `mt76_insert_hdr_pad'; drivers/net/wireless/mediatek/mt7601u/=
util.o:(.opd+0x18): first defined here
ld: drivers/net/wireless/mediatek/mt76/mt76x0/util.o: in function `.mt76_in=
sert_hdr_pad':
util.c:(.text.mt76_insert_hdr_pad+0x0): multiple definition of `.mt76_inser=
t_hdr_pad'; drivers/net/wireless/mediatek/mt7601u/util.o:util.c:(.text.mt76=
_insert_hdr_pad+0x0): first defined here

Caused by commit

  7b4859026ccd ("mt76x0: core files")

and following ones.

I have just marked that driver broken for now:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 3 Aug 2018 18:18:01 +1000
Subject: [PATCH] mt76x0: mark MediaTek MT76x0U (USB) support broken for now

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/mediatek/mt76/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wirel=
ess/mediatek/mt76/Kconfig
index 850611ad347a..ad56b3ed2be2 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -13,6 +13,7 @@ config MT76x0U
 	tristate "MediaTek MT76x0U (USB) support"
 	depends on MAC80211
 	depends on USB
+	depends on BROKEN
 	help
 	  This adds support for MT7610U-based wireless USB dongles.
=20
--=20
2.18.0

--=20
Cheers,
Stephen Rothwell

--Sig_/AFDZMSJVUSXBB0MOIzJXB9l
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAltkEnYACgkQAVBC80lX
0GxnGAf/WGdyBFXTCpqq3D9/qg5coHg/rljVvJaGgCXrLS8BzW2R/c+NZuwtaQaL
WdP6427c0GSuxrD4M8RS0YCSqhcOlF2Rw+PBr1GlDg4NteiBr2JQQuR9Kj74HbAl
EVEHe73+kIABqEdRIVBa/7/wGqRvZ3xAxALQ27Lg5BP6jeaZLHFpCPVTC+7v3egJ
11KVt+4AIHLSzpAmC1OrVCrV7sWis5l4LHeEnw4Y9ZTQjJna9IUEDK+mJqHbSyQT
XiWDrSTPuOK46473Fa/V4sKDzGyfywUifd77fPdg3PnA2q2aH1TN9WObe3NqPAgx
dvQZoSybcFurAqzBJACqXQUEEFESTg==
=jECu
-----END PGP SIGNATURE-----

--Sig_/AFDZMSJVUSXBB0MOIzJXB9l--
