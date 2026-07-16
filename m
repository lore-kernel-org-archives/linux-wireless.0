Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5857B262FF8
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 03:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784173022; cv=pass; b=FXmuvZgCzg4l0l5eBH5TfNEGMuxf4iRQwp6chxhD0oDYQSUNy18aMzaAdci1yVlOc30KOaXjj2IA2YPKbENUYbVHS2vp2wLLLKnzoJgrkGwy80DQdcm5kI/nfZyQ38QZezo5eRuYTdKCArcE9hPa8z2Rdm1WQ1kblEPOfBiyv9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784173022; c=relaxed/simple;
	bh=SOyE9cp3+o/CWnjamglQIYbeQsb/nLegiKSIjZyugKU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Blguv4rx3aGyXCDjCnOg6SCkoi28J2KQ3cwsn8B0C/CNutrGspVHYds73kPzVCJQVtDMC6RuukTOHZbcRwny9I7pLByDS+tISxAVN1cu5pjlnHyRGaKAjIlj/ScrD+aLEkRRlAZuZeE/uGbZ+TXl2HNiZfTNmZw8JIkVC9klInk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=km1PDbMo; arc=pass smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="km1PDbMo"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-ca12086c06eso5163319a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 20:37:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784173021; cv=none;
        d=google.com; s=arc-20260327;
        b=szUAcgkDAMfl1nT6tzVaaVjRROBcPtyCzjZkX968jA/1WzG3wFtUN7L4AmjNL6Pp7v
         07Vcbb8uA1PtV8qQR/q4F6UA4DE9nPgIYyL57WQr7rXmgR58aXKlzYjfBFO2IteHlyff
         uRCqr+DPoNQaf3qj1cImNft7ZZpWzEXaE3FqnEvdn6ID0HhbkSND+AxOhnDdVaCjfz8u
         jIAKJ/J6Uaypkeol5L+d6pk2QOipgxmD66O4K6c36iuspS3bgnp0N/0fVeoXZqosID3F
         7efw7ZXOX/B4lqfs+LnmosQ5JnzFFZS6D53nFw0lSZt2xF0dpduF4NYz9rrCAZCBOl4Z
         XahA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=++xPNOPeREpY4gCo4ajCNGLsmjHdnRGu+s5z8t1lDAw=;
        fh=3Wh7BGHdb3PxEJScgAGGZIxiQnxRxVF/Odmwd1X6W2M=;
        b=FFdW7+FJsA7ouygEbtD79E1aj8PGLnMC/AlCcLA7ykAYDeEVFSFVp5aMMd+swj4JDA
         e6VskksROD/8+RnZh7rV7u6vY8iKB74TOJJOLvlw13beIOO0EoKF0iuCOUyyDiE/uWX+
         1Vpu1OtXK+fT1pSIAdzVNBGG+prfaaLezrTn1ryuVvvk+BVbHwAw4bAghlk3MskDD/Vs
         PgQYLuODwS0qtoiH+1SgTz8sVH4kANpwLiamn7iKIehvv2KeHN9uKiMGWpYUFMQ0bUen
         pFfFJW1HJNLADrpnOFoF/Tqqi6ScWeugVj+Ikc7fr/fSujgCfoRZiutEWeqFF2boGwgw
         1JhA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784173021; x=1784777821; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=++xPNOPeREpY4gCo4ajCNGLsmjHdnRGu+s5z8t1lDAw=;
        b=km1PDbMoCcPmKiVZmQM3q9VYxDnUkIzoN4+IdeJKt60Ewk+mcwywpMq+8QL6Bxmv4E
         LuG4sWOYjf47GQGAFGS3fi31w8zySSLoaMZwRMU/TahpFOAkQa/ktcNSmuM/GkaUZ057
         F+KBniAZgIXezNpYC1QY+ttrsBxai9mrZa78/UWRXTwjFZEnxANIQClO8KiIYZ/LrhFz
         nbPcWW2W5JlUMqaW4zqqsjKxOrVzHYQ94djwcp4VKNt89Y0M+i0ySXlzXmjE7zhOpe0/
         uCAUXNgnwPZprx/1PpbCrE8CoHtMqOR0lCfjvy9Kb4YxBozrmNVzWROneZOlAryDQpP5
         9sUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784173021; x=1784777821;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=++xPNOPeREpY4gCo4ajCNGLsmjHdnRGu+s5z8t1lDAw=;
        b=rbXIbTi4+Vr24wiCwMqeDF4FnIpGIPQLLJRVnsgdNLgBnmk4YkTM1WobGeTv/EKdMP
         vEciEdePXDXTn0TspNRGAzqVYshItlWTTbIKhSy0FCcGZnVOH1NkuGJU8viHoS1yZDSI
         ugRBGYGpfHYEBxzv6SSudnxH6QvOUecHzWhpfJFDtDRT2T3IRiLxi3UjGpN111uTgiPw
         /iUTEDpLo57qOY7TuuhZlO3WXLymfBV0MoIq+Iyj4wAmY8Mr8ADu0kTENnasj/5KB9M7
         qMKOoUKqZ97o+BCi4ObUXbDIn/R/i0V4to9qIsj3qjKS0+hIMNFYriK2o7uHfCCCNW2/
         2Nng==
X-Gm-Message-State: AOJu0YxcLQtku/M5Z4s1UOKI/KAIzWq0U78c4BSMFHDo2qqKDpZ7oL9U
	KJQQeJylMTFrT7qDPvcLyO7XVe8/FZTl9AMc7D4LGtY1pr23omGoq+4wT6O8ZXUMwzaiUtPQaxs
	gnUwLd0yJ/+UH0ek0Qrpo6ZEL5no4nYk=
X-Gm-Gg: AfdE7clxCShb0d/9JaJIEL40dwHQDI0abG9ii7C8IVUZYWPn1hF+0uO78vsDe2FdR1e
	rZh2+zYZxrbjuZMbn5peig3YcNSfYjbXeo+ZBS03VYUPUaJ+JSvLe10G7PG+3F0NFuMeqPEEZsc
	d5wy4/DN4g6tnYkB/HEaudedZwxHK1NP2/3Bfgaog6F6Bjjbuvaxq0iZaYpj+EdaWyzcEwkOiba
	DLjU+xhBlwGD8nSr73oXnQf+0CZJ3UI9l0QXZj0sWCOa1unvU1uyTL8AwNTT0f8jaMw+lkTJxsF
	buFd9/uem6yHE+bJuwCE/f+V/DNWKLs=
X-Received: by 2002:a05:6a20:7347:b0:3b4:c9d5:cd5b with SMTP id
 adf61e73a8af0-3c36c0f6d1bmr5645717637.13.1784173020542; Wed, 15 Jul 2026
 20:37:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Mike Garuccio <mgaruccio@gmail.com>
Date: Wed, 15 Jul 2026 23:36:47 -0400
X-Gm-Features: AUfX_myaWIWReqY2lk9gfQSj8KILG7qLkd2EhVi6NUrAOKnpUQG3B49UdOvqG7k
Message-ID: <CACfdPNH1Hgz70gYNRFBupxzjpOyBAVBPdxF+f_OLRUwMwXmXFg@mail.gmail.com>
Subject: ath12k: WCN7850 fw stats permanently wedge after AP channel switch
 (v7.1.3, includes 8f153eb74546)
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, baochen.qiang@oss.qualcomm.com, 
	jjohnson@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

  On WCN7850, an AP channel switch (CSA) can permanently wedge the
  firmware stats path: after the CSA, every WMI_REQUEST_VDEV_STAT
  request times out with

    ath12k_wifi7_pci 0000:0d:00.0: time out while waiting for fw stats done

  repeating on every request until reboot or driver reload. The data
  path is unaffected (still associated, traffic flows). Because
  ath12k_mac_op_sta_statistics() falls back to the fw stats path exactly
  when the cached rssi_comb is 0 (the post-CSA state), every station
  statistics poll from NetworkManager then blocks ~6s in the driver,
  producing a continuous stream of these messages (~14k/day) and
  D-state polling processes.

  Environment:
  - WCN7850 hw2.0 PCI, chip_id 0x2 chip_family 0x4 board_id 0xff
    soc_id 0x40170200
  - fw_version 0x1103006c fw_build_timestamp 2026-03-06 09:10
    fw_build_id QC_IMAGE_VERSION_STRING=3DWLAN.HMT.1.1.c7-00108-
    QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
  - Observed on 7.0.12 and 7.1.3 (distro-built stable kernels,
    CachyOS). I verified v7.1.3 already contains 8f153eb74546
    ("wifi: ath12k: use correct pdev id when requesting firmware
    stats") and 7259b1a0e54c, so the duplicate-reply issue fixed
    there is not the cause here.
  - STA mode, single vdev, 5 GHz.

  Reproducer / correlation: three occurrences over five days, each one
  starting seconds after a CSA from the AP, e.g.:

    Jul 14 03:48:01 wpa_supplicant[1403]: wlan0:
CTRL-EVENT-STARTED-CHANNEL-SWITCH freq=3D5765 ht_enabled=3D1 ch_offset=3D0
ch_width=3D20 MHz cf1=3D5765 cf2=3D0
    Jul 14 03:48:02 wpa_supplicant[1403]: wlan0:
CTRL-EVENT-CHANNEL-SWITCH freq=3D5765 ht_enabled=3D1 ch_offset=3D0
ch_width=3D20 MHz cf1=3D5765 cf2=3D0
    Jul 14 03:48:06 kernel: ath12k_wifi7_pci 0000:0d:00.0: time out
while waiting for fw stats done
    (then repeats every ~6s for the remaining 4h20m of that boot)

    Jul 15 00:10:01 wpa_supplicant[1273]: wlan0:
CTRL-EVENT-STARTED-CHANNEL-SWITCH freq=3D5765 ht_enabled=3D1 ch_offset=3D-1
ch_width=3D80 MHz cf1=3D5775 cf2=3D0
    Jul 15 00:10:02 wpa_supplicant[1273]: wlan0:
CTRL-EVENT-CHANNEL-SWITCH freq=3D5765 ht_enabled=3D1 ch_offset=3D-1
ch_width=3D80 MHz cf1=3D5775 cf2=3D0
    Jul 15 00:10:10 kernel: ath12k_wifi7_pci 0000:0d:00.0: time out
while waiting for fw stats done
    (then repeats every ~6s for ~23h until I reloaded the module)

  Boots without a CSA never show a single timeout. Uptime before the
  CSA doesn't matter (one wedge happened 40 minutes into a boot, one
  after ~2 days).

  Additional observations:
  - It is always "time out while waiting for fw stats done", never
    "time out while waiting for get fw stats" =E2=80=94 i.e. fw_stats_compl=
ete
    still fires, firmware is still sending WMI_UPDATE_STATS_EVENTID.
  - The WMI pdev temperature path keeps working while wedged.
  - Recovery: reloading the driver modules recovers immediately.
    From code reading, nothing in the SSR/restart path resets
    ar->fw_stats, so firmware recovery would not clear it.

  Analysis: this looks like ar->fw_stats.num_vdev_recvd getting out of
  sync. In ath12k_wmi_fw_stats_process():

    is_end =3D ((++ar->fw_stats.num_vdev_recvd) =3D=3D total_vdevs_started)=
;

  num_vdev_recvd is only zeroed by ath12k_fw_stats_reset(), which
  callers invoke only on the success path, and ath12k_mac_get_fw_stats()
  does not reset it at request start. A CSA is executed as a vdev
  restart; if a stats event is lost/late or arrives while
  num_started_vdevs is transitioning, the request times out (no reset)
  or a stray event increments the counter with no consumer. Either way
  the counter is left non-zero, and since completion requires exact
  equality and the counter only ever increments, no subsequent request
  can ever complete =E2=80=94 matching the observed permanent wedge on a ke=
rnel
  that already has 8f153eb74546.

  Happy to test patches =E2=80=94 the AP in question does a CSA roughly dai=
ly,
  so I can usually confirm within a day or two.

  Thanks,
  Mike Garuccio
