Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A2433F8C4
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 08:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978127; cv=none; b=IM9gl/U8iF54a3SCGRSGH4hsI3BHKJR14Ce+YNYwe5nQv7Ec5jxm31l7sV1eTaaoKaXD+0hnFS8rgt4fTgUTntE7xgshtBv+GrMgr4jUo8KtsQdPZI1rZmY1zk+8JWX3OuTCQ/xBSDS6vAufJ+cjUTEOdCN/ljL71u5HU2KqfG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978127; c=relaxed/simple;
	bh=0RaQGQqIo9leMXjyzQA0KC9Q+HujEJJke6QT7/KvSNo=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gRiHeVsPwltBnn1tsl8xp2Pf7lhIqq96tA5nDDm4UZU9DM7a+rwsZzjc84rPusc7vgRoRdrkrpENxdvnGVDEeudQchtTyKyzc5bYlLXqQDgibSLQbgV4XNWB+5zbQ84okUOMe0Sx39jSns78c3ch8afFhlD+3+jEG6qibethUms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bVSv3kMC; arc=none smtp.client-ip=74.125.228.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bVSv3kMC"
Received: by mail-pz2-f40.google.com with SMTP id d2e1a72fcca58-8748f34b1f2so2564151b3a.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 01:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789978126; x=1790582926; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lJf0AoDPq153hT3aZ9zolJbEGD9GJzVcss+BLxpyNVg=;
        b=bVSv3kMCmbOHD9t1EXb9tFC/DwYBsTtIXFRtmptsDNkCYfr4NYrol30HUMxWhXCrcG
         NugtI9VMwA04MFK+YqO3jzk0waVYkOzbUyv7Z8ktaJwZP0h6tK7qtSNee/9K+HZDAXaQ
         k9VvVtzoKhlSq1u+GU8FGZaooM5H3oO9hMOwozpuAdg7iQh9dqlaMF9YeCpe4fs4Trzi
         Eqn9sDPAn9dIAQmm0caE8yqWZJ0e0LMzWvyofFqFkCCzxnsEs3cRWExXZyVyxYkVsC0S
         LVdutyaNjzZCaf8dNp+a6oK5OHVsgu6AzNeIlV3YjbTYc+nLMCrENXIJADZfqHZstaTt
         5wYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789978126; x=1790582926;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lJf0AoDPq153hT3aZ9zolJbEGD9GJzVcss+BLxpyNVg=;
        b=xkYU66sVEQ1dS0kRylD3xKoLiKozd1NIWu0+RtW0yglaJkK/hxqSpokO2ZJsPbSPvK
         fw5yaCo9fhFqzhBfuGqWtY9MeDbp169iM9bDQpXLZ3l0t+3cLU+4liMb+Um/kAR9nh/G
         IwCoWzDQKZFFmF5j9GwXLlGnmx/gf/V96oKQDoSFPZEpZ97b9RgcGBb/SGX4cK0KPN6Q
         jdin0CEL4l9NwhHQBDelQuVejtz4gi7v+dpytx6a5F6OmT1tsWACtqB4WqnliSOC8H+c
         f5A2QGywdSlwp2x8I4JURggtV6dGRPeHAw2nL5VcclRkHwCnVZFVH4uvqt9rPVIDRhUb
         JgVA==
X-Forwarded-Encrypted: i=1; AKwUvBz1lRcxArBnROTgMKGa4pXz+pJmBJb+Cl5RvJhGtT97niGfeLMxo1i2g0lA4FXlF3wtMJDw+Yl7jlxpPFy9+w==@vger.kernel.org
X-Gm-Message-State: AFuF++k2YxILRyJqs7EYJ3YRK1acekZEnFEH6FIikc2RARifqLAq0uTI
	iBDd6AopD8bHyuYWHol+eknsrM9G3LCVIDODQpCWHkSErs04kHL6Kgs3
X-Gm-Gg: AYBFou1fGTkJgA0OR7H6061rS6aHhwHMglnN/LzyunhQT/F6Lj09V+cXu1P1zg2DFXS
	7IPb9fHLQ4858tAnPW3GZCBve7p4Wb9E02IduceZGcy/Ekjzyg3Hz3xo8tSTz76nVkMn7WUTwlJ
	KtQLng/kFUIkXgBM2Ytlxb6CBd99d09FV7DVre4IrnxmjZc3xep3tSaJqi/vMs+j95Od5kJYWHo
	lA55wS98MdCH8e5rdZ1rNR0PMIKeaWvILdebskJnXQQycKQSWh/OIz8wpEHXII7+Frobo1fZyMs
	oQTzqEegyNeJ2q5APEkaoGhSUY1uwo2A9IIaYeeIaGkGpOtFSif5RRsMv3+tZMXLcdh5pkmayT7
	XCNA/wnnzc/pZ96iXW9wyDL93sXMDlxWNy5NFT8mXif8JmfnQYAeBPzl8EvELFkr0QYgqc5PFVt
	qY6GWEMg8TIS3megrhueCZM5xbs1B9wnXZO2xZKRNc000jGJA5jdM/s7ZatFOVFP5e0QuMRueTN
	zMPC951BR/WowFBcdTGq3fQtFwW8LI6kN6iW8kAu32EL3ZSdm68y34maGegpnsmxKX6t3AjrOnP
	KILqR0zoYPk=
X-Received: by 2002:a05:6a00:1c8d:b0:857:72ba:ff0a with SMTP id d2e1a72fcca58-874dcae6e87mr14283804b3a.18.1789978126122;
        Mon, 21 Sep 2026 01:08:46 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-227-192.dynamic-ip.hinet.net. [61.228.227.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877a96f8da0sm2842130b3a.32.2026.09.21.01.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 01:08:45 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Mon, 21 Sep 2026 16:08:40 +0800
To: Heyang Tan <thy15333007817@163.com>
Cc: francesco@dolcini.it, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] wifi: nxpwifi: bound histogram debugfs output
Message-ID: <arDmCFfgOGThdGxX@nxpwireless-Inspiron-14-Plus-7440>
References: <20260919040253.590-1-thy15333007817@163.com>
 <20260919040253.590-2-thy15333007817@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919040253.590-2-thy15333007817@163.com>

On Sat, Sep 19, 2026 at 12:02:52 PM +0800, Heyang Tan wrote:
> nxpwifi_histogram_read() writes histogram entries to a PAGE_SIZE buffer.
> Each entry is formatted with sprintf(), so enough populated buckets can
> write past the allocation.
> 
> Use scnprintf() with the remaining buffer space when formatting the
> histogram.

Using seq_file may be a better long-term solution, but the current
scnprintf() fix looks good to me.

Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
