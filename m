Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05113F211A
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 07:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785828754; cv=none; b=YKPHvnDSglqlccqgfAqQ0a0o3mTd7WLkFT9y3jcNjT5Vz9BdepwxbqlfWesFpb2QAhKqecWTmfSJtRbqwfZyctfg+F9VOsTZW+DUx2GQWZXhgf/QfB1o3w6HzU6giRlux1eA5x5SOLee04Q4FLS8N0FMsVkdnl2m5qodOUkA94M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785828754; c=relaxed/simple;
	bh=5XbyqdSXJW430fZo6N7HhdFgzjvc9wvvFOLKHbMhF9A=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nX4Lb2VVZq2+M/I10qZJOXX/RUJ+P55+rvXdxbAQ28a8z37GmAQvL/llSDkfnBgyQgAsOsrhYwxqNeCI/n4o8mUM4gJYtX7TKKvKHvAlO7p+sWUAp/Hx5/GHDlw8j1Wb7ucrOzsmBBHUQb0d2ecL0FJtzDQ0GiDE6CjriW+2mHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nxU9Jr28; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nxU9Jr28"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d032846c95so47569175ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 00:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785828752; x=1786433552; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H7MYhIOz/hkty8mHdFJ53ZWzkbrLjBJWCvFkcesm7rs=;
        b=nxU9Jr28qEwK0n4BBdmcS/R2X0E0UbIr3pJqGqZ+VjwbM6t4/P5wkFHjWO9dQa9jgr
         qNOjew1aX2maAcVR7tP2Apdm3tDmlNO06HAT6+JBQkTYl5N4nCAYff0MHtazxaxG2ysD
         UUeo4vJqJlHUEktJbtYfADbBC+ArPyp8hf2yRgAXbOcuY9HcZdncAb18MAHC2pn3Ivul
         kl/kz1FZUHWA800ZZhkf8gKZhtBcVx2M3K8S0Fksr5dRXYY0v84xmq1Bh3/n2jObzMn3
         dK1EfTgI2L1xusJJGiRQbzVjT7iqpefhRXfxx1vd5BCLzlgSZLEVqJUgZgG0pFhcEKAw
         8Hvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785828752; x=1786433552;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H7MYhIOz/hkty8mHdFJ53ZWzkbrLjBJWCvFkcesm7rs=;
        b=jIxHeXL5+++DbgC6wlVHRLcELhpBcw93drTblyLyvkT5tDLVm4zoFFqkraBFBCVuhk
         W7RQ3Iirvp6T7b9x14K0nDxkUk7/tLUfAZ5dWL11dHAG0Z0nOK5sZaVPGF8yW5FwQu0M
         hULMKOHsC4JuhfJCDuB+b0Bkg6hS/+M8vNZ4NAzjDtoP4ff0869cRjADUzABqkwJqVjJ
         VP7lhyiTvlr/+lmGod0exRqG2qjHVlep+AhV6ta8RxxxgJR3t36/SGoVEyYsjxjQ/1hw
         jkdeNrEedAXZgyrl5QYBb8vjetvSyMg4+EkXyKigF99/B5GEzRtEXPIqMJEaNrSLgdfx
         Fr4A==
X-Forwarded-Encrypted: i=1; AHgh+RoOdw4r/bOf3uBqrC+eYLdotG5JsprmlA5MjxLGj1Zdes2HVii3/i0AAm3oihrO4Em1skF4ajC2sVqh1YBbZg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzVca8zSeSI/5P5slnrHpb4sms/9adhpet71fBOg0AfM2GYKZYe
	XJCPTUE9KyTuiyFyP4kHCQsF0hd7adug4M/8KVeCiBd8+18XVfzr57FY
X-Gm-Gg: AR+sD12DNdNrhZ/FktBEwAjRpwDUUS/oBCH56Ceb9/r0VyzIVkuIK1qqBv4Jxv09ouy
	+nAvqABjSXom/wfUjDOm6f4semmC9oyhOSxThpcnO5cHvvJa2+LXgj+uOSrgAmfVK2a2ihogkJC
	doOIO3dQAp3bnFmiNlDe1JJpqq/cF9jWXP4R3iLZi7pRbtZSmMXm90hnFlm99gTHhiVHbYHHs2t
	al3pxM8u0oxbidlXEcWGbWUS/lFvTFkNLxP7ADwhVMUfDaiabSr+u6Do9gv8yo5Pd2DCDT3PM6+
	GNKRMKEJNe3cK6clrDCuUnstOErxUgzMSmlL12Fu5x1Od0pXDbLH/iJUiRzHFrnZoXD60NQBuhF
	TQmH6sqXjbirq5Qc+5lwSiU5ALloEbPIK4pZz5kOiOJQnfrkHq4IlGEJEYY3k+m5wp/v8vn3csB
	Vak1wjbmwKu1ncYLI3YXGLULBD/0x89dXoYVqPFDufYvnL3F2M1MDeRk04vEMxPaOzdo9OBEZIS
	hk2dRt34/A09gUSkYMNtsyKTIWcto519d9dUFaklBlMvWlJ0Atd
X-Received: by 2002:a17:902:d98e:b0:2cb:3f5b:6663 with SMTP id d9443c01a7336-2d0522023cemr132594225ad.11.1785828752170;
        Tue, 04 Aug 2026 00:32:32 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-234-35.dynamic-ip.hinet.net. [61.228.234.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4d8af6sm1479115ad.74.2026.08.04.00.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 00:32:31 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Tue, 4 Aug 2026 15:32:27 +0800
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Brian Norris <briannorris@chromium.org>,
	Jeff Chen <chunfan.chen@gmail.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: [PATCH v4] wifi: mwifiex: validate event lengths before copying
 bodies
Message-ID: <anGVi6k7xqsVNdMo@nxpwireless-Inspiron-14-Plus-7440>
References: <20260731141600.2-mwifiex-v4-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731141600.2-mwifiex-v4-pengpeng@iscas.ac.cn>

On Fri, Jul 31, 2026 at 10:20:02 PM +0800, Pengpeng Hou wrote:
> mwifiex event packets contain a four-byte event cause followed by the
> event body. The USB and SDIO paths copy from data after that header using
> the full packet length, so the source range extends four bytes beyond the
> skb. The SDIO path also reads the event cause before validating the
> packet and publishes oversized events without a copied body.
> 
> Reject SDIO events that are shorter than the header or whose body exceeds
> the event buffer. Discard them through the same free-and-break contract
> used for unknown upload types. Retain USB's existing error path, apply the
> same body-length upper bound there, and copy only the bytes after the event
> header in both paths.
> 
> Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---

Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
