Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9F3451992
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 06:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790578683; cv=none; b=QlqwWiHaSu17iMW4uWgG5SjaJiqZgblt2NKOaXU9eF1ei7S4wn355uEwYe5mNqSVCt5dfIEolLl7T2SNaE9rxOxq4zjlKGMeX4PTl+aLfgcJqm/1LsguYHuwjTy1MjiG+KzqNTMyCK/sJsJQpXTvdh1y6KI7PARAPDwKHu3yUtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790578683; c=relaxed/simple;
	bh=AwQl1+NEpG1Pb7xs1KjCw0Chz9DYVPv7HbUe46VITdA=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=nlKdJQDUXfBbMnCVhYIeVBA2p3Sr0aXdJjEbL0ZQf+JfXlQ6ruHS31Ye1jbI9Whi6K+jXrRIBCdAyTFgxBC8xipD8yrtWv8NN7gux4lWXBzRRU5r+o1A0wOC8GkeaIsCsbeaKO7UH/pW0v9bQSjw5fEQK+lvthpSNLC8ruUOFGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lpjJUmIy; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lpjJUmIy"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=AwQl1+NEpG1Pb7xs1KjCw0Chz9DYVPv7HbUe46VITdA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790578670; v=1; x=1791183470;
 b=lpjJUmIy2HQ2+svXU090hi5R8mH+8eVqZmIc2Ga5cU8QuVQ2vOYIJ3ASEO+nbi0+HerzVt9m
 SfG+JTukumWm4QeKDlj4cxzE17O+U1bRVpmiqeQaaOEEoEupHGcBOOIFVfU0WVFqNvxZp7YNpTA
 DQak8LgOldRueTOUco4NBG50=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f0fbdd739400b69e;
	Mon, 28 Sep 2026 06:57:50 +0000
X-Mizu-Trace-ID: f0fbdd739400b69e
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 28 Sep 2026 06:57:50 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <a074601a204af3b8bfea915589b660cc4a66b3db@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 3/6] wifi: rtw88: 8723b: add the RTL8723B chip driver
To: "Johannes Berg" <johannes@sipsolutions.net>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael 
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <2e378b6615ef4022a62989f6501018e689e5993a.camel@sipsolutions.net>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-4-luka.gejak@linux.dev>
 <39da13e5cdd840f5a5ab86ded478d07c@realtek.com>
 <DLN10FU8L1PQ.3NK0M6NVQ3Y53@linux.dev>
 <304bbb9a43a74e909eec0dd84d86d528@realtek.com>
 <2e378b6615ef4022a62989f6501018e689e5993a.camel@sipsolutions.net>

September 28, 2026 at 08:25, "Johannes Berg" <johannes@sipsolutions.net m=
ailto:johannes@sipsolutions.net?to=3D%22Johannes%20Berg%22%20%3Cjohannes%=
40sipsolutions.net%3E > wrote:


>=20
>=20On Thu, 2026-09-24 at 03:11 +0000, Ping-Ke Shih wrote:
>=20
>=20>=20
>=20> Can you reuse the existing since they are the same?
> >=20
>=20For the record, if you find yourself arguing with an LLM (which is
> clearly the case here) then feel free to just drop the patches - clearl=
y
> the submitter hasn't even bothered to understand them.
>=20
>=20johannes

These replies got too long. Sorry about that.

I'll stop arguing in mail and just rework the patches, then send a v5
that is easier to review and addresses Bitterblue's feedback on v4.

Best regards,
Luka Gejak
