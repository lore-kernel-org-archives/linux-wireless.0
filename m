Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B201DFFB
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 14:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785766395; cv=none; b=PnnuVW1CtnWDgRNHEMA7T93kD5Dq1qJEltYNKwZtZCvBkGfSEF1dpyc65VJvfAkMQ8+DBbp1EduqqzkxWRvYTTwfj/s121DqQm9oIhUymXfe6uKpif48c0g3TA405+tHtdrrVXJz5NI99dfhzUy/JF+O2NsOnPCZaFVwI8Kw1YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785766395; c=relaxed/simple;
	bh=wxO8jr1VAv1g6sifXox4qGfHRFjuEbeA9JIm3Lv8ZkY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=AzutnVpsEQHh2EfcBerXTf5hGc7gR+UdWnp5FRVN9YDSYvgYBMqUqKuhvJqUQgkP2ohy5Bj6mwM4MCCUU6QAxmCxeqVK/yZI5mvNgPS9QEJJ3PAuOXIM2Za6LK8tNxsgOAzPhqnFHO7X4yfEPMriYoSqVFlJDBozz5OZCBDpctk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=AkEA1dUc; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="AkEA1dUc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=wxO8jr1VAv1g6sifXox4qGfHRFjuEbeA9JIm3Lv8ZkY=; t=1785766394; x=1786975994; 
	b=AkEA1dUcAZ81zw8VgAxCaR5bhg+r/CG71uh+Qr6brnB8en6gtMvenuf1rOltx7gEYoZkL5w38hh
	v6n26HasbPdfaSKC2hElf+z6HHqiaGnAAHyWxMGHnZU2d9+es2xgT93d4mjRRwh9OUBENZzc0+eD4
	PVXYolMg+/iRME29I2T1go4/w1mTaybsgUUbnSpxEXA8UQE/3I4xVf5czoIodNZG23AmMUHmAg3+7
	+tAlnj4lmrf7mzPR0fmUs52k5f4WKAU7xX8wD1BJtcmsi/6gU1AUSmhDnXtRhz6cI2fWbkT2Bom+g
	hCyTKBZEtE6s3krTZjUvBaUhiaMm6AKBQIGw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqtPj-0000000G4Ws-1LkR
	for linux-wireless@vger.kernel.org;
	Mon, 03 Aug 2026 16:13:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/7] wifi: mac80211: minor TX cleanups
Date: Mon,  3 Aug 2026 16:08:36 +0200
Message-ID: <20260803141309.292711-9-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here are some cleanups around the TX control path / status / build_hdr
area. This is way less than I've been trying to do, but these all seem
obvious and actually overall reduce the amount of code.

The first one really is a bugfix, in a way, but for a bug that didn't
really matter much (really the only side effect was setting control
port flag for preauth frames).

johannes

