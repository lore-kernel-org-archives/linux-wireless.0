Received: from mta1.migadu.com (out-152.mta1.migadu.com [95.215.58.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F2232ED54
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 23:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788045954; cv=none; b=jYqU6ffEWayZk1vIkFDWytMdSCTmQvwIUacwJNtjKer7dwtuK/NflIocpslzp6Lv6HSdGmLQU6GBd88j2zSXPeKiYMBGQzNadqntCPw1RRXbfwMAaN88nElrMFExDj2JWSX8RDEQnc8N7fvU3YwxlFu5upxOlfnJ6H1di0Y6oVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788045954; c=relaxed/simple;
	bh=vYgvfqVKL+gvqjlecyfRg1/rneQasRvsOFWbVIPsXsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ui6/KGEdjbmFR8Gx/BKgYjej6/9pO1BDwevcBKiy9CYRm1QbeVsXIrdnX5w+j8BnwIWiuDDwM8JDtUEc41nX/2d78dwx5db3IE86cWQ/AoiOtDfyedpVBxjo+YiPr5K8G1vHXKJW2R30mvlm/eaAVORA/LSuDB+kzh043axbhNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=w0g6S0C/; arc=none smtp.client-ip=95.215.58.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="w0g6S0C/"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vYgvfqVKL+gvqjlecyfRg1/rneQasRvsOFWbVIPsXsQ=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788045949; v=1; x=1788650749;
 b=w0g6S0C//IYLSKgQI6EWkxvY1SbAV1HYKQe9OceKQgs1UMvopIyiRrdbOqfvZRtN9f0B+0GJ
 wt3aEL6NroRsNJqfJ7wTOTp3lCoBOSaEq4fTiyIktS+UnC6GMvqjiIcjaduX+Wm2pqkG1ncJkJ4
 OCZPvSacF7C29Rfjnsq6f1M/89YVRxxTFKW32V4OA1gI2jKZAwLvmVt9QminE1BnHwibwgOB5i5
 LXGYaHjuslZNxoOE9nlz9BXh3h/RHXxNUcmXNsbgKu+iUuCKCQUIH0ctSMNzbNX6gjqeMzKJWc5
 zxfvPmj28GmVLY8dTNl6BO7SS2pko3/OO4mdflQVmFNwg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 22618b5f24637d71;
	Sat, 29 Aug 2026 23:25:39 +0000
X-Mizu-Trace-ID: 22618b5f24637d71
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Thomas Hilber <anthrop@enxio.de>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com,
	linux-mediatek@lists.infradead.org
Subject: Re: AP drops STA data frames for ~130-170ms after 4-way handshake
Date: Sat, 29 Aug 2026 16:25:32 -0700
Message-ID: <20260829232532.29622-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827074442.826644@enxio.de>
References: <20260827074442.826644@enxio.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 2026-08-27 at 07:44 +0200, Thomas Hilber wrote:
> That suggests the pairwise key becomes usable for RX some time after
> hostapd authorizes the controlled port, rather than atomically with it.

I think that's right, and I don't think SoftMAC is where it splits.
I ran your test on two more access points.

The first had no radio at all, just software. Median 2.8 ms over 91
associations, not one above 100. That is your FullMAC column, produced
by a SoftMAC access point.

The second was real silicon: a newer MediaTek part on its own driver,
but the same family you already reported, so corroboration rather than
a fresh witness.

  35 of 40 associations   5 to 16 ms
   5 of 40                116, 128, 138, 162, 181 ms

Your range, just not every time. About one in eight, where you were
seeing nearly all of them.

What separates the fast case from the slow ones isn't SoftMAC, it's
where decryption happens. In software the key works the instant it is
set. Everywhere else it has to be shipped out to a chip first.

The port opens on schedule. It's the key that is still in transit.

Your Atheros access point will skip hardware encryption if you ask it
to, with the nohwcrypt parameter.

If the gap goes with it, that is your answer for the price of a reload.
The MediaTek one has no such switch.

The reorder buffer is out as well. Anything dropped later, at
decryption or at the port check, has already been through it and moved
the window along, so no hole opens and the timer never starts.

Mine differs from yours in three ways: a MediaTek client instead of
your ESP32, 5 GHz wide instead of 2.4 narrow, and my clock starts at
the client's end of the handshake rather than the access point's.

Thanks for the pair that were the same box, same kernel, same hostapd,
differing only in radio and driver. That is what made this worth
chasing.

Devin
