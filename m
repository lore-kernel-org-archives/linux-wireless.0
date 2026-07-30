Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A142D839C
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391764; cv=none; b=AyxxYTmXlkhzC9Uu1UP/J/Tu3MBMFy+qr+M1MQa2doqpJZ+ICRpHDFbqyB0UT5+utYyD+UIC0AsI6ImUtqw/CnjPe9/uuL1Otq2yHXv4HWFaYTPxWQiYIxojLACJSqd5KE1sXvVH3HzeYHgC0jaxSKv9pUkvmNaFu0zy5iyxuOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391764; c=relaxed/simple;
	bh=Tn5a66s3H0FPQI3uq/BYxBlhm0kMV3gcSbpQjDPJAYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9KD2VaWSnzSh8v30x03OUYNhF9qsNrn6m3aP0QcXJXQDQmfv9lt3xsTMFH8parknMuyb0q3VTp8w7cjW83o1SdrZUJX6vqiL7TmA2yAAVRd3RX7QSCCzQmOcyST+cDcJZKcNPFob2FmMKfcDdOueHCKjXK7SAQs9kBU7MNW0m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FApAlkSx; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FApAlkSx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tn5a66s3H0FPQI3uq/BYxBlhm0kMV3gcSbpQjDPJAYc=;
	b=FApAlkSxCwEgUwCyo2R8O4oBV6DsV3eHpsf98a2bYbn9MqnmaFaFK06A6/JI1wUQ/TmHxs
	SH1xCQgFFUyrgGjoH0I9na7oo1x0zaquAzYq6CqCLBdnzPo1nSIAo2iqlPnbtQjQKTHBvO
	ARLNWW/ZEXZAjDGXzpqRActT01aWMRc=
From: luka.gejak@linux.dev
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH 06/19] wifi: rtw88: fw: send the media status report in the vendor layout
Date: Thu, 30 Jul 2026 06:08:51 +0000
Message-ID: <20260730060903.30187-4-luka.gejak@linux.dev>
In-Reply-To: <0e1c1d85-6042-4464-9cd0-c93d0a4a2f1c@gmail.com>
References: <0e1c1d85-6042-4464-9cd0-c93d0a4a2f1c@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 25/07/2026 02:52, Bitterblue Smith wrote:
> rtw88 doesn't fill the role field, but otherwise the layout is the same.
> Not sure how important the role is. The other chips work without it.

It makes no difference here either. Dropped in v2.

Best regards,
Luka Gejak
