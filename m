Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBFF3C4B8D
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 17:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787161482; cv=none; b=RP7Wy0ViVM0E6TRXqyB4jEDiwp1akS5InntfNKLuGHEH9TmljkAxylDJZIDisWyJ07ndbmcdSehJJFm0QngtBWYjz8YGTNbZUbUvcRevvj1BVm5qyyKosc1by3KGBPat3zBzxg6s3SaTn5+CV6SNka0ALVS02x4Fdf8UXbjj284=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787161482; c=relaxed/simple;
	bh=kl2vAl6hTDL2AYJRAzbZ6h4vRN/KK/5gh6DpWrDWx1s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JfOy7yc4+YCbMkqSB50kCGhP1gAkUTr3Bl0qoCoLkyC3Er4xayZEuILjD8FC2IXhuv/vko7kp8AsyCUgJTY652SfxhIKUFAqJYCtxbQho+fC+0KK5UuOC1mI2p/mxu8iNQW/Pz+RKeGLSGyXc95pgp96DPtPs2BqM7Hnk4OR6fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KR8ws3X+; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KR8ws3X+"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so12505455e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 10:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787161479; x=1787766279; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cHI4k/qB4htx3KIUscycjSvTuvxYrwgRpa/2Edi5GwQ=;
        b=KR8ws3X+5sdnMnl5kp2lTHP3kcbtDmWqbMjdlPdNkepuo+mxkOOefRILhYVaEcyBI+
         5qq4KkbtxXS76wdWWuxv3Dfy3oMANz5+HmecGhkIOo1CAhNi/Y0eo7Ew0U4K8tVp3jJS
         6M/DEcUxBN7beb7RCe8YAzB4w7EQFEvm9r0PE9I62KCoqFUDBlEdPoOcGIb/01jSoOPV
         JygSlBGzG7CcBggpPqGS+EUG7dv8cKQYcRob2F9H5j/7XLcCq+VDfhR4CcWqhn4YfQUp
         j35PqmVi3eEAjKKoOGTMLRdPhRqD2oFCDy2L2F5eP+LTdHw0iPtOVCfQ11uETup6zV8O
         +v3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787161479; x=1787766279;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cHI4k/qB4htx3KIUscycjSvTuvxYrwgRpa/2Edi5GwQ=;
        b=mIwku6jmSqBojuuEDVBQTecheeRvWpHO2ss9uSxWv7BtOFU/kPSQECcB0QVCxwoBIP
         GGdxgXchHP81lMTL0nEeCPnif8a5Cri5NLXXVXU4MIfWe1gkK3otbZBuDGFR4bm0oFkq
         i4pYsNWinRPmWsBu6eDLxpin4NfYlJEfMkfV1S5hrwiD62azZGpBRORxisaRV130cGDO
         fNDsv0Ulo3HbUIx5nIDKwGH83dTbg5+3mRWL0gLJmIM/MTPfcWYCqOZ4s5BKRp5PNqKb
         JoQDGm+ItobZ2F0cJnYusC0yjpw5w8Ajado/fSoz2Wm5XH0S+5qsCbdOpNGQW6AXC9KK
         FLEA==
X-Gm-Message-State: AOJu0YzvPIgRaEjnQIXhURjPHJR9Z/h53CXfY8NK1cwuHx2L1uVBzVGG
	teCkXzNsMi87jCZBHC+H3fCAKs7fi9y+ZNNeFmx6PFAP7kqBdqWU2Kjr
X-Gm-Gg: AR+sD13zAgb3Mez+V/MSyO8rlPQLD/7UX4ijQqCicbs51QPaKtpfUAGCTzv5urrLdl/
	tJTO2ZFYKJrjaUdOntPSTSe6OkR5FmYbsHde44A9rW+ul3kklFvQVtcPhRiE70AXBOY6vBFSAvz
	J5A6Syv80d+qn//v7OazOis8QS9Zkdwot/WEz8k1McGw/ZzNs49rQZyq6HHgep6aLTR5NfhOZRD
	wTtY8zVT/dcjenRkmWEGoTizhl9hdP4vlZyG3fN8gRc6Cgk4YNHZazJg2N32MZyWAJC7uxz7Sf/
	YVSOEEzn/4qg352DJPICtGziUbSH/C5NVGq//T3GgHXgLeqz3fAmB1WyREQ/4w3VR2ZhJ9TTBV/
	Sm084EXBJJAUvCWrYFOoVyRm/4Gs0F5hH/zEYM/DRjNBDhuPiJpuH/8MWLzlsl+YxQ6X1BuAvqN
	lXXRDyAKEvZJtavK0gsb5w6rKaaARlcVu+cnIki59+ymGOwYNQzZxxllG9
X-Received: by 2002:a05:600c:1c22:b0:499:9240:9a1c with SMTP id 5b1f17b1804b1-499aa1f5589mr119427085e9.15.1787161479285;
        Wed, 19 Aug 2026 10:44:39 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499ab2a8b34sm84045115e9.8.2026.08.19.10.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 10:44:38 -0700 (PDT)
Date: Wed, 19 Aug 2026 20:44:35 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ching-Te Ku <ku920601@realtek.com>
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] wifi: rtw89: coex: Add Bluetooth binding for Bluetooth
 RX gain setting
Message-ID: <aoXrgwyFu851qVNV@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Ching-Te Ku,

Commit fe8f6ddb9095 ("wifi: rtw89: coex: Add Bluetooth binding for
Bluetooth RX gain setting") from Jul 6, 2026 (linux-next), leads to
the following Smatch static checker warning:

	drivers/net/wireless/realtek/rtw89/coex.c:3943 _set_bt_rx_gain()
	warn: duplicate check 'rf_band' (previous on line 3927)

drivers/net/wireless/realtek/rtw89/coex.c
    3914 static void _set_bt_rx_gain(struct rtw89_dev *rtwdev, bool force_exec, u8 bid,
    3915                             u8 rf_band, u8 level)
    3916 {
    3917         struct rtw89_btc *btc = &rtwdev->btc;
    3918         struct rtw89_btc_cx *cx = &btc->cx;
    3919         struct rtw89_btc_bt_info *bt = &cx->bt0;
    3920         u8 h2c_func = SET_BT_LNA_CONSTRAIN;
    3921         u8 i, id_start, id_stop;
    3922         bool state = false;
    3923         u32 scbd_bit = 0;
    3924         u8 buf[2] = {};
    3925         u8 len = sizeof(*buf);
    3926 
    3927         if (bt->bcnt[BTC_BCNT_INFOUPDATE] == 0 || !rf_band)
                                                            ^^^^^^^
The patch adds a check here

    3928                 return;
    3929 
    3930         if (bt->rf_para.rx_gain_freerun == level ||
    3931             level > BTC_BT_RX_NORMAL_LVL || !rtwdev->chip->scbd ||
    3932             bid > BTC_ALL_BT)
    3933                 return;
    3934 
    3935         if (bid == BTC_ALL_BT) {
    3936                 id_start = BTC_BT_1ST;
    3937                 id_stop = BTC_BT_2ND;
    3938         } else {
    3939                 id_start = bid;
    3940                 id_stop = bid;
    3941         }
    3942 
--> 3943         if (rf_band == RTW89_BAND_2G)
                     ^^^^^^^^^^^^^^^^^^^^^^^^
RTW89_BAND_2G is zero so this is dead code.

    3944                 scbd_bit |= BTC_WSCB_RXGAIN;
    3945         else
    3946                 scbd_bit |= BTC_WSCB_RXGAIN_56G;
    3947 

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
