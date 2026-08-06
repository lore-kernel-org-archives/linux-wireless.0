Received: from smtp9.infineon.com (smtp9.infineon.com [217.10.52.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E7064A8D;
	Thu,  6 Aug 2026 04:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785989019; cv=none; b=e7WDFqNngF8L+B73lSR3yWiKJDQpq0uKGtopjuYFBoN3MMdIjwlPS80e6DvnIYjgZP43SmjmpSEsFQ0OSVGkim52xXqOFwofQxJvppAkfWWuD0Vw96u5h+G9tceDDw4fndb7Xvyo5xtb+/qqQmd1Z4iYY3/YJPb5ocKgXItBxH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785989019; c=relaxed/simple;
	bh=hXyhyHW9zw0Ag1Xy5VrxiE7ZeSF8iY6dpaKNAgvswlk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oo3CThP0/SRB9U7SjNce/mItqX/0eyAt81d2K3dSSrcKh/t23F6jWzMjgo7ktZ6HLYO31ySrOdvHy/02roJSWnencsT4XHD/L4WI91Ux+MqRQ6yopjDGfUpxVuvdyMVO+oiRq52by2j5Se3YPqtvL1A2yiDfiH/tATrhCQeGh1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=hwWeVtTR; arc=none smtp.client-ip=217.10.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="hwWeVtTR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1785989018; x=1817525018;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hXyhyHW9zw0Ag1Xy5VrxiE7ZeSF8iY6dpaKNAgvswlk=;
  b=hwWeVtTRXEAibASZCIz6yZlg4KZepTBOXlCSwzJRP+KbkAiGQ6OPw26Y
   37ek9LCwemsLqZ+UqF0+TpBWkddqtfS7O5wvtTGwNgaZ1i6Ahuv1eVXVt
   kMkztb3005/y1EFw+tyF1z/lqPuJo0DyktnkgwdwjDtMQ9dnpy4ZQ8UUG
   c=;
X-CSE-ConnectionGUID: MQRdvXnARtiMW17NJuJwkw==
X-CSE-MsgGUID: tmbcTGAUQ6O6Oqt4+2FgvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="103658660"
X-IronPort-AV: E=Sophos;i="6.25,207,1779141600"; 
   d="scan'208";a="103658660"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE812.infineon.com) ([172.23.29.38])
  by smtp9.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 06:03:35 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 6 Aug
 2026 06:03:34 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 6 Aug 2026 06:03:32 +0200
Date: Thu, 6 Aug 2026 12:03:22 +0800
From: HungTsung Huang <Jason.Huang2@infineon.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <wlan-kernel-dev-list@infineon.com>,
	Chung-Hsien Hsu <Chung-Hsien.Hsu@infineon.com>, Chi-hsien Lin
	<chi-hsien.lin@cypress.com>, Johannes Berg <johannes@sipsolutions.net>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] wifi: cfg80211: report authorized connect and
 roam events
Message-ID: <20260806040304.GA39624@ISCN5CG5251XQT.infineon.com>
References: <20260804030450.232028-1-Jason.Huang2@infineon.com>
 <20260805110116.35884-1-Jason.Huang2@infineon.com>
 <20260805110116.35884-2-Jason.Huang2@infineon.com>
 <f2c8c83f-e2e4-4ed1-871f-f1bb1d71c057@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f2c8c83f-e2e4-4ed1-871f-f1bb1d71c057@oss.qualcomm.com>
X-ClientProxiedBy: MUCSE817.infineon.com (172.23.29.43) To
 MUCSE809.infineon.com (172.23.29.35)

Thanks for your review.
> > Assisted-by: GitHub Copilot CLI:gpt-5.5
> > Signed-off-by: Chung-Hsien Hsu <Chung-Hsien.Hsu@infineon.com>
> > Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com> 
To clarify the roles for this patch:
- Chung-Hsien Hsu is the original author of the code.
- Chi-hsien Lin supervised and reviewed the development.
- I am responsible for refactoring, testing, and submitting this patch.

I apologize for the confusion in the sign-off chain. I will fix the patch
attribution in v3 by setting Chung-Hsien as the From/Author and will make
sure the Signed-off-by order to reflect the delivery path correctly.

> This attribute became deprecated when NL80211_CMD_PORT_AUTHORIZED was
> introduced. Why are you not using that?
> 
> 503c1fb98ba3 ("cfg80211/nl80211: add a port authorized event")
> 
You are right. I will drop this cfg80211/nl80211 change in v3 and use the
existing port-authorized event model instead.
