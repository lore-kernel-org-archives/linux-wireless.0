Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793876950;
	b=L9bT+4md8WcaQ1tX2SdyJAqFk+HVmdHv0JSW+drO/WvqgJoZjPxFXYt83Ln9YeLmITfH
	 7uOd/mMHMTfpR2h6FCEg0Q9SdmJHnlZDSvoUHRds5ZOeIS2XR4eTm0xDqS7darDnmOYbi
	 35FGOBwN3wKwSjSdKkriUIyyHXNFPePcl0Ypi8sdIS9iCQWFPLANGVHabd2rfKYZPtCa7
	 bp+VdBKg21f4bMYrx3WZ1RT67NaocPbONLTqFFYUvOsqts2DrH5PDPDPaVn49wXo2SVIx
	 iZ55fOJEENDU6AhEsYfrMcLIdqvzrR+NJJrP7T0KAkZsy+kMPi61ruuNKR4QorDduIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793876950;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition;
	bh=cI2QlAQMr7iREriuD1HAiq70znD+xRkslg0HV9Cag3E=;
	b=Xyt/yi8jEhaS6UHb3vStVFeerhRbATkLbU9kniNuvnhgjGJz7TRvjwr9z7f/aT4RmdUW
	 AhKRNA6XFpxShOyFkRZ9cr9OI/xpUxArWhrcsJWNwVjMfDiGzuFh8IjrioCkQLzFfBAjl
	 jLuQMrczhFRCfuE3XnrKKmbpAhzrFWCGjb7t90rhFhBKvjsn9lI04gRNPjqayFdmHuvx7
	 5sQnIJt0YZnpvFGyCjSWX3c4tzP+WQHgVEDVi/CbEpB7SbLVYYdJkX3ahOB7HGK4I2KVD
	 qqSQATPH8i2BR0bQVjOyS/QJCtgxqLNcZor2cLkSbTPgvK2rU2bkPzBAPyAfZ/K7g2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F69D606D809
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 11:09:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F69D606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3b0a519049aso948573a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 03:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793876949; x=1794481749; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cI2QlAQMr7iREriuD1HAiq70znD+xRkslg0HV9Cag3E=;
        b=Rx1FXfZjgqy+v59kDf0d2zRwLI5gg4xyusYLJepr9EuhR2yZ1bLGXa9r7bW4UX0m5M
         BM4JyKjjJwg0jcCsPOnMNa2rOgCz7DZshvqNc6bZsH+LuhKdxQerCe0cAEm1iAoA0QUF
         /XK2R5o/ni6MyrnM3ujDooFOWnBghBaVKvaTui4ke0SB7IETCql443MzHqiUH+FkFysJ
         vubqHKbrDdcm4CJoLyKh/SmfvWpLBnoTBWJGfQ6Uz3oxjFi7vJKaw6wD5zZ/yC+A6BcC
         zxTXuB2E4hLGNff7R8RtnY+XBx5qM2rhDzSAJ8Suf65tRPBM9VtrVsHkLAnuyBwDU3GG
         AM7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793876949; x=1794481749;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cI2QlAQMr7iREriuD1HAiq70znD+xRkslg0HV9Cag3E=;
        b=YzqXF3WOVpkiI6iTJNbkQfAVnvHtzUl1OgqxNy9NK3AlvFdF8JceX/CaxiXjUUxPTi
         AwNPkVqZZf1iiAtwv9OG1FMHYBgKvko0uJc1qvvGO3Ee90TbhchJDXMgA83bKnZH9H0A
         QQ+tUMmWebIcZoqlBVL+/TMSABzdBCO9MSnzKVm92JyEdrQG7gHOtJ3JkulJlfiwfYXD
         W6PmWDJC60Yl2SQ3vwk14HmiulDyIZo6quuPLCLTt7eeBboKqzAlJddlXAOolGi7GOJk
         9aWCKpiNm1UxZm5XLVvDTIJmo02RnwUmoW9pnbnkLxz3e8lievBpxEjXSnGZBenMIQdD
         ZesQ==
X-Gm-Message-State: APuU4Z/LhI20yCtIDQfRsq9qsUheo1qUUjlpACg3rUDSk/jTm8VJfP49
	p6yAjtfQctjzjbmG1BGVC7NUjGoiKLAMWt54bWKW5Yb36LkSHUIwhOmcFceZSRhpK9Q=
X-Gm-Gg: AYBFou2WZQP7t5mu/I45s6wKH6tzAhbUwmV15WzeOSisKtjDLis9vRTLwZTx2fYzM03
	JHN8rrUB1XD66sJ7+NtWNOFYM+je29lt6R+E0CqmrT8OyfH6xLnzH+rgt5D7xfq/Rd3M+74TCOr
	3kzkNlO3d8/dn9dk+UIbYmHT4GS5S0e3+IF6U66dJNC+6FpPtG5AXUvAo1bQCrM/LDGnRGFm5Xh
	6/kVsfJRAD7Km39ZsOUGJZjDq2895OmLEzknJJpAJSJ90LYW2tyYRzXyxAHZhdt32cPXpP9YL1o
	yoSUOUNQ3HsfvuxOgyGvYfx3FPito4gK4gHpLH4juk0UdDuIWcfdfSG9utxu6NX319ghV+faiPu
	i/VorB/bnu8a+FS38AL9lt+7p7ldt1IrErGwPvaFsUCTTV49ACA5NSXjfn5K7icbBEq7Xhi4OhP
	krqSp5iNRkxXjU0I4z+HnklNOAEDs0wsiFUUQIaPLZI1eMWeE2LJvmRwvXHMYwzwsVPY+D2jbCG
	AYIg1r7nWtq9M1bKRdZJPxxTooVyDFtFVHsbFy2Pz14zvx+AtjU79D2rv/ML/i6QtZ4a8jfXKkH
	Yg671jMVmVZqdX4/0uLf4OXr9ztMluztu9OHTs3M4eIiBGZySvb4pC48r7As7hpwPEI=
X-Received: by 2002:a17:90a:ff03:b0:3b0:a757:4f85 with SMTP id 98e67ed59e1d1-3b0a757518dmr2393219a91.2.1793876948751;
        Thu, 05 Nov 2026 03:09:08 -0800 (PST)
Received: from localhost ([60.227.235.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b319f2c9sm3383930a91.10.2026.11.05.03.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 03:09:08 -0800 (PST)
Date: Thu, 5 Nov 2026 22:09:05 +1100
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, arien.judge@morsemicro.com, 
	dan.callaghan@morsemicro.com
Subject: pull-request: mm81x-current-2026-11-05
Message-ID: <fvxlzr6h6xskr7dp6e3kqs4radp3cammky4frm7tqmkp75yw43@o3my43m54mzi>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

This is the driver side fix to re-enable 2MHz primaries after the
mac80211 rework. Our newer firmware which well be adding support for
soon actually reports this natively (well, as an index) so that works
well with the whole reporting 1MHz control channels though we'd still
need to handle it for the existing firmware, but it's not too bad.

Please pull and let me know if any issues.

lachlan

The following changes since commit c4328134f3f7c2ce141121a8f82a5ec0cc8a709c:

  Merge tag 'wireless-2026-11-02' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless (2026-11-04 15:00:50 +0100)

are available in the Git repository at:

  https://github.com/MorseMicro/linux-wireless.git tags/mm81x-current-2026-11-05

for you to fetch changes up to 2823fb11dcf06177a0ae48364400af90337c0f9d:

  wifi: mm81x: report non-1MHz frames on the 1MHz control freq (2026-11-05 21:53:35 +1100)

----------------------------------------------------------------
mm81x 7.4 rc #1:

- Fix driver rx status frequency reporting to report the 1MHz control
  frequency rather then the wider operating frequency.

----------------------------------------------------------------
Lachlan Hodges (1):
      wifi: mm81x: report non-1MHz frames on the 1MHz control freq

 drivers/net/wireless/morsemicro/mm81x/mac.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)
