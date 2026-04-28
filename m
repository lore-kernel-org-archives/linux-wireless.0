Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E56B34F25C
	for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2026 07:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777361963; cv=none; b=HEFIxIIN1Yv4aZo2J6KFU54RPXO81sh2S8GnjnFbwd68xNY8IPzXErqWTpbwG5vzW6+qGfGcCfFWclbifgEYJSbywrJbMklzpmU+T9w8qmXryXwAuTDA6YoOezyHbXPRkkupKIKfhtMJQ/eoQWfzKgYKRrO4gJjlV+ZEIIogCFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777361963; c=relaxed/simple;
	bh=hXoqHavhsG3YgNa8bcjxY9BlA1QOkabkYUW0JrGMdtw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tTpl8X6PpDlGBbWPF5jW6lwjOy0HOJGsOVq5lZtRZoOAO93na4VRA1qrn7tU5WdW9yAPClgf0v2EDYrpv+e3K1lhJGQNDOksDV5wF9jQXebaLJxxtWuDRHiJ2rmgbjIzep3Ju9eei2fNhMro6BQHUdjXXldfNHDARYwUZJvq6hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=mPKAHYJE; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="mPKAHYJE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=2chTtP3Db3OHq+TfnS96Z+7gVdZWDA2jVHoNNCVRLso=;
	t=1777361961; x=1778571561; b=mPKAHYJE/ub/1ETcR9GPUzmZbYsusY/5H2MSsWoR9vF5gUv
	2XWnyCIqxMGi7rqtxPUK9gwxwGBrBoXSDBdwfnpU/VO6FdbT71GuCVJeAFdwhG5rYmQC9Bywjq9k4
	INMs9kRsoCJQNnUct+JppjwbEPgjnw284I2lKinz3S/U2sQqe4xyfDYC4cT3tX76kBmJ6m/NHvvsL
	tZwSANDfqAyPQog+SOQl5tsd1cf2l/e19rGFmQa3dVCUo2ddqMqwq3YmOUcDM1a31Wjrf/F9G0hcQ
	ZUPNu/VqFkpSAe3syLjyoVz7EVB7QKry8ld+zTjSr5Ea6snn2oQ8W8MSk1nX5xig==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wHd2M-0000000H53q-1GlW;
	Tue, 28 Apr 2026 09:39:18 +0200
Message-ID: <0fb5e4ef6fca8b099fa0614085dd8b3acb911510.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 1/2] wifi: cfg80211: indicate
 (Re)Association frame encryption to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 Apr 2026 09:39:17 +0200
In-Reply-To: <20260427150735.2391680-2-kavita.kavita@oss.qualcomm.com>
References: <20260427150735.2391680-1-kavita.kavita@oss.qualcomm.com>
	 <20260427150735.2391680-2-kavita.kavita@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-04-27 at 20:37 +0530, Kavita Kavita wrote:
>=20
> Mark NL80211_ATTR_ASSOC_ENCRYPTED with NLA_REJECT in the nl80211
> policy to reject any attempt by userspace to send this attribute.

This is not necessary, it's the default given

        [0] =3D { .strict_start_type =3D NL80211_ATTR_HE_OBSS_PD },

johannes
