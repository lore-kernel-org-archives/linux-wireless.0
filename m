Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3609A4F55BF
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569663; cv=none; b=RYkhEi9Rd9pwucmo2woO+bp0V0T7EWIjifVjOe9mt9c4FOKCD3V9fmtAEBusr5VgUjL+OOwtbuBvYCYOyH9rSS+tpONq7n1yj4IzyiBd66bNep/OF1fmVQ2RsWuho2oCAzj3NaKSbqHkhom4ntiV1zU5nEyiwqphSoUtLOqeFVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569663; c=relaxed/simple;
	bh=bX5jYnbHn9HCXYiDxwH+6E6+8nLym5Kmx/M9Yf/jV5s=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tXl1NLzOqfkiR7FzGmBGgzOpA544FB53bc20zDdfbgG9C8p4PxlyC+tn5d+n73SANEygJzVlYIDLcAmPgYE9CY9xA/w+OcgoLTX9gt2MeQduka4cZm3Lwf8gX+QeroIJ/SObLhTiUrdC4ZBIXm0wLqJ0vnpbep3kE1tZrvq1iTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=buHo3Bbm; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="buHo3Bbm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=N6kim/Q5OmEN0aMHhaWjB/0+slYhvcvkPjROhBcj7WI=; t=1791569662; x=1792779262; 
	b=buHo3BbmW49eqNaImsD3SJ00kL70Sc5XlMnkSPT8kmUN6w71qd8AiAAR1E5bvRfREztT+nVk/Dw
	PrOr67Idx/GRNcHYvecCfaxEZMvWWSYexyX+WrCsYCzkmIXuZY7i75lR3qTIkXmkT6FEwhrW5rPZ8
	fBnPJdBi8E0IUPjnTY58cX1G+BNDpWU7ZB4MZl04i/IcqZ6CnMp7ZA66W/gyByQiczuBXr4jJ4NB+
	j206dLYx0dAHqlROlDZ1Uktb+dwxQx6Bry+Tqw6RfCRsKLQcra3j9n5Dj422QUpAAKn4YnEeQrSlI
	jP5IH2R0Tqc/xMSNmmF9BzyI8Uc3MjHObysQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF6p-0000000AtGH-2dkb
	for linux-wireless@vger.kernel.org;
	Fri, 09 Oct 2026 20:14:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 00/17] wifi: unlocked updates/requests
Date: Fri,  9 Oct 2026 20:09:59 +0200
Message-ID: <20261009181416.335754-19-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As I mentioned in v1, the wiphy mutex can occasionally be
held for quite a while, and we may acquire it in cases
that don't _really_ need it. This makes a couple of the
important AP-side (and NAN) things not require it:

 - beacon updates (needs driver implementation/opt-in though)
 - management frame TX
 - control port TX
 - peer probe (which is really just a form of TX)
 - obtaining station statistics (get/dump)
   (also needs driver implementation if it provides any
   statistics today)

Most of the additional complexity is in mac80211, especially
for the beacon updates (since it must check nothing else is
in progress or going to change during unlocked updates, other
than the various frame templates), but that doesn't seem like
too much of an issue. Drivers opting in get even more value
out of it.

v1:
https://lore.kernel.org/linux-wireless/20261004214504.1636783-14-johannes@sipsolutions.net/

v2:
 - split the mac80211 beacon update patch
 - rebase on top of MBSSID changes and defer unlocked
   updates while locked ones are in progress to avoid
   memory safety issues

johannes

