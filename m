Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEA11AAE17
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 05:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786600641; cv=none; b=gPJs9Hk3dKDVqTlUHLUkYr9G0K6pqNy2q1b2HXr1Xfda4CcZMSVGvslmR64Ck8OXTevg2GKhr37EY5j0TYnMlfrciWrstyGZknyTmf67eocWIHPoXKaiEdlLTGEKFpjmfBARh/IHg9mqeYRb0u+vnMHicooj2q+plAOYhR3mhCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786600641; c=relaxed/simple;
	bh=a42qqutrvNEsIBTjeYtRgJpfyAco7/ed1UM+NmRG7BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8HsqG+RFaUg/+nv7QodIN44ZC8ltP234azAe25JVp/cy/S313VsLgLPzaAsQcJo9+AH2MBTNwBcyuX9LbyhQxAT1Jtcj562RhOBVkISi35bKQRXF2LTBmEYCuK2H1q/fmhwieyU1FjwcXBpiyfZ5S+NziqG7vF8HJKfcDH1eYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T2sUQ4rL; arc=none smtp.client-ip=91.218.175.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T2sUQ4rL"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=a42qqutrvNEsIBTjeYtRgJpfyAco7/ed1UM+NmRG7BE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786600637; v=1; x=1787205437;
 b=T2sUQ4rLBqN3Go8+8txosdyyp8hT5d3K9U/wr1oV/1yxi40ZpJNZTLJQqLH7cFRVBAh4q3B6
 aQx/ShTDitD8Hc6NIOUY0eNoux7app4zXWLdZqN1ukPwfLxbBSuWXYvaf95h13VvfGRbSc2SgAX
 4C0YiKTcNr4DJHt3NRye5wyw=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (31.223.131.186)
	by smtp.migadu.com with ESMTPS id f6c43e95968d5701;
	Thu, 13 Aug 2026 05:57:17 +0000
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>
Subject: Re: [PATCH v3 0/5] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Date: Thu, 13 Aug 2026 05:56:57 +0000
Message-ID: <20260813055657.13506-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <57719CE4-BEE4-4A1E-B760-DFFD04FF865C@linux.dev>
References: <57719CE4-BEE4-4A1E-B760-DFFD04FF865C@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luka Gejak <luka.gejak@linux.dev>

Hi Ping-Ke,

Following up on the test I mentioned: the result is in, and patch 3 on
its own is enough.

The tester ran the series with patch 4 removed, on good signal near the
AP. "firmware failed to leave lps state" did not appear at all, over one
run of 46 iterations overnight and a second of 825 iterations. That
warning was only intermittent on the unfixed branch to begin with, so
patch 4 was never what suppressed it.

"failed to get tx report from firmware" appeared once in the 46 iteration
run and not at all in the 825 iteration run, against being easy to
reproduce unfixed. So patch 3 is what addresses it, with a rare residual
left over.

That matches the firmware feature word and the C2H capture, so patch 4 is
dropped in v5 as planned and the slow host improvement is patch 3 alone.

Best regards,
Luka Gejak
