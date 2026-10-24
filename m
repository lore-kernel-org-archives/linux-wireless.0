Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792852272;
	b=DWFNt3aORV9vBjhht447u5WY1HpoqXSZAeDhcTrWEdlZzyR2isDVauBs/JPjfPT2yepf
	 k1Pi8h8/2AhzR55SMuHgsM3/WxUXSt5Ig1JHDTzr/5pNoRAZN5Ob3y1yec+lkRlGkzetU
	 NMBHIe27HP8TD4QKYeyyKyG8mq5QdKlKv42EpoK1ksPUmD2rN0kE9S2etB1Bsl3roWa5G
	 JkWHvZGd0JptbHTpVvLbaiUbnzHIgjtmCmlEKmk9MluSDK0R3TqVvYf/r/TjMoh+tVXju
	 jOB3M01V9jl7au9UcihSYlW9+xKoS/sW4rHaFdo7GHiQ/J+DEK0+SwoYG7GN1GViBEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792852272;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=7zPquDCtZyzOA5PY0kmGl8Aq5WV/QI7GoaYVVezsWQc=;
	b=LbkEB7SucsVoDAT1seQ2eiLwVZXTBg6CDLK52+l8958LuvTficEqjwuJHwDDvulu8YIT
	 rnvXEc3bEVsiQN+pioQ+sZppXdiHdDv/pnI9K7fY4NBcWzlTLdqBrQ+gZSs/ReZBozdsa
	 10fc/WtVUd/Zw8/S67pVZBrtLPD0vuH+2HFuZ6JNRQsEnzc8xlR6mRlZrGlGO4rgwryIc
	 APHvqhNmATzhQd6Hs8VcYIc2wg+ueLz5oNnnzHDGyw4MTvdDqGJXFHuX2BhqcLPgYOGIY
	 OO2WXUUWgHUfmU+uq2hFvXmrygbU2HbBuBrlnMeeSQG4ngZy+Uydp1zEqb7+9spFdMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XfUjjjhg;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65096606A31B
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 14:31:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65096606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XfUjjjhg
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a218c463d1so9108265e9.0
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 07:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792852271; x=1793457071; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7zPquDCtZyzOA5PY0kmGl8Aq5WV/QI7GoaYVVezsWQc=;
        b=XfUjjjhgRU3xKHOnn3z8d46bbr73JjAC8ug7xqkXxnNxWiyIHSbEfMKKkXKSXHBBTu
         aRh8PW0+GS4VIeLumDDnmmdR23GxI6OYLl01+SOZlj8bCUzG92sqfdTGJ5pWUbYaJ/zY
         y2mOBofxl26k90BbgSlGM6l5RU0cXFFDAU5685pIDuam9ny0mG10H8yO29Yj5hvvewIb
         K94fwYOTZyiI7Qbnik8/rRtXkV/TDCRVYkLrNyY+jmbiUt3GWQ0nPKeujWv9WwM9EKJu
         sOqpl0HVfT9qrjAJYg6k+jqIJ/H5L//nEcYrXn6YR5oGdKjsUKD7r5WWkU2jYczQoY/f
         s/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792852271; x=1793457071;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7zPquDCtZyzOA5PY0kmGl8Aq5WV/QI7GoaYVVezsWQc=;
        b=xx+T0CuNGPJcyBP9NyuhmlmqZoSvmnQC7jyxWqkm1m702k2Ms32m6MUkPri33+toE3
         5LQshKKkactJePA4RjYkfiu7CVgdSDHCJ83XAIpLLv71Q5aRYOafqmVygS5Ef5+erBDB
         ebk7LXrJvI1ZWayYuOyoZ6v+nYIhXKtTD38Oxo4tNGFJ5L5bPKbbcnGNpI2Ijy215FIM
         B3sAgDLegbFqKczs3N+H/e9Z8e5xBBFtrp5FM8MLRm2xz+LRAyKOpMweP8Ah+8NObCHJ
         VpRHcoYbRbYZAcaZaMbqi1psh4boJuzM7drftMvyX/8CWV0FqZLJoMvmAkSVLsWogWAh
         1QiQ==
X-Gm-Message-State: AFq9FYKEWagVhqlKFADj5EZsO80GeDNfykM1ab4A8QQHcCrsIbgQCv9p
	xqqmtIfI7WiLH/IAuDv9nQfsmW+O1TR8TQbVi6rxO2vYQBP+Wk8W+UDk
X-Gm-Gg: AYBFou2JTcMKck346SxwwYlnWLWREpUgJKu6iJFuMHoig5VrVlEO4cSpQD393gYlYTu
	Ul/tmsF7vBtmDyJ5bOBvdL7GnRIy84S/z8FQqfGRLhhYbGGaqzYGgxV3OhPSKT0kjlibCSdBXeo
	gsHrIa7NeLeOCjtU/fspmt6yyFj5kxBeqyYTXXkStXPs4CmxGIspet4f6BqtZchFNdt7sAbOGRh
	eUoiw0iIJcPPsREWF6Nbk9/wwl8eNIVg3BaIy2a/RGb5cvRFBKNqWdm/rnBED6JMaSxy4BuQy1Z
	zz450NdGwj9cKL3nDGASkrpqVNteyCNVKDJUD6eXM0ZspD6dXxFLdSx6xLPQvh0vcG8xOMMBlx2
	M4bxYhvw45zyso+cbAyv5dIxEo0KCNYFhAnWboEWh3gTijSyOCb58qZFcg3O7hOF26G1ntZdkQT
	jUS0TwMWnC7483HYCEGXy2ZS1fBDKO8VHv1qcF5OYEcW0ES8/7gJV05Ys7WC+pkSUTWk7g8wL1C
	Gbt6ZGj6DCh4CSyb5fsz87TilH+0zW52YTaCQV7ZdbyDBUY9RTNqOIH/Fte8oiuY/mSWJ63ZzyL
	u5ylUVSMIaFVOH9vaXoQn2vRBkTO+w==
X-Received: by 2002:a05:600c:4f4f:b0:4a3:5a42:b29c with SMTP id 5b1f17b1804b1-4a35acbc00bmr34586575e9.26.1792852270605;
        Sat, 24 Oct 2026 07:31:10 -0700 (PDT)
Received: from [192.168.1.2] ([31.176.165.29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a2d6f6fsm56502995e9.12.2026.10.24.07.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2026 07:31:10 -0700 (PDT)
Message-ID: <b441d4fc-e0a8-4952-bb7e-c3416a040daf@gmail.com>
Date: Sat, 24 Oct 2026 16:31:09 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mac80211: hide tracepoint definition
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261017155509.128114-1-omer.e.idrissi@gmail.com>
Content-Language: en-US
From: Omer El Idrissi <omer.e.idrissi@gmail.com>
In-Reply-To: <20261017155509.128114-1-omer.e.idrissi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

ping
