Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2334385D79
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391772; cv=none; b=pkGp5PkG8wjs8mAkxxfm0Q9XE5MrxvVXLQB0f7O7e4ymIpmH4HhlRj8P0EqflVZ7oqCwBbJNUQIX/bsCzpdspIdFz+ZmK5cDzDXxRi2fS47CsPsv9+QKyeEoIcJvkTUwBF0nxky5BUKIp+W5utCPDRZOwwtpxwyFr7Liim4paRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391772; c=relaxed/simple;
	bh=pifqdQNztAAvApwCg98Rx1gniYjnBaU31zxVFz/FeQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZkyUE5pqa8QYvZWabgLZtqwa8/PUONq81G0A9a4tYi+CzSxs/6bxc0dvlRR8F5+MpZ+Cr5vaAaAfmdY9T0YRUIuIcRt3rbxKB+Nyb16X2AqFg9yYT9V8ItFlFXADtxZLlJq3QsxWKz3zUlPCUrhk5H9GMWUP6xeLeNAb9IgN60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qNBX0KZ8; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qNBX0KZ8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pifqdQNztAAvApwCg98Rx1gniYjnBaU31zxVFz/FeQg=;
	b=qNBX0KZ84oXXbny/GAGpck8aIh0ssG77Qvs8p6kohTCwF2Ay80i8JtzkQgcXHi4eLIHg3P
	KIVz/DJZ2iPmF+Yj9tg7hWeNBgE9nJ/5dI6FpffjwlXrID84AE+UjL+tLvXqN3IqEme8k6
	JvM06wWdzahzXBVkl/hf5q0Iae24Q7o=
From: luka.gejak@linux.dev
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH 18/19] wifi: rtw88: match the RTL8723BS firmware connect and power save behaviour
Date: Thu, 30 Jul 2026 06:08:56 +0000
Message-ID: <20260730060903.30187-9-luka.gejak@linux.dev>
In-Reply-To: <fe9a4df1-1ea9-44b6-8f98-10130d37e55c@gmail.com>
References: <fe9a4df1-1ea9-44b6-8f98-10130d37e55c@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 25/07/2026 01:10, Bitterblue Smith wrote:
> Does the firmware really care? What happens if you don't do all that?

Nothing changes. Association, traffic and reconnects behave the same
without it.

The power save half I cannot justify either: with RTW_DBG_PS enabled
there are no LPS messages at all on my setup, so the gating never
takes effect here. Both are dropped in v2.

Best regards,
Luka Gejak
