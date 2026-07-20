Received: from mail-yx1-f97.google.com (mail-yx1-f97.google.com [74.125.224.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C423822BF
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 19:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576948; cv=none; b=Fv0GlrM1N2pYQsM9CKAVr7zi4gx4Cc6h1i0g5Z4l7vhyawbeHBfdj0GnPazlU4ryuKFvHe3QLc0X6tdI880noFNTNDafRMhD3bg3GeYnqo+K8QCf0Kffy2j9uF3Yzjl9osPZhjiFWHTty7/Dj+kRpLArOlhL1ZF7D6+JExuGMqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576948; c=relaxed/simple;
	bh=ILZ1OXSqpg0YJAMnH1L7KR62EaBTj6ncEaDP3DDL3YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qfdjho34IuWL1dScYUT1j5wa+DDyY8GBGGRs/M9xZa/tQPRk6nnUE+FO//ABM8b5u+U6O2CAcOKPf2zK+nhz5VzIfuFXvsSUpUD28MiIat58ZkPpO+0dEReXCiwvBHPDEk/df4hcuS/M2tvtYu647IhJoW4V77KcOSFbWzvm9jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cARFAA1W; arc=none smtp.client-ip=74.125.224.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cARFAA1W"
Received: by mail-yx1-f97.google.com with SMTP id 956f58d0204a3-668432fe416so1960159d50.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 12:49:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576945; x=1785181745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tRt6BPmnSIJVDlX+Tp6C58k9HWDHbAncJG4jnoURZe8=;
        b=Fg78ezMXX8EugmtVyXW3zwhkwtl5dOv8LY8KPNC3Wwdai9MYpRwMB5J2XPibLII6Wx
         t7ARhFFGpfw+9SUGZ0v4ABtPe0eTN05JTAaD3kouZhBGHtdhkUWbmvQt7lIlDZtXqfJC
         FUmoYLntnmJbuEJxQsTwmDC8gAM4eDLOYE2ViU7guwictBX1T4Vhp0fb+psrtZVexQwx
         ZjPeiu2c65gBPp4nUqzUNPqbsV7tvsXbSwfW5Hn8wL4vfw6BhSy3FfmRTNC53cv7ZSBx
         XFQP/tDZxYAk3cxCpXNToDIm1QgfoDI02/Vr/j2euc+NZMT4PpY/eByqoiARuElpx/G6
         KEpw==
X-Forwarded-Encrypted: i=1; AHgh+RqBh8Apz/Z5fW3Nk/JHeYmwek3xbCgXgdSIVW882ftnMbzH39RLVd6LWGKTpJebjsPYLNu9Xrd0k6IOtrFutA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5ptX0feR8NCUJaMJqRG/0xT6SpCKwF36oCaCAM6jUcjJLz9l+
	rXKSEx6gEvIJF+XKHVoqfbIVjSdXZ/Gl/Bsg8GOd8ADWRHCh5zaFfwff5abOu1J6BuylZLYIGwt
	I8AVy9KPYrUFQZqYFnsthswmHm1Fdgr8W4t2fcK3eMchQ/zFbUQiXFBY0mK2yZeud2csSPbqp4E
	WGOX2uvuIO+D4+Sq+drJl/taOMG8pMt6nmYEA3xLz/9QD5uuuGmWc7i215MbP7lTEAUzYpYHldk
	tRPSBBQSypODMoYRMTD/QINRuP2
X-Gm-Gg: AR+sD10bQ7Ev0SBsotG35fEGBtijqOqaeosEC8cROGDu6fHMmPo0MVRB0EHhprImmJL
	TB8+o8deRJBK+UJFqi1eR/eHdxGgnBXFSPh8MItBYl3NeNXIBJaKI0CKArFJwtds1+sZMGE00jQ
	7ejuPiUW1zu9fn88eEpvgaRpa/EyOqgI+MJ7gUwRwl76wgZAZNs0fJ3Yl3uTh57RYKv3oPn/0GI
	mSataE4fR6NFknNwDEsS1ccYWDR2WIyIB4ZFjfkVuIJt+zXDbDx0gvVxpUrWxfWi7kco1f8mV45
	S/OccD0zD0RWVdD0iI1qckb8kecRaER81lSVBNsEPn8Bn9PLp2lS0HSyA+R+dCFbQkr7Tb8PwH9
	5WGVt7R8GFGZ9rja42kQBG4nwmJCELDpaUbaXTTwgN4RmIlD9QwxJZkF3Ru1D9GsQ9LTjhTI5fA
	gG1gqrnDxcUhVw1pxMyWIqQX6ftOFe4vGU5w21IBQ=
X-Received: by 2002:a05:690e:4009:b0:667:8de6:785f with SMTP id 956f58d0204a3-6683b6cc39emr4161900d50.0.1784576945345;
        Mon, 20 Jul 2026 12:49:05 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-12.dlp.protect.broadcom.com. [144.49.247.12])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-6683b54f547sm829090d50.11.2026.07.20.12.49.04
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2026 12:49:05 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c15e555a164so554145766b.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 12:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784576943; x=1785181743; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tRt6BPmnSIJVDlX+Tp6C58k9HWDHbAncJG4jnoURZe8=;
        b=cARFAA1WyyW/L+HMoKQcCEDUN8lrDoldF4n4CQ514Dmmg5M5fhe50t9m8JPKY/uKya
         PfVjTc+yl/PaisioXJCFp36+XG4Hci6mj8mozeAWmKcujb4A4a0plN5VZszXv7PRT9lL
         crYmjek3Dr06l+cIl+aZc34y7O3w9Q+Z5gXjs=
X-Forwarded-Encrypted: i=1; AHgh+RrWjNmJzIU4C0QGIfmiPx5KsdA7tWTBQR78ssrBa+k4aDxxXHqm3iQcpPuf5nprcopt8pF79qYdBTKdYs0FPA==@vger.kernel.org
X-Received: by 2002:a17:907:9816:b0:c12:58c0:db2 with SMTP id a640c23a62f3a-c16922d74c7mr845558866b.18.1784576943712;
        Mon, 20 Jul 2026 12:49:03 -0700 (PDT)
X-Received: by 2002:a17:907:9816:b0:c12:58c0:db2 with SMTP id a640c23a62f3a-c16922d74c7mr845558666b.18.1784576943308;
        Mon, 20 Jul 2026 12:49:03 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1705912972sm506543066b.14.2026.07.20.12.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:49:02 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: bogdan.nicolae@gmail.com
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Bogdan Nicolae <bogdan.nicolae@acm.org>
Subject: Re: [PATCH] wifi: brcmfmac: cyw: clean up PMKID and cookie code
Date: Mon, 20 Jul 2026 21:48:57 +0200
Message-ID: <20260720194900.2356442-2-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714150423.53960-1-bogdan.nicolae@gmail.com>
References: <20260714150423.53960-1-bogdan.nicolae@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Tue, 14 Jul 2026, bogdan.nicolae@gmail.com wrote:

> [PATCH] wifi: brcmfmac: cyw: clean up PMKID and cookie code

The code itself is correct, but there are process issues that need to be
fixed before I can accept this:

1. This is a resubmission of the patch sent on 2026-07-09 [1]. A
   resubmission must carry a version tag: the subject line should read
   "[PATCH v2] wifi: brcmfmac: ..." not "[PATCH] wifi: brcmfmac: ...".

2. A v2 submission must include a "Changes in v2:" section below the ---
   line documenting what changed from v1.

3. The From: address (bogdan.nicolae@gmail.com) does not match the
   Signed-off-by address (bogdan.nicolae@acm.org). Please use a
   consistent address or add a second Signed-off-by for the sending
   address.

4. The patch addresses two independent issues: fixing the packet_id in
   brcmf_cyw_mgmt_tx() (SAE auth frame TX) and fixing the zero-init and
   PMKID copy in brcmf_cyw_external_auth() (auth completion). Please
   split these into two separate patches.

Please send a v2 addressing these points.

[1] https://lore.kernel.org/linux-wireless/20260709122315.11400-1-bogdan.nicolae@gmail.com/

Regards,
Arend
