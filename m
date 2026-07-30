Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3BA3939D0
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 07:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397543; cv=none; b=f0LhYBKuRZCP6ALTvQFJUgp37T+kz1GL1E36TYQSjVWd81Knwuli3JLKQXIUNeCKEoPCNINXxkMe4HAo2HdjJ5hY71U5vHKCFbNIHZeDwQ99fIsUoQTOjnCL4FAPOnxWof43Z6attR3fARgvSvUWQ3iPsPEU3lgOjeGgRCrriCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397543; c=relaxed/simple;
	bh=4Tbqk7oOyLiiJbxKIi/0D2BTXdXVOZq5Fo6c+vBZsB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxyzV9R5P5+5GGJ87RdAa//mtCX4lRXBup717QEGY/yn4QBOKulZbx3ZB8unKeSKS6kqsdwNNnr4yYGUXtKFNxipBAyfo+19BQQk1SiG0MMrIZ5wGUU+Q6iL+3+8/npzr5oAoqwxArfIb6Prh36Tcm35VCIG65U0QkHPlBjCyww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Od+4NhdK; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Od+4NhdK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785397539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=78TOQ+rSHEAJNnw1dA6AKkAyKpqLLK4cRhatATDorvY=;
	b=Od+4NhdKMPiHO8T5AE7QpmkiMoKuAuU0ummbne9aAhHKwL6TNe04r8czhlaDuh+0e4swWy
	bSXjSnw8RmqLVGdg8kG8sXe5v+cPhQEzORUauxVxYAuXGz9RX/i/tOcwgB1dp+qxs97GtE
	9G3aOhqZ5b3bz4p3AqB1yjITEK262TY=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v2 06/11] wifi: rtw88: coex: reassert the antenna path when associating
Date: Thu, 30 Jul 2026 07:44:59 +0000
Message-ID: <20260730074504.19725-5-luka.gejak@linux.dev>
In-Reply-To: <67bd17b405084af29d4d07e855ec5b60@realtek.com>
References: <67bd17b405084af29d4d07e855ec5b60@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 27/07/2026 08:21, Ping-Ke Shih wrote:
>> +/* Replayed immediately before start_clnt_join()/auth: BT_INFO + PS-TDMA type 8
>> + * then the forced WiFi PTA antenna path, so the auth window is clean.
>> + */
> 
> Comment style.

Fixed.

The chip test in rtw_coex_connect_notify() also moved into a single
rtw_coex_8723bs_connect_notify() that the common flow calls once, to
match what you asked for on patch 05.

Two other things went while I was in here. rtw_fw_query_bt_info() and
two of the three repeated PS-TDMA H2Cs in the pre-auth replay are gone
(see my reply on patch 05 for the measurement), and
rtw_coex_8723bs_restore_pad_ctrl() had a keep_pta_owner argument that
was true at every call site, so the argument and its dead branch are
removed.

Best regards,
Luka Gejak
