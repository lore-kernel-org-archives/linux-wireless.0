Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2599E35E948;
	Fri,  3 Jul 2026 07:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783062386; cv=pass; b=KNAzsVseRea9yA672QeJQdYGCnS9yfUW5y7j0S4HbWjXJqFnnzep5O6NyyCWrK7DRxMNwIk34qGzSPheLO6u7qd9bfe2onqkMN/24CD/fkU9QFoa0fWUOXNdaHaeKJdOYKxzsOHzDDo8GWWyH72mKiIn8+Z97PdYfdnMC/MKBxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783062386; c=relaxed/simple;
	bh=yR20nYYUJgcPA8IKpgnkq8fG0ppAXEcAY9TEpHBgdBM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hNtPT/1huIfyWUw6swIYNv95ycRL3a9Kr/7i2HagZUOfDa6/0jkm9ef119JNDcLI4/3gpIOHbRnYFS2UVqbgJRQWR4E3Hl/AbzWJ1PVU1V7mDRuEj2q7DoTUIbOvsFw8wzsDdLcZqfa3t5K9DVX3IrplEjt//2OhT+b8JVPvGxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=matthew.leach@collabora.com header.b=Mh05H89g; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=matthew.leach@collabora.com header.b="Mh05H89g"
ARC-Seal: i=1; a=rsa-sha256; t=1783062366; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=KY2pLqh0ZoupfiQRZu/231n55A+2utR1GmdaW6v/YDTW5xlwVeX0eckyzZ0BFlrLccHtwty1zlqYLXCxosMppEQf9gHRYplpfWo9/U8n6ti2ZyoKQv8uH1wXZInAARVsfGILfJB8fxPjN9VQEO9VoHDp6/0paEsjPKq/3D6bSf0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1783062366; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=+6pHyZxWbatKYOvCtdPwzFFfwFORFhjhD8Bmb0G9ebU=; 
	b=gbuZychvZJFfD/Pea2w8GZtqHyqzfV2d0E6kwHBDj9Hq6U3LGke7PmF+T42H6B1nmZQsQEMHL+sCbgfuvAbIX/rbfxQ0uKSg3DUzU+iMvqfvxGaXkSDD5bylR9BJ7Au8qrg1WCXQS3nErvY6UViL8VRSVUTMmQC1F/+5UmZnnE4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=matthew.leach@collabora.com;
	dmarc=pass header.from=<matthew.leach@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783062366;
	s=zohomail; d=collabora.com; i=matthew.leach@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:In-Reply-To:References:Date:Date:Message-ID:MIME-Version:Content-Type:Message-Id:Reply-To;
	bh=+6pHyZxWbatKYOvCtdPwzFFfwFORFhjhD8Bmb0G9ebU=;
	b=Mh05H89gDD/ygQkOhi/nOe+PmIAJuiAigKcFluPnBGaNiUVN5EGmtgQ5UUNgkZKd
	IB+CPUFQVOTPFR+cC23MeGgDoT6ZWdDwq2Eu5mQTmxT/ULCnoFDc1O9y/UulxQM9I5a
	3II1lYpB377sK5xRvMOTr5drEqxDBkb+o1iZNZqY=
Received: by mx.zohomail.com with SMTPS id 1783062364503160.63095399663666;
	Fri, 3 Jul 2026 00:06:04 -0700 (PDT)
From: Matthew Leach <matthew.leach@collabora.com>
To: "Nicolas Escande" <nico.escande@gmail.com>
Cc: "Jeff Johnson" <jjohnson@kernel.org>,  "Vasanthakumar Thiagarajan"
 <quic_vthiagar@quicinc.com>,  "Baochen Qiang" <quic_bqiang@quicinc.com>,
  "Ramya Gnanasekar" <quic_rgnanase@quicinc.com>,  "Karthikeyan Periyasamy"
 <quic_periyasa@quicinc.com>,  "Pradeep Kumar Chitrapu"
 <quic_pradeepc@quicinc.com>,  "P Praneesh" <quic_ppranees@quicinc.com>,
  "Sriram R" <quic_srirrama@quicinc.com>,
  <linux-wireless@vger.kernel.org>,  <ath12k@lists.infradead.org>,
  <linux-kernel@vger.kernel.org>,  <kernel@collabora.com>,  "Rameshkumar
 Sundaram" <rameshkumar.sundaram@oss.qualcomm.com>,  "Rameshkumar Sundaram"
 <quic_ramess@quicinc.com>,  "Jeff Johnson" <jeff.johnson@oss.qualcomm.com>
Subject: Re: [PATCH v2] wifi: ath12k: fix survey indexing across bands
In-Reply-To: <DJOE9Y6P3ZOV.371FAU647MOYR@gmail.com> (Nicolas Escande's message
	of "Thu, 02 Jul 2026 23:14:34 +0200")
References: <20260702-ath12-survey-band-fix-v2-1-75b5bdf72a08@collabora.com>
	<DJOE9Y6P3ZOV.371FAU647MOYR@gmail.com>
User-Agent: mu4e 1.14.1; emacs 30.2
Date: Fri, 03 Jul 2026 08:06:00 +0100
Message-ID: <87ldbswo13.fsf@collabora.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ZohoMailClient: External

"Nicolas Escande" <nico.escande@gmail.com> writes:

> On Thu Jul 2, 2026 at 12:50 PM CEST, Matthew Leach wrote:
>> When running 'iw dev wlan0 survey dump' the values for the channel busy
>> time have the same sequence across bands. This is caused by indexing
>> into the ath12k survey array using a band-local index rather than the
>> global index passed by mac80211. This results in surveys for 5 GHz and 6
>> GHz channels returning values from 2.4 GHz slots, making the survey
>> unusable on those bands. Further, there are redundant survey slots for
>> multi-radio/single-phy instances.
>>
>> Fix by moving the survey data into ath12k_hw so multiple radios under a
>> single wiphy share one table, and index into it using the global
>> mac80211 index. A new spinlock in ath12k_hw serialises access to the
>> survey array, which is now shared across all radios under a single hw.
>>
>> Band busy-times Before this fix:
>>
>> 2.4 GHz: 9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
>> 5 GHz:   9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
>> 6 GHz:   9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
>>
>> After this fix, times are independent:
>>
>> 2.4 GHz: 23, 5,  5,  12, 2,   12,  26,  5,   3,  1,  27
>> 5 GHz:   30, 40, 29, 27, 118, 118, 112, 120, 11, 11, 11
>> 6 GHz:   1,  0,  0,  0,  0,   0,   0,   0,   0,  0,  1
>>
>> Tested-on: wcn7850 hw2.0 PCI WLAN.IOE_HMT.1.1-00018-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1
>>
>
> Hello,

Hi Nicolas,

> I see that this is supposed to work on single phy device, but could someone
> do a proper test to ensure that it will work on QCN9274 split phy ?
>
> I know this is a big ask, and usually I would do it, but I do not have a setup
> with a new enough kernel running to test this right now.

If you're looking at getting this tested on a split-phy, I'll get v3
pushed out asap which incorporates Rameshkumar's comment.

Thanks,
-- 
Matt
