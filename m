Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B58F3321DE
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 06:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788245822; cv=none; b=jWCIYKeykk5J8d3kRozuz6usW1HBr68DUf2knROxW3mRGmM6i+l75LuVqOAU/zyhkqLFxc9x0/coHNZ+5UMz/hVFfn6+kvzEzwNvu5zS8R16XBWSjwVJEJu49REuYGTkctOmSyDZztHxDQtVngmAFeWOXlysUCJqudbvMWawMng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788245822; c=relaxed/simple;
	bh=FU6oWgCVS36J+D815+YMgAwN/Nk8iJwBsczv26jRlp4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VOINytGLNQfwmsqYmY2qPO4UcRrFy9KPaihdCTUxOEfWf1XUiudHcAoVRltRChsAn87x+zqk7CmiN1B4wgPbZ4XcZlAGSTp6S8thdJp9aLztcqVb+lVjXF7/VpOb5HNYVzcGODpPyAptIAG3ZCiPnISf6lPrMhG5fk3975zUVDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=odS/gVyH; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="odS/gVyH"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d8fd3b729dso23705635ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 23:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788245820; x=1788850620; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q32SeAudVTuiY20cWEi3a7Xbsol0OX0/y07mW5kK2EY=;
        b=odS/gVyHShZ/jjqwfBHBT0dVU/JLUcVWEFq4Zctn+m7gezjJBzbR3DZvTDUMxhrCoo
         zOKADWmFfAEVCIFpCZGbY1ZBersKy4Xtc9TuyjvUu3uBjii7FwUX+WK61HB/ceZCUwEn
         F6zm/9pDSGX2B/P3I4U9U1FfT1WwKzE7J949zXa78XgVmhaHwHy60GNo+kqJnI9yKHXP
         GB7eYqSRoo5iJDJ/aJn6v/lU7TzNJFjLR/u8s8/2ZcDA+iR9oE476SpztlQzYEN2bDqG
         brU6QB8WNv1wp+JsJpOqISWieV7VPgAsdcwbigLblcDlpyugPeGb/dXUgE/9PnWzooMS
         zH3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788245820; x=1788850620;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q32SeAudVTuiY20cWEi3a7Xbsol0OX0/y07mW5kK2EY=;
        b=fNbXu4l+AHIcS1aUzJZB7fKLp6EH8jLxw1nVLL/PpoWARG7TegB71/Q7gYtTvvHRKb
         BeFu/sKOqDRVxlFSC3DFB5B+qAnWs0sLlwmG2blPeou86slN+4fIgXWi8yzDYAQLkIc1
         sJnIuQ5chj3UmzLUB3TLI/8ybvTmA91hzxzrF5skhCOC3eClfQ+H/qsJzVzo/9+PEUWr
         2PbR5mSVvieIwDVTnRyDmxkK0y2ZgHLrKsxvtV9iBKIxfcNpDv6BIBg9sMsBHb4lbSJ0
         su6zcqGAmeByzGv0bKCU+1S0htYEOqga5X8mfQKYlOCLwlpSwsCJAtsow4LI5MLkSYCD
         FE6w==
X-Gm-Message-State: AFuF++lIbpfIeMmmVEMHBA47k3v0veWU+cuLWMnJERtUrSrr37/+KgLf
	xZmBbVqdVd25eV3+ruJD4OiLFR7ng3IMDhsRtb8Ut7UY0rG9F9TOOAzd47vBntQD61o=
X-Gm-Gg: AYBFou3Y74zfD9ibb5YIAvis9LfQ92JBGymKChMX6qc1fu4hy4lAJYTk1CVls9C3dwU
	YUIMNGcV5/8bhIz/6i7NJdpCMmuWFF2iF8Bi7JunPHiRhjrVJhly2HjnOhvze5O56Gkf1PYaKN/
	oLMB8LRDgf+aPaldLZQophv5gK/01Byj5l0cV1RJkFBOcR2pTaJ4xtl5dF7GdX74q7NjsMEC0hJ
	8snurKr6GI2HwGN+hZIc/zQe/BelRgu44vRTF08uaqO7+XmQPo59VxgfPXCKNQNC+Dkz+6gZ5F+
	DCKmOnOy9ClCf/tVlEFhsm6l4NBvTEw3+1JDldjQP1YQFaiV+f/M0qxt1bFitzSPjsUaIgTSUjb
	r//p2vVFzmmu0RSKeqk9pIB7suIuiQcP7SBRrr6C9523SxhuKItmaKla2GzP8HHfQyinlGo86Ar
	Qrb8tzok2OU5Yr1KtrYxoNP7OipGDwKdtQb4rGQMxC4LBI75zVKYNkzEt5VbZ6JcEW9+8lppELh
	75+KL1Qa2VLeJTZINk9FaTsGYaTb5ePXPUSF4dzbaajUqpYSwk=
X-Received: by 2002:a17:90b:4a4b:b0:398:9be6:f999 with SMTP id 98e67ed59e1d1-39907e17dcdmr7521854a91.24.1788245820373;
        Mon, 31 Aug 2026 23:57:00 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-209-44.dynamic-ip.hinet.net. [61.228.209.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990bd21e9dsm4243604a91.4.2026.08.31.23.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 23:56:59 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Tue, 1 Sep 2026 14:56:54 +0800
To: Jeff Chen <chunfan.chen@gmail.com>
Cc: linux-wireless@vger.kernel.org, error27@gmail.com,
	johannes@sipsolutions.net, Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] wifi: nxpwifi: fix return value check in
 change_vif_to_sta/ap
Message-ID: <apZ3NjwKESguarhV@nxpwireless-Inspiron-14-Plus-7440>
References: <20260825104942.5730-1-jeff.chen_1@nxp.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825104942.5730-1-jeff.chen_1@nxp.com>

On Tue, Aug 25, 2026 at 06:49:42 PM +0800, Jeff Chen wrote:
> nxpwifi_change_vif_to_sta() and nxpwifi_change_vif_to_ap() both call
> nxpwifi_set_bss_mode() without storing the return value, then check
> 'if (ret)' which tests the stale value from the previous call. The
> 'if (ret) goto done' is therefore dead code, and errors from
> nxpwifi_set_bss_mode() are silently ignored.
> 

From: Jeff Chen <jeff.chen_1@nxp.com>

Please ignore this patch. wifibot reported an "email address mismatch" 
warning, so I have fixed the setup and already submitted v2.

Thanks,
Jeff
