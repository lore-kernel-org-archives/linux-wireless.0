Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC66637C906
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 08:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250475; cv=none; b=gSd3/YsV3Nsqwyof5TSJ0S8OZrWsRUqsLBAb01AvW6tVARWqt2cKhDyAE7eRnBHiKToPOSuTgWo7TQhIMreJB8xdbDPqxmivw8FPXPwNvvi+N5J+R9NJGKjBmF95Wln5P1g9Vn24rbX903aC29y7vQorieJAjAAljfzSmMQyu9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250475; c=relaxed/simple;
	bh=hC1h58ZXGlW7Qyt2CFxkT11Uz1je6tDDj63vOjFEPAk=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mop+gIUPprchqX+fSzcwA92WAH2o02xJ3iM4jdL0ySQxV66GuErIWmYsG4hVL+xe4J2r5XcQppmkLkgBqOKNvwWweP4lNMRh+RXBLSzK8lzi1Jsak+BhSyQ3Y69ySyKs2AJnxLzwmwuef7n2msGjYKa1XnnpBVHTw6KQn1e75J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eMzPkYCO; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMzPkYCO"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d91ded8174so5055725ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 01:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788250474; x=1788855274; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N35DlRlBLw418a0l8mNUqYvGQvXApXM5HfkSj/C8eBI=;
        b=eMzPkYCOAJDBNCZiAIJjLAiuw+35obx22EP46gZFEnF+rvy/4W48zGtU8Fvp1C9xGy
         Yll29XiVRBRA0qzKY7omPfucUqaKUFnmEnTo3tZTxpGfviE7o0PIApLINzgPTwv+QCnW
         /7jvurZEXED++CY2HH7Q9fMU0FCf+hz2bDtLuKt+GTA0NW03aiPQXPNsxcMMLaJSCWM3
         YnbNKPTEREFU1rbgxtgR7vurPaABoVkI0OV3EzPg1zARPUt0FAm2UHojhzUlKOY1nMdH
         hMGFhdg7ScxEE6vttxgEnyxz5XqMe2Qe/bRT/C9U5HLCQTlPEPh92hECVNLXW3SpwnHQ
         NWnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250474; x=1788855274;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N35DlRlBLw418a0l8mNUqYvGQvXApXM5HfkSj/C8eBI=;
        b=pXTfjW2Xptp1zIm91U94lY2KIsmG9J/rTE1+Fzje1j3tkr7spS0zIw+/wqjjn6RzLp
         YmHsScsOA5ougmaFS+lcI+OTq1ktrl7gqGCmv4EZN12eu2xOelzpQhMMxcqu9/SlgvwQ
         +B0fwIfkSh74qOV8hyDpoNbcgkpp+mMBTm8gaglq993ZF9FKTIo1yDn9X4wMRlhPi5Al
         YDmN3W923Ixto7sMWhYozs5Jd4jC3AV8/eBlcEyGpb/FSsNgn9csb/VizeyTDVnYAeSh
         xKoUpyl4HXgOljZG2SABZ+kGytDaoLdjfRJI0oMPWaiwzIv94kmobTcTP1IGMIZZxgKo
         SWiQ==
X-Forwarded-Encrypted: i=1; AHgh+RpqdZ7EHpo0WFypA539UKWZ8B+RMalNipCF6BFIAoTA3QyItT81w8RBAqBljIUnknK+yJzBZbYj/5TsLWSYxQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kHeXQhJjQzp1V/76LGxjnSQc4PbnHeZ3XNhYaI57cdq24OLjAe
	6hzc9wG+3sqIyvcTr9Oq3Src/HfBm4Jk6smrl9TmmAmQweAlJxfALMej
X-Gm-Gg: AR+sD11dfpDiiBWELj5arisiLlzDVuMUHAJ9YNkzgII63zUSM/JiTJhhLZx+ku8t8dd
	uNcWk5kS/UtwUpRazCwXrdy5nk/FGUV3kaVmgaX1d8s3Tj3x3UqcFY9saGJu64TWx3s4D6bpFC1
	g6cNjtiBfjUvID5BKlrQlctyRTvBIcm9RwMtmUONa2fzew4fmtAyWMxSeIdvEnP13KCC+LSahJW
	yrHcY9kXqn/6uK+vC57I2B8+5L1QGAGN194Ypbzecqa3GSR0O6VHKXARlU6T/RIX/yYi2nMcyNe
	oPjph7UxGM9rss0g39K6RxANkmLj5GLV91EjofvBgolPiCkQRveUxE+xO+0fg0MWbu6VB4jG/1p
	EFKBoYMGvQQuIg5u9d6eIl9wjMw7m1NXEZ/Rhlc8EnC7oHCzW3rHoI4x19iQuZNenle9LdYYoYO
	vRr9Cxu6Q8aKnD0SBoiYTGKUZhN0sthShW/1YarlRUm0JQBppK09vYe2pKdhtXGwAmrPr47N/4T
	pjGxoGK0H1gRCy5ATtt208BMpOCRYPWfjUxpOp7rsn/TKCIorE=
X-Received: by 2002:a17:903:2f8b:b0:2d3:160b:c01f with SMTP id d9443c01a7336-2d74ddd684cmr449703555ad.6.1788250474066;
        Tue, 01 Sep 2026 01:14:34 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-209-44.dynamic-ip.hinet.net. [61.228.209.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d75988ac7asm47305955ad.57.2026.09.01.01.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 01:14:33 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Tue, 1 Sep 2026 16:14:27 +0800
To: Linmao Li <lilinmao@kylinos.cn>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	francesco@dolcini.it, arend.vanspriel@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next 2/2] wifi: nxpwifi: delete the station
 entry on the uAP deauth event
Message-ID: <apaJY8Xc+Dx3GXxz@nxpwireless-Inspiron-14-Plus-7440>
References: <20260807132554.888706-1-lilinmao@kylinos.cn>
 <20260807132554.888706-3-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807132554.888706-3-lilinmao@kylinos.cn>

On Fri, Aug 07, 2026 at 09:25:54 PM +0800, Linmao Li wrote:
> When a station leaves, the firmware reports EVENT_UAP_STA_DEAUTH.
> nxpwifi_uap_event_sta_deauth() tears down the reorder, BA and WMM state
> for that peer but leaves its nxpwifi_sta_node on priv->sta_list.
> 

Thanks for the patch.

Tested on nxpwifi with iw612 chipset.

Tested-by: Jeff Chen <jeff.chen_1@nxp.com>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
