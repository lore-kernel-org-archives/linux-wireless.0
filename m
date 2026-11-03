Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793678690;
	b=tb4zzOywrKchWNs9WPclJhM79Th24vB17Vu7CYcmS596lxfx0ixEMPgkirep6D7knuMA
	 qPhAGza29cW8HLjPFZMy6XlrQMBO7THHZkyFMEyoKBDLb0gOeMHfz4+jHabLmnAjDuTCs
	 MQJHogrZEEUYgxdVTT/hTw8WHXgTsKtiN5VLbESB19auUephbrpFbz8ulwRJ9FVveir8v
	 O/GiyBkI1ocBW7s24AvD7PhxhTdBjj9cwzwcU1Nm6uO+WPDPMO+YK1wsfvWEiDL6kJJWE
	 6qoj5otSqhQZAq1wyQFE3NLuoIWGE/56928ikTPbt6xO6fmwdPBBtOBE+QAshq4qV1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793678690;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cl7XuderxVyatIgZNuprudUTpms6qFioS0bOx3h11W0=;
	b=BibToudtp4GtyX3iucyBNAbskBHkVULFlju8k8bJOGhZrCRE6+DvQviuZEdwzw+hGPLg
	 WJsooC7zwqKk/WDGgatj05WEX+gs4a4fCWDw+SMebRP6DzlsEPY8R3Is+81v9musMs+K2
	 AmLhLuFDnX5cbFWatULLbjkyxrVDOdfvnR/lYkVMn7QNT4FFilprDh+JWIzQ9d0erj7Oc
	 Ft7L8/xIX5RmWcKtZdTAZWKWLdgDicd1jAT+f93I8dwBfznMW8aVtvR3Q9JZcooUuikAf
	 I85x9sxY2gr2dGNgFHnjC0rXcxrR5VYMgY3wMatv7b2IXgQnX9G32N/o7wNgrieumMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R2gIKhW6;
	arc=none smtp.remote-ip=209.85.216.49
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52987606A326
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 04:04:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52987606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R2gIKhW6
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3ad2b3b1c02so1984894a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 20:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793678690; x=1794283490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cl7XuderxVyatIgZNuprudUTpms6qFioS0bOx3h11W0=;
        b=R2gIKhW6pfblgk9jrw7yZXDmd173ksyQUrOkB27n2rVrm/JMdpjAHeAyYy7ZysBU8Q
         RDHdJtBApkO5eWkEzBM9VobNhpvR54hAh5FFZUKircnF/TsrZdQFSVoWzbrm0fYfpqoS
         xo3RXktiKbnnlmt6fvxqvtuagTkSTraI6bAUWzAGvuw8AZuZF85QJf0ui1rD4IuJ+Wgn
         kDNq4dH4sDy294dxIHFDJCh10fsB/xN2rZZZm3Ee46zD2QvtT4ZNVILPYbP7Tr3bENdn
         tT0xH//OOGvc/+gFaHt237BtGpW0jUZmmBY28WmKzmx0yuEpfQlEgbp/Sdw4A76RBVgS
         ZkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793678690; x=1794283490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cl7XuderxVyatIgZNuprudUTpms6qFioS0bOx3h11W0=;
        b=uE4xB2/kgEDSmZJYgHx12xGebGWHdYmo0p3APzHpTo5HNMuUeX4yq5sqeEQB6e6WgX
         ALx6Ax3hmxK1JsSNSqAXCXSBJTUn+eR9K0qSUk6br6UzmTRx4UN2cCJTFDqf2I9s1faI
         N0sCaZdKr8dKe/kpSOPvD7JA5w8vUqS8TO2GITkeFDk8cX9X0enbKGeziLzd2D8U/K2V
         y2NrEMe9JzIIkp7pp+bNUr4DSAwCIy707PwUgpVkc+dnMA86XS4NeBk2zVpZrJYpQVi1
         93Z4BDw1c5K4URz7epeFdQSvcLoOPK0EpIZSheTUYq4wom9iOLcmGl3cLfjuv61Zqhub
         lh/Q==
X-Forwarded-Encrypted: i=1; AKwUvBylCPkc88eSlyyeY81QiB5UwpzPqsc2bdSjppTer280N3YVydiK7MVXR7Q/zhuG/3SQqD6q0K6RuQPT4fDqAw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9/dQX8TSfYUUGZgu9q+KxdPe9kf2qGzgFYlPOTql4jvNpCEurA
	IBdn22Y0NZf19n0cJkOS5wPXdwy3hZ0rXr3cD48WW/qE2777GS8c80Q=
X-Gm-Gg: AYBFou3Bjmni2q7NOOW3mO52+KqramiVT+u2Njy+CCwWr194glBx7NDP0O3H5BiSih1
	c1W+alA/Iz3509H8HoOLEd3uu/EFBs4w/GsxAzjRM/lJoBNjxGp3qT6GdKuuBQjUYLpYBbnPZVY
	z7IznYB0rAxBo2ozVRklkIBnUOaYZK/NVyMxxK9kHLWbjNg0CTCxRkMWhMUDbQ+FGmLjkzPtA3e
	s83boSbEREJNMMs69y+vX7+9f2jLDG8UAMteKT20P0KlStdn3gbpG7hjUp/jILQ3iqCyz4B11HW
	X7AscPW8/g1BY5c03jNLzN5vc8IR/bsbuxz/z3IlZ4xvrYgGjXvOXqQO8ZhFNImI3LJ0S18Z/zY
	XnMDjNcwrgl5bCjJgcUA5rGGf5jUM1NHajjPcve5v6j/mOKOGW+XqXQUgjs9sPcTiCssZ9nfGQa
	TqSuVSTTHhJbaii/+chPle07uLUBWv4n3HFhNJizCbrZoe90IrmcBEHcPC/l2u3YjcdS/k4JGUE
	1PwKSVukJCxeuHh3cO9jg0Pg6EaOnATwYR0wDUxL/MLNYsYBFT5fkuVClBF1Aws9kOFtsRDMqI+
	qRmaYVw9zhau4u8DkJgwRMyYwBDfzVLrDkNLJVNzb5qbsQC0l2tYZ25h6k31gq5OVHxj
X-Received: by 2002:a17:90b:2e4f:b0:3ac:9a5e:9ce9 with SMTP id 98e67ed59e1d1-3ae897f3440mr10056187a91.29.1793678689562;
        Mon, 02 Nov 2026 20:04:49 -0800 (PST)
Received: from freddie-kane.lan ([71.212.222.246])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c896cc6sm1887277a91.9.2026.11.02.20.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 20:04:48 -0800 (PST)
From: Burke Cates <burke.cates@gmail.com>
To: baochen.qiang@oss.qualcomm.com
Cc: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	jjohnson@kernel.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH ath-next] wifi: ath12k: fix MLO 4-way handshake timeout on QCC2072
Date: Mon,  2 Nov 2026 20:04:34 -0800
Message-ID: <20261103040434.3387789-1-burke.cates@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <492ece60-a670-48f4-a808-f09394b3db95@oss.qualcomm.com>
References: <20260815014329.3748059-1-miaoqing.pan@oss.qualcomm.com> <20261030041902.2740757-1-burke.cates@gmail.com> <492ece60-a670-48f4-a808-f09394b3db95@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Nov 02, 2026 at 04:02:56PM +0800, Baochen Qiang wrote:
> Hi Burke, can you please try if below series can fix your issue as well?
>
> https://lore.kernel.org/all/20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com/

Yes, it fixes it here too. I took Miaoqing's patch out and applied
v4 1-11 instead, on v7.4-rc1 plus three ath12k commits from ath.git
(c752394249f8 and 02121aa4a012 from ath-next, 1e678e37ff13 from
ath-current) and out-of-tree Glymur platform/board patches; the tree
also carries Miaoqing's dp_peer reconnect fix (8b6b871332b5). All 11
applied as posted.

On the tri-band MLO SSID that failed with reason 15 (SAE, PMF
required, 2.4+5+6 GHz):

- 12 of 12 connect/disconnect cycles completed the 4-way handshake and
  came up as MLO with three links (2.4 and 6 GHz active), ping OK each
  time; no reason 15 in 23 handshakes over the session
- 5 of 5 rejoins after s2idle resume
- non-MLO WPA2 on 5 GHz still fine

This firmware sends the PEER_EXTENDED event (two per association), so
the host allocation path in 8/11 was not exercised. I'll send a
Tested-by on the cover letter.

Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00277-QCACOLSWPL_V1_TO_SILICONZ-1

AI coding assistants helped run these tests and draft this reply; the
results are from the hardware runs.

Thanks,
Burke
