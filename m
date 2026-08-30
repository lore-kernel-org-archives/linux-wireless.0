Received: from mta1.migadu.com (out-88.mta1.migadu.com [95.215.58.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EFF238C2A
	for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 19:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788116445; cv=none; b=KOlv2RnLeyC/cxKsbxTWndwT1Y5Pqb52NGRyMWC5S5jBMAOlvVKIbGJDiOIuVo/TpZqulbF6IA6pBN3Z+zeZIyNh4mU7CNbWbjUdeBxr7GVE1SQdh5+OumpX+p98IE1jytE95+sJGr+xXHts9kurYPryHQogk59bqj5T07WF+pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788116445; c=relaxed/simple;
	bh=qK6iwww5JrQ3vyns8B4jz2tWg+m13M7aEYKC8BhkdtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMdVYgdCaOW1v5n06BsaYC4CYc9A0LjEonP7cFIbIbIM9ze/UNDntrBqMoLjWjtnM33rM8hdYkTe86hJwPn1IZOVyqrQPsdhMpJGa6unrXCODMs4b+kanrGXuppegYH4lgBo5Bej1E1PZtMRMx7iIFEZd1Esf3CFa33Lcm98WSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=nHTJWVH0; arc=none smtp.client-ip=95.215.58.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="nHTJWVH0"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qK6iwww5JrQ3vyns8B4jz2tWg+m13M7aEYKC8BhkdtA=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788116440; v=1; x=1788721240;
 b=nHTJWVH0hRAzsqhDdYkhoCiSheiIifO6kul+l6Xy9S1mdpsb94VU/jRXo72+sq9zZKW4SVs+
 WWDmEgDJ4h7BJGWHqjnO/FsIy9JrXXQNcIV71RIy2W1wmGu4AZrTFLWMru409IuRBG2YpWzeY51
 RbbisfFoodynsS2OVJsJ8ZrYOsGIVnenpHfYwANA4nTfNF1PbU4ES4Le1+PVpSqiTDHAb+64j36
 BGwuACiWM/QT56wkbM4R1hzYSpDSBWt4jzWteran2Yvw/XDgRQ6Yv8+3lBiORcMTS2ekA3vKDZr
 +VW1BhsP/8c4uCW3M8VakmmFe2NUarx2OG75F6v+mwsvA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 430c9ddc9c3fcc46;
	Sun, 30 Aug 2026 19:00:30 +0000
X-Mizu-Trace-ID: 430c9ddc9c3fcc46
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Thomas Hilber <anthrop@enxio.de>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com,
	linux-mediatek@lists.infradead.org
Subject: Re: AP drops STA data frames for ~130-170ms after 4-way handshake
Date: Sun, 30 Aug 2026 12:00:28 -0700
Message-ID: <20260830190028.20209-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260830104236.521389@enxio.de>
References: <20260827074442.826644@enxio.de> <20260829232532.29622-1-lucid_duck@justthetip.ca> <20260830104236.521389@enxio.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 2026-08-30 at 12:42 +0200, Thomas Hilber wrote:
> It goes with it, and it takes the whole effect with it.

Thanks for running that. Six of 216 against 292 of 302 does not need
arguing.

I have it on an MT7922 built to your AP2 spec: 27 of 95 associations hold
134 to 189 ms after the handshake, which is your 130 to 170.

They are held, not dropped. On a slow cycle my station's attempts go out
every 5 ms for 150 ms and none of them reaches the access point's
interface, until fourteen arrive within sixteen microseconds of each other
and every one is answered. Across the capture the station retransmitted
three of 110, so they were arriving all along.

A monitor radio says why. Over twenty-five associations, every request to
open a block acknowledgement session declared a starting sequence number
of zero, and zero never arrived under any of them: the first frame after
the request was one, two, three or seven. In fourteen of them the station
had already sent zero before it asked for the session.

So the reorder window opens on a sequence the station will not send. The
first slot can never be filled, everything queues behind it, and the
release timer is what eventually lets go.

Worth a look in your own captures: the starting sequence number in the
request against the sequence number of the first frame after it.

Devin
