Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793355539;
	b=a0gRtcODF3W0Yfiiiqi8wIwKTaY+FK9hqszNxoeUZSvFqSEqLh81t4ztDeaK6WlWVZ1u
	 4a7ypIjNuY9+KgTs4yqzjTdzeGToM+lmHnWziRRuUIlpvgnhi9IzUudDE1ItwkzyoSTpT
	 I7SJelDQC9GrkIvSh4PHUB+795j67cZ9zNUnzF62It4OF9CZFw8duWOgZywtZDHOP/tU4
	 GgTqxr04nvzBQq15f6QVaWRFI2Q6D715oZ6oqkgq7HrHFDWfr6SsIXxyMdcLM4ZaiEekU
	 uyBlJtFOXoqjpw0OHN1y8stvPSmCflviARHYHVwQtA/1n2JtWQiRfxL9v2g/d1KCBRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793355539;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=PqC2VGlCGIsA/VW7WOwQfmzHfoq13g3huhkoZR49dMA=;
	b=JIJweaHeqtDNXBfRtEQIUCm/I1o6R+MLSvFT1FJV12ckPnhyenkuE6C1vh9W5hQOv5aS
	 jENCzPnrtcTGZA0zmU31oJaMb0CLVpGntB3mCNjZK3ub+F9qFXxFyDq1W1YIKkYXH8RRO
	 +ZpYpgRMhjnXRp/v7gL5H0pjjbJ9Tyk6XAJA+IFP5urKsg2fv7csq8AmHeQ956U/vaPe6
	 pE5+jwVj4l57JAobAKoat5+zL1LaN7w8GQxmOuhRp4fKruDVUUrcZdMvLRSSTRjK865sS
	 PJ+CS3Qx7JABZNDG94o5B4rAt6OWBTY1l1chrn6hMsQL3XH2apiH7Wk4NYJ9fPt4WBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s60wwAZm;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59E6606A31C
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 10:18:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B59E6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s60wwAZm
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso266530f8f.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 03:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793355537; x=1793960337; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PqC2VGlCGIsA/VW7WOwQfmzHfoq13g3huhkoZR49dMA=;
        b=s60wwAZmNHeWTO0IjlgHG3JCWCrtLtKnf5gMtH/S2dF30iB6z+Q/uL1OP+4hZuOqIS
         6gqFg2fgezsd4/KeZmdDgslRiS/SqAQ5i12zM0J1wQERVZKBrH2hMrpGFfH6jq9JDFR+
         K5kFOFP+57M7p9miTED8FHf986lsEK43UNvwZeIXRpZ33qxk049TQEYcEUfIhc2IlUVF
         5OHdt4rmmfbs266c1PChzSHAByE4zk7zz7WvkWs+9T6crMC2vsnjBF6Q5unsqGN6ImMg
         9yCcgl1Kt3WNa126qf+MSvgwDoFqNnhc6vOSm2LIeK/Ym8ZOhzqNWyWXJd9VFfnDEFTE
         KOUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793355537; x=1793960337;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PqC2VGlCGIsA/VW7WOwQfmzHfoq13g3huhkoZR49dMA=;
        b=SPI1g9o6Dt+7tMMItkzmPV1i/D4y3o5DRZtHvGYX7T6Y3C+riUuIiT7rqM007WC7Ye
         bhr3W43juBvmP0plQnH1tVk3JdeWsy16lV4AqiDq+Mf6MSWz81V0bVSHS7cYtkZ8Rdhq
         X55u4ULVtvoOqPhVFteqCzATB+Y4f5dQp9JsUxVvsL7JPZ+7qwm//4/jBojKnlmB28K8
         PwaAlVmrTTP9rlZZcRZ39Y8+R9lJAqsoeBWr4Z2pDR6+KhavP1ThLhYC46VOR54UcEAC
         DnXz7997rTTzzArzkjxMOmX7Azql+S79KW8G6TjJ5/J8e2PDYx5se9MgawNu18oD00e9
         I4Hw==
X-Forwarded-Encrypted: i=1; AKwUvBz5ruzRR5BCXSSSTUlwJsR1k4zZ8iKZrpy3x+1afbwSxPN4+kVKHiPpS+rjaBfiHZeoQSPZrYhFEEmfz+Glqw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJUb4W4r+zqdchdlZ5cFHM6Y2JMRkrOr5zdTokHbVrmKwCDW0N0
	zDUwA06idN4iic9rANGZ+v/7D7NxmpHYgeHFm9QH1VYjoBtylh9bqT45
X-Gm-Gg: AYBFou0x8w6VhBxNpcFvLMACrXTS97QynUUtWtHw9mx26YvM435V/c1dXuLIyNoLEET
	9WfnU2AqAKbNNz6BqyQCnvSS8XFaxOc2kCtuebYAR3+6bNSaM1jOCVmwJfQR5z9nLIg1uj7AI9c
	g5NbtcvUC4koag3CYbOXIl8C+g+U2Qza2K+r7KRDk/rrRFKXSTvwSTRD2XLrtpmuj16WceWYiVf
	A8ie9WSoL6Q0ymHRkdZ5nRelV0rHx+oweaLhMBZn2W06kH86uXdXNyIctNA9k/RAf5diXEpsfAr
	9VsfSrRlxC6Ks9/Zd017EjrNJnV5hn5w+36IQpjR2QTt/sNMEP6pF5AfWjqDL91ZsCmac8MZKAS
	PgsUMUSO2IwYIdVJx1xnuBMafE7O1OLSvmARKi7QFy0FjGCG5MvfKMo4tTA/Dkgrcu2X/D81663
	IO/QKSdNIzbTMuFnevrojNpv4w8kP32b5Mie8ckK+Bmj+NA+dX5TqHnIeuQl3HJF0FvbFRzw9Fg
	eoUWVouDqym2WhgU4chvbbivMAPvxCN9zAb7vI+k+Jtoh/I3mlRouR7qGs67A7tbh/fFy9A5Rt4
	1SdxKYMyrTNHF3h7mDO73Gdets7PvLZJGlyZ4oNnpW8ZnAPEwRmGcdUt3NaOO9KDViklskYSWzH
	RF89wCRYxl0dfBA8HWR9WvrG9934F8Pqk9iNuvORIfO6SnIARq5O7r1qPSAUjIw83asxyKS24sy
	tSlQqysMkkWp7/
X-Received: by 2002:a05:600c:4ece:b0:4a2:40:8d2c with SMTP id 5b1f17b1804b1-4ac17b2c396mr36235115e9.26.1793355536801;
        Fri, 30 Oct 2026 03:18:56 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8a5a7sm2410452f8f.37.2026.10.30.03.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 03:18:55 -0700 (PDT)
Date: Fri, 30 Oct 2026 13:18:52 +0300
From: Dan Carpenter <error27@gmail.com>
To: Anthony Liu <anthony.liu@mediatek.com>
Cc: nbd@nbd.name, lorenzo@kernel.org, Sean.Wang@mediatek.com,
	Leon.Yen@mediatek.com, Quan.Zhou@mediatek.com,
	Ryder.lee@mediatek.com, litien.chang@mediatek.com,
	kun.wu@mediatek.com, jb.tsai@mediatek.com, emery.hsin@mediatek.com,
	linux-arm-kernel@lists.infradead.org, ingyujang25@korea.ac.kr,
	shayne.chen@mediatek.com, angelogioacchino.delregno@collabora.com,
	lucid_duck@justthetip.ca, matthias.bgg@gmail.com,
	eason.lai@mediatek.com, linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] mt76: fix buffer overrun in pkt buffer
Message-ID: <auRvDN1KPy_qhb_B@stanley.mountain>
References: <auQjsDPP1PeJg5sV@stanley.mountain>
 <bb9c40516e7379bf763b1ba7cec228c354494223.1793351111.git.anthony.liu@mediatek.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb9c40516e7379bf763b1ba7cec228c354494223.1793351111.git.anthony.liu@mediatek.com>

On Fri, Oct 30, 2026 at 05:05:54PM +0800, Anthony Liu wrote:
> The last patch (d4e5ca3483a0) addresses mt7928 F/W 4 byte-aligment
> requirement by reducing pkt buffer by 2 bytes, causing the chance
> of buffer overrun.
> 
> This patch reduces incoming skb length limit accordingly.
> 
> Fixes: d4e5ca3483a0 ("wifi: mt76: mt7928: makes struct beacon_tlv 4-byte aligned.")
> Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Reviewed-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/r/202610172141.mmRmGqow-lkp@intel.com/
> ---

Thanks!

regards,
dan carpenter

