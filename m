Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33F73AB48F
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 20:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811962; cv=pass; b=oBAfqNQCeQoWLfzfr87AI4wt0STHP69M4wsKdW9BEFLi/HVxmMsLmCFA3X5fqsv1oN3kDQEqmAIRZBGtk0Xka8WPiuzQAH4AvG4KNzKDF6wfe/uZrfpg6x428phn8CV5EdlYSX8sK/zTHkBrLS5ec1TWP6qguBFoT1SDcDUI+0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811962; c=relaxed/simple;
	bh=mmP8AAChbL2CPbghSaIW0ZqpNcF99u1zA2zfUCLMUY0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=siQW7BsN21R1Xk0IKw+hr/NEA99NNYynB5IaYuiL7/Xi6QDWHaP1yooa4JfjTNshYpM0CEHonHzksb3Iomhsd6EIC9VA54yakimlutrsbjr9ETNH5x6mxL0Ka/T8QvJCyxr4EfTx6hD9FY+Nv0EkX8QlIwICTVoOR8yvok9LuA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A9sSpDIm; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A9sSpDIm"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a68279dd86so4806347a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 13:12:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788811959; cv=none;
        d=google.com; s=arc-20260327;
        b=nqhRUYn0ieC2bmkaw8RyFb7wNiKRq3uMa7N5viRCCyJ0L9famAywIorVW2VhDOKCSb
         5q6LyxFy/0mDSRl/wnmg3kBDsKGZuExoyp7gvlwM2RAbQAGDZ3zFHhoA3CSOFFFpHCOV
         ZLYsKTU9765X0ZK2LoYdXkKaRP9AJUiqea6UPmyhuS8qzMwzBVSf+jpUwz4hrVAGdZ7R
         62Amj714lNZyg0lZkIVmYm49XP9wtCldy61Su2ezQZJcmhRiLc5fMR8LQ+0wxSPMD3B7
         B9gp/IfjWUUNMAb6vPW9JLrrvVsGn8MTZJGO2ZQMGLteNEgNIhNhP5vs2ttgBmAoHC8D
         6sPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=RcoguBFziVU8whZLL556GMv268B8OMT9r/sEIsBMoSc=;
        fh=KUmwsLzLkhXVl2jJ4u39Wpqo57xilkMpy8GHdaLYkMM=;
        b=rJrBJI/5k2DeVcYt4HuxDUvri2BU3aQ/9KUHiZyP+usjFxK/Pb25Z+gEvAM+K0ExB6
         k8hvR1dqbYvhk0+aA7UAXNeXB8oUYta2Vlp8FfCyChhAlAHSVr0JpobmR7HSzxzcGZtC
         F3DjiF688pVdOyKQZfSchJ4+SPNYVimzrrHO57QGKKk+Nusw1HXtSFmB3OKYKJLVpvGz
         /86GZgaiHJkw3jTM3jVfY2fw+jmiZGMwYxdjnDsegWg9uJuGHXuPhnZL3spLpJ3l86pH
         cPN0mInyjnDltnroANNFlhGzpTazsQKOt3I/624dNmCFkS3ZkLPeJBVMraKK93CLNSqg
         tcDA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788811959; x=1789416759; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RcoguBFziVU8whZLL556GMv268B8OMT9r/sEIsBMoSc=;
        b=A9sSpDImjtQZJbAyW6I/4VNzR1OBx0zs3KWDor0oOT+n6Lp5MytcY4eQMaVXOTs79a
         cfhB0lALFa1f6x8ITQIVY7n22rAHOnQRIVdWIjn2708laj/bjYmOM1AIiZ4FSvsgh6AN
         /J1sKtCncgPfrm9xMNzCcw/YE3d8gBk4vtSWAkgQL7oizf+AoT0UMl8nf8DVCALz63ae
         girSUu8r9+klhm0Kxn4Xol1+/27imOwZNFPnkxmQFTyAtAbHnOknW9gW8Ec5vea4c7GZ
         3BLLmo1m8K6BCt6bHYV4MXbXWppAGp3n5j9wOC5jMswznbu1BfdqyWh8i38k3UiXnJyH
         mq3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788811959; x=1789416759;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RcoguBFziVU8whZLL556GMv268B8OMT9r/sEIsBMoSc=;
        b=DLGOaNsPSWP4I93qq+p3lRH25l1GSaAPwNuqZdemlM15eyQrv1H9Du7eE6hSQLjW+g
         76gHaEFGIBiqg75E6QbHo6jYYm+dLg6uWMh5rgs4JGyfFMLcNI0t6sFDQUY5ERm7BLnG
         nzbGPTXu4heXAKzLEIwF8Caml96LP/NHeqas3tQBemiFs9S+FHxFFEuzLz8YxUqrea5o
         ENAQ4DRYMmRYjYVM1tw3D590GAGtlTp5F3bXRrhaqJPPmgdNo8aSikv2yXFKYVazhHgZ
         DCHQk3cl42Z5MfVyb8ZeB+o7gHDgAvRbDU5/5j1KdQqDzOboUFRpoYD6Ww+Lm3h4hYOq
         ct9w==
X-Gm-Message-State: AFuF++mSMktrR0CGvmHp71Q8wtQxBBNKfwt5I/UIy0Cdkxf0DweftMON
	qCYnDP9ykA0qDHxIdheKOsggTPduY2LzaCb1s3HOdY78/j0UeSrtrLBQjfACjQ8AWJlKaiptHee
	uIjtYZcvSUuq1fKi9kCzXodD/24q6dRxhNPzU
X-Gm-Gg: AYBFou1PXGZ+fzIFjfeiDN+joP8ozNFBcVUaogWWbCah9LViLl1VIQxHHIHjU/JT5nL
	W/sCtLCKWCBNCCEMX0psy/hs+YfoNaonsauoTqt93bQKv4gOOVLIDyo+bbD/drxhDPSLMPK+T28
	Njh3YB0ZNCl+9dlzEXyHyvhBVtnQsrrCsHOTUNPPLBQxG4Usi27rdvLPG0ofXikVhUWgcUQu758
	59Jq+eE4VUZ1toYE87reswQwF+1kLeU1Wcivt/dXtj8MAE/s86NBl/ZiFRbg3o8waQrRotBwW+Q
	/ylbaZeovm16TSkC19HWM1PJWbjt9WCW3FZtyqgC1I+5PJkxLGRpL6hdtIWaDcTH39G1ixL1wKZ
	GWsg3Ckiuo4J5onqZKX9r9LWz4bPnlNW8
X-Received: by 2002:a05:6402:3719:b0:6a6:32f5:556f with SMTP id
 4fb4d7f45d1cf-6a7e8e92ad8mr8818954a12.17.1788811958603; Mon, 07 Sep 2026
 13:12:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Gavin <gavinsan33@gmail.com>
Date: Mon, 7 Sep 2026 16:12:27 -0400
X-Gm-Features: AcwNN1XW1e4HxWtM3AzTI5zGEnIhvT9ZTJb6pm8B22VsT3USip1d4GAjaFTLZWg
Message-ID: <CAHpNbGEHkTawQyNXzibj32=QsuOWGFdqhZvoqxjQ6sAJCbNORA@mail.gmail.com>
Subject: mac80211: Basic MCS Set check drops connection to legacy rates
 against Wi-Fi 7 gateway
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Content-Type: text/plain; charset="UTF-8"

Hi,

I'm hitting a case where mac80211's Basic MCS Set verification drops an
otherwise healthy connection all the way to 20 MHz legacy rates, while
other stacks associate at 802.11ax against the same AP. I'd like to ask
whether the current behaviour is intended to be this strict.

Symptom
-------

Associating to a Comcast/Xfinity XB-series gateway (Wi-Fi 7, advertises
HT + VHT + HE + EHT), mac80211 logs:

  wlp0s20f3: required MCSes not supported, disabling HT

and the link comes up as:

  channel 157 (5785 MHz), width: 20 MHz (no HT)
  rx bitrate: 54.0 MBit/s
  tx bitrate: 54.0 MBit/s
  signal: -27 dBm

Measured throughput was ~15.6 Mbps at -27 dBm. This happens on both the
2.4 GHz and 5 GHz radios of the same gateway.

Hardware / software
-------------------

  Intel Wi-Fi 6E AX211 160MHz (8086:51f1, subsystem 8086:4090), CNVi
  firmware 89.7207fc64.0, so-a0-gf-a0-89.ucode, op_mode iwlmvm
  HT TX/RX MCS rate indexes supported: 0-15  (2 spatial streams)
  Kernels tested: 6.17.0-1028-oem and 7.0.0-30-generic (Ubuntu)

The gateway appears to advertise a Basic HT-MCS Set requiring more
spatial streams than this 2x2 station can support, so
ieee80211_verify_sta_ht_mcs_support() fails and
ieee80211_determine_chan_mode() sets:

  conn->mode = IEEE80211_CONN_MODE_LEGACY;
  conn->bw_limit = IEEE80211_CONN_BW_LIMIT_20;

A single failed HT check therefore removes HT, VHT and HE at once. I
understand this follows P802.11REVme/D7.0 - 6.5.4.2.4, as the comment in
the function notes. My question is whether collapsing to legacy is the
desired outcome in practice, given the AP is not going to be fixed.

Evidence that the station itself is fine
----------------------------------------

  - Against a phone hotspot (no EHT) the same card negotiates
    "VHT-MCS 6 80MHz VHT-NSS 2", 650 Mbit/s, at a *worse* signal
    (-56 dBm).
  - Windows 11 on the same laptop, same card, same gateway, same BSS
    reports "Wi-Fi 6 (802.11ax)" and an aggregated link speed of
    288/1117 Mbps. So at least one other driver ignores the Basic MCS
    Set requirement.

Ruled out during debugging
--------------------------

  - Signal strength: reproduced from -27 dBm to -72 dBm.
  - Regulatory: channel is permitted at HT40+ and 160 MHz.
  - Ciphers: forced pairwise/group to CCMP only; no change.
  - AKM: reproduced with both WPA2-PSK and WPA3-SAE.
  - MAC randomisation: reproduced with hardware and random MAC.
  - Channel: reproduced on channel 44 and channel 157.
  - iwlwifi disable_11ax=1: no change, since HT is already gone.
  - Both kernels above behave identically.
  - No firmware assert or restart in dmesg.

Workaround I'm currently using
------------------------------

Adding a module parameter to make the check non-fatal restores full
rates. With it enabled the same link comes up as:

  80 MHz, HE-MCS 7, HE-NSS 2, rx 720.6 / tx 544.3 MBit/s

and measured throughput is ~215 Mbps, a ~14x improvement.

I'm not proposing this as-is -- a parameter may well be the wrong
interface, and someone closer to the spec should decide whether the
right fix is to warn and continue, to mask the requirement down to the
station's stream count, or to keep the strict behaviour and accept that
these gateways are unusable. Included below for discussion only.

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -90,6 +90,20 @@
  " before disconnecting (reason 4).");

 /*
+ * Some access points advertise a Basic MCS Set (in the HT/VHT/HE/EHT Operation
+ * elements) that requires more spatial streams than the local station can
+ * support. IEEE 802.11 (P802.11REVme/D7.0 - 6.5.4.2.4) requires refusing to
+ * use HT and above in that case, which collapses the connection all the way
+ * down to 20 MHz legacy rates. Some vendor drivers ignore the requirement and
+ * associate with high-throughput rates regardless; set this to do the same.
+ */
+static bool ignore_basic_mcs_set;
+module_param(ignore_basic_mcs_set, bool, 0644);
+MODULE_PARM_DESC(ignore_basic_mcs_set,
+ "Ignore the AP's Basic MCS Set requirement instead of"
+ " falling back to legacy rates.");
+
+/*
  * How many Beacon frames need to have been used in average signal strength
  * before starting to indicate signal change events.
  */
@@ -1227,6 +1241,7 @@
      "regulatory prevented using AP config, downgraded\n");

  if (conn->mode >= IEEE80211_CONN_MODE_HT &&
+    !ignore_basic_mcs_set &&
     !ieee80211_verify_sta_ht_mcs_support(sdata, sband,
  elems->ht_operation)) {
  conn->mode = IEEE80211_CONN_MODE_LEGACY;
@@ -1236,6 +1251,7 @@
  }

  if (conn->mode >= IEEE80211_CONN_MODE_VHT &&
+    !ignore_basic_mcs_set &&
     !ieee80211_verify_sta_vht_mcs_support(sdata, link_id, sband,
   elems->vht_operation)) {
  conn->mode = IEEE80211_CONN_MODE_HT;
@@ -1247,6 +1263,7 @@
  }

  if (conn->mode >= IEEE80211_CONN_MODE_HE &&
+    !ignore_basic_mcs_set &&
     (!ieee80211_verify_peer_he_mcs_support(sdata, link_id,
    (void *)elems->he_cap,
    elems->he_operation) ||
@@ -1258,6 +1275,7 @@
  }

  if (conn->mode >= IEEE80211_CONN_MODE_EHT &&
+    !ignore_basic_mcs_set &&
     !ieee80211_verify_sta_eht_mcs_support(sdata, sband,
   elems->eht_operation)) {
  conn->mode = IEEE80211_CONN_MODE_HE;

Happy to capture the gateway's actual Basic HT-MCS Set bytes, a full
beacon, or to test patches -- just say what would be most useful.

Thanks,
Gavin
