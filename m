Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0B23C1411
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 07:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791272800; cv=none; b=okBAvWngkr8zn6Sh2WdxeztJNX9yhRl2AFfdRO+7SPjs/DkLXp1quYjnBydj5f8m1CDJ8WsHEpxabzMB7qPOSiYsDLdQVXYIhZJzdu9vKlt6qY3r5I41LtatLQke1D6j3OiwPmPnls5l8EgzjS89Zv+zx0ppTDhtqNfZGKhItIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791272800; c=relaxed/simple;
	bh=D3gB1XP2QGK8Z9e+6oRiVNsyyn/P+mt36J/dj2dEDzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaUlxoS2MjCjlopDMGsU4CafTcqhokUADjcxE8KhfgTR6cA2TxvIpIdK+0B7Fh8+IYh6CPXrnl7el3QQTYZQ1iYQ+RrLCwihv7QDWmWS9losXM3YTmyd9LnvX8yeVtHBV6hIuLa8Y0cy/B6jWCzg+1zcPT/iMcVwqROrKj7egk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S132A0wB; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S132A0wB"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48c5358fc28so1415050f8f.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 00:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791272792; x=1791877592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D3gB1XP2QGK8Z9e+6oRiVNsyyn/P+mt36J/dj2dEDzs=;
        b=S132A0wBCgnBBXjwr9TelgxWqG3KZNr1RhGW5O/cN5BS3WcaYPgsn35iFk2rZtGaju
         1wyLpwIoOvyRmOOMLwaEqgl9P1UmmH2pn07mgTTIjeFC8tHeodBeWwSty7Mta/T216Zk
         WC+q+kakRxo0xybUwhynUrdGJK1iMOpr4k1kw0mEk4rhkHaWadNAfZTGSBbvTVfRId2m
         13xGJGY1xFJK5/bPxykMypRxj1qDR5s5D8EzmkVbNXoGFk9y/q0MBjFHq6drvPeqWepr
         D/woN7lvCtJjOgyfW2FK8e6oQYb6wJxwDnTudxjFM25FQnxyGNB/kJIMgpQvr/ZRHQPb
         nSdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791272792; x=1791877592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D3gB1XP2QGK8Z9e+6oRiVNsyyn/P+mt36J/dj2dEDzs=;
        b=T5Af8Q1PGxco6iPJhZpuQVbUC2jInkQgTMcfEu18FUS4cOBVWY7ISGldFJbJJCGm7I
         BjxPZ0BC2M0lleHXgGZal/Ixl30Q8UtjX22ntoD0CYFjuqphSkqWIMmBMK3FX6b4SLs0
         j27rkh8qI+t5jVMN/1KFotqmTPhvlh6sf6UkJDpk3cbZCoPuJmE8wZpTYHUOirJD3FWP
         LFBkvHQE9Ez5JtB9CUtwomplpvncX/BD4M3PTDAq4Zp/eG+9PciE23vrUeWalx8+v884
         W45ZK1UTzmYKkNgGTTQLeUPI3ufxd4vswVcylpvkx63OVkECgbmuMcGdn9OiHU9BpmbI
         D8iw==
X-Forwarded-Encrypted: i=1; AKwUvBxMjAOn94/iswmYqiwfkalUTekmg1nFfBNHrxWcgzGZGQ3dvhQvNWUiOxAskrwbHHC8kwNS0KOk2Eyxo61+bg==@vger.kernel.org
X-Gm-Message-State: AFq9FYILIBeWMhwT4H8oYKA010wIG3CDQaIlyJdn3zbovbhBOq8m5mlr
	nyqKetuhfwcWOYDiKGZ6cwTuP/LvG0V3bKB7l2ZsQwEzIYHEHRbXYwHXARhPTg==
X-Gm-Gg: AYBFou30Y7TF90f9oqvlIMx58Q1OqmIkikEmmR8c6VS1Ah1GVXX1FnkZb2ynhC7XATL
	MX03lh8hfXzBc0zM3gAfmO5FDGhFWYWEfMDkB8M7y+WnuoyyYnFkIVKWVlEFns3piJ2rDR27nCr
	ywpQNnHBhmLKf3k6POv40gl4Y4i7Gxn35vQaF+Ce5QW0Ub8BSHp/ejN0yuQ0rZUs7JVH53vonyy
	GoTg9NbSMLXrrjqR0/u5gr2Lpn0hWXGGnVRBQgHCHP0MVq+MMmv+JL3AwJjJt5T0KzK0oDKF5h8
	3meLx5sO+GELchs6d/TRt1iPhGrqwi9RVBi9INrcoahPRMxFI3VjAD/DqgRPBGzGSKbjW9Dk9NL
	DnCJbVFOH5ri5AX0c45Jkc2iUumL6HhvKRVY32Owhf/9x5crystHLjYoQhOMCIVALdOKmECuwXl
	kYRdu8Ja8q3iaj+QpWHeTWS/xa0sXz2jLup7n3T4vKqlsSlFQaL8L3bccVRUeTP+kSC2apLazUs
	kOVThszTHPLmiU=
X-Received: by 2002:a05:6000:144c:b0:48b:180:b900 with SMTP id ffacd0b85a97d-48c47fe7564mr17336900f8f.16.1791272792189;
        Tue, 06 Oct 2026 00:46:32 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c6f3a36dfsm166254f8f.19.2026.10.06.00.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 00:46:31 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v3 2/2] wifi: rtw88: support channel switch in AP mode
Date: Tue,  6 Oct 2026 09:46:30 +0200
Message-ID: <20261006074630.372808-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005173326.2306-1-luka.gejak@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Luka,

On 2026-10-05 Luka Gejak wrote:
> so an association during the countdown moves the count a second time in
> the same interval. Can this download skip the page while a switch is
> announced, the way set_key does?

Yes. v4 skips the download and the H2C on association while a switch is
announced; the next countdown download carries the pages of the new
station. Of the remaining callers, the WoWLAN ones run after the
countdown work is cancelled and the beacon change is the countdown
itself.

> so the AP leaves the channel during the countdown anyway. Can the check
> move above the feature test?

Yes, v4 takes the mutex first and refuses the scan before the offload
test and the scanning flag, so firmware without scan offload gets -EBUSY
as well instead of a software scan.

Both verified on an RTL8821CU, whose firmware has no scan offload: a
scan during a countdown returned 32 BSSs with v3 and -EBUSY with v4,
and an association that completes inside a count-2 countdown hits the
mac80211 warning about the counter reaching 0 with v3, not with v4.

Best regards,
Mehmet
