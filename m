Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792512958;
	b=MyK0kCmwihITbZehh6xwC2AIy9AMfYBXGWOpkU8CAdwnl3YB7p3RY1iEdm64jOV5Y7SQ
	 lG3XXNR64yWrK9of2MdoxmS68BLVW02wsWVM2mXOTWVIvqEb6RBJ3OFI7ON2I3//JQ/tm
	 hW3BJMB4+VIhLJge7tvJkXkdnK4NQWmsy5P7+Iw0CA+V++ochbB5MdRwS/FX/XLteSmdF
	 5HiGCl6ws0oFXrc2wipYe9AE5XtIet0yDv+AQAs5aMI2pnZW4yOjlRQHU3JxSKJOWj6tt
	 Tv+9ubXzkpeZxkohTTddpeRZIkhibT87tbMDBhr+8P06L9uyCB4B34OiliwJiTvbXow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792512958;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UhDQRNkc9FLSlLZbPo9WwVAAHQKsjx+zb2EBe+RwcLY=;
	b=0XBbUcPlU6kIBNpU3KKuwDfbJBKNZpq5014xD/fQC8UTdb1knv6RRtIIgaVrJzVoSq2s
	 h2oMCHGOusMxsWvqv8dwUOYs83JMoWMcfPZj3pz9zm5mM5qfX6tHqkCLrhCjeEP4paYYI
	 3JeNQJ++ehhBCla2V8ToUHDmV7F258LLA2aphL1iFSkB7XjawY3mQaVWJUQY8WbQ9jTJb
	 SvMpThYu975n9CbGu9xsVjzimVxH/4xPqkGqZERSaBDTdWxBqItYMIgkIIPw4AcrjUthK
	 5KFgTTQYU/V+bv6nwbCpL+ROsPPgvArsTqghCbpjQPr+yrXs3tpJETkWqPJF61/I3sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WalPdExM;
	arc=none smtp.remote-ip=209.85.221.170
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E5D606A33E
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 16:15:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6E5D606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WalPdExM
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5eabf7d5bbeso3060167e0c.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 09:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792512957; x=1793117757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UhDQRNkc9FLSlLZbPo9WwVAAHQKsjx+zb2EBe+RwcLY=;
        b=WalPdExM7lHlWsTDznBX0Fyl06synozvZt4SX10rtsmo96i+4x8Zp8kY38DMvDvoAG
         MWRjRFWn53CppNgFs0ngLw/6OtF3BoAXiUFzYSZPYJOeocKSt0J7fT0g7iAEsz3JpsT+
         2r4FZWHtl8viYqxcPox4gn8zszaNPUXtg0cae1c/0YoLHGZ4oqBiLqTfpX6o6379QUC2
         WP+L4eOyj1WuN60IeQSfZEI6hp8231lcqW2QoGSAH8b6A8xrR9MXledPJRkNSasLjick
         Lv7ltYgNOVEkIbRbhiijTH+RklXVrFsjuv2a1Mb0ImqW2oeKCM3+N7Mmzj4RsUbKdjdT
         LZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792512957; x=1793117757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UhDQRNkc9FLSlLZbPo9WwVAAHQKsjx+zb2EBe+RwcLY=;
        b=GvMHoXq/ompXMdmziSPTDSHEPhE4iN3K+FE/Rfz0AslF9Otu7FNUrJ5P71ElqnHtum
         Po9PhntUt6IQhpJQ07TxS2wRZiXunb+OhA4lTzGD5uHZiYNiKzOqHAqdYGYNUdpqt83w
         2b7CjCOKcBg1Q9Ug6XNPHfpKVKhOqHkMiy6ADy/IFqkfjM+7cXsAFVKrKeshl+rdw5Vv
         BLXwTUgp+RyjsH8iTug+H1cbxO6EyuKBjBbYvnf3bRPhLLMluCYRO6PhnYV797ypl3+7
         AUzYCrXqukBjeBeYbMeY2xtxwkYPTrZxi+5FjPxlznIBu4sLp9ipA+VUKEVJLddp5pKu
         eXlg==
X-Forwarded-Encrypted: i=1; AKwUvBxPN81z2iQ5WD59bJ/OgXtTzZE01GdlSYXIo65wR66JhjMDItrf+iSH5gCt6fUY+MVhoxsWDwrl5JRl6Nqhxw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLiRozzlZovdVh8HvD3B/Rf95mpHD5IeRV7XkpBsuxNYRWZ46Lt
	PwOaMFJnQw0lTq1bf+ghFjczbp7k527NMYVw6lpXBxx96jOY9MIsvxLa
X-Gm-Gg: AYBFou3SDKcc0QkAsPsM6MysRXs9uqsZKlAThrnTnx6319F4cyUzzCugdMC6+ABlPF1
	w6EWeUKv2KOxEv7R/mwDf+6zZlXNA/v828qo0KkGQjtDxK1LoC8zByZrTYcGsnOUiJfMEezA7E4
	/Wx/rxVPjAhc8pFXOhQd3AhE/WiFnZ8qpThl54SJv4cgRNE1SrAkB8JlTb1yKJx+VfZzXyBS2dt
	EUyKif5lOsL37QlrB7I4Wl0AmidI6/bwhxS2e8+OWB5ClPMgqrxMeBsx8/sirnI/8/fY7mXCLQY
	CMqywWTS1Hz1DWMa7fVwo1+qGcNU1GzP3WjVmbxvNs+5gDpLwBHS87ul2u9qw+msu2PW4EoW8KU
	EY6sfgbAM1mvvtrG883nNA09N2kO53tS29vmK8sqQAMZUHPHjYZgMZyUx3aEtyVAiyeGqh10RH/
	2ZsrA5hcVX/SOqNvggaPum6iNe2P/TnTQ9fVOeUg4vq4UTtjT0t8MkoxidtU23gMy4EjEGp6Bvy
	AxVEODEWFbwmOp8vqJQ2kc4L5v8pQ/KyIAeQsbHUmbh7Q==
X-Received: by 2002:a05:6122:4f97:b0:5ea:e197:93d9 with SMTP id 71dfb90a1353d-5eae19796f9mr498417e0c.19.1792512956788;
        Tue, 20 Oct 2026 09:15:56 -0700 (PDT)
Received: from localhost.localdomain ([190.177.181.23])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b518bc8sm12918381e0c.11.2026.10.20.09.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 09:15:56 -0700 (PDT)
From: Cristian Papa <pcristian292@gmail.com>
To: nbd@nbd.name
Cc: lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mt76: mt7603: discard power-save loopbacks after wakeup
Date: Tue, 20 Oct 2026 13:15:45 -0300
Message-ID: <20261020161545.9330-1-pcristian292@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <6e7358fe-4070-4a88-b8da-77e2f9e9bdf8@nbd.name>
References: <6e7358fe-4070-4a88-b8da-77e2f9e9bdf8@nbd.name>
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

On 20.10.26 11:48, Felix Fietkau wrote:
> On 14.10.26 08:22, Cristian Papa wrote:
>> Discard late frames rather than retransmitting their old sequence and
>> packet numbers after newer traffic or a wakeup BAR. This loses the late
>> frame; it does not recover delivery. Use the station's sleep state, not
>> the temporary hardware PS bypass used during U-APSD service periods.
> Why did you decide to drop them instead of pushing them to immediate tx?

Hi Felix, thanks for looking at it.

Because the looped-back frame keeps the TXD it was first queued with.
mt7603_mac_write_txwi() puts the 802.11 sequence number in the TXD with
SN_VALID, and with a hardware key it also takes the PN from key->tx_pn at
that point. mt7603_rx_loopback_skb() only rewrites Q_IDX, so a late frame
pushed to immediate TX would go out with its original SN and PN.

On wakeup, mt7603_sta_ps() sends the psq ahead of the newer traffic, so
the order holds there. A loopback that arrives after that drain is older
than frames that may already have gone out with newer SN/PN. With CCMP the
peer's replay check would drop it, in an aggregation session it can fall
behind the window after the newer frames or the BAR, and on an open link
it would arrive out of order. So I expected immediate TX to mostly spend
airtime on a frame the peer discards.

I haven't measured how late these loopbacks arrive, though. One that
arrives before the newer frames go out would still be delivered in order.
If you'd rather push them to immediate TX, I can send a v2 that does that.

Cristian
