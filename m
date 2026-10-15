Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADFA50AC05
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 11:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792065594; cv=pass; b=npZIh1PHISDobYJB+Qke6Ppzq2M5RPBNmQVX4yLl7EUkLexQSwQaPjYuSxNy9zPoiYqrtNdiMbJwq2qc0xyAA/ZojbmeeOyII6vCjvqOIEiMLTgl+EeyDumx38EPYVmaFvNP1486gkiDzYHihK5/o1onX9CxiXPztWmA44HISyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792065594; c=relaxed/simple;
	bh=Wo2ZdmDchHyVz6ffvcBLU2NgjwqOxssNxx4WRw5zMxk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Yf3b2t3kth9YC/ZzEs0ySUtwGjDclggB2MrySU8ZzHEmgpYX9+ipX/QQSfww/Bc+xCbAeb44KNhXFbzNnuc7EJ1MdDj/USfyslLvkzadrgn/MlqOx3mh74jai863bWWOLx2VuXY03KAOWg6EwLd6SQE5EElcMpVf8+yyaRii4Wk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kcAMb2k1; arc=pass smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kcAMb2k1"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cd632f7a4a1so514998a12.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 04:59:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792065592; cv=none;
        d=google.com; s=arc-20260327;
        b=BxY2FTnNcgH+kpeQqibm9aey0+k72gb9pSejqLzzdt4fIpZWG1iiVTySLdOP2L4+zD
         AA20zMb3HLVaF/lT2CHXlHfZAunB4om3WuhPT8HvC2HZFve6RrZmEiyYlffhi/dAU33j
         pvi1q5r8i43qe9fFJvJGo2rlGSjQ4xr4vvn9W486wyBdSsS0LH8uyhs0lBDj+FLovCh8
         22uCXYTFv4yRjjwHgDmMRN/VIq8rtDAWrAIFF6m3fMKgl/jCiTDaUieZ6p6XQrLuC1Yb
         +DW3Acj8D38qEfneIax6RTSLqu2lf17Yf3V+3MU7GPMHZV1jvOAzTEBYQyM7rvCsM7VO
         WvrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=3/nReelf14EWQqHsOcbF+fu+5vGYBDoHE2O0C1m+MiU=;
        fh=InP8ZgxEyPw9Hohwr/lJKfEKSYLCI3a5eP6n8bhGvoQ=;
        b=JWpNJOhxzbue/yZBoolGKmA1L8BE1sTpCfQtnu+YTDhFseaubVorPkfTq4AUqHAwHh
         7GO0/Y836d/UUhP8JkKeRajRN3oVuFIT15UA4j7BGh59Ffl4ozuWvln4y3nhf7X/yu+x
         DD7xErYwlxpzdEP4sTVdj30rh6ZUuLijBaO3U2L6NF1CMMP7BUhM8WyUcFmxXSuwIfaM
         bLQIzhbHu/tNhgV0rP8RoJH+RZzDPK0eQ0I8nADmUpu5o3MN3Dp2pApJFqlBJ1etcxUG
         UVSpROb1TTqyzz4lbNarNTbj/ne8iU1wdCMv+UqRIxYRRezS6FBfC4HznF5XOfgQdFTW
         bHJQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792065592; x=1792670392; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3/nReelf14EWQqHsOcbF+fu+5vGYBDoHE2O0C1m+MiU=;
        b=kcAMb2k1aWz+WgK360hArr19Q/Bd7a95HzkpS34OX0ti0ZGZCbQt8pi81T9Fj1YvMZ
         yZynECOyf24gHqNNydMmbC+KnGZ6Z8l1HqI78pwiaQUEyQFOtE/JX6Xd884aN4ZO2m1/
         lHKJwReouWsFFZgKse6+GhVoCiSmhm/OQYyLNzg6VQcvEQh0DGw0Pqy7yzQ1axrnofOe
         eVawJyJRY5B+I+Ibgvn+ZHpvvN/EbwT5ZmNAZLMYbCYNF4WmWkTN7O6bS5gEKQT8RT0L
         l9Cn8V+FD5Ntc99ztV1kwTL+HLz8nMeBxK+ewKJhaJqrcmt6wnyOB7tsdhrZ23eznKV+
         jViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792065592; x=1792670392;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3/nReelf14EWQqHsOcbF+fu+5vGYBDoHE2O0C1m+MiU=;
        b=Cv/1JAh7HsuxeZz8Yv0blt1ECuvB/D8MZZTRPe1OPUw/14kxQsbDbVsS9fS1og7xKy
         2AdeA8meekU3qJCMJBG1t+3Szmv6PjDnUgQCo748kbc3HRB8YXScqDIVIzIxOXLZupK4
         ILdOMj3svNLwa7D9vdom/lPT7liskCepG9MUxpaPPL9nkWpJE32iCoJabHa8RN4Jjhzz
         6P7lTlFCvK8tUhrJnK7HSf2K2vV63s/Duqpti4cvpevQiOS6cFH0kPIxc4tcjwuA0rul
         5UrPKtuo19muwRT6tO+OWeAu7w3slhjw6+mAiXAmGNiI0VjXHpm+O33rWP8LmivyYite
         axyA==
X-Gm-Message-State: AFq9FYIoWcnzKCIXeYA4IpnohkDXnCDCNVupSVpIucO4yjKjZfJG384Z
	NeMTd/2wcGMFnrRxnL4nLK5na3Up2UFXQsByb8Yunp+OUi4mGsmeyl1y6Z1kT98+/lbDfj2NGgg
	rX3I6gRP7WQiFwtvwQYevXM4JUWmV0FOAzO4gW2o=
X-Gm-Gg: AYBFou0r9FOjturkhNaBkMzvi8nl3YbTdy9iLuEGMl7Stdatlmsup8TOcfDc63N3sgN
	sYIIn6UEhbBaEK8GyK76mVd8EzfUhpwWyLi1IIZOrsWrz6v2rWdRB0bxB9IX0XgsIhgUP+Rawwl
	60VaaAxl6ictkRM2f6RIJhhXft2tXjbRtofmYvSgkwUgAVNHU8BsoQolCZzO2pD3BYgCKUIpNJm
	dbaXPL4WxB6CRI2JMTNI7ygv3YDhUX4T63PZipqNHhxOwOcJNrcyjH7zbayjEsseBMWPAO1/wRu
	ZmPpWlTIjsyB2n7Grj8MwuBRrOyYgMkhtMt5nCIUzoJvMTsFGUxTLV61SjkS8ItJYM+zXDy+Uju
	ulfjzG3Q+cvy1I2eB1npMtdra0Z5Z1cyBZ03PjeA=
X-Received: by 2002:a05:6a21:3a42:b0:3cd:8bba:824f with SMTP id
 adf61e73a8af0-3e16baa4738mr17749367637.4.1792065592409; Thu, 15 Oct 2026
 04:59:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Enrico <vovkap97@gmail.com>
Date: Thu, 15 Oct 2026 13:59:41 +0200
X-Gm-Features: AclHuK_1loIYtjP2yiGN8XJ9aUDF0ZR1Aguu7iHehBX8Ni8AvgjegcgRYd573T4
Message-ID: <CAGHkXsZX7Tnze+rqJY=D5Zz2Vo=t2Hee28pDxFpoE+Lno+EcxA@mail.gmail.com>
Subject: [BUG] ath12k: WCN7850 firmware stops uplink TX on EHT (CMD_REMOVE_AGED_FRAMES)
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Jeff Johnson <jjohnson@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On EHT, the WCN7850 firmware stops transmitting uplink data for 1-4
minutes while the association stays up. The driver keeps handing it
frames, the firmware releases them as CMD_REMOVE_AGED_FRAMES, and the
AP receives only the few frames the firmware reports as acked.
Downlink keeps working and the kernel logs nothing. I saw 11 stalls
in 57 hours on EHT and 0 in 24 hours after switching the AP's 5 GHz
radio to 802.11ax.

Setup:
- Client: Framework laptop, WCN785x [17cb:1107] rev 01,
  subsystem 1eac:8000, ath12k_wifi7_pci
- Kernel: 7.2.7
- Firmware: WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
  (fw_version 0x1103006c, latest in linux-firmware)
- AP: TP-Link EAP770(EU) v1.0 (IPQ9574), firmware 1.0.0, channel 36,
  80 MHz, WPA/WPA2-PSK with TKIP group cipher
- Link: EHT-MCS 12, 80 MHz, 2 NSS, no MLO, signal -31 to -38 dBm
  at the client

Client side, sampled every 2 s with bpftrace (ath12k_wifi7_mac_op_tx
calls, ar->dp.num_tx_pending, deltas of
ath12k_dp.device_stats.tqm_rel_reason):

During a stall the firmware acks only 7-15% of the frames enqueued
and num_tx_pending grows to 1616-4360 (the 9 stalls recorded with
bpftrace). Frames come back in batches as CMD_REMOVE_AGED_FRAMES and
some as CMD_REMOVE_MPDU. At the end the whole queue completes within
2 s.
Sums from stall start to recovery for the 4 stalls recorded with the
release counters (FRAME_ACKED includes the recovery burst):

  stall start        enqueued  FRAME_ACKED  AGED_FRAMES  REMOVE_MPDU
  10-13 22:19:13        20546         9916        10630            6
  10-14 01:28:35        28114         8799        19219           94
  10-14 03:16:57        27658         8811        17770         1075
  10-14 12:14:35        43663        17485        23012         3146

mac80211 and cfg80211 tracepoints show no flush, queue stop, sta
state change, beacon loss or connection loss in any of the 9 stalls.
The only events inside the stalls are scans: 5 of the 9 contain one
or two back-to-back 8-9 s scans, 4 contain none.

AP side, per-station counters (apstats -s -m <client MAC>) every 2 s
during the stall from 2026-10-14 12:14:35 to 12:17:36:

  time      AP rx data  AP tx data/ok  client FRAME_ACKED/AGED
  12:14:01         +48        +44/+44  87/0
  12:15:05          +0        +19/+19  0/224
  12:17:30          +0        +22/+22  0/993 at 12:17:31, pending 1990
  12:17:36       +3273    +2399/+2398  15033/0 at 12:17:37, pending 1
  12:17:38      +12498    +9273/+9268

From 12:14:41 to 12:17:34, in 61 of 87 samples the AP receives no
data from the client. The
other 26 show 1-213 frames, and each matches a FRAME_ACKED batch on
the client in the same 2 s. The AP's TxSuccessDataPackets stays
within 1 of TxDataPackets in every sample.

802.11ax: the client links at HE-MCS 11, 2 NSS, 80 MHz. Over 24
hours CMD_REMOVE_AGED_FRAMES stayed at 0 out of 3.42M frames
enqueued.

I can send the full logs and the bpftrace script, and test firmware
builds or patches.

Thanks,
Vladimir
