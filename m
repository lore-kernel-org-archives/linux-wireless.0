Received: from mail-yx1-f97.google.com (mail-yx1-f97.google.com [74.125.224.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B0437A828
	for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 21:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783893450; cv=none; b=QtLiPH6L7ijDw6IbQfhwcut3jMGlVEx0Vux3K0MBGkiXyTuib/fFmPHY30Op90BG/ADS/jvnj0GC87VBOSNaPzj/+lbYnsTCjpeGPyV0cZS2XgCpZOAXID4p7SWzuDAm1hqVp4kt0nDUT3rQWj/iu3S5sSw2a7zlKrYfDKYS/x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783893450; c=relaxed/simple;
	bh=K4mSZwTp/u7hydGX0B9HMeu+jFvEsCWuLWVpwuqs11k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rn/5mOcLWjLs5EEW9fgxyJsfu1+suCU5cCfS1Wiyd5KuRYsYLxg7x8u6spPUyZFp21HmLy+PaeB5b2H/1JBOetnIoQgsi3obbJDOp1nB8iOSHHvJdYuITFtJ3PyBpUwKj8xXUBzQAvi0tiV+PcFSukmz0Tt/oBIkBA4YtMyfokk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=RZHLJiM+; arc=none smtp.client-ip=74.125.224.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RZHLJiM+"
Received: by mail-yx1-f97.google.com with SMTP id 956f58d0204a3-6662551100bso3233913d50.0
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 14:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783893446; x=1784498246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zyr6YBFmBRz4cpGfkF4vKmM2rz6RRnkLotsCwCyQb3w=;
        b=heNu+LIWFtuzxQSWy9zGy9LW0nUIyV1Qzre9JpuGnU8CPrk7/1K1fJ1IWC1WJJPT/E
         asONS//y+NzNeVE36nWvnSEAhRQJzKfWOWDgf/cW37++7HHEQ3vt6RxUw7RWbHvpa5un
         C2HfnpPdsS5xxhmB6ko59bgMnqFEOjhO2PrtVWlA+VJ0dVIORx/Wu72N0fZWLKrsWpLE
         DuyKVF1LPKQpNQ9ivmSwUACbMffXZABW7HBPYSz1v0K5GdMfH/tfAiZ7JV/QX62X0Dvl
         CxrvWvKpYDtg3oYfsTT9A0w7aBx1WtvwDTG+9bIMUApOvz2heOnDP4yrk4XHBr95nzZs
         ak2A==
X-Forwarded-Encrypted: i=1; AHgh+RqN6+PV4XrtZ3jZQ51GILzwlFYTrnPGaHvlXMLzylbkBwon0OywaTCzEC6xkxPbB733G3qM4S+kwKGmIkcdMw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxtCMed8imtL1riu2eNy0V3MVBRrta3GPkVUBIvTtjVkJ1QfWmN
	d6HWpyEpwaDtJ0L2mG4uQhU9M8cxvd9C0hdDgP7ce8wtKdB/0uZTxxrZY0s522LWN1y2nJxQ4Vl
	fP8o9R69JM1GQGzeMHNqNfyNAG74WqiIMW6s1Cbpbn0xEoHxhVtSRoe9w2oyrBH3mD1XjJAnIPO
	03RkYPu5yI3iE5XAL3oDPUfllsTqwg/kyq18tkHHygsuvY1aMnP4mbaycOX/TXItjpcg1+f0/vu
	9uzqAvY9AUyq5qxLO/uSPg+OL7F
X-Gm-Gg: AfdE7cmVSkwlu1OfoBsCcXVRxpWnBMDggIbC4gXBRQNL/ViLW7LcmlVtDW3XgN+9gXs
	eqBZU+Qn7LTieQqqHsQb/bCpl0guzWfDCADZSpKQNT/oiWs7wjDMe6TvAG+P8Z/cpTeYbQsdWPI
	WozFCba5UMljXB+IpQku4YQKDjBgXPylfbgBMDoryfBRZZ+WUEAVAhxoVQusli097iLu8LrkVDk
	1v8ZNCB2h/iWdkjye6r7lFsmCOlR0pgqKTke+DINgjU9B2VYfaqW5keWc+EYOB1LurG9Q69fNmo
	glSspLx+H9sVj2rJ/X80OV2ZK8P3NrFterLmXd1Z5rZzi6EC4bDBcfRu3x8Z9Rwgl7Meh7zQzd6
	rusDwFZW/mBlptoSFnbqYChbTp3cgoeATfmwGkb1j2sX5h9cR4yYcvAfMtdo0Z0GBhf9CLUwK7i
	B4uC3/IFMlmX0plEVqv4487b6m40bd4hIq3HdAEJtjp+ibKiyfk6R9
X-Received: by 2002:a05:690e:1589:10b0:667:ac9e:2e64 with SMTP id 956f58d0204a3-667d7c3dfffmr3822535d50.50.1783893446235;
        Sun, 12 Jul 2026 14:57:26 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-116.dlp.protect.broadcom.com. [144.49.247.116])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-667879bcd35sm859156d50.15.2026.07.12.14.57.24
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Jul 2026 14:57:26 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38db4fa2e25so2942134a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 14:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1783893444; x=1784498244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zyr6YBFmBRz4cpGfkF4vKmM2rz6RRnkLotsCwCyQb3w=;
        b=RZHLJiM+z1ARcnvgMk2ZB+irb4SSQLgf/7cyDkG+r3gBG4FP3hMgEeFlKvYlrwb4Cr
         zdT1HNVLczw8yg2YU5/rTvpWFxf5P1IPslYZCZpdN2agIjBGh19awqHVI0Y7+kZM8Fg1
         Y83Cqb1X5doxo3kv2JR8r6umCaYIU3mU8FNMY=
X-Forwarded-Encrypted: i=1; AHgh+RoZjn6YkI5PZ9j5Nv2goyfskI6j+A2g1627aPJAKrq62FXK0ZryFGevPOaTDmkAfBZE8f4QjXjFd8YgbQpteg==@vger.kernel.org
X-Received: by 2002:a17:90b:58ce:b0:37f:9ce3:ca96 with SMTP id 98e67ed59e1d1-38dc777c50emr6691018a91.31.1783893443835;
        Sun, 12 Jul 2026 14:57:23 -0700 (PDT)
X-Received: by 2002:a17:90b:58ce:b0:37f:9ce3:ca96 with SMTP id 98e67ed59e1d1-38dc777c50emr6691003a91.31.1783893443371;
        Sun, 12 Jul 2026 14:57:23 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-313b4b97661sm29930583eec.7.2026.07.12.14.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 14:57:22 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Fan Wu <fanwu01@zju.edu.cn>
Cc: "David S . Miller" <davem@davemloft.net>,
	Arend van Spriel <aspriel@gmail.com>,
	Chi-Hsien Lin <chi-hsien.lin@infineon.com>,
	Chung-Hsien Hsu <chung-hsien.hsu@infineon.com>,
	Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Kalle Valo <kvalo@kernel.org>,
	SHA-cyfmac-dev-list@infineon.com,
	Wright Feng <wright.feng@infineon.com>,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] wifi: brcmfmac: drain bus_reset work on device removal
Date: Sun, 12 Jul 2026 23:57:16 +0200
Message-ID: <20260712215716.2170806-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709101635.103005-1-fanwu01@zju.edu.cn>
References: <20260709101635.103005-1-fanwu01@zju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Thu,  9 Jul 2026 10:16:35 +0000, Fan Wu wrote:
> brcmf_fw_crashed() and the debugfs "reset" entry both schedule
> drvr->bus_reset, whose callback recovers drvr through container_of()
> and dereferences it.

[...]

The patch does not apply cleanly on wl-next/main -- a rebase is needed.

I looked more carefully at the cancel_work_sync-under-lock concern that was
raised in the thread. brcmf_core_bus_reset() never acquires bus_reset_lock,
so there is no deadlock. If the work has already started when
brcmf_bus_cancel_reset_work() is called, cancel_work_sync() waits for it to
finish; by then the reset op (brcmf_pcie_reset) has completed its own
teardown and reinitialized the device, so the subsequent remove teardown acts
on a clean device. The design is correct as submitted; only the rebase is
needed.

Regards,
Arend
