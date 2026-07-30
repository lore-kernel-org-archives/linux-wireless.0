Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DC838239D
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391767; cv=none; b=QXNUANeKkqjZ8SfTB7+70MlQnBOhR7kjmVA7AclgO0fZFqqDEbXEJIyHDJJNkRLks7IK9cg2gtbDOabFotnjQr3dZqxk79N9JT0rsDhIZMoKRhARY1BbazBYhEKf+TWvNEeVG6V5iLXyp5VaXG8613HdAeOjFgK1PjMKyGPxprw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391767; c=relaxed/simple;
	bh=iiefxBqWHARHs14lJV8lAotzwxPPxXeZlFhA/B+65UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hY3+xuO/nQe9hSe/om4xB8QVDJpTr0ZhHBSdKmQW33rpRqPerNT6hTuLFWE4kmyumbg1NDiyKp+oz975/8cEJaEMEA5olaJ0v957ce4sZ/uX8o/ZGFZHlRo0KDe+9zo6w/Xz7JkJNFufGXgFC62NwUDfnnh/j5UJfLxLEprpQRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W3xEbntN; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W3xEbntN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iiefxBqWHARHs14lJV8lAotzwxPPxXeZlFhA/B+65UE=;
	b=W3xEbntN8T5+q7oSj6z+uPis22mEekfR2waL4OACvRoxEkgKhg9aIk2OMnC+nBZGhTUogJ
	0UGYVyzknQZTv8ABFSwv10Qm9YDdiPKq3thL6/NstO086Ndgp+ijkajl2XNQ/Ot9+KUQF2
	jHXI6by4HhagYy7xXubj7xvAJqITz7c=
From: luka.gejak@linux.dev
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH 12/19] wifi: rtw88: sdio: handle the RTL8723BS management TX path
Date: Thu, 30 Jul 2026 06:08:53 +0000
Message-ID: <20260730060903.30187-6-luka.gejak@linux.dev>
In-Reply-To: <51ca65e1-93ed-461a-99ff-2e72488a3a6e@gmail.com>
References: <51ca65e1-93ed-461a-99ff-2e72488a3a6e@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 25/07/2026 14:08, Bitterblue Smith wrote:
> Sequence numbers work for the other chips. Have you tried it?

I have now, and they work here too: payload[6] & 0xfc matches the
sequence number the driver enqueued, 32 out of 32 times. The patch is
dropped in v2.

Best regards,
Luka Gejak
