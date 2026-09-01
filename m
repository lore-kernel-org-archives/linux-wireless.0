Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950172EEE84
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 10:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788257645; cv=none; b=pdWk00HWbV/meOcX9vTa2O/jgPjv3EheZZOZCvyknmqhvTRI0PHtBv9OMuxOM9kJyx+j92Haq8EqBwrLBaK9HkBWHRW/b88fX56VT/MplYFolJFUJd6fuaH/sYw9IGtNLK68Xf7ObTftLRGMDp/zXnLfv7yJMyUk9nId9AK0F0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788257645; c=relaxed/simple;
	bh=uhpK4AxyjI+tVbZj2X57Y2+1cx1k6678Tro/8VdFTh0=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BbTE3EDmVV6w5N5wJ9RDwUeHps0mcPPILAUbUwwccqV/l4ViEpudKijuV5EWN2LFuf6U2YDjZiLYzQZH+kBwiERIrAqV2jItutmbKQ9ltQsacAiKJNGrNxr/hPsfiJFkFDe6f8E2KTQ6gNM63A5rkt9INgJkxCkCbeM22mw+MMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pVyW6VH2; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pVyW6VH2"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so5184526a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 03:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788257644; x=1788862444; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jgSrADsGx66Jfo1T1VlDwGXCMp2/+MfM6ZbXGzEQa8U=;
        b=pVyW6VH2ypxMyaXvsEky0VActZAr8eAK94ArkGzN+yFyQc+s2ufYZAh79mjkRTrhWK
         CYv0Jz6PPVInMXo9JRFJgLKUkptPsdeKJINI/y/U9HTp2d39PaqeUUXc83BgDTBCO6IQ
         Hqu+GXwWJc1OtLLkUHXOIa0H3DA4nzK7yn9SuM3yVWwjjgY4Sl9TwkQYzTh1+bZ8FzGz
         8rR3baKcKRWN8KVqwEPqWDWOA1nh6bTqOxU2YKnFlzSaUv5gqh+FUW2vzzbwYTVKON8g
         jpF1yTUo5dKxzFiNTa1B170QrmgclLhZHjTM1Mcy1iGKyak4RCKalnVIMvYmjCz2OyuZ
         wbNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788257644; x=1788862444;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jgSrADsGx66Jfo1T1VlDwGXCMp2/+MfM6ZbXGzEQa8U=;
        b=bFxMXRDmTbibFbhWg1fLcezGES9jFwzdunB/w7WVeu+YLZL7keJ52ByKuBOqGzBTUb
         8ru3fq2vsftZhsSmB0KWjYra3IxzIzaXVp4uFUAlhSZMgeUJSKv0UMFq/n2bL65s0iBW
         gHBtNxT37Fldb6V/K9cFeSntl8uSolKQr+2zDbva5GLg2heYojVXTt4nqDFrf+T61Oqw
         iBn7EqiLk6yYg75JiVn+oDO6nFKsM6wDWARSHhcEisiYZPgPaW2xJHVMTujEUkLHgAQj
         vLJrySqu9AdtYkQCJAw0ZRkSU/3q6MbGCCh1M3Ino9NN42zKBxWN9PkHzgK3wtDiqw7r
         /dlg==
X-Forwarded-Encrypted: i=1; AKwUvBwt2yNqHyNAzsTndGDYp/ZIm/DdFNWV8WpisgWCob7KjUpVEBhp3WQ6cwf+qjVUhYMY4zbJvdeA0MGk7aPESA==@vger.kernel.org
X-Gm-Message-State: AFuF++n/707jIUcJ0s23WhUcW70LVCSin8+ayTZK+5wpx4F5TUKAQg6j
	1nuX3WoigujMjdUEzrnCkhG2YvxA2FaaQJpUMwl/0SMsfmqYezJG0tWF
X-Gm-Gg: AYBFou3SIG1eN1bIwF5eMWvZp2C16xByK774XNK0obLmZYCgd2Kz90OoOwAzrURVfGr
	IA3NuNI4yXrP1nDz/j9lzU0zgbEMnPPMu1IZN5cCBpwGFBI3OODGlvwXCdjeo3OAxxKJg/k8y86
	HXmcz8GZjgp/UuYG0poGCtKjKMpbueZGQCW49g3FMWOy7ec9XKNTjYqo7M/Mw6NI2N8OEf0XY/e
	Jbfy6icLEcuEd7vvoNaR+TrTwJ8AdW2GfeRQL6sJBpS8J2wadx86wLbx3Vd3egHFF3MGLwft0JD
	5BtqfOMSAuY/d5XGWeZckM9KTBdzf0HA4HWEwLDfIgC7+If82oZqqY7BggQ3fpl6WlRi7CdIcT0
	SW2dZ1diXYzK7NBgniFeyWQTmArgqvGj5932yNU6EX69t9SCSTGWLySl+y7Fw7uOgF7cdt4aJ9G
	vfnuDXhSbczggY3sS/PPBXkX4gY/XGYLWBM0XQLO8q1HUJlYVdEQu1g1eHbGz6cf6ZOAnUrpP27
	um4oIyxvi2z9YGDV5GijG1wCCxiicyzUhqpWa/JmrzDoRVfCqo=
X-Received: by 2002:a17:90b:1a85:b0:398:a2ed:7b5c with SMTP id 98e67ed59e1d1-39907f04d76mr8015628a91.24.1788257643830;
        Tue, 01 Sep 2026 03:14:03 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-209-44.dynamic-ip.hinet.net. [61.228.209.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d4a1732sm5118110a91.7.2026.09.01.03.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 03:14:03 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Tue, 1 Sep 2026 18:13:57 +0800
To: Linmao Li <lilinmao@kylinos.cn>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next 1/3] wifi: nxpwifi: wait for the wakeup
 timer before the adapter is freed
Message-ID: <apalZbUytbmsyiO1@nxpwireless-Inspiron-14-Plus-7440>
References: <20260813082315.1390321-1-lilinmao@kylinos.cn>
 <20260813082315.1390321-2-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813082315.1390321-2-lilinmao@kylinos.cn>

On Thu, Aug 13, 2026 at 04:23:13 PM +0800, Linmao Li wrote:
> nxpwifi_adapter_cleanup() stops adapter->wakeup_timer with
> timer_delete(), which does not wait for a running callback.  The
> callback goes on using the adapter: wakeup_timer_fn() sets
> adapter->hw_status, walks the command queues through
> nxpwifi_cancel_all_pending_cmd() and calls adapter->if_ops.card_reset().
> Both paths that reach nxpwifi_adapter_cleanup() free the adapter right
> afterwards, through nxpwifi_free_adapter() in nxpwifi_remove_card() and
> in the nxpwifi_add_card() error unwind.
> 
> Use timer_delete_sync() so the callback has finished before the adapter
> is released.
> 

Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
