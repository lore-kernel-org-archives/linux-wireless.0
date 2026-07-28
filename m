Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978A736F917
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785225207; cv=none; b=dhXBZ4XLpE4PGdQjyaB64cvAUty/kfvhY9h3KkZ1uEb2B8JeY0N1Z7Cb2NofgYGH8lDWKAU6xG3J5Byd/zo0EDDS8qB+t5vd3/jKMcBbOKPu9wSZDq+NEHx8puA3YQaB/Hk/Kt/FjBI0Xuvnnuj4W1gANf9dkt4/S7bMf7K/ykE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785225207; c=relaxed/simple;
	bh=NFz2mVptfxXcgs5HKXMuo99UvlJ5LfPNKWMDii+t/Io=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QI8qQy0G8/rhGarwwdOKTyDbTXEjNUzNP0LIN1RE1gWxpJqVoRdsbZLXvMLtlX8OgicT4rvPvTdCPz9rgL5mF3BamJ2CJNhcesJz/lCJ5FlIwfnFI0csldnG1AgYS1DWypHxJbRRgiw9u+wp8NSlOPsUqWWADQvGQbCUefkKXME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Okei8TX2; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Okei8TX2"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d01663d816so3072605ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 00:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785225206; x=1785830006; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8KNwWgkU14XPJ7UuJ6JUVf+SiJZ69QA7ZKs8dWYD4lY=;
        b=Okei8TX27Wq7kA5KQgpmKi9mkBk4L7wtEk3T2fpKpT9kXEeMcTNLdrn+HByUsL4fvN
         DfS/Bp0cV4z+Pdngo/m0qsmmNy1YIto2UvT3BraFCe9OM/1hmd2zveC+P+SuoMmQztpi
         PE2vFtgeyEeYrF2cjhfpQ1X5ILtc5lXmqUFwZ1e6qkebzpugNCzUSncx4l/ViRb3vkz7
         Q5Y+4s8Xbe1ObAjYIYkkY0S8wDPHS1Gq5AvhMlYowaIYS7gtWOzn0eIhWp5fIa78YjVu
         1a5viC1NQEL0HK3eO9jvwmuiPPuulDHHL0LqNhehqs1CYFSxzzdX66PgQ4P1gi99te2D
         8ejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785225206; x=1785830006;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8KNwWgkU14XPJ7UuJ6JUVf+SiJZ69QA7ZKs8dWYD4lY=;
        b=NmV3DSPfXmIk/fHVGOVLEtn5OFFMEij8z5cbnAWMQWoca5QDrZJEEX3G+t39qKCTql
         5X7yJ4av+t/oRLi66QIYtCPLo9yes6xghhh8XZ5HHzZCDTda7kAcNIfmpiQOexUzmlzg
         W+A2CTgjQysyl5Ycf1dfOZzq+yeT0GNhXcGvQ8m1aFm3FImFIGeqCFizPsvTSeoeZbuv
         mNiIF7JUJVUtJwyOAZ7+t84sMDi1DqHjyVQ8/mN17sq2sHiZQk4R0EWILIUw0lvANwiv
         b6tXh+LGvqAHqK4Y0NFN5QmECQtjmwIHwGDgSUNs1qtuV/vbXPIh7o+Mr3+eGI+XPsgx
         J1+A==
X-Forwarded-Encrypted: i=1; AHgh+Rqk7I0OFliSMCspOAU2KNdxzXihviJREhtn74bXBxXmiDjuP7pa9zXl/LO/KEgAySPEMLeIFh86nuar3lxt+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyT4bRus7BOxcgZYpAuxD2AlRyBd0Z/f1yN92LObG/17BXSMzz5
	bCW3cYrvH/ncqAyp+xuMYF7yHCEvnkoemT95F7T7MgGT6gUIs/9ItUqj
X-Gm-Gg: AR+sD12vglda3CBJK00WCGtZiNzG9SV9qzc3/MyksERFzuqqI/UNZCyQKqOpUORbEHf
	eJWJHka3EUnPwRiZ54qq8WRCF/1wqLxUqpCsOZk+/g7TT9hGhLc6zNz7lK3NQU5PIVB/W/mC05c
	RuLqvNu240Nq2j/fE+GJNkOXU8Ay23nR9x6mew7VZzEEzsBEjmRP1uVexuKxmmNmo4BIPOs/Hpt
	uf28tyfMa3bM+n5a/bhX5L34PonJoU+uCktYht1t2cuhy8Sq8lFs5NpqWLyEUj5eByz5SNhaea/
	9rdb8BEIrZFr8VF18esXAopmx6INInshZ9/t0OfheSQFEVxXO8rddTGf7Ih66+YbN6qGnsexoPn
	qPVjyNs7hy1+ls/GsVOrYGXxkNZA6Nm1akMBReYW8cScJveU8B28LOizZMt+tEpYcVVlOmmiaev
	1NFvUhjDgB3zwcX1UvazrGenififedVJkx/5LWACHAis+6SKbZPvfJo06faJfqHyaZae62
X-Received: by 2002:a17:903:1aeb:b0:2c9:dbdc:c0e with SMTP id d9443c01a7336-2d015c88931mr16581295ad.26.1785225205770;
        Tue, 28 Jul 2026 00:53:25 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-203-195.dynamic-ip.hinet.net. [61.228.203.195])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde59b768sm48545535ad.4.2026.07.28.00.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 00:53:25 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Tue, 28 Jul 2026 15:53:20 +0800
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kernel test robot <lkp@intel.com>, linux-wireless@vger.kernel.org
Subject: Re: [wireless-next:main] BUILD REGRESSION
 90883c513ca01e77c56b8d94be7de11420c1dacf
Message-ID: <amhf8FQaFP5cu9Pd@nxpwireless-Inspiron-14-Plus-7440>
References: <202607251212.6TdnMBFC-lkp@intel.com>
 <f5daf31604eddf9098b3310cff85409b60b0333a.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5daf31604eddf9098b3310cff85409b60b0333a.camel@sipsolutions.net>

On Sun, Jul 26, 2026 at 12:39:19 PM +0200, Johannes Berg wrote:
> +Jeff
> 
> > On Sat, 2026-07-25 at 12:56 +0800, kernel test robot wrote:
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
> > branch HEAD: 90883c513ca01e77c56b8d94be7de11420c1dacf  Merge tag 'ath-next-20260722' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath
> > 
> > Unverified Error/Warning (likely false positive, kindly check if interested):
> > 
> >     drivers/net/wireless/nxp/nxpwifi/scan.c:2034:1: internal compiler error: in final_scan_insn_1, at final.cc:2823
> > 
> > Error/Warning ids grouped by kconfigs:
> > 
> > recent_errors
> > `-- csky-allmodconfig
> >     `-- drivers-net-wireless-nxp-nxpwifi-scan.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
> > 
> 
> Jeff, could you please take a look at this? I don't see anything
> obviously wrong, but also the function has some weird stray inline
> blocks, so probably wants some cleanup anyway, which might make it go
> away.
> 
> johannes
> 

Hi Johannes,

I looked into this and successfully reproduced the issue locally with
GCC 16.1.0 on C-SKY. You are right. The C logic itself is fine.
It is a compiler bug, and adding __attribute__((optimize("O1"))) to
nxpwifi_ret_802_11_scan() makes the error go away completely. I will
clean up the function to remove the stray inline blocks.

Thanks,
Jeff
