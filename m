Received: from mta0.migadu.com (out-4.mta0.migadu.com [91.218.175.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67A43BFAF2
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 08:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792226181; cv=none; b=N8tWO4Ia32tofEpFOupuvgtBSn+kKG2VM7/kM9Jn+phJQ2LMM+rhvF30REmzHxH3A53dF436/0yLSQIL3f8zk734T4DhLR74KE+adwS99bayJ/t8Oh+IbkSJB2FjtyCTo+d/UL7Cn78c0TW3KnQM1WNGJh4s4i8j8kWz09FzfYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792226181; c=relaxed/simple;
	bh=7pOi1ek2mAzoArVRbCeDr8pcNT4Z2McCw+iFhA62++Q=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=YJEBp1P65iNOR6VMIziKWmoshPyRcjg/z7nnc7SLjIxXOTSrlGqaxMCgxZr1d6VqQr0lDF8Pwbh8b3K+yLkEoh27Xn39Sc8XCRXuZzwMvLJ830jc6zvse7rfVMJq4z8W0/oRBPHE2726sNKB0VaRjv9cYiLm9wX7uUIjIh/J9e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KWd7EPpB; arc=none smtp.client-ip=91.218.175.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KWd7EPpB"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7pOi1ek2mAzoArVRbCeDr8pcNT4Z2McCw+iFhA62++Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792226177; v=1; x=1792830977;
 b=KWd7EPpBqFHEpzv5OhjRF+GLx9NB5PFWPy4+6oSLcgPUwMoOzusKbG/46sZJYwgG2SwAbIiq
 G3FFGnupotZEgc3QGK+yXWbM28pDhjeTnzwkz+aW2XOWphR/ku2w6UkXtadcMFmC8tBMcIaViIb
 HyV/XttOMABms4+9du89/Ut8=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4ba72de6d90a3fcd;
	Sat, 17 Oct 2026 08:36:17 +0000
X-Mizu-Trace-ID: 4ba72de6d90a3fcd
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 17 Oct 2026 10:36:13 +0200
Message-Id: <DM6Z5LX41ZDL.173GZOBL49FTJ@linux.dev>
Cc: <linux-wireless@vger.kernel.org>, <kernel@collabora.com>,
 <matthew.leach@collabora.com>
Subject: Re: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted,
 poisoning CCMP replay counter
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Luka Gejak" <luka.gejak@linux.dev>, "Bob Beckett"
 <bob.beckett@collabora.com>, "Ping-Ke Shih" <pkshih@realtek.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20261016191100.1781056-1-bob.beckett@collabora.com>
 <3839685695b77706f39cfdef192e1d137e9d46bc@linux.dev>
In-Reply-To: <3839685695b77706f39cfdef192e1d137e9d46bc@linux.dev>

On Sat Oct 17, 2026 at 12:15 AM CEST, Luka Gejak wrote:
> Hi Bob,
>
[...]
> I will send a patch that fixes this part  so you can test it. It should
> turn a dead link into a dropped frame, but either way the test will tell.

Followup, here is the link to a patch so you can test it:
https://lore.kernel.org/linux-wireless/20261017083313.56113-1-luka.gejak@li=
nux.dev/T/#u

Best regards,
Luka Gejak
