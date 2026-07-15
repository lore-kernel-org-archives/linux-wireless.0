Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07133D5244
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 22:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784156397; cv=none; b=DwhxTSm5tZCN5vEPbHQT09d5HPeyD8p8orYBT53e2CyftwkEdHfO59qBGfe9q3NPud0ecv5/yMcZoZIVSTn2g+QS7VCvYUt1kbFnrt5c7W7LR+AmronfdWuZWMVf5Vwhh94rQIzTbpgkQXIUSnpVSdCLb7n2utk4EUWXE8ozQLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784156397; c=relaxed/simple;
	bh=3+5MNPDbac2Doh6TDWHhFIOhQ2OOQ1JwQGZmPOWoocA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=WsttkRKH8stxpteQ/PvrN0L4hUWT72O/S/PYUR7NaZSLA7R+RyrTRkkcHLE8URJVdyxY82NuwsuiwsLhtNov/hK4dikOQRgr9pAh1Ktci7zmQskxVTpY0XCgrdfP2s9bX8cm/R05P9jP2JwhtQxZPZM7yz3cwcuZk42qcZNyZm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q9weEO2K; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q9weEO2K"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493c733f15aso53333635e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 15:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784156394; x=1784761194; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CbzqhwhGZkJlsOqx47M8Ar/Y+du6MMpIBga94/ACH5Y=;
        b=Q9weEO2KBbfKYksFznUI7p8K6srIdNGPqfczLYvOJe0008TAfO3kgLOO14ogPfXeRB
         VgxvSXiqA6kCXN+4V1sn88nAnHCHNtHWJv5iHC72SXOdk0KSPaYn6BQljGkNvL7csZ9C
         mSP+T4wmi8KhqFVVY/SbxuKw9LIWGxN/j38/dyqNcTqS0ml2bk2aA4bVjU0CoPJPRzdL
         ifwNw0v+XcX/kUL4ONu1KKUCLFXL7IfPaLWaZt/B4c2fvyCtWeSKriC1LxF0M7sjZTjo
         alQLXtKXUCElKxPgWqswRO8/yRCIxCnZ6TzfBYRdNwd9nd8lFQGvGlxWEcGttRHIPAbX
         6vdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784156394; x=1784761194;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CbzqhwhGZkJlsOqx47M8Ar/Y+du6MMpIBga94/ACH5Y=;
        b=Ys7B0RuBnIfn3c8SK/UhzwXZ4rh1FcbuZjQbBNCkcQLXbb236IYNg9tvquXKwnkooT
         IvJo17E9HhAh7qspPKen972NQO+Sia2X7nKtcgKiNsFJWT00B5g9U5s5ZJV6n+FZ47Ql
         BVJxKtx6raxE6InVttSPKjbGSazgB3onqKb+pLkOLuB/ZkGC/d1jaRJr2voc4ANv+IC+
         Dg2RDGRxma+ctVYJza+tuCgT1LKzciYZyrFKByTqyU9HtfjHX+ETpl/V6mxMOHKW4jlM
         G82Ls3j08c/zqC9cqmp2q/oR5ppe1RlrdLNik5L/L2K9+6ffxtzoNVzS8qG08QxzCxAq
         b6xw==
X-Forwarded-Encrypted: i=1; AHgh+RpqRjDJ9ckvCkmb15+ClRCvGz7V2r9ddYhbMZwlxTTjfCmT42n0t4i7GsiS44zEAd3A6U3zRoTbbPLbtIb/8w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMugGbWoR9s0aIeORWnmT7BZOm2T92ALeS7HcQKvJkzLB6pBAA
	FlBktaHBQRNBVB44zaYg8x/Ql7hvsAjZPYLEZy9x3kCNq15O0SWJ9/ym
X-Gm-Gg: AfdE7cmVmiOxRP8e6MIEIfNtP3LQ1NF6R6SHCf+w9ZPef9H3ckTyiWR1UQGCwp8rRBD
	esOxdG9v1Hy8rZ0/m2mSZuUQRC/VOrFI13I6I+MNYoM2jX1plARZDWqZef8sVqfsWYat7AEipVV
	rUARMiziMErbC4QNSPmdXFozbW7qi+DyPGmGFIE1agBZ+6RUuKh0dAI1Po5vR3FvKawbWr2X2iJ
	LhWcEYanVIw5EP1xneAvO+aLEuSxaVv/goFIw5jGOnqphVERBszpkpEjBSdg84iRL4Wvg8W0LOQ
	sXBh/PhoEIvYNNHV5x03fmFpMQElZ65XiL9dccSWeigkPtlc4fQLGp1X+tjuD1EBxRGlBzMZukO
	xHRAt/HvvSzp4+BWw2llB11gagvyPlu7Flb8uGwXXEJexABEmLEINlZIPVj+yx1He03rJd4cGN2
	BTMW4YVRh+TQ83+jtrTQ32f6kZ92S9+XT0QG1WRE5SMzyiZ1Vq9gYMbbCCx3fc8yy/LKLfiwttb
	w==
X-Received: by 2002:a5d:5f48:0:b0:470:3edf:e28e with SMTP id ffacd0b85a97d-47f488486f8mr10262195f8f.10.1784156393869;
        Wed, 15 Jul 2026 15:59:53 -0700 (PDT)
Received: from smtpclient.apple ([151.251.240.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4634e029sm19997004f8f.3.2026.07.15.15.59.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jul 2026 15:59:53 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.8\))
Subject: Re: [PATCH] wifi: mwifiex: replace one-element arrays with flexible
 array members
From: George Valkov <gvalkov@gmail.com>
In-Reply-To: <202607150932.F2A0836@keescook>
Date: Thu, 16 Jul 2026 01:59:42 +0300
Cc: francesco@dolcini.it,
 johannes.berg@intel.com,
 bhelgaas@google.com,
 error27@gmail.com,
 s.kerkmann@pengutronix.de,
 linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1B52E88B-C7C1-43A1-85C0-661AF30D5CCD@gmail.com>
References: <20260712222334.7134-1-gvalkov@gmail.com>
 <202607150932.F2A0836@keescook>
To: briannorris@chromium.org,
 Kees Cook <kees@kernel.org>
X-Mailer: Apple Mail (2.3826.700.81.1.8)

Thank you for your help!
Please backport to 6.18 and 6.12, which are used by OpenWrt.

v2:
- restore the unions and use DECLARE_FLEX_ARRAY
  for the flexible arrays inside
- restore use of sizeof(*member) instead of sizeof(struct)


=46rom 654af1e2be5e0d2269a108f050dfbcbf1ad79262 Mon Sep 17 00:00:00 2001
From: Georgi Valkov <gvalkov@gmail.com>
Date: Thu, 16 Jul 2026 12:28:00 +0300
Subject: [PATCH v2] wifi: mwifiex: replace one-element arrays with =
flexible array
 members

Replace deprecated one-element arrays with flexible array members.
CONFIG_FORTIFY_SOURCE reports the following warning when
one-element arrays are used as variable-length buffers:

sta_cmd.c:1033 mwifiex_sta_prepare_cmd
memcpy: detected field-spanning write (size 84) of single field
"domain->triplet" at .../marvell/mwifiex/sta_cmd.c:1033 (size 3)

Convert affected structs to use flexible array members.
- Preserve existing wire layouts.
- Use DECLARE_FLEX_ARRAY for structs inside affected unions.

Tested-on: WRT3200ACM, OpenWrt
Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/fw.h      | 18 +++++++++---------
 drivers/net/wireless/marvell/mwifiex/join.c    |  8 ++++----
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h =
b/drivers/net/wireless/marvell/mwifiex/fw.h
index e9e896606912..93561116959a 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -823,7 +823,7 @@ struct chan_band_param_set {
   struct mwifiex_ie_types_chan_band_list_param_set {
  struct mwifiex_ie_types_header header;
- struct chan_band_param_set chan_band_param[1];
+ struct chan_band_param_set chan_band_param[];
 } __packed;
   struct mwifiex_ie_types_rates_param_set {
@@ -886,7 +886,7 @@ struct mwifiex_ie_types_wildcard_ssid_params {
 #define TSF_DATA_SIZE            8
 struct mwifiex_ie_types_tsf_timestamp {
  struct mwifiex_ie_types_header header;
- u8 tsf_data[1];
+ u8 tsf_data[];
 } __packed;
   struct mwifiex_cf_param_set {
@@ -903,8 +903,8 @@ struct mwifiex_ibss_param_set {
 struct mwifiex_ie_types_ss_param_set {
  struct mwifiex_ie_types_header header;
  union {
- struct mwifiex_cf_param_set cf_param_set[1];
- struct mwifiex_ibss_param_set ibss_param_set[1];
+ DECLARE_FLEX_ARRAY(struct mwifiex_cf_param_set, cf_param_set);
+ DECLARE_FLEX_ARRAY(struct mwifiex_ibss_param_set, ibss_param_set);
  } cf_ibss;
 } __packed;
  @@ -922,8 +922,8 @@ struct mwifiex_ds_param_set {
 struct mwifiex_ie_types_phy_param_set {
  struct mwifiex_ie_types_header header;
  union {
- struct mwifiex_fh_param_set fh_param_set[1];
- struct mwifiex_ds_param_set ds_param_set[1];
+ DECLARE_FLEX_ARRAY(struct mwifiex_fh_param_set, fh_param_set);
+ DECLARE_FLEX_ARRAY(struct mwifiex_ds_param_set, ds_param_set);
  } fh_ds;
 } __packed;
  @@ -1383,7 +1383,7 @@ struct host_cmd_ds_802_11_snmp_mib {
  __le16 query_type;
  __le16 oid;
  __le16 buf_size;
- u8 value[1];
+ u8 value[];
 } __packed;
   struct mwifiex_rate_scope {
@@ -1551,7 +1551,7 @@ struct mwifiex_scan_cmd_config {
  *  TLV_TYPE_CHANLIST, mwifiex_ie_types_chan_list_param_set
  *  WLAN_EID_SSID, mwifiex_ie_types_ssid_param_set
  */
- u8 tlv_buf[1]; /* SSID TLV(s) and ChanList TLVs are stored
+ u8 tlv_buf[]; /* SSID TLV(s) and ChanList TLVs are stored
    here */
 } __packed;
  @@ -1683,7 +1683,7 @@ struct host_cmd_ds_802_11_bg_scan_query_rsp {
 struct mwifiex_ietypes_domain_param_set {
  struct mwifiex_ie_types_header header;
  u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
- struct ieee80211_country_ie_triplet triplet[1];
+ struct ieee80211_country_ie_triplet triplet[];
 } __packed;
   struct host_cmd_ds_802_11d_domain_info {
diff --git a/drivers/net/wireless/marvell/mwifiex/join.c =
b/drivers/net/wireless/marvell/mwifiex/join.c
index 5a1a0287c1d5..a83f4d081fe2 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -421,15 +421,15 @@ int mwifiex_cmd_802_11_associate(struct =
mwifiex_private *priv,
    phy_tlv =3D (struct mwifiex_ie_types_phy_param_set *) pos;
  phy_tlv->header.type =3D cpu_to_le16(WLAN_EID_DS_PARAMS);
- phy_tlv->header.len =3D =
cpu_to_le16(sizeof(phy_tlv->fh_ds.ds_param_set));
- memcpy(&phy_tlv->fh_ds.ds_param_set,
+ phy_tlv->header.len =3D =
cpu_to_le16(sizeof(*phy_tlv->fh_ds.ds_param_set));
+ memcpy(phy_tlv->fh_ds.ds_param_set,
        &bss_desc->phy_param_set.ds_param_set.current_chan,
-       sizeof(phy_tlv->fh_ds.ds_param_set));
+       sizeof(*phy_tlv->fh_ds.ds_param_set));
  pos +=3D sizeof(phy_tlv->header) + le16_to_cpu(phy_tlv->header.len);
    ss_tlv =3D (struct mwifiex_ie_types_ss_param_set *) pos;
  ss_tlv->header.type =3D cpu_to_le16(WLAN_EID_CF_PARAMS);
- ss_tlv->header.len =3D =
cpu_to_le16(sizeof(ss_tlv->cf_ibss.cf_param_set));
+ ss_tlv->header.len =3D =
cpu_to_le16(sizeof(*ss_tlv->cf_ibss.cf_param_set));
  pos +=3D sizeof(ss_tlv->header) + le16_to_cpu(ss_tlv->header.len);
    /* Get the common rates supported between the driver and the BSS =
Desc */
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c =
b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 623ddde8c8e5..071f7cb305e1 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -108,7 +108,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct =
mwifiex_private *priv,
      "cmd: SNMP_CMD: cmd_oid =3D 0x%x\n", cmd_oid);
  cmd->command =3D cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
  cmd->size =3D cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
- - 1 + S_DS_GEN);
+ + S_DS_GEN);
    snmp_mib->oid =3D cpu_to_le16((u16)cmd_oid);
  if (cmd_action =3D=3D HostCmd_ACT_GEN_GET) {
--  2.55.0



> On 15 Jul 2026, at 7:35=E2=80=AFPM, Kees Cook <kees@kernel.org> wrote:
>=20
> On Mon, Jul 13, 2026 at 01:23:34AM +0300, Georgi Valkov wrote:
>> Replace deprecated one-element arrays with flexible array members.
>> CONFIG_FORTIFY_SOURCE reports the following warning when
>> one-element arrays are used as variable-length buffers:
>>=20
>> sta_cmd.c:1033 mwifiex_sta_prepare_cmd
>> memcpy: detected field-spanning write (size 84) of single field
>> "domain->triplet" at .../marvell/mwifiex/sta_cmd.c:1033 (size 3)
>>=20
>> Convert affected structs to use flexible array members.
>> - Preserve existing wire layouts.
>> - Replace affected uses of sizeof(member) with sizeof(type).
>> - Replace unions containing one-element arrays with
>>  u8 flexible arrays, and document the stored parameter-set type.
>>=20
>> Tested-on: WRT3200ACM, OpenWrt
>> Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
>> ---
>> drivers/net/wireless/marvell/mwifiex/fw.h     | 20 =
+++++++------------
>> drivers/net/wireless/marvell/mwifiex/join.c   |  8 ++++----
>> .../net/wireless/marvell/mwifiex/sta_cmd.c    |  2 +-
>> 3 files changed, 12 insertions(+), 18 deletions(-)
>>=20
>> diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h =
b/drivers/net/wireless/marvell/mwifiex/fw.h
>> index e9e896606912..ec3e3f806134 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/fw.h
>> +++ b/drivers/net/wireless/marvell/mwifiex/fw.h
>> @@ -823,7 +823,7 @@ struct chan_band_param_set {
>>=20
>> struct mwifiex_ie_types_chan_band_list_param_set {
>> struct mwifiex_ie_types_header header;
>> - struct chan_band_param_set chan_band_param[1];
>> + struct chan_band_param_set chan_band_param[];
>> } __packed;
>>=20
>> struct mwifiex_ie_types_rates_param_set {
>> @@ -886,7 +886,7 @@ struct mwifiex_ie_types_wildcard_ssid_params {
>> #define TSF_DATA_SIZE            8
>> struct mwifiex_ie_types_tsf_timestamp {
>> struct mwifiex_ie_types_header header;
>> - u8 tsf_data[1];
>> + u8 tsf_data[];
>> } __packed;
>>=20
>> struct mwifiex_cf_param_set {
>> @@ -902,10 +902,7 @@ struct mwifiex_ibss_param_set {
>>=20
>> struct mwifiex_ie_types_ss_param_set {
>> struct mwifiex_ie_types_header header;
>> - union {
>> - struct mwifiex_cf_param_set cf_param_set[1];
>> - struct mwifiex_ibss_param_set ibss_param_set[1];
>> - } cf_ibss;
>> + u8 cf_ibss[]; /* CF and IBSS param sets are stored here */
>> } __packed;
>>=20
>> struct mwifiex_fh_param_set {
>> @@ -921,10 +918,7 @@ struct mwifiex_ds_param_set {
>>=20
>> struct mwifiex_ie_types_phy_param_set {
>> struct mwifiex_ie_types_header header;
>> - union {
>> - struct mwifiex_fh_param_set fh_param_set[1];
>> - struct mwifiex_ds_param_set ds_param_set[1];
>> - } fh_ds;
>> + u8 fh_ds[]; /* FH and DS param sets are stored here */
>> } __packed;
>=20
> This (and below) can still be a union so you don't lose the type
> information:
>=20
> union {
> DECLARE_FLEX_ARRAY(struct mwifiex_fh_param_set, fh_param_set);
> DECLARE_FLEX_ARRAY(struct mwifiex_ds_param_set, ds_param_set);
> } fh_ds;
>=20
>>=20
>> struct mwifiex_ie_types_auth_type {
>> @@ -1383,7 +1377,7 @@ struct host_cmd_ds_802_11_snmp_mib {
>> __le16 query_type;
>> __le16 oid;
>> __le16 buf_size;
>> - u8 value[1];
>> + u8 value[];
>> } __packed;
>>=20
>> struct mwifiex_rate_scope {
>> @@ -1551,7 +1545,7 @@ struct mwifiex_scan_cmd_config {
>>  *  TLV_TYPE_CHANLIST, mwifiex_ie_types_chan_list_param_set
>>  *  WLAN_EID_SSID, mwifiex_ie_types_ssid_param_set
>>  */
>> - u8 tlv_buf[1]; /* SSID TLV(s) and ChanList TLVs are stored
>> + u8 tlv_buf[]; /* SSID TLV(s) and ChanList TLVs are stored
>>    here */
>> } __packed;
>>=20
>> @@ -1683,7 +1677,7 @@ struct host_cmd_ds_802_11_bg_scan_query_rsp {
>> struct mwifiex_ietypes_domain_param_set {
>> struct mwifiex_ie_types_header header;
>> u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
>> - struct ieee80211_country_ie_triplet triplet[1];
>> + struct ieee80211_country_ie_triplet triplet[];
>> } __packed;
>>=20
>> struct host_cmd_ds_802_11d_domain_info {
>> diff --git a/drivers/net/wireless/marvell/mwifiex/join.c =
b/drivers/net/wireless/marvell/mwifiex/join.c
>> index 5a1a0287c1d5..a2c427e6af3f 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/join.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/join.c
>> @@ -421,15 +421,15 @@ int mwifiex_cmd_802_11_associate(struct =
mwifiex_private *priv,
>>=20
>> phy_tlv =3D (struct mwifiex_ie_types_phy_param_set *) pos;
>> phy_tlv->header.type =3D cpu_to_le16(WLAN_EID_DS_PARAMS);
>> - phy_tlv->header.len =3D =
cpu_to_le16(sizeof(phy_tlv->fh_ds.ds_param_set));
>> - memcpy(&phy_tlv->fh_ds.ds_param_set,
>> + phy_tlv->header.len =3D cpu_to_le16(sizeof(struct =
mwifiex_ds_param_set));
>=20
> And this would become (the "*" added to get the member size):
>=20
> phy_tlv->header.len =3D =
cpu_to_le16(sizeof(*phy_tlv->fh_ds.ds_param_set));
>=20
> etc.
>=20
>> + memcpy(phy_tlv->fh_ds,
>>        &bss_desc->phy_param_set.ds_param_set.current_chan,
>> -        sizeof(phy_tlv->fh_ds.ds_param_set));
>> +        sizeof(struct mwifiex_ds_param_set));
>> pos +=3D sizeof(phy_tlv->header) + le16_to_cpu(phy_tlv->header.len);
>>=20
>> ss_tlv =3D (struct mwifiex_ie_types_ss_param_set *) pos;
>> ss_tlv->header.type =3D cpu_to_le16(WLAN_EID_CF_PARAMS);
>> - ss_tlv->header.len =3D =
cpu_to_le16(sizeof(ss_tlv->cf_ibss.cf_param_set));
>> + ss_tlv->header.len =3D cpu_to_le16(sizeof(struct =
mwifiex_cf_param_set));
>> pos +=3D sizeof(ss_tlv->header) + le16_to_cpu(ss_tlv->header.len);
>>=20
>> /* Get the common rates supported between the driver and the BSS Desc =
*/
>> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c =
b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
>> index 623ddde8c8e5..071f7cb305e1 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
>> @@ -108,7 +108,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct =
mwifiex_private *priv,
>>     "cmd: SNMP_CMD: cmd_oid =3D 0x%x\n", cmd_oid);
>> cmd->command =3D cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
>> cmd->size =3D cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
>> - - 1 + S_DS_GEN);
>> + + S_DS_GEN);
>>=20
>> snmp_mib->oid =3D cpu_to_le16((u16)cmd_oid);
>> if (cmd_action =3D=3D HostCmd_ACT_GEN_GET) {
>> --=20
>> 2.55.0
>>=20
>=20
> --=20
> Kees Cook


