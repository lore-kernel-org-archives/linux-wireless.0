Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEBC3C416A
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788939584; cv=none; b=h0YQBQ45ObDv2W5AOh9RecCRqpJ2CjaG8MmKIt0WK3flysZRHDhzvD3Ah2jLRGaZ0ZRlIdFq6BAQTea9Ah1dXwxpmMlFYWNfML0RwIRVIsVs90vj7eugyeukE7zRYYsCnZ1XpfTbwE+htXwCmpNYH+988xorKlv9u3FlAEcs8os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788939584; c=relaxed/simple;
	bh=7J5DuWjOUEZHYuqjdhf56y5uZniimikWET/7Pjv2e5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a6u3+QGztt4/AqjGnk4mWo/zDdORH0ICpCfqmkeYRCZR+TYCkmoil9gG4rdf+VIMQFYRqP7zt9TmufxydNyjwnilQsTxRT8liitG8raosgxhlcgnFNZOWTESo/pV50mxtbCEPh/i/0Yavnov4PN+fAiXFXLrrJ0gEIF4IrGFifs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=ggr8vZbQ; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="ggr8vZbQ"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2d9520b9155so46468915ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 00:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1788939583; x=1789544383; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7J5DuWjOUEZHYuqjdhf56y5uZniimikWET/7Pjv2e5A=;
        b=ggr8vZbQOFvQzDm/s34U/BKlqmd1+GkmF7eT4hq0FSSriJ+Cc+xGMHkvoPegBSxahU
         4NwZnyUPwV8/yxSnAfqvD5E50cqtuLTCGu5lRYxwqAjObqpZhQ0mYveiwQAeBZMW2KIl
         uRnr2MkLbf/t9wm4iiGh+hkBqc2H+dKKFFidPHBriLqg5+Cjpn5pUmK83GZP2eWKn8t+
         4TDnyQFzSoyeph80HNYReouprbn4gmwGRKezcJUtZN1XzmE7diBadS2fQVnN/iIRV32D
         PhSYvRtbqnqUscwUyTxm2FjOEl0hynnmwjkavclkpcBRIZSLJEj2+MPoeCzQchwxmY44
         z3oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788939583; x=1789544383;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7J5DuWjOUEZHYuqjdhf56y5uZniimikWET/7Pjv2e5A=;
        b=CExEm452aQrB7Xnt1jNFcqDMoNiFKXhwcBsWwgIqTv0X+neiisltkHu6rs1WHdJyS+
         OJaLgUpDMv/8MUkD3f/UVPpciniNbsu9IICtwk+JurJc9POLrFz4QquLwVMaGI9armC1
         lphUVKPRygpfGyzfLIWWbKTTA3mDs7yaF4JkLvvmdsIdo4XNb33PaRiq6tZwRjqOSxCL
         pLYK4rNTRimhL3rOcL8ISHCX0WlJlEUyS3KL/14l9LvBOlGY0adOm3H5uGegZKxSloYD
         pf/O4DkH5X4p3W8oh/mtXiIc7zpVsSYkpYQVDM4g6RtwxzR2Oz4GRcSe54H70Ndilyem
         KFZg==
X-Gm-Message-State: AFuF++mK0IiBJuzj8q5WCTNkucS/2NhOH1kO57eZw5JM9Y4oKpEAk/qJ
	XnrViI+8TrXA1qE+UXCmi1+HnUQeg7wmgBZYK7zRd33hc9Xz+KaPebYpyufikoopHX1bEyt7YtA
	nb0jr7ek=
X-Gm-Gg: AYBFou2ey2DLh6+iO7UXo3sBumAr/ZGxsWeHAKgPvFLla7Pct4YrAJB8hA9cormHxhL
	2/235wXRJZS+rAejMGpLchrJlW9LO96fdkbXJVpauXGvHqR/yjchcKu8YY8/57J/RKw+TYfzSZJ
	Dv9pJ1zRGETnI2emYjWwWoJ8tGp+UtjiygdwWRoRXKJhLBPUrTEdHo4pQNc4ne1wYuBIvmJI1c9
	nyftLbBkyPReN5SRtE7ho/IblPAZs1J+DvxMehzRQ9emyhGjNlbgfTuDaG4UiTIMhK6z7Nv93vC
	L577ZJB43LAcbM4tMNaPHN0+7IjyFLu4tbXeotakdO5itfHGLR2GXXty8FQKfZiuAayU3kN2LHg
	xhjzKltsRQApJVmtB3IpCbdTQjFoqRSMhth9PVukxsSmW8al7tvrUojprh4vQNXdpaWZUx6y9HH
	PIOHdhYmh7b2HR2OI2xoCQdbdjs3q+m/K8nKkQMCq9M7IKGE3sOsrd0ukEaoGrwXmNbeJvTSQrD
	ARrw6ap2zFJhuacdO4vlxdJoqumvIh4KKgJIhgM/g7Ykt7P6Ux7LOs2oUcgbhptnddj/Qw=
X-Received: by 2002:a17:903:3910:b0:2d9:383a:30f1 with SMTP id d9443c01a7336-2db6c699f35mr200481885ad.4.1788939582704;
        Wed, 09 Sep 2026 00:39:42 -0700 (PDT)
Received: from localhost (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1497d9ddsm68562405ad.31.2026.09.09.00.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 00:39:41 -0700 (PDT)
Date: Wed, 9 Sep 2026 17:39:35 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, arien.judge@morsemicro.com
Subject: Re: [PATCH wireless-next 0/2] wifi: S1G radiotap support
Message-ID: <edoj7zdj77g5cxopwucrgixfdyociaek5pf73gzet2gv6yxkk3@pg3mjeem6tk6>
References: <20260909073014.53344-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909073014.53344-1-lachlan.hodges@morsemicro.com>

On Wed, Sep 09, 2026 at 05:30:12PM +1000, Lachlan Hodges wrote:
> Definitions for S1G radiotap fields and report the channel as 900MHz.

I was just about to send the driver patch separately, but then I realise
it won't pass NIPA because they are built as a set ._.

I guess you can apply the definitions and then once I get them in my
tree I can send the driver patch. Let me know if you'd prefer
another way.

lachlan
