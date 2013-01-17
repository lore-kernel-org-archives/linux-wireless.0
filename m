Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:46177 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824Ab3AQTfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 14:35:07 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Adrian Chadd <adrian@freebsd.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
Date: Thu, 17 Jan 2013 11:29:00 -0800
Subject: RE: Tx AMSDU Support
Message-ID: <477F20668A386D41ADCC57781B1F70430D140B0437@SC-VEXCH1.marvell.com> (sfid-20130117_203513_895553_5CFE2E13)
References: <CABPxzYL1LM-XAAb1RomgcM=O9Ma=KJZcbmEgTA678FSFuT8QMg@mail.gmail.com>
 <1358248982.4648.1.camel@jlt4.sipsolutions.net>
 <CABPxzYJciFXV=S7BGWT_V-M8U9ydpiBT8RSJJn35oHQy+zh3aQ@mail.gmail.com>
 <CAJ-Vmon_m1bH_OTL7XitXwRvqPK2+Q-V7E=rcBdGw7Gkj58LJQ@mail.gmail.com>
 <1358378606.15012.63.camel@jlt4.sipsolutions.net>
 <CABPxzY+2qNLxoySMou+PzqzfhK4ZOVfcP08BwZGx0J2Bz3Sd1Q@mail.gmail.com>
In-Reply-To: <CABPxzY+2qNLxoySMou+PzqzfhK4ZOVfcP08BwZGx0J2Bz3Sd1Q@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="_002_477F20668A386D41ADCC57781B1F70430D140B0437SCVEXCH1marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_477F20668A386D41ADCC57781B1F70430D140B0437SCVEXCH1marve_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Krishna,

> Ok...will try with the below ones..Marvell definitely has support for AMS=
DU Tx.

mwifiex driver uses AMPDU aggregation by default. Please apply the followin=
g change to disable AMPDU so that AMSDU can be chosen for aggregation. Also=
 increase the Tx buffer size to 4K to allow AMSDU aggregation for two 1500-=
byte packets. Or, you can use 8K to aggregate more packets for your tests.

---
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwi=
fiex/init.c
index e00b806..97ef459 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -317,9 +317,9 @@ static void mwifiex_init_adapter(struct mwifiex_adapter=
 *adapter)

        adapter->pm_wakeup_fw_try =3D false;

-       adapter->max_tx_buf_size =3D MWIFIEX_TX_DATA_BUF_SIZE_2K;
-       adapter->tx_buf_size =3D MWIFIEX_TX_DATA_BUF_SIZE_2K;
-       adapter->curr_tx_buf_size =3D MWIFIEX_TX_DATA_BUF_SIZE_2K;
+       adapter->max_tx_buf_size =3D MWIFIEX_TX_DATA_BUF_SIZE_4K;
+       adapter->tx_buf_size =3D MWIFIEX_TX_DATA_BUF_SIZE_4K;
+       adapter->curr_tx_buf_size =3D MWIFIEX_TX_DATA_BUF_SIZE_4K;

        adapter->is_hs_configured =3D false;
        adapter->hs_cfg.conditions =3D cpu_to_le32(HOST_SLEEP_CFG_COND_DEF)=
;
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwif=
iex/wmm.c
index 135d96d..ea722c2 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -425,8 +425,8 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)

                for (i =3D 0; i < MAX_NUM_TID; ++i) {
                        priv->aggr_prio_tbl[i].amsdu =3D tos_to_tid_inv[i];
-                       priv->aggr_prio_tbl[i].ampdu_ap =3D tos_to_tid_inv[=
i];
-                       priv->aggr_prio_tbl[i].ampdu_user =3D tos_to_tid_in=
v[i];
+                       priv->aggr_prio_tbl[i].ampdu_ap =3D BA_STREAM_NOT_A=
LLOWED;
+                       priv->aggr_prio_tbl[i].ampdu_user =3D BA_STREAM_NOT=
_ALLOWED;
                        priv->wmm.tid_tbl_ptr[i].ra_list_curr =3D NULL;
                }

--

Patch attached for your convenience.

Thanks,
Bing

>=20
> On Thu, Jan 17, 2013 at 4:53 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2013-01-16 at 15:05 -0800, Adrian Chadd wrote:
> >> .. for testing that out, I ended up just using a NIC that implements
> >> AMSDU in software.
> >>
> >> God knows what it was though (intel?)..
> >
> > Probably Broadcom and/or Marvell.
> >
> > johannes
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--_002_477F20668A386D41ADCC57781B1F70430D140B0437SCVEXCH1marve_
Content-Type: application/octet-stream;
	name="mwifiex_choose_amsdu_aggr.patch"
Content-Description: mwifiex_choose_amsdu_aggr.patch
Content-Disposition: attachment; filename="mwifiex_choose_amsdu_aggr.patch";
	size=1437; creation-date="Thu, 17 Jan 2013 19:23:34 GMT";
	modification-date="Thu, 17 Jan 2013 19:23:34 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvaW5pdC5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbXdpZmlleC9pbml0LmMKaW5kZXggZTAwYjgwNi4uOTdlZjQ1OSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9pbml0LmMKKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbXdpZmlleC9pbml0LmMKQEAgLTMxNyw5ICszMTcsOSBAQCBzdGF0aWMg
dm9pZCBtd2lmaWV4X2luaXRfYWRhcHRlcihzdHJ1Y3QgbXdpZmlleF9hZGFwdGVyICphZGFwdGVy
KQogCiAJYWRhcHRlci0+cG1fd2FrZXVwX2Z3X3RyeSA9IGZhbHNlOwogCi0JYWRhcHRlci0+bWF4
X3R4X2J1Zl9zaXplID0gTVdJRklFWF9UWF9EQVRBX0JVRl9TSVpFXzJLOwotCWFkYXB0ZXItPnR4
X2J1Zl9zaXplID0gTVdJRklFWF9UWF9EQVRBX0JVRl9TSVpFXzJLOwotCWFkYXB0ZXItPmN1cnJf
dHhfYnVmX3NpemUgPSBNV0lGSUVYX1RYX0RBVEFfQlVGX1NJWkVfMks7CisJYWRhcHRlci0+bWF4
X3R4X2J1Zl9zaXplID0gTVdJRklFWF9UWF9EQVRBX0JVRl9TSVpFXzRLOworCWFkYXB0ZXItPnR4
X2J1Zl9zaXplID0gTVdJRklFWF9UWF9EQVRBX0JVRl9TSVpFXzRLOworCWFkYXB0ZXItPmN1cnJf
dHhfYnVmX3NpemUgPSBNV0lGSUVYX1RYX0RBVEFfQlVGX1NJWkVfNEs7CiAKIAlhZGFwdGVyLT5p
c19oc19jb25maWd1cmVkID0gZmFsc2U7CiAJYWRhcHRlci0+aHNfY2ZnLmNvbmRpdGlvbnMgPSBj
cHVfdG9fbGUzMihIT1NUX1NMRUVQX0NGR19DT05EX0RFRik7CmRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9td2lmaWV4L3dtbS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmll
eC93bW0uYwppbmRleCAxMzVkOTZkLi5lYTcyMmMyIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93
aXJlbGVzcy9td2lmaWV4L3dtbS5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgv
d21tLmMKQEAgLTQyNSw4ICs0MjUsOCBAQCBtd2lmaWV4X3dtbV9pbml0KHN0cnVjdCBtd2lmaWV4
X2FkYXB0ZXIgKmFkYXB0ZXIpCiAKIAkJZm9yIChpID0gMDsgaSA8IE1BWF9OVU1fVElEOyArK2kp
IHsKIAkJCXByaXYtPmFnZ3JfcHJpb190YmxbaV0uYW1zZHUgPSB0b3NfdG9fdGlkX2ludltpXTsK
LQkJCXByaXYtPmFnZ3JfcHJpb190YmxbaV0uYW1wZHVfYXAgPSB0b3NfdG9fdGlkX2ludltpXTsK
LQkJCXByaXYtPmFnZ3JfcHJpb190YmxbaV0uYW1wZHVfdXNlciA9IHRvc190b190aWRfaW52W2ld
OworCQkJcHJpdi0+YWdncl9wcmlvX3RibFtpXS5hbXBkdV9hcCA9IEJBX1NUUkVBTV9OT1RfQUxM
T1dFRDsKKwkJCXByaXYtPmFnZ3JfcHJpb190YmxbaV0uYW1wZHVfdXNlciA9IEJBX1NUUkVBTV9O
T1RfQUxMT1dFRDsKIAkJCXByaXYtPndtbS50aWRfdGJsX3B0cltpXS5yYV9saXN0X2N1cnIgPSBO
VUxMOwogCQl9CiAK

--_002_477F20668A386D41ADCC57781B1F70430D140B0437SCVEXCH1marve_--
