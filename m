Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1C0282F2A
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 08:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786522287; cv=none; b=V8x17/6LWaSpuzm+L95G+IRfq7TP25M04oCvc1j8DzE1Pe+a5zgKInefgoc61U7LeT6KU3CTiTXPcUSWQZipNCIKgMz6Akw8kLjQbsOSsLXPRRQBb7iTQVZxTYBN8nGswN+AwZHmvjQ7x5sZYospaq89q3Lw6vu9lmAhDnQ1enA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786522287; c=relaxed/simple;
	bh=j7iPKZajdynzJCSgbxb1Xh60z9mW3hDVAZIm+yzzLxk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oz2WT2v5DZI0st1DUQRogtwDL7J2Z0b1J69oxREh0V/J3Bb2od8UxWZHzccbgoRs/2N0d11LZdcahN12fLJqUCeGUVA3fe/z+RYO0F055MMDYlXWYIUpQ/vOUxrnOiUW2ygH9kjwEfDAq1Ho1goHOaZwvh0QFtr7VI5V6tpyIbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D7wopWqe; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7wopWqe"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47fe2d179e2so324074f8f.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 01:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786522284; x=1787127084; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DUUew1TgUXKr+Fo1GhQIDyGs5pp/Nn+31fMTiE5epuQ=;
        b=D7wopWqePgR+jUYpnoBzxgl/DbRCCzpWT9vD9jvjtG8EEPtS/M8xu091incYLxiT2h
         SwFozTn9umNpzIy/JtND+/2ggVrd7Q7zLcAqE7PVkR2vYXWmO/qyM6Wn0K4rhDAuM6je
         EreP+ukSeQ5CqUuibIY45jrmWVYsZHOEYVgxQnwjpmhZQzunoSDRRk8hCIzCEncHdgrR
         VQY5TGc8DcdnDXPydKa+4MN5ksXUDrbIPH3BOSoiqst2saIQl/Bm2mSxeoD8LRbAuoJA
         dLHqPKOfyo4kqgJAXupU33yWzA8bbx7bgOdRonsEhxr8pyY1lfZFFY6kltvnDG63ZEs0
         +hTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786522284; x=1787127084;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DUUew1TgUXKr+Fo1GhQIDyGs5pp/Nn+31fMTiE5epuQ=;
        b=XfVWNx/qWVsNtp7ktNj3Zp9K0fq8meGIdEM399TVYgIsz1SzJ6pICYH6aKoLzxfeBj
         3AvvYlRHAegMlBs0PQ5mOZc8LskkuUntyz3I+R0z0drwUXmuhT745YyeIIA9RCvmbRT2
         Zla+yPLGhq0BAD3XPgp38UKo6mill3iR7gy475y5yTsclrOb8g5oW6Jq7ymHZA1t/Kls
         543LivHjzkKeRhPNqOcDRs8VjL0NQJvxGTgF2hkTlE8ynCSpIyERzafTsmCqW5JvSW2+
         GKLqeKKD9sI4wpzkR8uiWfwSGNOu2az+Q/3kM6w/+xRlT+/4ftfbc6xLKA9BHjZCTb6e
         jRhw==
X-Gm-Message-State: AOJu0YxwLZonHKpojk0Jlu59DgTzz+LO0yNukRGtQzmKp3EoIaquNhkx
	0M0ezVWqcOewIbrVSf9Iemy5jhV1EVDJpKfsy7uakuJbbB/X+MCbkpBd
X-Gm-Gg: AR+sD10MI9GlLDUfdA2ZS1Vg1H/iZ+ZOyTq/rIWfidSf+kQuxaKoHqXUao6yPVRq3yz
	1DbVkrTVQnVt//gFyMPrC6k9HlRxWk+pDSVVARXsi4oTR6g5MTqju8b8mYXg+vVYCrZt5D/6n80
	zEgN8VE1jyoc7ufb69uTtLsAkE2RTWUSt0a1GcWjrZpQ6vwzB6wLeAypUDPrTYLE5fYzX2oZ+mE
	sNROOS3qE4c1yDP0gpVfx6uYIs8KawDVvDhdzSsJIL53FApPVlhzoG4B8wgdGkRG6YuApU15lxp
	AggTEJHSm8fBNv2dXi1UAhjsXdCjEkGq1ZVDjih1kF6OVC4xkmEoj2wCrRTPJmxemNxuBFj51kC
	Fx2uPtZQc3dLWhV++6PygLpg25KbZQxMdBUihJaBqnca+ZdUwKJPrwjx9JitoxIc8G3vXI114mO
	6FBu/uV1wqu8neL5hxN/ogdOl8HtoF6H+/ij9TV7RAwIEfopt0R9IFGq4VrxpGjuzru2Y=
X-Received: by 2002:a05:6000:65b:b0:481:46d2:19a4 with SMTP id ffacd0b85a97d-48152b103e1mr3249899f8f.24.1786522283994;
        Wed, 12 Aug 2026 01:11:23 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48150bf5c5fsm5146702f8f.3.2026.08.12.01.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 01:11:23 -0700 (PDT)
Date: Wed, 12 Aug 2026 11:11:19 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] wifi: nxp: add nxpwifi driver for IW61x
Message-ID: <anwqp-LuExbRshYu@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Jeff Chen,

Commit 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x") from
Jun 5, 2026 (linux-next), leads to the following Smatch static
checker warning:

	drivers/net/wireless/nxp/nxpwifi/cfg80211.c:850 nxpwifi_change_vif_to_sta()
	warn: duplicate check 'ret' (previous on line 840)

drivers/net/wireless/nxp/nxpwifi/cfg80211.c
    816 static int
    817 nxpwifi_change_vif_to_sta(struct net_device *dev,
    818                           enum nl80211_iftype curr_iftype,
    819                           enum nl80211_iftype type,
    820                           struct vif_params *params)
    821 {
    822         struct nxpwifi_private *priv;
    823         struct nxpwifi_adapter *adapter;
    824         int ret;
    825 
    826         priv = nxpwifi_netdev_get_priv(dev);
    827 
    828         if (!priv)
    829                 return -EINVAL;
    830 
    831         adapter = priv->adapter;
    832 
    833         nxpwifi_dbg(adapter, INFO,
    834                     "%s: changing role to station\n", dev->name);
    835 
    836         ret = nxpwifi_deinit_priv_params(priv);
    837         if (ret)
    838                 goto done;
    839         ret = nxpwifi_init_new_priv_params(priv, dev, type);
    840         if (ret)
    841                 goto done;
    842 
    843         update_vif_type_counter(adapter, curr_iftype, -1);
    844         update_vif_type_counter(adapter, type, 1);
    845         dev->ieee80211_ptr->iftype = type;
    846 
    847         if (nxpwifi_set_bss_mode(priv))
    848                 return -1;

Was this supposed to be?

	ret = nxpwifi_set_bss_mode(priv);

    849 
--> 850         if (ret)
    851                 goto done;

Dead code.

    852 
    853         ret = nxpwifi_sta_init_cmd(priv, false, false);
    854 
    855 done:
    856         return ret;
    857 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
