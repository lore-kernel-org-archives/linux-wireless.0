Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5290345D93E
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 09:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981463; cv=none; b=IyRyBSsGP4DqxWwJTPSdOgL0BoEE8QbqgdKP4HuNBlg/8QhNJXO0XSIvVrumHT+4V7UNNh2O+RZU0r+ZRTAMAKrBlVVCwudNpUXHRSRjhPXPL6LG0D0DZfFhHI2gB+3/cddFXduBX6SJjiuqzY2SOdhdcz/Bfs2lxkedeTurR2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981463; c=relaxed/simple;
	bh=oY3stP5KLzqGYT97d+/+0s4ed6J5f+UGTrv35laFW8A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W0foY/hqB0rj9WSRkNbbV3oAYSTHNYTRv8tP6Eo3OV3bK0KZAw9wsQoTB/8LkT/KulvFJMGw4Fg2SJQjD0kTzY1OrI3POW/dGTjbMniYcvqtPmJ9HArKhZkYy/pzQhUJi6jMcjTa0NuK7CiKUITJbdjBoS3sw2KmK5s0pIYd8Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=c/DLuu31; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="c/DLuu31"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=oY3stP5KLzqGYT97d+/+0s4ed6J5f+UGTrv35laFW8A=;
	t=1789981451; x=1791191051; b=c/DLuu31DjV0BLV6/V4xrL1OWHdGS1b9lR1uF/n2delm/XR
	SyLK+Gr1ZsDku0dpdkoJXNT32I/0qwHq+b1Z7D3vhCIA5lgEBcx53iPanEi6VOcWpebDZhEm+2yzZ
	R79dttjkjf9EpMSKzCnhYnQRfQhuwpfxme+tJ1OeBXRyQo2GkilZ5MTu5YK6Iti2R5kXmiefKY9QQ
	v2/0YBwyLPlAlPjhC3aoua2wtLl2FwSIHBI6LppYsEavyEHly8JaywSALqyGoCpIt95EfZKI6J5ai
	PC1v+KVBco5yiWV60biYxjN1g52fUmQAyqVAQTSIGj486m3be6iD5LhH2eKgjSHA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8ZwQ-00000005hZa-3g4G;
	Mon, 21 Sep 2026 11:04:03 +0200
Message-ID: <2318ac388c0da7a200c8a1aec0d0af662fdf1ba8.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] net: cfg80211: Validate monitor channel
 set against radio usage
From: Johannes Berg <johannes@sipsolutions.net>
To: Rory Little <roryl@candelatech.com>
Cc: linux-wireless@vger.kernel.org, Dylan Eskew <dylan.eskew@candelatech.com>
Date: Mon, 21 Sep 2026 11:04:01 +0200
In-Reply-To: <20260918170746.3824-1-roryl@candelatech.com>
References: <20260918170746.3824-1-roryl@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

You didn't really have to send it twice :)

Please fix the subject and the syzbot reported issue.

johannes
