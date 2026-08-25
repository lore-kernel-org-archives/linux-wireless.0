Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352CE3F6C39
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 23:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699921; cv=none; b=et60CUdxZnOkYEP3SXHZEQN3h09cNk5sxeAPpruwbF/pLFbc015FWZrOUooi7WWCoYKoR59UiL3R1aQRcQz0OLAPV53OtyQghOrFgQ8wxU0I4iODdxC4/xeNp9P9QOhGOpT3LHDTV5Q0fxJLmU6ags/KXEPB9H+l/1Uq/queCsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699921; c=relaxed/simple;
	bh=FuOJHq88ch5E+muTVmv1j8y2KH/xN2nzfZckkDFB+sU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OyHUcs3a5Ru3Xi84Mngphipso4Pc28/6Db6tzKrQgSBS3nsWjywZKncfqUd/iQy1mS/Og7CihdzeXFxzV+/G+kF7UnxMVWJsxkft/IbKyY1aIU32E2NZYhkv3WsUatc1yug9t/XH750qP7qufX4dN2MKR8+kb/mL0PbjWGwkg50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ISCjaFth; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ISCjaFth"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4956242332dso2087475e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 16:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787699918; x=1788304718; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=O+dNfC9yZKHQ6z3DOGM7RRBr/QCmWjOhBNLPlCYcSz0=;
        b=ISCjaFthnsPOgM9Q7hbP0IZZo5N8iwzyMuuxXonHlZHZShgvNjyWA62OrK5PXoP+gb
         v6pwxZQCMjNz/U5Kz7BOVAcf/5a/RlfQtOjMyA4GbAe01K9+8Ew0wsszqx/LMqHhhpxv
         aNgFM+tbo+EEjdTGuDmg0+b9RENFgMFhxPAAITgJvr74dmZtNx7yVMwYrMAEcYzcB3Qg
         8Is2B0lMObNY6jlDSi8pVBn3WnZV0578IRUtUT7hGVOSRMkUkuYK9oWDG0Y6QZzaZLe3
         Kt3B0lY6dUgWzRNnWcUEMpIItn+ekToZk/zvT6sz0Dc0KsL/PadK6OqP70K/yfG4h9jF
         t+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787699918; x=1788304718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O+dNfC9yZKHQ6z3DOGM7RRBr/QCmWjOhBNLPlCYcSz0=;
        b=S8+8WpHM6F0tFavRXteAGTKm31clFF2kdLDaDI8yXILPGLMP6RncafXdsUzaXZm0yF
         2AZLsbyDDolKnhxfjkJJGSsM8Hzj7kxJEzzKSUMzN8PqQR5iDHbjXDynafXyywbqYPJ/
         ME6m5Mj4l7R52T+v2gIbXA5W6blLJiP5U7fEg8nhlFT8wjTs+509e74ewEoL+sJ2/Y9G
         CAK2lCfeB0xupg2kp5iJ6EsbpxJxd1X6aYNfMHH+H7Ms37ZJkrOTQiM+Bq/Yub9e4JON
         lpJ51OpHfV3oPjwAEW+PofGeCwSF4tduY3mECZ7P8dqTpxaf8La6eolZp6/Q8KoOVXsX
         s8Og==
X-Forwarded-Encrypted: i=1; AHgh+RrEHY7UxXdiOG5d5i2zUA8DuvHLFq1q1YO3ieq4RsvUdbXgeUwXkCs6OGGw561UHYEjfEy/MXVNJLmWObZ++w==@vger.kernel.org
X-Gm-Message-State: AFuF++nxjEWN917Zuu9eVvsRL7ORJitdcV/Ea2tM1xwYpaX1baHbNy+6
	FwwESNrVk8aa7ApQohJwlbXROLsVjN43yNTN5TyX16yHdPNEQk8DxXe2
X-Gm-Gg: AR+sD13LWRKYYOA7kP15uaE3vRprlgnboZlWPO1Bzn9zGVhEHHeTOTe1CVI6HsfnH4c
	Qm2v8TyAwRZmemXPYatgt3Jz1Kg9WoNTJ8Tp0ocm7DrSKyhPapraAWCW/jKcbnV52s879tu5qCI
	QPL8bQK5FE5UpPrx+UJT6itgcjK5hwtzn7R0hUiCyIJOTn22DX/gS/NKm+YpRYpY2agrzDFK/Tg
	JT6KnL12OuOSY1xrUP+UIgULsx/+b6ZXvrCtkH4u+xylXjbCa+nPCA0CQW38RT6st7lYQ6lz9cU
	JJ0H/rph8iPigXHQM/8WPirb/a7TISVf7JOkEGXEYMOfFQUWJkavrOpX63RqfXCkEgtznYKci+v
	xlbxaNXkYDbrSj3nhM+zGB2rAZ3AmKbg74H47jqwDUcnx+wx53AydBL/g524N1UR65z5VTkuwZ2
	veo1g4ccizruuVhY1/4Wzp9Qwfe02WTFxK8xdlpDu6Xk7wtXu2GwT2Sl1owvbSP7iawOIIei5nN
	d3Ka+tSOV6eQfDe863+Yz4bbTaLtCN9neq+bTfiXe1Emnp5
X-Received: by 2002:a05:600c:6287:b0:499:db27:7b1 with SMTP id 5b1f17b1804b1-499dc8311b7mr20313125e9.15.1787699918326;
        Tue, 25 Aug 2026 16:18:38 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e279e8b7sm864017f8f.7.2026.08.25.16.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 16:18:37 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH wireless-next 0/2] wifi: nxpwifi: fix two block ack teardown bugs
Date: Wed, 26 Aug 2026 00:17:08 +0100
Message-ID: <20260825231834.244783-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two independent bugs in the block ack teardown paths, both found by code
inspection on next-20260825 and compile tested only.

The first leaves nxpwifi_11n_delete_tx_ba_stream_tbl_entry() unable to
delete anything, so Tx BA stream entries leak on every teardown and
aggregation eventually stops being negotiated. The second holds the RCU
read lock across a teardown that sleeps, which splats under
CONFIG_DEBUG_ATOMIC_SLEEP when a station deauthenticates from the AP.

David Carlier (2):
  wifi: nxpwifi: fix inverted check in Tx BA stream entry deletion
  wifi: nxpwifi: do not delete Rx reorder entries under RCU

 drivers/net/wireless/nxp/nxpwifi/11n.c           |  2 +-
 drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c | 11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

-- 
2.55.0

