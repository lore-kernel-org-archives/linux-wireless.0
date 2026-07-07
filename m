Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557F142086F
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2026 03:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783394285; cv=none; b=ROUazOPQip9ZFZelrhzfLG+IpL2BVywKd0zGKO/KryfUdqCUKpD/v6UYGa/W2Eb0kwRiXFDyOejT9hgaDgokVbIfKQu3HuF/vlbwf9MvlpoSkmra1owdIjCl7HQLnvJlFvpAQA6bac7hxgHWGNpW4hbhTedNXmhsaoTdDUgaSz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783394285; c=relaxed/simple;
	bh=gav4LTF3cvprPYjndHmHcB3itWgpZXJAtVegwVDBP7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOpMnEFXiCd8ZnSwne4pZTVW8TbulFsYpcv7QlSQ5z9XtjWN9ypmmQZMw+iNrHWejhhULGAK5kQx5E3CS9x8IkdkC9YErlGskNWuXwETaNJinbWCR7cMXLM+7YSc1si2rAO5KZraxGvbK+XUSy67fyjTPLf+g6ceKv8klPpZjJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fQjY1xDK; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fQjY1xDK"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cc8e87f29bso14245745ad.2
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2026 20:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783394284; x=1783999084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BPOGuMjYAA69qMOEoOxiyWwUYw5tnfC/y0StLB5yxdU=;
        b=fQjY1xDK0xsZ9D+IPuMPviRWEtKZzsoNflwLJY57LgsOyzxrHVpHBn5t7IDNgIO3Xe
         BO7rf6Jyt6Gy9UCuw+2b2VpTu8fkO3cq1W1R1IMpKpFS4XH+DZeNJnYdjUb6e2sYeMdD
         8KB2xEBtnDAy6SVwWo5LJhILLIvMitx8yGTU1HWID8a5fqRE2ZOFZwfPzw7IJDaLh3oF
         9zxyc2vwZUBPG4ikbdxXzyjqH8zOwefcP30eFImovNP40llUmldwjOjEfa5n5AGFXN/T
         7ys9L6X6mt7uCu5wv3cvlzgrRCvy4qv7R/To55NonNcO+zH2qigZbKQH2I7mS/r0AnJI
         vB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783394284; x=1783999084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BPOGuMjYAA69qMOEoOxiyWwUYw5tnfC/y0StLB5yxdU=;
        b=XueQsf4ewVArHkZmmsppY6rBIb/b1k4FROHVZhkoNFH25OZYq5mP63O5JbxRSRbrNi
         rb2DMuouNfeHorFmXAgvvvOc9IBHbLGmKeVtaah1S9t809T1ZYNGrSJW3rGhX9XOad5/
         rXVLbZXhqO1NWOmtww8bkItFeOBfrE7wdU9B6kmUO8+Qk+LVFLL6RyiWHjK+UuHSX5s5
         gH0WIKjfUfXx1cckxxOWStbYf9wz3YUwlXmPCASXfWU/NX9uwRwEIIN1fuCwXTNjuGDG
         KQ5NmKRp1w/M+iERH9gEnY29f0wd/SD+OL7+FCIR2ogh2OncLYCENnC19HChJRVd+UuW
         PO7w==
X-Gm-Message-State: AOJu0YzRuHpPpvUUJ7av72nGvEh7s7+NQZqklcyPgGQxtwLzTAilvxUK
	XkkhWbmOzSI4oBwWkrklUZVsOcJ7eXtKIxBhAL4IkigVw39tUuRPyOqPSCl4PpK/eIs=
X-Gm-Gg: AfdE7cmE6JalVcqLY36aBnTJgsaal0GZJznt4XHoaW2C9tPaTPgPFmvoeI7843CBpPy
	1ihTBQJFiSPwNtxnycI9nt6bKo1M8S5suEVHdvycLhaHpXZF3aQugOryk97uWZ7zijJ+PYmySAV
	uk5tJoSxo/qnqriEU+KVJsKxE0kOiyEjWJqWnU3skWxxLBn/l0jTNCk+L+XHb0gJuXHQetS9crl
	TiCg2xT93PyUvttpaH1ewp5zimXTxP/aVa9b+/QpDf7Z46UeNDoauKCC/oKbSQcGQ+VXBezZ1B/
	6a4LnR9V/sNlN+OoD5+kE8CJ8Z0Mklvm56PRYCo3gwguLzXRSTyPb+X0yn5nFdrIZzTzimQvd2j
	bqWltWnsCVWOJExjbeEN3x7EiJ+jA+yqks0YISwIR2e8G4aSZmJx020fAfQ//uoy6DQzpFkXh46
	lQubXQzJSjarIidn2vSp2/ajiUiEdakl07OfxaoG7OcyiKhoaPn2kn
X-Received: by 2002:a17:902:e74c:b0:2ca:6c8:abd8 with SMTP id d9443c01a7336-2ccbe625b96mr32367015ad.12.1783394283673;
        Mon, 06 Jul 2026 20:18:03 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.229])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9c100adsm3648255ad.32.2026.07.06.20.18.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jul 2026 20:18:03 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] wifi: cfg80211: validate assoc response length before status and IE access
Date: Tue,  7 Jul 2026 11:17:52 +0800
Message-ID: <20260707031752.31318-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <c967e7897f421fde56ca4367c9e10d0c6d9f7ec4.camel@sipsolutions.net>
References: <20260612185042.66260-5-enderaoelyther@gmail.com> <c967e7897f421fde56ca4367c9e10d0c6d9f7ec4.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2026-07-06 at 12:39 +0200, Johannes Berg wrote:
> What makes you claim "unsafe"?

"Unsafe" as in accessed before data->len is validated against the
fixed-field layout, not as in known-exploitable on valid traffic. In
the original struct initialiser, unconditionally:

 - .status = le16_to_cpu(mgmt->u.assoc_resp.status_code) reads two bytes
   at offset 26, needing data->len >= 28;
 - .resp_ie = mgmt->u.assoc_resp.variable points at offset 30 (non-S1G);
 - .resp_ie_len = data->len - 30 is a size_t, so it underflows to near
   SIZE_MAX when data->len < 30.

resp_ie/resp_ie_len are not a harmless local intermediate: they are
consumed by __cfg80211_connect_result() and nl80211_send_connect_result(),
including the kzalloc() sizing and the memcpy()/nla_put() of resp_ie_len
bytes. So the underflow can feed a later copy/nla_put length rather than
remaining a harmless local value.

The mac80211 caller is fine: ieee80211_rx_mgmt_assoc_resp() gates on
len < 24 + 6 (== offsetof(..., u.assoc_resp.variable)) first. The
mwifiex handoff to cfg80211_rx_assoc_resp() only checks that assoc_rsp_size
is non-zero.

For S1G the IE offset is 28, not 30; the old code filled the regular
assoc-response fields first and only patched resp_ie later once it saw
S1G. v2 makes both layouts explicit and validates data->len before
assigning the fields.

If "unsafe" is too loaded here, I can reword it to "unvalidated" or
"unchecked" in a v3.

Thanks,
Zhao Li
