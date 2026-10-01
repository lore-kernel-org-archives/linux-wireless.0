Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14DA30BF70
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 05:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790830875; cv=none; b=MmwjHpSWfG1BQW5drADknEwosy3Y2Zp5qUn4pFH1OKKmYlm0q2XmUKGpdSFQQTg446EJZxgyFZ/gJNdOF/ZTU3YTkc76KoKVg/s00Omz70aUswP8gME53olJyIznomHTR+7K1kocaWUWDR1+lPdbM9dHbx2V/zwPh1fUl92fmiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790830875; c=relaxed/simple;
	bh=s+oMzrUKFgXpDixV7YFkJvkS1XqGJl7Qp7fnv5b4nUg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A7lJ9fqDBzurlOghXDWDv62q0iyHkwcdNTPu9dppxBqqEHYNhKERUp66T8NDfopgQQVd/HAdopXgJB92EbfMJ1WgsxjglE4A7Yl0VJnbu1JI8VRMvksFaqyWbMaL6z2tX4dHaPkPfWdwiVSbLuT4I0QrroXNRNL/HEiHpjH0MJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oAuypULY; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oAuypULY"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747ed9866so43659685ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 22:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790830872; x=1791435672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lJGKX+MspRpF69/x1f73Jj1LeEntaRoySY/fuMe6cXY=;
        b=oAuypULYvncq2/IX8le2DEbEkPfP1dUpUW+8BTyckhiQ1oolsVV6L/NSHLnCauIvNf
         EQX9GW7j9fB4UpfK6TSoOQh6/oCm4+K4bdzZwh61VEdBbrDaglaCTUXDDYPBrS5DwTrF
         V1KA2nB4NQVeeuZ0fhbgdpWN/8Kv7tpKmNrxr2dCfz5pYVgaVA2OtXisxiWN6aRLfyhP
         IZiPP0bGuIu4itDAlfGBX+etyQtPBKrPRco5JnhfpiG/bVGoEr70z0PiLpbbhF0QaDJQ
         jHN2FfGuhjk+QcAKsB4IxN295Mkz7rWZQXzUbdLDiUYjT3cbaGgrnDhRA3w6K5xL7T/0
         9Z2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790830872; x=1791435672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lJGKX+MspRpF69/x1f73Jj1LeEntaRoySY/fuMe6cXY=;
        b=jjULc9JG02gTLTuk7mge4ZBUS5I5G8dMLpKXjAecJhYkClP/2/yIicfyRiBmWWCJm8
         0xDxgL3YhCPulUzGA1gvxtOgMqYvKBIfdxdzXqIZo1T69ryLfHRbl8iMTcGnww6yYh/8
         R/HNUO1+rZKtKFt5nC+Yd6xgH9tr5C14AwbA8AnUcu0CO2N6K6RH+GOZRd2uBdzt9y8j
         4KDxrSg4NPfXymeMJEALRtXd+see/VdT3cFmOGUgD8Ou9iOl/JMJ2JzV5M+wk3yPuBnY
         paq8sz9qDuIdnx7t24fdCUmZ9vcMAMlONhBUw3ESCFLdjpJQNXw/AGTEM7mswFuE+hAw
         IUGw==
X-Forwarded-Encrypted: i=1; AKwUvBxaBNCSWhih91UZUvCWx87CXa25IuWffO8xwdNIy+IVC9y+elreAtzjG/qtF6BBA9IP05I1gin1KFWaTnrjHw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIoB5NDOlnwJYiCw6/DKAlPkTf0v/pC3J6W2GM8WuOQeaxyOPWb
	VorbgotFV3SVTVWsZLca+U4S8EWsVuQZFQhgKSIeABKoAEVzqZ9FM0QL
X-Gm-Gg: AYBFou3P5ET8mENDeAVDoPN+YP+oPvtJctkO411UTd7jHthv5VgZiuz0pMGyzdH7Er0
	ye6/YixVg3mOIb4gTY4twm8nbb6aL9/FMokqgJWk656Yw8jzd3OurULEByezKyg3VhREquRqB+R
	XQUcHPVaurPWr6NB/1MOI/DOFL/YrJTpb9bCGSDTOYclr9JoShumbk3LcyZRNOQQWB1bZRPbbEq
	VuPPjf8OW5z+AO14K152QdWDQYe0mmwuFyrlWSbxUUADuMATcikUHSwj5EGBUZJGZyLqVgpPvEU
	V3qmjANjVTnv0NVDGTgfV6wUSZ+c0rri/UngMmtZi9iF/ndpfX9goAXL/zqi/rKTtEeXxYV/HmV
	sp0h3E1Re70sa5VX/2bzFyxvV2AFEAaWkQrEOR+aegyuAArYJz/sKazW6gzK32h8Q9RU0MSFffr
	hnVc5KkeZSTaCbKauzOfBorywscB2qw6uwb+fteKEu/9U1Gu7F4QkkbxQtBdXqpo0BbQiyXMXcf
	Br/V/E2GFE=
X-Received: by 2002:a17:903:4587:b0:2df:aed3:2ac0 with SMTP id d9443c01a7336-2e2e4a138abmr30429175ad.10.1790830871805;
        Wed, 30 Sep 2026 22:01:11 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e300b21912sm5112085ad.54.2026.09.30.22.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 22:01:11 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Daniel Gabay <daniel.gabay@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Avraham Stern <avraham.stern@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>
Subject: [PATCH v2 0/2] wifi: iwlwifi: Fix GP2 to nanoseconds overflow on 32-bit
Date: Thu,  1 Oct 2026 13:01:01 +0800
Message-ID: <20261001050103.860584-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GP2 timestamps are u32 microsecond values and NSEC_PER_USEC is 1000L, so
on 32-bit five conversions are computed in 32-bit arithmetic and truncated
before being assigned to u64.  A GP2 value above U32_MAX / 1000, i.e.
4.295 s, wraps; GP2 wraps every 2^32 us, so almost its whole range is
affected.

The same files already cast four other conversions, so this is just the
remaining ones:

	gp2_ns = iwl_mvm_ptp_get_adj_time(mvm, (u64)gp2 * NSEC_PER_USEC);

Changes since v1:

 - Added the generated-code evidence below instead of "Found by code
   inspection"
 - Rebased on iwlwifi-next; no code change
 - v1 was sent with the wrong From: address

On i386, iwl_mld_ptp_get_adj_time() changes from a 32-bit product to a
32x32->64 one:

	before: imul   $0x3e8,0x17d8(%eax),%ecx
	after:  mull   0x17d8(%ebx)

0x3e8 is NSEC_PER_USEC.  A standalone _Static_assert() replica confirms the
arithmetic: with gp2 = 4294968 us, the current form gives 704 ns on 32-bit
instead of 4294968000.

mvm/ptp.c:219 already uses a u64 gp2 and is left alone.  The
wrap_counter * IWL_PTP_GP2_WRAP * NSEC_PER_USEC products are fine because
IWL_PTP_GP2_WRAP is 0x100000000ULL.

Built for x86-64 and i386 with IWLMVM=m and IWLMLD=m; checkpatch --strict
is clean on both patches.

v1: https://patch.msgid.link/20260805082515.4136842-1-zhanxusheng@xiaomi.com

Zhan Xusheng (2):
  wifi: iwlwifi: mvm: Fix GP2 to nanoseconds overflow on 32-bit
  wifi: iwlwifi: mld: Fix GP2 to nanoseconds overflow on 32-bit

 drivers/net/wireless/intel/iwlwifi/mld/ptp.c  | 5 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c  | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 4 +++-
 3 files changed, 8 insertions(+), 5 deletions(-)


base-commit: 90e281bd4ea3d19dd6b5af1923551648e477bd26
-- 
2.43.0

