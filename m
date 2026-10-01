Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E63B48F846
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 11:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855677; cv=none; b=W1FkDKGjegSPh9Rr3L04SuxItdPZPN9Wl4+a1t5ztfL3QEyJy6MYyNPNXuXo1nZl3CKwweh58Yd2rA9HZMNlO1e/a6hAi0cjjNMDbMB9A6tSxZ7G1kY7Zn9LUJTTAPQ/Z9xr0E/X3kBNeeLYxMbdyE6Q3ZZwZdd56Ps5XdyZIn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855677; c=relaxed/simple;
	bh=xTnrOATJyRY/t1BaZ1/rZxgk2urH6TavcD2eYZ2/x8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olaVQXLmKJKDCnRgwowjWKTgOV/Kb2aX4VxxweF+WEzuCFLIanDdfP5J/HxQiU0Fyap6PVZh5KW3WPhpbfRZJjDSOzwxz1xgGXns5lb/msgfnagu+uTVn5PCx0TaTJL1yDdV6QWlwR7CBUdRttZC4Z9HyP8hkBV3LNnPnzX8C7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bV1j9neZ; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bV1j9neZ"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-4a022e9cbebso3706155e9.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 04:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790855671; x=1791460471; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xTnrOATJyRY/t1BaZ1/rZxgk2urH6TavcD2eYZ2/x8k=;
        b=bV1j9neZpe4L/wJrqRACbO9er+NpmsHxNAzfUYcvMr0sAgLFRQVUoQhoIeqGp+TCOQ
         LrNUBYkbYZKC+9Wkcti741WrgaMIcXvqJ60iqS4zGIHhjdeZ+u/rKHH0BQ4iy/5DEK02
         OJHMwLkGshD8O5RZiy0a89uIwH8JbsFqh/xuUxAG6iBagCy5JaPuuDq47pv+l/WBZ8gk
         tIxGo45+pCtsBct1Cys5+AUCd/pZCQ2lB+8aMex0+zPSUtyGU7ChSrwhf3md7Dv2WZcW
         e/7FS91ium3AzeO5w91ZNVaLGKaNAeqTM26wWirJ9lJ8zTAuFPgJ8WLQNuqZ0J0J5nGF
         CvNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790855671; x=1791460471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xTnrOATJyRY/t1BaZ1/rZxgk2urH6TavcD2eYZ2/x8k=;
        b=E4iMUUYmQv3K3Sx5/j6v26qdTZDFBoz41+xn2AIebOLFp3RkditjljMvPt2J1ihUtS
         u43L+wdrzs1cxOWMFg6+pRyZL0L3fCwaHW6rgTmF/aZ1H+KHu5FGmViSVXePKq520H7K
         h6OmIuBl/LKkJ0baFPwgq8dqO+vCOPaxA7GhuLIzJq+ttX27kues3Qf/gpwKJwyWsm9j
         RqI85/PRv+doqsv4PmFq5N3WkLXYas+m+bROUHNCEB5sE1fga+iBDuqeEaHJNZ/21GWw
         qfc4pu9uNi51LKt8+EXWNqWzfaA3e6mwZBRCp9p6kFkS7gdPclFJRjdLx6XzhB0McKeP
         e5OA==
X-Forwarded-Encrypted: i=1; AKwUvBzwL2yaszaKVuUabOVs83VwrsfnKXRhJaoUp7mN8sMi4GFwhfAwxcWbPh2AGqYI7BKOEBRq5Z/xLampp0G6Jw==@vger.kernel.org
X-Gm-Message-State: AFuF++lSLtZ/EP0YvjVyLHVRm1N2PnU5bvXO/qvOWqarbkx7bmV+o5NF
	WFgAWRUhWVBEj6FhXWeerS/ennlpXOgQo5+F3JZqTsv6waekAk98SHOg
X-Gm-Gg: AYBFou2PjxVFNmosQ7DH1H0iVyO8zXn47Do4STHpkN1qbRMCWo+ev3kXbSReHBsGcdz
	fpV/uVdJtXFamNf9a8aGa1Ju2SyX1ySVQ4b85Xt6C2eHzeN2iOSUPEPHTEKiRqD9ARplHgxKb/0
	uKmGsvo0mhToj++20ifQWTb4+7r6CYzkNd2ojvfBh9jleHlWKZtQNdm8L9uyX5RU3sOClgVLOOG
	PyoI/mNttRirGGAocZvOiR+yBUbjsDXuQQcMD64W+r6GmafQKDuQuGAxQeFD/QH9W9LuBkMOEM1
	U/Lzkahpst1QDQTtwT7D8lhwY7vbTPsoOaHIdZHpcCBnk2mtwto/vKy39F56DJkGEGMm6NSho2+
	c9oXjGB1e07ygEndxZLW1Q1SOueR622T6HJd9JtuT/kocsy49eb7BxWkeR764Sd9KMRshdpHS3U
	Fvl2Ghxkis7pRoARYTUJ7guyep0mYvrvyjgOhA60iL/m5UnFMsPe5UwU08S32hYvYN3smMgmowm
	lGutyHUZuRR1/w=
X-Received: by 2002:a05:600d:864b:10b0:4a0:2dd:7573 with SMTP id 5b1f17b1804b1-4a01b12b666mr53819085e9.33.1790855670520;
        Thu, 01 Oct 2026 04:54:30 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a020f7f220sm68289915e9.5.2026.10.01.04.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 04:54:29 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v2 1/2] wifi: rtw88: download the beacon the reserved page was built with
Date: Thu,  1 Oct 2026 13:54:28 +0200
Message-ID: <20261001115428.2979730-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261001071656.16499-1-luka.gejak@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Luka,

On 2026-10-01 Luka Gejak wrote:
> beacon is written in that branch only, and the caller declares it without an
> initialiser while the free at the end frees whatever it holds. The first page
> always takes that branch today, but the caller cannot see that, so a later
> change in the build would free a stack value. Would you mind initialising it to
> NULL?

Yes, v3 initialises it in rtw_fw_download_rsvd_page(). That is the only
caller of rtw_build_rsvd_page(), so nothing else holds the out-pointer.

> The cover says this path is compile tested only. The feature comes from the
> firmware header rather than from the chip:
[...]
> so another firmware for the same hardware can reach it, and this is the path
> that v1 got wrong. Can it be run once on a device whose firmware has scan
> offload?

Agreed, it should run once. The feature word at offset 0x0c of the
firmware my dongles load is 0x7 for rtw8821c_fw.bin 24.11.0 and 0x0 for
rtw8822b_fw.bin 27.2.0, so neither has bit 8, while rtw8822c_fw.bin
9.9.15 carries 0x1e7. An RTL8822CU dongle is on its way here; v3 goes
out after the scan ran on it with the AP up, once without a countdown
(the download must keep the beacon) and once during one (the scan must
be refused).

Best regards,
Mehmet
