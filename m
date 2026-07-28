Received: from mail-qt1-f227.google.com (mail-qt1-f227.google.com [209.85.160.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A13E200110
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249959; cv=none; b=dpMA8cRJvtC/t4siIpBg/g6nNWPsOV+8t/cwNIx7jSdLdvAUxibo3cvdxZXm9pO0YizDsyIjEi8N9qR+P/Rerx0h4H7g/Q461Gr8HlZtOuyZSSmeYtMbGT39x9KOyc+hQdm2JAHREBd5npy95Sh10+VA6O/E+J7BfLVf6n9Ce/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249959; c=relaxed/simple;
	bh=7UKX7MDyVv9mLrNISZS5Pf78Gjq3JDN7YTKqNs2Az0c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ct40GUA9XLyWG3piMP714paHUVEuOLHCU0MNhatt17N8aIpumuiqSwaJR/H9Su1glsgcuMJyyQYUggylmM5EY6TZKdg+JyUii+GkxtF2HuoCY7IJaZcEwQbd8F8XeZTt8/3SU9vc+Eoa7m0mdlROJ+9YKKXk2UDnseAjyw1PaWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SoFgD4xT; arc=none smtp.client-ip=209.85.160.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SoFgD4xT"
Received: by mail-qt1-f227.google.com with SMTP id d75a77b69052e-51bfe810293so21398711cf.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:45:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785249957; x=1785854757;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=C1f3fUn1EJlSqlbr0IU2+J+B/U0AZgDWhk4xzCb4/LA=;
        b=W54O2LeAOVx9ZliJ2ONv80U3+Y5genyqwE0zNl7KclvJXufO4hc9Bc7Sk2llMGvxqe
         TVrVgJJKaUuhEWtXS2EthLY+ihk6fGluPOo9ctLYy4oPAplrbU0KkO2ckzzLC5/4RaAj
         hE4UB2e8Mh5nMuTbGTg+14oWTWRAKwe/S31cz3/x5HNjqba+eDP2J7/jSPh/EudBy7CV
         zAV7gLK9seD0L8OEV5ddylcUfjZCrPj4LXW4XAUEU2cW8grqAGcaeBxA25/cb6Nucdun
         WyVUAeeAV2+41WVvidDqxEZrQFWudM9teRt6C5Hr+ooQsemxb5aSVv9LprgleRrBzj1M
         UZZg==
X-Gm-Message-State: AOJu0YzE9+rqM5tkYFJQOkk/CLCcngIwS8FhC3p/1KPqXk2vMq62gV7u
	rm6S3La+rXFUUcUqNgtNl8RVzUQa2nQB9gU73roYQEo0meBGvltqdi+d497N4TCydknm5GK0MUJ
	ep1WqEuu71SPZ0xQbqOuVZZNEQohpBuM+NhppvdGfWz0aARI/7ZqpWghWzFkweYlNvW1ddaCM43
	LtQfAHgd7OAclgnxvRKCsM9LqI14aq6f+Wfdbi6kpFj4bO1/eocGbCUi0SmV9kqQU7NIqRuyLDf
	bfoLJ5yf9HZ4jlBGpv+/A7UoHpy
X-Gm-Gg: AR+sD11Mn0mshd8z8eMfHmS5gdDGiV68k6h5Jupy6bYETsTP/tAaKKJj87jgmwwX+vg
	iopWWfXLZqbPr9nTv+XkfS3r/aAUSeKWMRFuu8e5EGcWuuOHlhcc+ccHALPRayHNJQOYa499Ifc
	QpX1Lf/jY0RUfAJ1xH7+55AoO78wi6BJm+YFEFxzqODsR8OdU1S/NZ3j9okDHLrk8nT0YpjflU1
	Wa04b5RzYfipWWBn8aq8EZVu0uEBGkuIgHjktA5nZsgo8R9j/X1KOf7F6N0KLyuDeJdap3kzMFO
	I/80PswTmJwRGHC3sBzQL2NvZZFPLXtsTqC4ggrA3QJRmED+9Fde1SAs55cpwyEW3lyNRuZAP/o
	85qXG3kLf5X1Vto1X5jTfjP9mbipalFLR+FdTVrrXwFcqnukZEjFznNBO2zeDoyaxpVKIkevWfj
	x81WTR95j8++4BGJMcz4NXHyG+SkATK1IhVj3e9/M=
X-Received: by 2002:a05:622a:412:b0:51a:8c9b:64a1 with SMTP id d75a77b69052e-529d7169f3amr24886851cf.69.1785249956662;
        Tue, 28 Jul 2026 07:45:56 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-529a29cf963sm2515381cf.29.2026.07.28.07.45.56
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 07:45:56 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-9309af14fd7so424963585a.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785249956; x=1785854756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C1f3fUn1EJlSqlbr0IU2+J+B/U0AZgDWhk4xzCb4/LA=;
        b=SoFgD4xTC2N5h8Zgn+3Tk/4aZrJyuOaz5n0KjPbaCACSYVMluyE3ONNjCcmldnUXxx
         43bVA0tVtjsNskhqU3Ah6KySDx79bEZxpBZywIZS2AqQtxcCErTsW4N9pdz3GyzWALhO
         4ssX1VRcFFRq2nJnblhjlIDyhysgukt/HqlT8=
X-Received: by 2002:a05:620a:1a21:b0:914:bb06:288 with SMTP id af79cd13be357-93302724147mr257115785a.22.1785249955765;
        Tue, 28 Jul 2026 07:45:55 -0700 (PDT)
X-Received: by 2002:a05:620a:1a21:b0:914:bb06:288 with SMTP id af79cd13be357-93302724147mr257109985a.22.1785249955142;
        Tue, 28 Jul 2026 07:45:55 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de519154sm878659685a.5.2026.07.28.07.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 07:45:54 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v2 00/12] wifi: cfg80211: consolidate cookie assignment for async ops
Date: Tue, 28 Jul 2026 16:45:37 +0200
Message-ID: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

NL80211_ATTR_COOKIE is a userspace-visible u64 that correlates an async
nl80211 operation with its completion event. Three cfg80211 ops currently
delegate cookie generation to the driver: remain_on_channel, mgmt_tx, and
probe_peer. This produces inconsistent strategies across drivers: some use
an incrementing counter, some use get_random_u32(), some use a CID cast to
u64, and brcmfmac's mgmt_tx always assigned zero - which is arguably broken
since cfg80211 treats zero as an invalid cookie.

The add_nan_func op already does this calling cfg80211_assign_cookie()
before invoking the driver, ensuring a unique non-zero value without
any driver involvement. This series applies the same pattern to
remain_on_channel, mgmt_tx, probe_peer, and tx_control_port.

Structure
---------

Patch 1 does the cookie pre-assignment in the nl80211 command handlers
calling into the drivers. Drivers may still overwrite the value at this point;
subsequent patches remove the per-driver generation. Patch 2 updates mac80211,
which has its own internal cookie counter (roc_cookie_counter) that becomes
redundant. Patches 3-9 are per-driver cleanups. Patch 10 finalises the
interface by converting the u64 *cookie output parameter to a u64 cookie
input parameter, making the direction of data flow explicit. tx_control_port
is handled separately in patch 11 introducing the zero cookie value used for
the dont_wait_for_ack option. Patch 12 avoids sending frame tx status event
when a zero cookie is passed in the frame tx status calls for mgmt_tx and
tx_control_port.

Non-obvious aspects
-------------------

ath6kl (patch 3): when the destination STA is in power-save mode, ath6kl
queues the management frame in a software queue (struct ath6kl_mgmt_buff).
The cookie must survive enqueue and dequeue so that cfg80211_mgmt_tx_status()
is called with the correct value after the frame is eventually transmitted.
This means the cookie field is threaded through ath6kl_mgmt_powersave_ap()
and into the queue entry. The vif->last_roc_id and last_cancel_roc_id fields
are widened from u32 to u64 to hold the full 64-bit cookie.

Synchronous mgmt_tx (brcmfmac, wil6210): these drivers call
cfg80211_mgmt_tx_status() before the mgmt_tx callback returns. The status
event is therefore sent to userspace before the nl80211 command reply that
carries the cookie. Userspace must buffer the status event and match it
once the reply arrives. The pre-assigned cookie being consistent across both
the status event and the reply is what makes that correlation possible.
Previously brcmfmac passed cookie=0 to cfg80211_mgmt_tx_status(), which was
broken; this series fixes that as a side effect.

qtnfmac (patch 9): the qlink firmware protocol has no frame-TX-status event
type. qtnfmac never calls cfg80211_mgmt_tx_status(). The previous code
generated a random u32 short_cookie and sent it to firmware purely as a
debug identifier; it was never used for nl80211 cookie correlation. After
this series qtnfmac simply uses the pre-assigned cookie for the same debug
purpose and discards it. The absence of tx status reporting for the
wait_for_ack case is a pre-existing driver limitation not addressed here.

mac80211 0xffffffff removal (patch 2): the old code assigned *cookie =
0xffffffff for the dont_wait_for_ack + need_offchan case to ensure
roc->mgmt_tx_cookie was non-zero, which distinguishes a mgmt-tx ROC from a
regular remain-on-channel ROC internally. That dummy value is no longer
needed because cfg80211_assign_cookie() guarantees a non-zero result (it
warns and skips zero if the counter wraps). The cookie is still not sent to
userspace in the dont_wait_for_ack case.

Changelog:
  v2:
    - SoB for patch 1.
    - zero cookie usage in tx_control_port (patch 11).
    - drop frame tx status event for zero cookie (patch 12).

Arend van Spriel (10):
  wifi: cfg80211: pre-assign cookie for remain_on_channel, mgmt_tx,
    probe_peer and tx_control_port
  wifi: mac80211: stop using ieee80211_mgmt_tx_cookie()
  wifi: ath6kl: use pre-assigned cookie for remain_on_channel and
    mgmt_tx
  wifi: wil6210: use pre-assigned cookie for remain_on_channel, mgmt_tx
    and probe_peer
  wifi: brcmfmac: use pre-assigned cookie for remain_on_channel and
    mgmt_tx
  wifi: mwifiex: use pre-assigned cookie for remain_on_channel and
    mgmt_tx
  wifi: wilc1000: use pre-assigned cookie for remain_on_channel and
    mgmt_tx
  wifi: nxpwifi: use pre-assigned cookie for remain_on_channel and
    mgmt_tx
  wifi: qtnfmac: use pre-assigned cookie for mgmt_tx
  wifi: cfg80211: convert cookie output to input parameter
  wifi: cfg80211: convert tx_control_port cookie to input parameter
  wifi: nl80211: send frame tx status event only for non-zero cookie

 drivers/net/wireless/ath/ath6kl/cfg80211.c    | 22 +++++--------
 drivers/net/wireless/ath/ath6kl/core.h        |  5 +--
 drivers/net/wireless/ath/ath6kl/main.c        |  1 +
 drivers/net/wireless/ath/ath6kl/txrx.c        |  1 +
 drivers/net/wireless/ath/ath6kl/wmi.c         |  2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h         |  1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c   | 12 +++----
 drivers/net/wireless/ath/wil6210/debugfs.c    |  2 +-
 drivers/net/wireless/ath/wil6210/p2p.c        |  6 ++--
 drivers/net/wireless/ath/wil6210/wil6210.h    |  4 +--
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 12 +++----
 .../broadcom/brcm80211/brcmfmac/cfg80211.h    |  2 +-
 .../broadcom/brcm80211/brcmfmac/cyw/core.c    |  8 ++---
 .../broadcom/brcm80211/brcmfmac/p2p.c         | 10 +++---
 .../broadcom/brcm80211/brcmfmac/p2p.h         |  2 +-
 .../net/wireless/marvell/mwifiex/cfg80211.c   | 20 ++++++------
 .../wireless/microchip/wilc1000/cfg80211.c    | 19 ++++--------
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c   | 20 ++++++------
 .../net/wireless/quantenna/qtnfmac/cfg80211.c |  4 +--
 include/net/cfg80211.h                        | 14 +++++----
 net/mac80211/cfg.c                            | 18 ++---------
 net/mac80211/ieee80211_i.h                    | 11 +++----
 net/mac80211/offchannel.c                     | 27 ++++++----------
 net/mac80211/tdls.c                           |  2 +-
 net/mac80211/tx.c                             | 31 +++++++++----------
 net/wireless/core.h                           |  2 +-
 net/wireless/mlme.c                           |  2 +-
 net/wireless/nl80211.c                        | 18 ++++++++---
 net/wireless/rdev-ops.h                       | 16 +++++-----
 29 files changed, 126 insertions(+), 168 deletions(-)


base-commit: 90883c513ca01e77c56b8d94be7de11420c1dacf
-- 
2.54.0

