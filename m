Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523FC439F95
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 23:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792278905; cv=pass; b=TERlamr8fvZGZSahYCgddMdtlf8z1V1KERmyS3IM6BSIT7lHjrL6L4g1jaxb/2iWo9loKDxYlC/EhGHqEMvAJ64NmouD758bdDyZfvzfktSa2byOcJFibtmGwsyWr6ljW8Yawh6hq0871HK1lnl7lUD4vyqpZSMgzV1hXvcsih8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792278905; c=relaxed/simple;
	bh=JGQQmMQk+YHEshO35FLCYdVBSknCjMwyLuG8a1XtJms=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Mwhqm8aRTD9H6ld8eZTRKQJ+FnPRLziROu0k8p2eGp9TKM1ztM0YyGpPZeq8CgcUK/wOGv22r9RISjkQwevHG44NBtFGjU3zqAXXdg23lz+yayqjwGjikLg4/kodqRZjXME4qrCgPY03VEoKnCZQwpS14bwCXxLhJrrtZ3YTrOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K/Gu8aeX; arc=pass smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K/Gu8aeX"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be3db57938so929749e87.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 16:15:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792278902; cv=none;
        d=google.com; s=arc-20260327;
        b=EaNFOt6Pldm8XSpUAMpogbpXKZ/mu6T2koKj71ofV8+qObnKUEJnGsRpHEayC2iVT5
         iTVYoCEBnvCRiGOXX63SSZRtxR6GgwVd/3g2RKIEFEgQW3QfrOXu/tNhEA0grWNFD/PK
         yQMtu6mhtRtjuFIu0r+xVIDqvh/2kQENiMiE8Kqxrr0HF1D7DaQ5E0LWNIYrmyEB7KRt
         1jaS3OmrQqHn8YZN7kPncP9TFKGM0CFDR2bpvu9EERPh8659fKVTHfIhtsbmm3TX/sLx
         7Z7lWevJueJXvezcYQD3EeLau1YwZl4yELq4sxlTxpbYvoblgoqlBy8yCGJdue69zS+u
         eZ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=dY5KKzZAmeU+yEfKm82zl3nVnOMZXYX8gp/zRSW1kMs=;
        fh=ox3XMud497JpuKHX7t97qGObhdbJ/xIrxiXGQa6FELE=;
        b=oJrPQAgbSWMGac+YJOkiKrP833Gk5Pp4019QXxXy714rog3DPuEFUmKk270NwT1nMm
         8OzhMMPfBez1C+Mw4Rc7OMPuL7uutyxNjSGt/fe9Za0WI4ryDk7kWI69XKihymY3qslI
         vVyMfIwRK/7kA/hs/+5uA604e9CmSexXJNThAyDyJ34S3S6p11CWHHnkFN68HWK72OlG
         zH/eQ5eWxDFfi3mltAlFy/sS3X+3PSL2zxXBZLioV2Aefj7fR+IjEkimjm2bb0WejO0Q
         jICzLkcA6Y9HArGe8HGSFjrfE3uY5dHXsmuLYfI20U0+gxCdaBnix/GegO+ZABz4jnu9
         Q9TA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792278902; x=1792883702; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dY5KKzZAmeU+yEfKm82zl3nVnOMZXYX8gp/zRSW1kMs=;
        b=K/Gu8aeXwcrTxQKELdD//3v2OhpoBTMko7XZShiArKVoOqQ0fSYKJP59RjEUUmkaEv
         AGtIJaMMOuvb4F2qIVctTz7Fb1cl8jWREXQu4CVwNPnaQHxAhTK3FRN3j/WshuUx9nXw
         EiNfRm7uQg2jU71kiElCAR6ufGRSzlDOp0XJXnrXxFQhFT5dL9gVQbWoXPbJpLWl16RA
         ccSVKjTHA03ltq4Z5dpHmZb/ezs4p3B8EtfT+qaGLLSRdBJJZPSbkJf6y3ZwpAzhcSY0
         bKiiW6w85rGNgPuT3GKFvqs5MpPhxEtpzvIUIKOXYN/yMz0JVmdc6oJsMGKo+z9+S4V5
         klAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792278902; x=1792883702;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dY5KKzZAmeU+yEfKm82zl3nVnOMZXYX8gp/zRSW1kMs=;
        b=x3/dK2OadXcXQrt7OLiwSW+xmTBPYvwyE5LJli+Z7e/QJCL2j+ANnq3S75aAi2L35I
         oMUsT6EtiwUsfR5I2tH/qe8GCM/MPsl6c1jWRaghXR2rNMOJpMlwYvSi0tlHYMQgXgdq
         L30ge4Uv59iWD5F00qsbJuQPgB9k7e/coeo7VmY1VCEDAc854G7HxpX18daWqA7XMzQH
         CCBjab52Ki5gTbb1Ngf/AJBDHM9o78D4q1eF5Bk3uFjkghIu/40L5IdEs7QZZLkYJedX
         0xmg22Lv6IlksW+mSKQ+Y0uyNrCP8fo9+LwhasA6exMZPbzjFRmLiSM/2Sa63hO0+rqN
         iPHQ==
X-Forwarded-Encrypted: i=1; AKwUvBzurrrQkzwjrd3x8AIBIQqUHmca4Milbl1JKV+mWu87a/gaMpe5OJ2VTlm40xOqLylhhYu27XQspUgw8kpprQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJWXJTMxEib3mF2HFMDvrrmGeA4nncp8+q80maOvXQ9zRe3UKb1
	gTyu8u3DuStU6ilh1iPzQaUdAGxFeVYCAh41CK0ijlQ6x1Gopq+dZ1MaR/RlOGutni4baDv2vEi
	X/D6FJLhnKl2RRKaCnNP/chRv4fj1QYo=
X-Gm-Gg: AYBFou3udn/dc3xOAp16mRy+Ikyp8OpeH6OPYR0hHHU6ojHyzNdJKSgx43Ku1Tkk6lM
	eeQ5xAD7fnFpvE4Q3PasYhhKkxwLK4jORmJe7ZgRqvXAV6dy0ignq6z9eVjuEyck+PorOfGbm5C
	SGcAti9wJslQfDBoCzuz4lxTB1qCrwuhccWnTR2s8T9gVJsifo9RheKECNdFAcRhJ8EZNigwLwE
	lO0leN3z6sQ2V1ccTT5DzhV5imDaV3N3TSv/7jjGT0Txzcqc1XdbhNiDzsqSx9Xn0CS3dvuplA7
	hFSCpdv0ScmWS5odDkQ55wxc4g0037dJR3EI7t7JIDsCs4GaieEuC7hEy+ypZ4OWhsncTK8+EqF
	590rL1aCLzWFBeg==
X-Received: by 2002:a05:6512:33ca:b0:5be:4d3b:11be with SMTP id
 2adb3069b0e04-5be50a47285mr1122227e87.19.1792278901939; Sat, 17 Oct 2026
 16:15:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?TG/Dr2MgS0FTU0VM?= <loic.kassel@gmail.com>
Date: Sun, 18 Oct 2026 01:14:50 +0200
X-Gm-Features: AclHuK9r5oP2EYX1cff49GE63bI8TeJDT_Yf62YbwB9bIK0KxMojdwbJc5md3GY
Message-ID: <CAAzpgGfrHpQZQ8iaH5fqZHzk5tTx39+jGvGkVXxhYFkp-A_bQg@mail.gmail.com>
Subject: [REGRESSION] mac80211_hwsim: CCMP frames dropped on fast-xmit
 (WARNING in ccmp_encrypt_skb, net/mac80211/wpa.c:462)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>, Rohan Dutta <quic_drohan@quicinc.com>, 
	linux-wireless@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Since 7.1, with mac80211_hwsim in AP mode and WPA2-CCMP, frames that
the AP forwards from another interface (bridge) to an associated
station are dropped, with a WARNING per frame:

  WARNING: net/mac80211/wpa.c:462 at
ccmp_encrypt_skb.isra.0+0x240/0x260 [mac80211]
  Call Trace:
   ieee80211_crypto_ccmp_encrypt+0x40/0x70 [mac80211]
   ieee80211_encrypt_tx_skb+0xcf/0x180 [mac80211]
   mac80211_hwsim_tx+0x678/0xa50 [mac80211_hwsim]
   ieee80211_hwsim_wake_tx_queue+0x47/0x90 [mac80211_hwsim]
   ieee80211_queue_skb+0x227/0x420 [mac80211]
   __ieee80211_xmit_fast+0x24f/0x370 [mac80211]
   ieee80211_xmit_fast+0x149/0x230 [mac80211]
   __ieee80211_subif_start_xmit+0x15a/0x2e0 [mac80211]
   ieee80211_subif_start_xmit+0x49/0x1a0 [mac80211]

Environment: Fedora 44, kernel 7.2.11-200.fc44.x86_64, hostapd 2.10
and wpa_supplicant 2.10 (Alpine), radios created with
"modprobe mac80211_hwsim radios=3DN", wmediumd in use. Not tested on a
vanilla build, but the relevant code is unchanged in current mainline.

Setup: the AP's wlan0 and a veth (eth1) are in a bridge (hostapd
bridge=3Dbr0); the station is in another netns. Association and the
4-way handshake complete fine, and so does uplink traffic.

  - ping from the AP netns itself (IP on br0) to the station: OK
  - ping from the other end of the veth, i.e. traffic forwarded
    eth1 -> br0 -> wlan0: 100% loss, one WARNING per packet, and the
    station never receives anything (DHCP offers are lost the same way)

Changing MTU or veth offloads (gro/sg/tso/gso) makes no difference.

Analysis (as far as I understand it):

Commit a536be923191 ("wifi: mac80211: Fix AAD/Nonce computation for
management frames with MLO") added mac80211_hwsim_set_key(), which
accepts CCMP/GCMP keys with only IEEE80211_KEY_FLAG_RESERVE_TAILROOM,
and makes mac80211_hwsim_tx() encrypt in software via
ieee80211_encrypt_tx_skb().

From mac80211's point of view the key is now uploaded to hardware, so
the fast-xmit path is used. ieee80211_xmit_fast() resizes the skb with
ENCRYPT_NO ("will not be crypto-handled beyond what we do here"), so
no IEEE80211_ENCRYPT_TAILROOM is reserved, and the extra_head does not
include the CCMP header either (no PUT_IV_SPACE / GENERATE_IV). When
hwsim then calls ieee80211_encrypt_tx_skb(), ccmp_encrypt_skb() hits

  if (WARN_ON(skb_tailroom(skb) < tail ||
              skb_headroom(skb) < IEEE80211_CCMP_HDR_LEN))
          return -1;

and the frame is freed. Locally generated skbs usually happen to have
enough slack, which is why traffic originating on the AP works and
forwarded skbs (from the veth) do not.

Workaround confirming the analysis: setting a fragmentation threshold
on the AP radio ("iw phy <phy> set frag 2346") disables fast-xmit in
ieee80211_check_fast_xmit(); the slow path (ieee80211_xmit ->
ieee80211_skb_resize with ENCRYPT_DATA) reserves the tailroom, and
forwarded traffic then works with no WARNING.

I am not sure what the right fix is: either fast-xmit should take
RESERVE_TAILROOM (and the IV headroom) into account for such keys, or
hwsim should make room itself (e.g. skb_cow / pskb_expand_head) before
calling ieee80211_encrypt_tx_skb(), or set PUT_IV_SPACE.

Reproducer:

  1. modprobe mac80211_hwsim radios=3D2
  2. netns "ap": first radio + one end of a veth pair, both in br0;
     hostapd with wpa=3D2, rsn_pairwise=3DCCMP, bridge=3Dbr0
  3. netns "sta": second radio, wpa_supplicant, static IP
  4. netns "peer": other end of the veth, IP in the same subnet
  5. ping from "peer" to "sta": 100% loss + WARNING at wpa.c:462;
     ping from "ap" (IP on br0) to "sta": OK

#regzbot introduced: a536be923191

Found while building a containerlab-based Wi-Fi lab (hwsim radios
moved into container netns, wmediumd on the host).

Full disclosure: I am not a kernel developer and not very technical.
The symptoms above are real and were observed on my machine, but the
debugging, the code analysis and this email were done with the help of
an AI assistant (Claude). The analysis may therefore contain mistakes.
I am happy to test a patch or run any commands you send me.

Thanks,
Lo=C3=AFc Kassel
