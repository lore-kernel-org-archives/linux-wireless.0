Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77034439F7F
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 06:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791788270; cv=none; b=pf5aOSgFqkFAGBLmwCjZXGRinhEYsFga1xP+NQwAyfDkylSejQPnIqLhMZFhbtx75GA6UioW2Rf6ZFQvzdC8Qw5qIyIFw5ACQ/z7nl33teo63tG3ih228Riulf3cqwKluKUccaybbuDbuZeHeVYlk1cq9bNSFiLpFJp/1SIbKSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791788270; c=relaxed/simple;
	bh=P6spEShhJuUJwspagHXdV60BnHh9HGtQLAR7l/RQSpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyTLzE3eXa2jYV2CUZHpXCoaJQR/AR4WX6BJ6gboNGS+cwDgF3s6FjbNS2eb78db2heynZP1PFfl8m1dwL9GVhLF+ckQjzasnAdFHFk1GPAvfJvKV+K7qrhg0EOFa/PIc4rwmx1ReAidlmuzG9+rJlyg+Kofdz1RYYv9ap8Yo9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W3RDrDtA; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W3RDrDtA"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a0286c981dso12752155e9.2
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 23:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791788266; x=1792393066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pb/kn1bilH8QkmWf3l7OGZJ5xTA+QDSeNfAS3mOibcg=;
        b=W3RDrDtAIOYkUhFlQ5UGdWxsBhOi0ff0QXxOaoHXVd+9QOoIropo7mQ+/EMKyExkIu
         uCfQ3DjcD2LItXYzZrXeZn3CiPwvxpGwEY0FytBQXhqNTCTaLl8hjcYFg+4WsZuOM9A2
         9fZ6oJBpKhs3AXRWhs1cH8Rj3TXuj8HOZuxOJjv4yoyrxYtezT5ZIuIrVAxBM6abFycC
         1onZKZs7POJfMn1UDaw+gjz4WDPR4x82mlmBe3bB1/KZ3jaxrKZxxeNancAov25pN78/
         DlydDTTjo/9r/zGZ9qxKn1TDRr4Wga61gDIyyXuODxC/leXGOnt5hIFbOheY2PSl/ALV
         uZug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791788266; x=1792393066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pb/kn1bilH8QkmWf3l7OGZJ5xTA+QDSeNfAS3mOibcg=;
        b=l6+akkzCwuY1BuVuD6bnu6Gpj6ouuD1siRU6r/4HsRCEGOdRi7bdNrEL7/MzEmHE2d
         JkNnjWSzd9lejY0qmRpCF3gouvFCOr92w7KRGZ95NRUsaHIWZ455fmnuiw1QAtnr2cx7
         oNCCGz7v87WpTLviBnFy+8Bv8LOVkv6E7UXg9wagTSfucjSBaJcIeUCO/EqL8qqcDKsB
         8MuwnWi5V5F8t+Zl/VDnNHE7WQPrqE0Pwi6PqBeov7Jah4TuQ5Ix0xMzi4QsU0EcKrXQ
         pY1Ptm9kOzoYLmB1M0dgNnZJSLx2HpQPpcAX5+7D98epap7V+kejtqrZeqd0O/8BbaqH
         +/fw==
X-Forwarded-Encrypted: i=1; AKwUvBy5g13ZC2f4UcvdVhEe2L4cwwt1OdBbrmxBxB14SywHNdZhUZTpZJpzXe/R4jMJKWhyXFFM1DOAI9ezDKrA5w==@vger.kernel.org
X-Gm-Message-State: AFq9FYK5ufxVNipHf+mOfhWLY4a3oUD14pRz3UlFDQCltoMLK61rtHo8
	4fw6CRMCtmjtwODH0C2670teq9vjYSNqSVqqD/4fNL+lHuZMhJ+ANToX
X-Gm-Gg: AYBFou03TEI2Hgiceu/L7XoS2O+qNJEOjGmcqpo90HmA9FZkmqfKf4UYL7HjZorBdaZ
	V371Dht1qHyKokSnejJZao9FPmBNdEwis5oQe40+vXSSQ1mvQu7ABMSrMwfwhEzyuf7kAuxt5Ln
	Df2uuWasm0Dl5DkYXUrZYysx8tTKOxExrgid8EsViKNmo/gyd8WKdfVlH29T/PpNNRahz8kJDCp
	nOVasWOhXi+nc8EFvtu3RQIDYSGsZfcczXRIqZLSaX4tmNtnqQcgCdPpeMxm2cnZ7XQSXPTzNUN
	vLPtHrn01STSQc2ckm7VVEnfROjIDnxRlEx/7pziU6S17du2GH8a3bU1ob8ux3AikwZWjb43K7M
	9BRmT+P9E6UkQBX9h3J9XGsvli7cKm76ktKmP5Y8cvesMD/c6NdxK91wzO1KyrmIor/NaREuoUq
	m8aVZl6GuJTRpQX9xM22gwNa0RkId3fIwBH7aJpnmUYFYsX/g5Cnc4EmKfrfB7Gd1Xd5UqzH+Gs
	XaEOg==
X-Received: by 2002:a05:600c:190a:b0:4a1:746e:589a with SMTP id 5b1f17b1804b1-4a18e4aea54mr176998935e9.18.1791788265546;
        Sun, 11 Oct 2026 23:57:45 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18c85009csm208854355e9.2.2026.10.11.23.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 23:57:44 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: Re: [PATCH rtw-next v5 3/3] wifi: rtw88: support channel switch in AP mode
Date: Mon, 12 Oct 2026 08:57:43 +0200
Message-ID: <20261012065743.17665-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <04b18579ec644839af3d5baa1790618f@realtek.com>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

On 2026-10-12 Ping-Ke Shih wrote:
> > -       if (!test_bit(RTW_FLAG_RUNNING, rtwdev->flags))
> > +       if (!test_bit(RTW_FLAG_RUNNING, rtwdev->flags) ||
> > +           rtw_fw_csa_active(rtwdev))
>
> As my comment in patch 2/3, I think we should cancel the work at core_stop.

Yes. In v6 rtw_core_stop() cancels csa_beacon_work next to
update_beacon_work and clears csa_vif, which also covers the firmware
recovery, so the wiphy_lock() in rtw_fw_recovery_work() goes away.

> > +               if (conf->csa_active)
> > +                       rtw_fw_csa_start(rtwdev, vif);
>
> Is this a necessary case? Can't rtw_ops_channel_switch_beacon() handle it?

It is the restart case. After ieee80211_restart_hw(),
ieee80211_reconfig() replays BSS_CHANGED_BEACON with csa_active still
set, and drv_channel_switch_beacon() is only called from
__ieee80211_channel_switch(), so without this the countdown would not
resume after a firmware recovery. v6 says so in a comment, and the
same path stops the countdown when the beacon comes back without
csa_active, which is how mac80211 ends a switch.

Mehmet
