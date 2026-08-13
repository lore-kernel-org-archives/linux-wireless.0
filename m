Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D80348167F
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 16:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786638210; cv=none; b=DoEjAlU6r4BFZ5Irb4PuViunyYNv9kmMUD/6wO1husdIhLqJQzO8K+gVVDpTNOTfcQmYHGQgdmviG7nJDHRWVeQtAqjpMOu5VREEQ5IL6m9y48LssgTWBxxPo1oZGb+excRNQuR7a/mHehDIZZkdaozNyFkhURhj82B0ZCFH4wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786638210; c=relaxed/simple;
	bh=J5oX0TTydYQm5s9SE3EpN4P5NGGstebvcoAtOJFAX3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kD6CDr5TrjZRYrNvAJHLNtweAY3lrYS1u0DnOHaLANPLuG3vbENNp8rZOskgFhjjJ3r0+MVC2T/iw/3uXnqrE7LEkjX59gwQeFL501jEeNkUAsw9qOxhVBontzv80v54llDlIf0h8z7+GbC59JIhOeeAGpD4m9MsiMl+Gb2Zdng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HEJTsvbs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EU/oJ5hv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HEJTsvbs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EU/oJ5hv"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67DFUKe03051346
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 16:23:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	H5cRTTHqlksMdYebDLk7D8znUq+PbG1zkgFfzQmI908=; b=HEJTsvbsQadE5buc
	5XAkfNmgvnlXmyjXSSCddV36MzoP3oeH1KhWVSWVv7JgZsNSzsQnHRR3b2ahTXKF
	6T7zR8V/2R2JMtE5qUmNHMyrr6+yyaXVI7Kp2IY/4ML5oRVB789HemLdWfNeR8aD
	iDg4g0we8RrveyGdtXc1Oo55HzayLpZIm+M2kxknzy6NhAswBglPCCIk4UrTwUed
	nXy5KGyfPQLH+cmL7uTT4ad0/Mi5TK4+PmjazXsSOeThO0zILyJpvAoedEUeDK+H
	4NTvcA5G4eRHiJxBcQ5NeJws4pI7pRm7QyQ0YRZVKVeCX6WQsh4/bzMuapC9mbUC
	lMWedQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g1fg3rnre-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 16:23:28 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cca3673560so1501905ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 09:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786638207; x=1787243007; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=H5cRTTHqlksMdYebDLk7D8znUq+PbG1zkgFfzQmI908=;
        b=EU/oJ5hvrVhTkgQo5O2XpT+BInmPkx69QM1wYT0SyCMT8JTPQzkKJEyulKcftTg0wV
         F+3u2WK5ksUP/sy/mW+XxgwhrOnuZ3cvS+hZlUwAnHe3xwExYGb2urv4dNXnlPKUixpu
         gm3MJfAj6IGShBfIJaygO3sDQRwlhywXxW7Izx3OPaMAnVsmEly538tuF5dIS8lg5HMK
         lIHpaP2DZcYoh80oIZiPS5cygLBFocu0iRSDs5PplGL5mtdtOFz/GgIQOVqSQZyP+zW1
         XeBIcgPzTEOQqN/IEUkQVS2K3Qohxek3Ouzbn2diaUHuQv9/g6y+z9BLACdJqvgRCmwU
         q0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786638207; x=1787243007;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H5cRTTHqlksMdYebDLk7D8znUq+PbG1zkgFfzQmI908=;
        b=YzoRbJdXfXy51nIAvMXM3pjUzTR0i7N6pdog/uYGU8nllWY9sA+nDNuR2WToIbEk48
         C5q9wwTE+urH/9a+i5w5zw9jQxGLpqZWMP29b9nrh4SLH22LLWkYr42nxuwuNXRCt/rm
         TO6S90oo1Z9HD/HI1xIGsmdNx0Y2gJZEBcsb5hDNOZvkqxxKE43tV7/0UlJdSH4Mhpjk
         +YBHEq2cEnlheTaxP0a+0Re16S7wT1gNNubfY4hGeanT+tUQCzwnvXHTJG3Kus1v3L+k
         6loPbsIwHiTeFsC9Sqcj3A8HbAVad9x0psyRYEMBnDG6bqcfIN9+iNyYgtG9H23M/Z2O
         GSPw==
X-Forwarded-Encrypted: i=1; AHgh+RrHj1wS5UE0v0fePSguvnPF+DU+64E+3fzzJBbd72h/PabnPiVTnw3dU7Mp66MrVGwSaAArx7iXay/rYeBP1g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWEstMjnGL6VLcRJwQNNRH+kVAYJYL8wrD8PXrp7VeqnqhWSHi
	O/BUTt1xX1WX+Hrljb9JRR5HWru0l/hRzpriCOnfD0wvEHs+APgrZxkZvDy7IdnXHW3BMjrI8gn
	2SXbrzrukd8kSiFy5Q8ia+K1as0huyvY53wrcWFaMSZ7xQKqUXkufVmr95bdeWRddSug4KQ==
X-Gm-Gg: AR+sD11UKnuL67a6Y2g+EkpXkmjnPGJZsftLRna17CNOo/W22j1PVXVIhRkTgUe/mb7
	To5IInLlRr8NFdTM+Jrt/dbmzlUaAE85A52AJ9D8UMjrdRsnW0f4R2m6iM+kd9ZFgxsbyrDLyTM
	rBu1v+7cbadsS189PRS+HTeyBN+cukTcAQR1jePuf82gdLfkbIqGvOzPqwU8dV35ORazkXNLDgv
	FG5RHld0StPi+0+8wrvRTp88gtRAuJw85aDIgQ97y5oVtZAVUT4suv4JfJIjwOdNT4txg+yNWZM
	fWc65AgjuFZsEEDXyJo48WjSlxy/NTeVpnSrZex1LrIRcu1RexOWcUOairL4ffCKvtWTdJV5hOV
	NGR+OQTttBsqulSqdulIlF1e1yn+uImCk/ge0YBSQmiBKitJYi5CaOYbdVurZ
X-Received: by 2002:a17:902:d4ca:b0:2d1:1f73:3667 with SMTP id d9443c01a7336-2d37d538406mr75749115ad.1.1786638207322;
        Thu, 13 Aug 2026 09:23:27 -0700 (PDT)
X-Received: by 2002:a17:902:d4ca:b0:2d1:1f73:3667 with SMTP id d9443c01a7336-2d37d538406mr75748325ad.1.1786638206748;
        Thu, 13 Aug 2026 09:23:26 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d37c2000bbsm13062545ad.7.2026.08.13.09.23.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2026 09:23:26 -0700 (PDT)
Message-ID: <170a200e-f0fc-4e8f-a7c6-72294beb185a@oss.qualcomm.com>
Date: Thu, 13 Aug 2026 09:23:24 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/4] wifi: ath12k: implement custom wake_tx_queue with
 flow control
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        jjohnson@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
References: <0b72231d-59f8-49bf-82a0-76d2c7862729@oss.qualcomm.com>
 <20260811111405.397112-1-jtornosm@redhat.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260811111405.397112-1-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=NsfhtcdJ c=1 sm=1 tr=0 ts=6a7def80 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=7Mwv2mn7B_PKH5WITEIA:9 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDExOCBTYWx0ZWRfX8WjEgTov9Luj
 EJ+m4+3fcwPayRgBdPvnlSRnc6SJ5oYmemQor4+l5yj4bzVasARHnpv0KuF7SnJYQsjSnUBj3Bn
 RdwvFkT8naQ+IC4n3IdxAX2QxnnBsCG+KcoKU4H43U1lOdA48jyFAiXc0jSXNHX9AIxm7oLI8/Z
 oW9dI1bpYLYuSwGjqlIyX41U64qbAfjbqvusc+5nC0GTeji64DycVcBQRtisb1mZIdRf9wb2RR1
 /CejOiUXyLnDgtnUtO1FoiA6cU+3SRUlGfAxvKSMBkto7MMo3uELEX11NnlLI9fHcs7i90sQ4BM
 kAUnoZ1mpbcSPdWnMWtU5PAr/hraCDEsuXekEWq45u3UVVLNNL1cs5+cHWWaSdLzX5gPav88BL7
 4O6aqFaD+7kDfVejNK15foNew0de9zKdiHN3+juFvlFtaO5mSL9TGFMkt0MmqOZ3hAQxAXoTvt+
 hrqd1Pe16BhHoApwumA==
X-Proofpoint-ORIG-GUID: P2U8Sybaj4MH_WatXsFBOMiG3x8_B_7P
X-Proofpoint-GUID: P2U8Sybaj4MH_WatXsFBOMiG3x8_B_7P
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDExOCBTYWx0ZWRfX9j1aay8PPUrL
 y4OPGN4/U2AYu5f6bm2xBwu/IRwsl80YJI9F984rYfiwo7iTSRBeqkCJhXggDuyT6vhHorvoewS
 +OB3h3OIDz1viT4biOJlWz7njsM+QbA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 suspectscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608130118

On 8/11/2026 4:14 AM, Jose Ignacio Tornos Martinez wrote:
>>> +		spin_lock(&tcl_ring->lock);
>>
>> seems this should be spin_lock_bh() to align with all other callers in the driver.
> 
> The outer spin_lock_bh(&tx_ring->wake_tx_lock); already disables BH, so
> spin_lock() for the inner tcl_ring->lock is correct and sufficient. Using
> spin_lock_bh() would redundantly disable BH again.

Yes, but if that outer spinlock is ever removed, the inner spinlock would no
longer be correct. So the defensive pattern is to use _bh in both places, and
both of my AI review agents concur with this practice.

/jeff
