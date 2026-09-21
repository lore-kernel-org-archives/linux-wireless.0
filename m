Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A694AA031
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 15:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790002816; cv=none; b=HNeldaA5XzI2Tu9g+jeX4xAIc7AAKSNZFqYbhg71nhcByRq9t6oCLWC1GnoduIk4G9iTRLYR6f9rZdij95J7alzeXSm+NoHYsknhZMbqWaqS8nGcPVN5k0OrMGzraoM0BvMeHJ8SL9LcrdMAkYTvVKjXfSr13WKTPCifUYI4dNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790002816; c=relaxed/simple;
	bh=HsoEui3YExaisG5WoslTzHT+gWiqVjCjFroG+4igaoo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fYcb9NjxnhaHd5Hfj4PmTTLhLERPn0YqkkYgDN3ThSAIzUXZnRrcAPPBBbFlE68syWRr97JPUhB9J6I/UIUWeaj7Cevmnv8kljuQTF+N7vjXAJ286jeflCHpUeRW7pQLfrXOPhIt2UBY2V7DDEaM0dd0ce3btuQW5b6yhud40o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S68+Kftk; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S68+Kftk"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-482f635552aso2585680f8f.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 08:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790002813; x=1790607613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=34cUXsmnuPxgm9IEcR3oRSbj60OSa+S8dJr2tJlsE8I=;
        b=S68+KftkaGCFy4PXsaMTm4e8spzFUlbKrpzjMV/8+X3B/riitEaFx9BVUNHs6lC7x7
         xuroYXgL+/tBnq3I+mTYzqDL47mKUOWOD/Jzpz0X+3JUXdhK7ej1qsRw+biD7eXcffov
         YikZD+1Krs71DInKgdhq84SRGp/HGSFyZK9eFi5NadpabNruc0I3Y7VZwvjYY2uzmF8O
         ndPd2v6JvMJtJulEHoq8THpOj/VQGzeFWr/HPuMDZ7YToPJx05mLktK8H5r93J5OARQ6
         roh+Ae5qrhCmFSL4wo/qQpF35+JIGu32+D74Oey7QhPDdEEdUZ4ULKm3ffeWqqlS4XpB
         o6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790002813; x=1790607613;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=34cUXsmnuPxgm9IEcR3oRSbj60OSa+S8dJr2tJlsE8I=;
        b=ikN7cI9qgj+UJDT4Y5YyR+pCIxJkuPoOAJ92QfbO3f1kaL2lxDIg1oGPo+7fZxXTPN
         WEqaL9eM7R8P3iZWm5U2UaAq4W9wqhF5QTRJxQF01y2ReYJyhL1cHaG7dVfjRt0KZlTI
         PsRytABei5OkGzmCq7UXI4r3RQNnp1vlirCZN/okehPLtEhnE407QCk3/V3W4ylMx2gx
         l7WjiRmREx9cepk7VaNqTn3gx8r51ueDIeX3NXtHeXTF3MZuth5ir58e0zMXpgce/J2v
         x/x8NIvoiHjLolG6SKryDYp2xE/m5KwCwkZn1AJrZwdraCBHH7LTCRpuRSNAqlb+GZNA
         l25g==
X-Forwarded-Encrypted: i=1; AKwUvBxKjADbG9O+linLbNIW/JooqYSBpO+gAACtTmDla8CRpfXy56ARWl6ema3C6qpwug1QLHsbnGSRBRPKGjIyVA==@vger.kernel.org
X-Gm-Message-State: AFuF++kcDamtlHznPDwxnFRTs7zyePaPx/wxif03JzFsMRSGLbSq/Ygz
	8pAt2gYwv+uMvb2oT3lMqvciuxOJPtRmt5mTuD0kMhhJ076Uq830c2H2
X-Gm-Gg: AYBFou0I+SbwUCyE+Fj3PgT09EMvyWHzXJYZ+TQoQ250ZfNmVPfeZS9y8fkNRwpAFkd
	xQbEegC/B+MKrgPJGmU4kiQwq7jrBz/kOR4YYdKWjMAUgDM1smEM7EnKm+xvbqMsIkY2ibILaap
	cOHvPuJrAdMbQfk5CABClC+v/BU0botQSz4npP11vSyyZAMu5pCI+kGi+IFQISr1AlIRsFwF4UR
	7aV5FM2287Ot/vZELpfMg5luTiHQrGmMChReoxGeKtNdqgPR39rxVUZyouBoiDucPCUOKE49dSA
	UxpO1NIH5Ib/W7xTfN1Z6VNPHDJEyVr8H5nstjSd6RC+rrZ3aA2EkUula5pkfX9KpYYXEVJEG6m
	z5qvFC7CXvb4gtRmzxjTZu9CcAXrR36r+Su6f+SctUcIsFlf57wKmrIZIUQVDOcLZMhkyhapVBN
	/N1EFCsKzO3vUSsPqdsOAoBs/8G5IM8KH8oDrRy6Z85gWwv23vv9qUr/+1m1OOa/AvZude+9FTr
	oL5q71UG2eZCHlMit9IPsDy4aVgf72n2+89Y2n2wZeUoO9t4GJ38vUWVgh0vUKq76TB1yVmIMvY
	UaQL0/OqtSswNESa84qzuonoaGIsbe5TM8bwMg==
X-Received: by 2002:a05:6000:2409:b0:487:6ef:86b8 with SMTP id ffacd0b85a97d-4871e3b6afbmr19102964f8f.49.1790002812455;
        Mon, 21 Sep 2026 08:00:12 -0700 (PDT)
Received: from localhost.localdomain (37-188-130-107.red.o2.cz. [37.188.130.107])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48724460767sm23044881f8f.13.2026.09.21.08.00.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 21 Sep 2026 08:00:11 -0700 (PDT)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: stable@vger.kernel.org
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Subject: wifi: rtw88: backport 737e980e1298 and f24d0d8c3cd7 to 6.18.y and 6.12.y
Date: Mon, 21 Sep 2026 17:00:05 +0200
Message-ID: <20260921150005.95894-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

please consider applying the following two rtw88 commits to the stable
trees noted below. Both fix user-visible breakage of USB adapters running
as an access point, both are small and self-contained, and neither carries
a Cc: stable tag:

  737e980e1298 ("wifi: rtw88: TX QOS Null data the same way as Null data")
      for 6.18.y and 6.12.y. It was merged in v7.1, so 7.1.y and 7.2.y
      already have it, and it applies to both trees unmodified. It does
      not apply to 6.6.y as is, only because the lines around the changed
      one differ there; the changed line itself is identical.

  f24d0d8c3cd7 ("wifi: rtw88: Fix the random "error beacon valid" messages
      for USB")
      for 6.12.y. It was merged in v6.16 and 6.18.y already has it.
      It applies unmodified, to 6.6.y as well should you want it there.

The setup is a Turris Omnia (armv7, mvebu) running OpenWrt 24.10 with
mac80211 from backports 6.12.96, a TP-Link Archer T2U v3 (RTL8811AU) and
an Archer T4U v3 (RTL8812BU), both as 2.4 GHz APs serving home automation
clients that spend most of their time in power save.

f24d0d8c3cd7
Without it the driver logs

    rtw_8821au 2-1:1.0: error beacon valid
    rtw_8821au 2-1:1.0: failed to download drv rsvd page
    rtw_8821au 2-1:1.0: failed to download beacon

526 times over 12 hours of uptime, roughly one every 82 seconds. The
driver mutex is held for the duration of the failing poll. With the
commit applied on top of 6.12.96 the messages stopped completely, with
the same clients connected and the same traffic.

737e980e1298
Without it the driver logs

    rtw_8822bu 3-1:1.0: failed to get tx report from firmware

every one to three seconds, and stations are dropped with

    hostapd: phy7-ap0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated
    due to inactivity (timer DEAUTH/REMOVE)

hostapd polls an idle station with a Null frame and uses the TX status to
determine whether the station responded, so a purged status is
indistinguishable from a station that did not answer. I have not
instrumented the link between the two, but they appear together here and
the driver does drop exactly those frames.

This is my first request to the stable team, so please tell me if the
format or the amount of detail is not what you want.

Thanks,
Josef Schlehofer
