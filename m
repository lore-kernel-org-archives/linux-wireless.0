Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969F54A3412;
	Tue,  8 Sep 2026 19:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897019; cv=none; b=fOfebNAlecdBMCQ5aCYTfRhmD0m72Jj2nU7ivORZtjb1/eHH02c+EWPsuMsWV3PKwPQYGkLVSUDG0idbdYZMzRYbpuDLESCohyLg21v06x0V1rCXtd8JT5Ld4RdptDkOeGeccMRLCilEg6AJvDfDI9qf7oc1w/MQ0VMot6h62Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897019; c=relaxed/simple;
	bh=JZM9zKUqYPSapJ8UXPz32Q8jCAkw1btM4R1j9tAbkBk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XA7pLZr4iwzf75LYdaKEYreJH0jGm0ZdcFU+DHlv2T27FiQH2OFFFxpw8ZlqRFYJ9PbPj4mnE4ovC8Hvo+UDEE8yQq6osW3B+tGZTdYYD9M/+BSzak4Tv+31BCheJitGgJiYOQBuojh/5XyU88GQjpnAQfpzQIFK7rxqobO6oeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QWUn41hG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QWUn41hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D1D1F00A3A;
	Tue,  8 Sep 2026 19:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788897018;
	bh=VkwdxuDr5HCKGJgcfNcm2WkTWuKxbIPO+r1JvSTy7ls=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QWUn41hGLpWa8i71n8tl7viKeEIr9GcDz/stRdpiHUcT2WFSMIHybAOjG4A1VN3uo
	 QI41zWtNlre47BhkKGeG7A+nsm653kg0EgSZ/u2Nh7F4JIKENWSOHGNIKLZp1xuHMZ
	 YrXK8iOWQ1orFYJvze4+FpQM6PUhIjaJSSaKShh2N8a1apkkPb976hwPjqlUovhz9P
	 RiWKV5S1Lnf0aRt3vI511vaXXlcx7I/hvtfgxO3I/ZVRmmO9Gl+Dybi45cd9kw694/
	 qeEN1hQuoClJdpMxDJ308z4SeMoUCz/A7Wbl/VRH9mVrBMs1T75ac/uThzuAKIVlQL
	 sqGagoycGh9ew==
Date: Tue, 8 Sep 2026 12:50:17 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Johannes Berg <johannes@sipsolutions.net>,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org
Subject: Re: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility
 Domain (SMD) AP support
Message-ID: <20260908125017.0fb226c5@kernel.org>
In-Reply-To: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  8 Sep 2026 22:39:28 +0530 Pooventhiran G wrote:
> To: "David S . Miller" <davem@davemloft.net>,        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,        Johannes Berg <johannes@sipsolutions.net>
> Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,        linux-wireless@vger.kernel.org,        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
> Subject: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility Domain (SMD) AP support

Why are you sending this To: core networking maintainers.
This is wireless code, what do we know.
Drop the core maintainers and netdev@ going forward please.
