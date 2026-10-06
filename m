Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8200A370ADF
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 11:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791287312; cv=none; b=WRyh4BtZJkm94udztvx+ECehY/9lTsYGu/ZNRsAeifASRKINavU8UOux3fhL0RNIdzA5ChZH7jgjU7TxKR7VEF1+8wVcWj1Y8mXGRS+jXnz4eeOt39+pxDQhs4baXV8bDRzvL+4mmgcmbpOw1AK2DhZnOQtbCh3VsVtVgbC0v20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791287312; c=relaxed/simple;
	bh=cr9hHYMB2tYTAMI1fcibd/WSAHGzMrbP0ig4jEuoGm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgAWUgm4eAMBXTqn7Oc/CEF1yVBAG7TCGDPGUTjA2trwcxJaiFrH1U3Q5HQVR8XQhYTGMEoGA+v8Jo2iccLpu9FHrhY5SwPE1xEhMUzjw/4tGRGMOW+IhPICyXgUWsogm0yEJjJpGiB5UgQighWAovsRn2WfURZt6og+x0I05kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=singe.za.net; spf=pass smtp.mailfrom=white.za.net; dkim=pass (1024-bit key) header.d=singe.za.net header.i=@singe.za.net header.b=niiakKds; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=singe.za.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=white.za.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=singe.za.net header.i=@singe.za.net header.b="niiakKds"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a018dc1f98so6020925e9.3
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 04:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=singe.za.net; s=google; t=1791287308; x=1791892108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cr9hHYMB2tYTAMI1fcibd/WSAHGzMrbP0ig4jEuoGm4=;
        b=niiakKds946+mbzjxmWnswuNtrOqy4VdRPtUOWB51sxmVhE4riYd8Kw5Vkf+ymUAuJ
         inUiiY44VskJmx11abRd3BxEeUj4nuSYeuRemhkBV28vENkS4sJjCAtbjs/V8NE/iidr
         J4dtj/JzeaukzrMSzDys12z6YkCCOQxasQCoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791287308; x=1791892108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cr9hHYMB2tYTAMI1fcibd/WSAHGzMrbP0ig4jEuoGm4=;
        b=kLKdVp6s7yN7IJhQpGD6BUbhn7OEqyOoWEMb6yeVRJzm9N3gOqeUg0M/Ism+mHus7L
         0XvTqCnmaiOngegbmp5Q4jhNcGZu6mzcXRgezXWyuY9M/6yy+yhbiE30uam1fkaBKbDP
         M7375C6hykiVmz53DWiBThHJPDZuq4yLrlyZLGpqo4vXE5otJHIgHyhW4tl0mWS+44tn
         dMT1VaPC0l1nY7c8mk4XHMjhH57urL0dOiqTDSVj9H4sRhCUXvZg1tegsrWmtq1Tav/a
         iBWlSSRfZy+GwiPZFlxkQfbr19J8FtS1PnlYrYiaSx94/zD3gC9pQOvrRygiYUsTf5nW
         2qCw==
X-Gm-Message-State: AFuF++kIWHurBPWNR3Kpk0T+WDUxUmLjAi79H2D7ln5WKBtOCOjCADol
	ve23uH5Z5pJPaMKQRs3pj4FZX0EGQG78JFWCUVA4nO/uJUm6T8xowJZPdZHdehOBBZg=
X-Gm-Gg: AYBFou3aipxh4IscufGUmzBf9rG4qkkku7nQTBP+VOM37KjT+xeMw4a3rmgDpcfur0k
	omCRLNvKNan9hDZciXc1cw0QZuz9qoUp/WNOjHoCuJchES3mciHZUc9N1zKj26nwlR2nVJSyWDU
	JhcPwllwzdSn/FR82twwWiGrgqgg8TUGtx9jni0x0NvEOLVkJa6JM1kxDoRadVLuV7dKlwotpCy
	PpsevYijhegpewtbaWe3Fneq5cM0/WU9Q7PZIW3xDqYxRMrfugI0NJ7oOXydgBfe69NoPDPv21D
	UmJyyFhVlA4LGALESFPJ7m1weldQdnuXfTpMjjtpK8T+QFN5Fb+pljXqCyfiSr2dcJjwBJ+sOWm
	RYWi8YajnDUb9gVFMKcag2jvb51WP3mXtu9Xm9IiewH5Z6RMSbyIxMfYG5d4DcCjcAjw453JZcn
	oUYdI0XIZN2DpJEYWQn4nAXEJkQ7YNKEOJPxwVpDz9TT/ItaMpB2sG847tou7teanyoQ5ead8A5
	SKC3FlTb6U0kHsPNnC9hSDg85o=
X-Received: by 2002:a05:600d:82c1:b0:4a0:1a7f:2abf with SMTP id 5b1f17b1804b1-4a17b536decmr21973265e9.7.1791287306355;
        Tue, 06 Oct 2026 04:48:26 -0700 (PDT)
Received: from localhost.localdomain ([102.33.233.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a178ca806fsm65783405e9.3.2026.10.06.04.48.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 06 Oct 2026 04:48:25 -0700 (PDT)
From: github@singe.za.net
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	github@singe.za.net
Subject: Re: [PATCH] wifi: cfg80211: allow zero HE OBSS PD offsets
Date: Tue,  6 Oct 2026 13:47:03 +0200
Message-ID: <20261006114703.29021-1-github@singe.za.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <a5f74bb1113b5841a4a5359ba615cc114f41a1cd.camel@sipsolutions.net>
References: <a5f74bb1113b5841a4a5359ba615cc114f41a1cd.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Johannes,

Thanks. I followed up with a hostapd workaround, which Jouni has now applied:

https://git.w1.fi/cgit/hostap/commit/?id=5b156e272a0266ca6be0f394192bad42b0ff176c

Regards,
Dominic
