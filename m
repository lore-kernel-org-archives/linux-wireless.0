Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7E638D3ED
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 03:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787803133; cv=none; b=tHTqjgiBxqDNKaEAspRUPVGZcTf2g2cEPBSVwesrId4swXsBQphhwGOuxdQVgI1r8g5pSidLQYYZWd+QivvlCjKUkt00cUO88+NpQUwIbYSXHPfUHNVZmYCC/ZTpkPTj/npvIPxpDOIyHtwciIRXgVKoOF33n0RlLN2ujVZvLr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787803133; c=relaxed/simple;
	bh=xVRZFbDUIViTRBkZ8muOyVesN8/ZBW2mU/Uvr8Y3YBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJo1neqSFne5zCG/PFOtYSkQybz7T91iW8x6hFvn0NtVz8QncvwdK2fyzVJ5m+L52dohr2smrf53q280oAAn1azK6M6d1vTpTCjcqnjkTAHDLnt43iVhwunfqxfpEkgpMX2grGPPY6HfXZoPZvIc7TjSzrPWBQBxhVRz8yNWvsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k/ZzM0wz; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/ZzM0wz"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-482e29049adso514403f8f.2
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 20:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787803130; x=1788407930; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CAzoKxSQ3b+/c/GS7UxwHGejvR1ze+cQZf36sXyzK8o=;
        b=k/ZzM0wzkjGJVIv06/2nIxQg0rw/2WFH8sB/IOe7PXW8XcOfZnsXM8QhviCoZdRfZ5
         MuWezIlSPnrIod1xOmGjZyVWzkAA0WuJelOZKlp7entOwl6sfD5Nbxa/4/dNs+o0TwWA
         dOA5GdA+J2QvP2VDbvv/aFkd/C3MyKxyWHpYy9K7q4pq9WvQq+ro6qrMKTPq7mwCbXYL
         HxIQOGJxJKvs6clxePKVGhuX0iTmOibG9Xli6vjjMnxFh7OklgIJeIb78QCjnYCqAW/0
         AfVzIJ76770I5mjCNn+5oZ4qnSo4cuIeW4+rXqsXc79m67VA+i0qWBRn+WvRs5wLw7oB
         /HZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787803130; x=1788407930;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CAzoKxSQ3b+/c/GS7UxwHGejvR1ze+cQZf36sXyzK8o=;
        b=VmiqEHrz2TjRlUQvmyrmKr9Umh8OXzy23odAwWOWbnbCNH3cOsCOFUu0fpPy7h+IdW
         1ntAKSk7p6cxY4/Qmmq0pMoHV2PL30adjCY4N3Car5kPQuTY+9oo19NSvdmwMpOD3NRS
         bU0KFQktaU9wd/Dbgg3aoCAgtXYPAwQkzhvry6KdRwKTeH6+4cyzo0HhzSv+87FJjLrS
         E+HA3KFE5x8iDtD9P6jbTUmIxenFsc1wSd75QdS+8ZBw0M/YPrAFJ5sT5HqFgxBDa2TV
         QQZAavH0Atb3aOJvpGskJXDR5Th1xrO98u1PC3cH7vZA3JYpL0MR9KLOT6JMvmGb6K2E
         ZIJA==
X-Forwarded-Encrypted: i=1; AHgh+RqiY3/evwCuqQTY9zJBccjLFkZH03nYGVO3fftY6uQ3V1yFJzUlHh+vYB89wGnTPCWqkbGEuxar24ud+hLonA==@vger.kernel.org
X-Gm-Message-State: AFuF++luAc/D+Mqi3CK9MKdJW5OUbmAxIwBEsmyIjj2lz0y/IAnQlxIt
	Tje90y04yrCdCs4mL0rZOfwtKoBv1wG2RTjZWPYYYfDZisiuC3NSaN+M
X-Gm-Gg: AR+sD115VMWXBnYGH90DNtnaGUJuHByHI/Gv52EDg/P7CFcfrQp6Xy4eIlqbIZO+JgM
	HnIiM4d+3AWrOUyrzF0Y1qQ1YkUpqOUta7dGTiHt+WcRf6sgrgJM2U2unSFXLxHxuH262kHLu+Z
	2YAyCHfjPbPZzQn1mqj7nb3AjATRH7ZQq4cwQGFNs0F4hNbUSFf1xIYzO9KqMd7bYl5xNCzbsCU
	gdP/Sjqqx+1d0BDJf/+d3/yTkmooxxiS+VZjRQvdeExQdaCuGDgGUt+YjzeHANvWDwpI4Y/itML
	uL4DMyf2DzBY93swp7cfoYLnvYqgXUeDNIcAn3wWYTwjAa7MdDQw3vRRxtYVZ3kbymDBAKrFf9m
	Vi2cG8jEGHxy+WXWkRCwkD/3DYu4gzJZn1JxdZB7C85hxygUAYbnVm3o/24oLCdoip1cPOPjHKc
	FP988mEl7HzfUnxODHduylV4UlrYfp3LKfEyTigO0/lqvy2X5QP+r4Ee1nJS9xz91qnOQiXHQxD
	o2HuFB//gKEoJeIqpebgV86Df0qu8N4fKe8Fj5zpIubnDCL/ursiWmM3XlgAml8RJgal/nSMSex
	/1vP8T4yLO1ZPiuS5DH3C7Q=
X-Received: by 2002:a05:6000:238a:b0:482:e968:86f9 with SMTP id ffacd0b85a97d-482e968892bmr7778855f8f.14.1787803129596;
        Wed, 26 Aug 2026 20:58:49 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-095-114-154-097.95.114.pool.telefonica.de. [95.114.154.97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e27ab569sm5601745f8f.16.2026.08.26.20.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 20:58:49 -0700 (PDT)
Date: Thu, 27 Aug 2026 05:58:18 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>, 
	linux-wireless@vger.kernel.org
Cc: Hante Meuleman <meuleman@broadcom.com>, 
	"John W. Linville" <linville@tuxdriver.com>, Franky Lin <frankyl@broadcom.com>, 
	Pieter-Paul Giesberts <pieterpg@broadcom.com>, brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: brcmfmac: fix lost 802.1x TX completion wakeup
Message-ID: <ao-1n5uWuVPKjhb1@gmail.com>
References: <20260811082702.44521-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811082702.44521-1-kmehltretter@gmail.com>

On Tue, Aug 11, 2026 at 10:27:02AM +0100, Karl Mehltretter wrote:
> Fixes: 21fff75d2fb6 ("brcmfmac: use wait_event_timeout for 8021x pending count")
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
> LKMM results with herdtools7 7.58:
> 

Just a friendly ping in case this got missed.

Thanks,
Karl
