Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C4D4F474E
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 17:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788455133; cv=none; b=itD8ZQXS6FctpQjE7nPyqX1IrkDRWSuBxb/ZSTl1/3zloSh+J0G9Gy0UH02awEuzFI+J5geyr8/KtnMPZyYsOAtj69CwCosGp54FQadqR49Jk9pIm3geCnfYktV/S3NirKDFnAfwt3Yh4U1/7cDvcMvHW9FepmenvBhSI/hsJ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788455133; c=relaxed/simple;
	bh=L5deRad4G8vbKcEqiYdOtd6Lszv8/JDgiS7HxPOAauI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VcgTYF2kHZxdqZYxgFWaX5ZgFHvmOUwKNWJQcb11AS9xX4/pxViRdj82nX9BAj6KQ8ltq2RP+/ISQQaWzo954WNTxjqfpF1nKNIWpzZn7SMuJMApMwMiaq/WSdrWm9c3z/jr7bpFMF/1nCMSaBl+NE55y4TgQ34K4vHMCvzCSdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Z8zk0RKH; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Z8zk0RKH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=L5deRad4G8vbKcEqiYdOtd6Lszv8/JDgiS7HxPOAauI=;
	t=1788455130; x=1789664730; b=Z8zk0RKHY1HPz5vn2J5hTaJBr2Glqzrvmeqkr/GmVh+hbTO
	cmJGAUhNpSHnJ0vD1VQYQ0d47aWemn6ic9w8dfk9wvPISn3xb7yDK3R0ZHpahwSl2QKRMpXm8JRHh
	nWWY5NHsxaWLeGGNhtivrtAmB7yBCPyRU2fcHD6oMcchjNpPxMSH1qTLEl0kKyav2k3tnUKPPbrwz
	kR7TILuSn07fdC5TYcRG8HjCgbDTOfkplk+KnrkmuXrPktkCufh+YkKBuN2sEaI2BDezTuaLlb3+7
	+nds+k67jkxPM/NQ3TjxFVsPL8vwgmlsStcu9PTz2nEJVDUIX6NQizfUQ4LdHqiw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2AsJ-00000000COA-123r;
	Thu, 03 Sep 2026 19:05:19 +0200
Message-ID: <603ff8bf1e9dca88a70ad95ff4ad1b185bd54583.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: mlme: allow VHT/HE connections for
 20MHz BW STAs
From: Johannes Berg <johannes@sipsolutions.net>
To: Sabeeh Khan <sabeeh-khan@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 Sep 2026 19:05:18 +0200
In-Reply-To: <20260828182501.1540352-1-sabeeh-khan@ti.com>
References: <20260828182501.1540352-1-sabeeh-khan@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-08-28 at 13:25 -0500, Sabeeh Khan wrote:
> The ieee80211_determine_our_sta_mode function assumes that
> if a radio supports VHT and is limited to 20MHz BW,
> then it must be limited to use HT connection.
>=20
> This is incorrect by spec as VHT/HE connections can still
> be allowed.

... Which already says why your patch is incorrect.

I have a real patch for this issue somewhere though, like this:
https://p.sipsolutions.net/a5d970acf354f0ef.txt

We/I should send it soon.

johannes
