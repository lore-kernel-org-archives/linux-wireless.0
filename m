Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4473633120E
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391760; cv=none; b=UuOqtyYTv72ECBRZZRddR6hgMT4K6C1R16y2dkVITWNCnNmJCtjljHdAOxHFDowTDzyYxyS9CoJ93LO0aIFdydzeMBYQNYpUQidcMYk13G7B1RmmVNKHipOsedG6AOB20C3kRlm409o/1tBNi0UuxgjqiLH+eV3Q0Wfsxi9r+oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391760; c=relaxed/simple;
	bh=CPIdbHK/+pjcS9hyMlVzAL86BVxAOupMx5uLWBEDeIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLAFgT7GMkCxiv8i1D04zEGOJZgh+mV9xrM7JFhKRmgunBqChJJQUfvzSTExK9/ErG02/GZlCTnciHWLB0suY7MsN5dCL8oFWx86dpuG5BbU9LuOBfcyoaqzPvnhkUDaebw06KsT6yWO5GOTBbOMcqlf3UYOaIb9zUX/NyNCyzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BilGfeJ9; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BilGfeJ9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CPIdbHK/+pjcS9hyMlVzAL86BVxAOupMx5uLWBEDeIY=;
	b=BilGfeJ9oQ8sM6yTM741etMkh4iypqC8wr7ZL1psuW3OI99bMhXEHDHDIIPArPuAnibehq
	bQcsZ7vzXNcYG6ZYjdKjmyW4HCzjVwWBqmuyS4XkZp1jzfRjmx63yn7/OdlwK6SYavBaCb
	bQTbUpoXTzIZKA+43V6Sr21CsdvvS/I=
From: luka.gejak@linux.dev
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH 02/19] wifi: rtw88: rx: mark zero length packets on RTL8723B
Date: Thu, 30 Jul 2026 06:08:48 +0000
Message-ID: <20260730060903.30187-1-luka.gejak@linux.dev>
In-Reply-To: <e5cb3bb8-065c-4829-8743-f250f66f0eb1@gmail.com>
References: <e5cb3bb8-065c-4829-8743-f250f66f0eb1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 25/07/2026 01:34, Bitterblue Smith wrote:
>> Like the RTL8703B, the RTL8723B reports receive descriptors with a
>> zero packet length, which the vendor driver drops outright.
>
> I wonder if this only happens with SDIO? I don't think RTL8723BU does it.

I have only seen it on SDIO and have no USB part to test with, so v2
gates this on rtw_is_8723bs() rather than the chip id.

Best regards,
Luka Gejak
