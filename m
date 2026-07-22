Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E34F386571
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 07:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784704047; cv=none; b=hN9ojhusX+J13OjdbknJhb11qM7y0uE/W7bj+oCxJk0vCu19SsDCUwoXAOhgjUBRuEbmdRYdIr+4cxRyIlHxoe+/h7dM7yWVpODxiqgaxlqHB6ESD/5AZU7Wbma5hhosTUg5Uy+meLmBfuFJwJJIRCjUtMM7N/iU9ZsHfqR3eoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784704047; c=relaxed/simple;
	bh=re/speWcOGwko6/FivO1AH7qay8ysB1ntlnYj2wNFUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaVMFOeuR0/TYRa5yzj928QFfvcpJ8oil/7OVlokGyRtsEHqalVWIkYnuIMn7QWsoFhh6LYc4NZfdmgWcjVlCHetl7DPZoR4M7/5cY/2reGUaVwUdJ3e64Sjf3RSYjfkYBbZSSeybPAA1TxJ7rUbTaYKvVvMrMhqHIzAC9r5H0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nDUFEQfT; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nDUFEQfT"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f7872abb6so1492196f8f.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 00:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784704044; x=1785308844; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6PxNNHc80S4oYsV0n6VwB4u3z9k7dWvx3UfOOSVFbyM=;
        b=nDUFEQfTFkk1n+fMkTDqFpGEX5ARYCkjK5p/+qsUR3seHL64CXTmrE3ofShuUpvafD
         7A+IpO33oIWqDVYsNiXUOBFVwFE/4icw21pvKKU5CyP3gtkhPdIn0ykzZ2BPl/3uZYi9
         ErEZzOgV3MisQ8jqCHSK10+lj3kuN0gIj4e3T5IE/u8zG/h7HE3/83WCY6xYXG0OQlix
         OGgbOhaDtaCzpwWZHJIxMmNhvWQ/vTq2SxErWPTblxw2ddcyjYwkWKLpYLFABdBn7n1m
         rlBIHTA7OaR9uPAAfuhEbyhFHPApO5nV7cF+R75PUH041qWaOU3v9ITodqsbuc3Y7bYO
         SZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784704044; x=1785308844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6PxNNHc80S4oYsV0n6VwB4u3z9k7dWvx3UfOOSVFbyM=;
        b=kdYYB7zvhj4ahEMcd6a+40WQq5BFTP2sOEZl2yZJbANybjCcmhtlXABFXpvU0C+mNF
         lguQxYGz/P8B6oIfBL6bm8oCzuWpn0nbC3+zMRyIzUoa4GCa11jmbneGM++BOO7me2Kv
         VoWY910DBmlk2aoL4smEgnJoh9lwI8d7nTGcb8Rplz5xS2jzMsHsOZJirZngGSmeMStI
         8DqQt7JtOKxe3NmFnanwNeXLPO9uh+nfchgmD0vSimbfj3sD0zMSP6JT+6SEJ9app74+
         rFWvOiorWjR7Jz6HOqMISsr1z9+x0SVV0F4E+Mq+zlCHBaGT8D/nC7FS/gHNkeLSTdv2
         giLA==
X-Gm-Message-State: AOJu0YyvijsYJC7/1GxfkPmyaH7yPSlifkmFSsEpvHq5tSJqKqXKc2D9
	JW8RkU22dL0gJ5Vp0O21sHk6dm35GnLHD0CXPC/dwC/xqggnMrWC411X
X-Gm-Gg: AR+sD100P833E/TlO2VR9a61ENx2kqgO+8FZalJ4nHydXLNYJXtCZPSxaRT/ceFHI9t
	GsxYLroKge8l+NOAaURF8B6MH59wE67OgrcdbGxTjnolyBFVFnz2RXLvWb3L2iKxg9Bu0UMKnOL
	hil9vpZbOyRDprlmLxonFIYVYyiJvguvnqTH45y8whdXS77hDJUd3tHe4LFwyV4vMrk+gRAECRF
	MG2TkiFT5yfal508IIHU7s9JwuMzHv3NzUVPEb9ioDSlyIW4X4pG//0N/hCHFZtu9nd1Y5Z6sx0
	B3NNSC969ZL90trDLOGZ93Ae+p4tJhcBO7PcJZ3RzYobRj7HNNadn25etkaybJSqIYf92aClXwi
	AhCkRtXghjirEN5FcoQzx2/lZDznXvqv5hzWQyDARG4ODBg+oXAtRZf59nGslYVrclmmmDFM+Jb
	8qvhyG7sscQ7rlfG/IL3U8PlpaZDDSwUAx15dx
X-Received: by 2002:adf:e004:0:10b0:47d:fc20:f6f9 with SMTP id ffacd0b85a97d-47f62320eabmr17459538f8f.45.1784704043822;
        Wed, 22 Jul 2026 00:07:23 -0700 (PDT)
Received: from localhost ([102.128.173.0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a64dsm3363403f8f.1.2026.07.22.00.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 00:07:23 -0700 (PDT)
From: Louis Kotze <loukot@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loukot@gmail.com
Subject: Re: [PATCH v2 1/2] wifi: cfg80211: say why the auth/assoc BSS lookup failed
Date: Wed, 22 Jul 2026 09:07:20 +0200
Message-ID: <20260722070720.3610942-1-loukot@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <bbb15b0ae332d7344f5b69da5e993acc6813aca7.camel@sipsolutions.net>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2026-07-22 at 00:10 +0200, Johannes Berg wrote:
> > +	if (!attrs[NL80211_ATTR_MAC] || !attrs[NL80211_ATTR_WIPHY_FREQ]) {
> > +		NL_SET_ERR_MSG(info->extack, "BSSID or frequency missing");
>
> could use the GENL versions and save some characters :)

Done in v3.

> > -			NL_SET_ERR_MSG_ATTR(info->extack, link,
> > -					    "Error fetching BSS for link");
> > +			NL_SET_BAD_ATTR(info->extack, link);
>
> why remove the message, it's possible to have both?

There still is a message here: __cfg80211_get_bss() has already set
the specific one by the time this runs, and NL_SET_ERR_MSG_ATTR()
would overwrite it with the generic text again. Added a comment in
v3 to make that visible.

> > -		req.bss = nl80211_assoc_bss(rdev, ssid, ssid_len, info->attrs,
> > -					    -1, -1);
> > +		req.bss = nl80211_assoc_bss(rdev, info, ssid, ssid_len,
> > +					    info->attrs, -1, -1);
>
> entirely unrelated (whitespace) change?

The call gains the new "info" argument; v3 keeps the original
wrapping so only that shows in the diff.

> That code should probably have a comment that the is_bss() must come
> first...

Added.

> Also however, it could result in having *both* 'unusable' and
> 'expired' set, and then
> [...]
> you prefer the 'unusable' message... not sure that makes sense?

Right. v3 sets a combined message when matching entries were rejected
for different reasons, so neither is preferred or hidden.

> I also don't think the "scan again" instruction makes any sense here -
> this is meant to provide an error message, not instructions how to fix
> it?

Dropped, the messages are purely descriptive now.

Sending v3 shortly.

thanks,
Louis
