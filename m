Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651919;
	b=R36G7o83b8f93UuByGQrTJQZm8FZwhMWRAdhUgM3Fvsmvc9wYFm/0DUz7yMn0Sxf7eWI
	 qh76aZERHY9kFWUmji4X8ngp4OQ+m5jwkwM0xkAB8wuH7ofgHzPIvKgOXAfvrxeHp03iJ
	 CxFfIIDomk35x6JF4nYTxs0c3NXVETGrxE8kQdCCjdTNK8EgQw/CJrj1Xb0HIncSrzh9O
	 XV/C7QrlRrDXvbH8pszw6JkTaoyh3cyBZU68SWSqePqYB+EDhSjsyiSwgxig6jbKrMHRo
	 8h05jKudy5KHgaWsNOUMmu5WBrh62GgC53lLHNoFZeov+xtrdAAR+Mbf7mI+oivY3lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651919;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-malware-bazaar;
	bh=tQ6kDdSKe4G8ZsXi4H1gZwYBiTjX81qmCh2znWK/MZk=;
	b=j2YvdGIfn59j3FAel9TXgvAruH/veSYPYVJw4EeSsJrTPdjseERPKBQOp8u+fNTAjZCJ
	 BVepxYgErDGfMEK+fkGTaHWp6jpxju2C/N6NZSH8TOP/I7WfnvxPw4w7Vf7J4Jrx6gKAk
	 HPkwNaVEUEdIDgNnMqtVXF+oi7W5u+zYBu+iQOdoPQCFC8sMrKI8CF/jZhmWbif4vRVFG
	 Ap+0JbIAc2cvjpYzxHgogjKU6oXp5Wj+tWuUJ5UWqQOS3pEOKiODcxdIhmvIaLYHgL61/
	 pTHqAex//1q9xMr3kqkNFUwPVMuutBK5abSIVJO2OIWtIo0KuNbS1Z1/m6vlWbblNIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=n1k7FcRF;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A5C606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=n1k7FcRF
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=tQ6kDdSKe4G8ZsXi4H1gZwYBiTjX81qmCh2znWK/MZk=; t=1793651917; x=1794861517; 
	b=n1k7FcRF2/p6VKnW+W4bKG94XAyiCPP5rzv10S6JtJt8WyhuNyB+6j+KHeIVb2hXQ0DWz9gqP9V
	s+FhwC/V0Kewv+PQQVQkrOKx9AiyhuFscAnqICK1yoS9EmN6TLHrUT5gbnWqpCxnNYk5sCfFznQKo
	OjGzo6BgyPBRHBVA7BeJr4jiUJQA7Hhaf8F5cbVJzY2dN+zBD4q3mRqg2E/ULDAnpRDK0tDQ3qEcU
	yf0XxbQknxojYNBS6tGkyjUbPRS8Dr46uynd4WtdPbYoOo5Tn83OjENtyn3Nke1r7Sk1DebVRvciA
	zKyETy9zVZ9Z91Ha/Xg+iaBA5micodpVdQaw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynb-00000001vzr-0TuU;
	Mon, 02 Nov 2026 21:38:35 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH 00/30] wifi: mac80211: unify frame queueing
Date: Mon,  2 Nov 2026 21:22:50 +0100
Message-ID: <20261102203831.1058362-32-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned

Hi,

So ... this is a bit set of changes, but I don't think it's very
useful to send a non-trivial subset, it won't really explain the
direction at all.

This is my fourth attempt of doing this, it's been on my list
for a long while; some discussions with Toke and interest in it
for SMD transition prompted me to try yet another time, and now
I seem to have something workable.

There's more where this came from, but the rest of the series I
have mostly moves the queue stop handling to TXQs instead of
keeping track of all the various layers of queues, which is a
simplification on top of this.

But going back to why I wanted this set and what I'm actually
doing here:
 - we mix ethernet and 802.11 frames on TXQs,
 - we build A-MSDUs all the wrong way (should be on dequeue,
   not enqueue), and
 - we have too many queues for powersaving clients, rather
   than using the TXQs.

Much of this series is concerned with the last bullet, but
from a feature perspective I really care most about the first,
since it's needed to (sanely) transfer queues from one station
(representing the AP MLD) to another during SMD Transition.

Apart from the queue stop/wake cleanups, I have a large set
of hwsim changes and tests which were useful while working on
this, but I'm not sure I'll post that at all, it basically
lets hwsim emulate all the various other drivers.

johannes

