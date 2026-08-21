Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C8E42F707
	for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2026 08:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787300342; cv=none; b=dR50f8qfcss/byLa+78sqk8JfhYvQV0VOIr8dJwv9fkTIWi9EL6Gx4yHOXd1fRLO2N27LUp4YqPjnH9aYEJ8ke71PdBxR61nJMr9ZkoDi3l6cJ9mDqP5axbH4xdmfgcuurXua1ryuFi41Zd4ghV/OVaP/pWfCMX1O6E+O+TpH8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787300342; c=relaxed/simple;
	bh=TU4uJHeueOdwiNcvNtR8y+Kb71SUpDkuCapRVkW68kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQnxCCdKP0VXNMyl/0nfzuXlNH9+B+IKF7f1lLrka3dZxE33y4jytETp2eYPxwohJ/d0LmXONje3LU1teGUlJ2RFFCTuyMzoEJiDBfAfnuLF9F7pGnVv7/QkhaOLxyZ9gEjaJK2UTdIhiFos2GT/pDuxPlUY65niG7yxzMIJ91s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kJWjoE/5; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kJWjoE/5"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a3fda88184so1340196a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2026 01:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787300339; x=1787905139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TU4uJHeueOdwiNcvNtR8y+Kb71SUpDkuCapRVkW68kY=;
        b=kJWjoE/5Lh6ry/fXbggdFpw0mc4zCLV2r1BvGotwmQCUx/h5eRHqpgriSem8Xv3SAm
         2AkJGB5M9Lu4oW7arJjnTLwJ6cgXsAxySCk1kGJSEj0cA4IbsJkEtn427RnHlTsi3+UU
         2u8bIvWZOhYI7x7Ms6TakPuF+kxTN0AHZgxeSZyq13O6Ye5SSVYEP6jcG++U1PhPyEqd
         jaJsfPSe5yo6nPfdTlhh8CJpQtOHCsUJVvNxQ+MjwEB/fHES14YY4xhut5Yz4CQHn5q+
         TeXDYUG1at7XrkCdcSGafJNWXGz5ssKY9wCXyEIsj3VUhjn2kNYRxhgxVr83cRYIekXe
         GXLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787300339; x=1787905139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TU4uJHeueOdwiNcvNtR8y+Kb71SUpDkuCapRVkW68kY=;
        b=jhtMIZelvovDPII76bvPrxmKXBZRL0btBzACGbDX3iqR0OY88vFONqeXkUXAh4KsBW
         /10cDKI6wkBlwVo7sngtGjuyFog/5qefgGQI1/RhBR/oArcxwzSRRTS7HqrCPVGZcAJ0
         EPVb4FFVNk8v/qhuvJEvzRSud3Pzjr8V9s/sEct4xzb1ExhW/0yXsdfGnD3PTPnnklOC
         oOefVpbRIWHBSFjMg8ixT2w2PrTDazgoEcDXxyOv7AjmVF/kJ3ZIP3EhBRzE23H6UvfY
         O3IHIdLCTfWru4wcX/tCpoBC0GnQRagUCr/Zof3K3Ywlbr0ePdQ/ZzfNvsmEG+snZPn+
         kNIA==
X-Forwarded-Encrypted: i=1; AHgh+RqEYH6/SkMNjmdJFoG6WMl1bpYjY9sGrBpO4zxvgdpqIwZfKi0qfNzVA0u/+JygjG92qW2JAO/mXl87iPAAdQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nNUXegXwvbxmBIbqfuCN/Ia8Rz7Y4GtHSqH+l5krDW0E5d3Lut
	uBc2EduLXpB/TDMkycepg69fHYTSRhDzDULUU0Lv3pWiv38bApe9srMv
X-Gm-Gg: AR+sD10UzBqzoGIRqM+kAqLrQVWlxyD9Ai64WindFIujoGtJyFSohhRkfwZPUl4e9qz
	rXOq8HG1RIq2EWcN0GDl9QSVmBuSDOwL3yKuXnI/bfiT1nyT9hPTayokOxxpaBtzM6DQqG2bzUW
	mkdAett57etHSqma6hYio6oIhrUWV9hkRbHVs+FOZrcHHXlzJ7OZ0Ko8rJ6uuNnJ3ZSat0n+eMt
	Fqz8Kud7MfGmnrIwHBvm2YJNEWJuH7nYnCmn0PZreWoo5XYk4R880deH4GTXxcxvs8+7uCsDruN
	+8vqyKqkbcY4WNp+yKAK49L/4JZg0JDAVmA2j/VaIQgTfFExEF2SpeRA1sylkd0nnQTfNpOjU2F
	w/OYwcjpix40DZFoTkAbkPXhIuywFqaHo8l8ilf7bjYzTxH76QxOINjf0HLxN3oZSBNDzGtjQPa
	n4+CBzcLmT0Ee3J9F4QTDwzNsgxML9LCa+WOVbaAm6AaBnKHN3br7YwEblpYca7onh8x4oDmjFv
	imqn23OYPCD8r+eDNYG6qQw
X-Received: by 2002:a05:6402:3805:b0:6a1:1bea:8ea0 with SMTP id 4fb4d7f45d1cf-6a42f0f7634mr5394501a12.3.1787300338853;
        Fri, 21 Aug 2026 01:18:58 -0700 (PDT)
Received: from ca91a6afa0c8 ([31.7.57.58])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff1780c9sm5238626a12.28.2026.08.21.01.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 01:18:58 -0700 (PDT)
From: Valera Kozlov <valera.kozlov19@gmail.com>
To: bmork@telenor.net
Cc: amadeus@jmu.edu.cn,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	ryder.lee@mediatek.com,
	sean.wang@mediatek.com,
	shayne.chen@mediatek.com
Subject: Re: [PATCH 1/1] wifi: mt76: mt7996: fix mixed FEM check of mt7996 chipset
Date: Fri, 21 Aug 2026 11:18:30 +0300
Message-ID: <20260821081830.280417-1-valera.kozlov19@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <87a4z9f7a5.fsf@miraculix.mork.no>
References: <87a4z9f7a5.fsf@miraculix.mork.no>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Device: ASUS ZenWiFi BT8 (RT-BE14000), MediaTek MT7988D SoC (tri-band,
dual PCIe hif/hif2). Confirmed empirically via extended TX PER testing
that adie_idx=1 is correct for this board (matches Chukun's patch),
consistent with a mixed-FEM design.

Readouts from the ADIE_ID registers:

root@bt8:~# echo 0x0f00002c >/sys/kernel/debug/ieee80211/phy0/mt76/regidx
root@bt8:~# grep . /sys/kernel/debug/ieee80211/phy0/mt76/rf_regval
0x79768a20
root@bt8:~# echo 0x1f00002c >/sys/kernel/debug/ieee80211/phy0/mt76/regidx
root@bt8:~# grep . /sys/kernel/debug/ieee80211/phy0/mt76/rf_regval
0x79778a10
root@bt8:~# echo 0x2f00002c >/sys/kernel/debug/ieee80211/phy0/mt76/regidx
root@bt8:~# grep . /sys/kernel/debug/ieee80211/phy0/mt76/rf_regval
0x79778a10

Note that band1/band2 (0x79778a10) match the EE4600 signature exactly
(needs adie_idx=1), but band0 (0x79768a20) differs from both Zyxel
devices reported so far (both show 0x79758a02 regardless of which
adie_idx they need). This is a third, distinct band0 signature -
suggests band0 alone may not reliably disambiguate the two cases,
since devices needing different adie_idx values can share it.

Happy to test further register dumps or a proposed fix on this
hardware if useful.
