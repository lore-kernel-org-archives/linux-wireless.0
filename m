Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A9B3AA4E8;
	Sat, 17 Oct 2026 17:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256470; cv=none; b=kFTg3I0uj9wagVdXtD1KEtbyQfGn977Fh4kheOGKZq2kMVqojSqUOURC33/8dPJJnvE3gcFVkR6HYpkV7IcP+s9IG7KjTiTl5Np0ukh57iogLLfpdzUDBZYkZwD7pkz2Wzi8HIT/O4LKTAg7PE26RZ9BVm2aUOReVKdqGZK/KqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256470; c=relaxed/simple;
	bh=7IyPBT2vPE9m2BPsdcRe+zvNvKk24JPt3ELwaOMmJoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G2ixEi9sSL2B2/MIEQ+fHC4AIqtXF9sMWVcxxA4h99futD5ySAB77LQ4DDnVkMQemZhFnKR9FmjiKqeSvy9FtOfQn/eLbkTP9pQRR8pqTz8lfwCc4zWFs6yIVD4TPZ0rA3T0EQ3PvGdifPJwfChZwpXTf3ifTIp0Ig4TTmV8Tzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gl5h4+21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gl5h4+21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B221F000C5;
	Sat, 17 Oct 2026 17:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792256468;
	bh=0DmjvHLfi4rX4oDVLRHrraRfixBiGRCaeJVcON71fCc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gl5h4+21xkTA9HLQn4DCTs3dAc+/A/QPpnLU1SnPGP/SZuZwzQCZD5wRkLZ4x+0Fn
	 ZsBaGWHLcbySiBu4SZ9zF53I31dkjHvaWTBp3QpuFWsoYrB9BHHE9W+ebxm/ty2NVe
	 0jIxPi2ImaHKinHaFjyFC/DONvjUn6MPiid98ZGRVf8qnrS2XMEKKEocbZ83bAqPC4
	 zHhZ5u0AukVJbeIWN2H+a0rOoYwY/Ta8jN9R13lJOPzzZt3VoRy63G5OK4qKBmetZ6
	 hnhXxWpl9yuKL1IdMUm0B44RlTcKbwXlMIbcddd7uJrTp6x7CD1So2qvWmEHTwY27C
	 bGSiGeyptPOEA==
Date: Sat, 17 Oct 2026 19:01:05 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ath12k@lists.infradead.org
Subject: Re: [PATCH ath-next v2 01/17] dt-bindings: net: wireless: Add
 QCN6432 device tree binding documentation
Message-ID: <20261017-exuberant-benevolent-gibbon-86a45b@quoll>
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
 <20261016-mpp-bringup-v2-1-f510c33bfcf5@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261016-mpp-bringup-v2-1-f510c33bfcf5@oss.qualcomm.com>

On Fri, Oct 16, 2026 at 08:51:38AM +0530, Aaradhana Sahu wrote:
> Add Devicetree binding documentation for the Qualcomm QCN6432 IEEE 802.11be
> wireless device.
> 
> QCN6432 is attached to the WCSS Q6 subsystem and is represented as an AHB
> platform device, even though the Wi-Fi hardware interfaces over PCIe.
> Document the compatible string and the resources, including the Q6 remote
> processor phandle, MSI interrupts, SMEM states and memory regions.
> 
> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
> ---
>  .../bindings/net/wireless/qcom,qcn6432-wifi.yaml   | 149 +++++++++++++++++++++

Heh, unfortunately need to retract my review.

Filename must match compatible.

Best regards,
Krzysztof

