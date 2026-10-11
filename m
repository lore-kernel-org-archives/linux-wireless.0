Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5624B2FFF90
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 07:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791704979; cv=none; b=iWj+B73Z55vHjbEa4dOLYf6SIK3qYr0QvpDHlXJGXTn1BofwpypNGVpZh3WCHfgAts12FCzHUcwi8WjFXfIoPFDqVfSMLmHZbtAkRCfDTRpwIKFNt3tiXCL/bR/rw4tBp5koAGjiKbNYGkDMmSrY3W/1knshe5pIhK2O20o8Rwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791704979; c=relaxed/simple;
	bh=O33tGh5hqvAA1/0BIQxCng5wAU7PH15eILlQ+R/9A+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XGyoKeunB9+T/oPGGNq+lyiKPsCrTvXJ6ecvS3R5BQaObbvgTKGfCzsTdlPpAD2YWA7zNGxdTkyBL5tleTc0QMWkD7HzU7kf0IqCnmGF2c5Wc0022bhfIurry5rF8xS63qguEgByHwLQDMY0drbgLNBOmsjM0ZinMpwGV/22Zog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KDoKtmvc; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KDoKtmvc"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso11869345e9.3
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 00:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791704976; x=1792309776; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O33tGh5hqvAA1/0BIQxCng5wAU7PH15eILlQ+R/9A+A=;
        b=KDoKtmvcu2dNX87BGHExwDrIbfMMm44UMGBCf3vsdZWx772k79g6HpCzEg/99CZ+VB
         YSdFBtcJyOSjLIR7NYMedEnnnZbGi10g+nrPxVMdIwMIui4XwLLRJXoUqEawUTGRyc3h
         lDouK8/rfr5OpWcjytVPXZmCXFJMQIjSSSwPHmgmlje8697VLjCQs5eROoO+aETtE44w
         k+EsZHlLWztdomLznngN+LVOOuoXjcHO0RHXn5DNMs1YsLpdcG2yeBWWsoO1cRlD33gI
         tAfSxq1Zj0z7kG8fGcwnJhh98oCCfAz2ouMJNLUUQA/HpahWDMU7HmKQDLkVnHL/YXUK
         1K9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791704976; x=1792309776;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O33tGh5hqvAA1/0BIQxCng5wAU7PH15eILlQ+R/9A+A=;
        b=VbhEjP0UPFF6Z628JWFplsD6qDJ0C3RcjOR0gvKw7rVrP2CFb95aTUIMHQO13PA0ld
         mfhkdgsZBER3L2C33tvgxehhEP6yjlRDF4TGRhg53Qm4G8ibU9oRUzKdpFP1/A5Mxv+6
         Rp1c5AWFyGoo4RgMwknuteKp5ZOx6CF3tOrgm6ekZNdyXktpmQe0mymJyhKuc6k7IXwB
         celtHAhcKFLS0EKgKig37EGeohabljG3ZvEV+wYjBIaV884po6XMrgEnbYiCo4VHzEyS
         T6j3TQj9Vu7IY02IoMTe/p+3Jit6qvFIvKE/wV94WRRNgg78gRqozHJGjbuFO/XjF+Yr
         iLgw==
X-Forwarded-Encrypted: i=1; AKwUvBwGzpp6y3+I4OygK64DnnxWQaK26eqwnl+4BAPv8LjdHGqAZCnyv2wmJDKd6uyeQz7u8skxgyewEQhEiAPkzw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKNJBQawJ28xz9SRvdD3oV0usIp61E8PeFWb3FO38ON4P3CQNyK
	9E1st+ojVSkXCROn3nRVCXhfamnlc+CkhpNZxPbciXw0G5JxqOyJ7KOf
X-Gm-Gg: AYBFou0Twj37H+zHFR2PGonkUGzRjKQ+xdtoNoVlDNDkkEAvbBjCKNCjKx70gkusJFx
	FSgffiBI/5v0dQzuj4pFXjq8MXfC1SPcs0F/s4Uo9HvNpUF2Ouuo4cXdPFV9myld48EJTVtbJQ+
	TWJglJL4ClB6p/aNJAxAe87gAwUDvT54QVhfbBlvTA7e4d2dM+kuM0uE2cns2x7fn8/5ehyzuHM
	7e1T6j+v6CU/t47EQD1MGtL40pwpFJ+9A9p7qVZaZkBrlx0Fy2S1ByNXotQuF9xxPJPWfVmAwPa
	sK1WsNj2uEd9xTyHTcxRdVMu/grm4+2m8P7SkYIyWxBidJ3yhLIpQe9Tm+omC5Zoo9IWvtL+iGi
	L3sj4KQvspyv4pCLqbRE7mKn4UUqcqbUoaGPIrpxOqLLzJenVRb0uvhSZvAD5OlWfbHQzXZ1eHy
	qmsKFg8Iis7Fkdt0R3/ePOukY4Quxoy8iVHZ17eHvtFRMtBHAD3pkrYe7iKma1AAk1BO6dPHkOb
	o5RIlJsSYhT2kelRUASfg==
X-Received: by 2002:a05:600c:4e43:b0:4a0:1f90:594b with SMTP id 5b1f17b1804b1-4a18e4b67e1mr100020975e9.22.1791704976374;
        Sun, 11 Oct 2026 00:49:36 -0700 (PDT)
Received: from FranzSP11.tail2d6612.ts.net ([31.31.60.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a19c8244edsm24355765e9.2.2026.10.11.00.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 00:49:35 -0700 (PDT)
From: =?UTF-8?q?Fran=C3=A7ois=20Roux?= <franzelfranzel@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Diederik de Haas <diederik@cknow-tech.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: nl80211: don't WARN on a missing self-managed regdom
Date: Sun, 11 Oct 2026 09:49:28 +0200
Message-ID: <20261011074928.9381-1-franzelfranzel@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <16aa99921c4e92e8d4da3c84aacbec2e673666aa.camel@sipsolutions.net>
References: <16aa99921c4e92e8d4da3c84aacbec2e673666aa.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 2026-10-07 at 16:55 +0200, Johannes Berg wrote:
> I'm not a fan of this, I think the drivers should have the regdom ready.
[...]
> Anyway I think we need to fix the bugs, not paper over them.

Fair enough, please drop this patch.

I've sent an ath12k fix that applies the boot-time regdomain before
ieee80211_register_hw():

https://lore.kernel.org/all/20261011074433.9187-1-franzelfranzel@gmail.com/

wiphy_register() holds the RTNL until wiphy_regulatory_register() has
applied it, and nl80211_get_reg_do() takes the RTNL too, so the window
is gone. On the Surface Pro 11 the warning no longer shows up over boots
and repeated driver unbind/bind, where it used to on every rebind.

Diederik, thanks a lot for testing. As Johannes said, your BE200 needs
the iwlwifi side fixed instead.

François
