Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793478845;
	b=FhVyBBrYOigExj0N4W9eAvjTO9SB4Tsq7dXcxw9a0liKzGlC588Cgt2PUFrp7uzNlYne
	 lXuRoJexPxtb6y1DdjU9Mk4c6TJD5phrl4HCEqt5qCZLWwGs+5S3GtZfmCGsseJhLHMkE
	 8c7Bj957ReYE3c8yPOyMhbzqLwtel0MiUKF0aHUnH7xUM/Fjzi9+tG759jtYxXM6Fdi1r
	 6obfE0/lenxI9UtPEfcjWRqXboZl7zUomTRsXfcugJlp1YGIoU2KZAvgOF1qOgE860i5A
	 74ilm7JwcZetfwAFhI5Jgpp7mbZUBZMZWPnPWP4zfmvbTqM1HcXRDmSMXm/r1MjwFjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793478845;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=u1+4nnRf1i9Xkva61km0GKadiZZAe35/Fj/lxJjaKFk=;
	b=YHhL8AOofeIo4S73dgyStsZ0KTseBjrO87+OLiNK8kZgmyZo9HRrwjDoqBRJAMLDyAyr
	 Lja+H2o/jgXFLw5obC0BTpw6BxOi/pLK3AvA4bGynS20rghjlpZpmteTAiF+DUWVpsI9U
	 R+AsnWU9BPkt7t6hShjRfEvah0uLANZdwbwzsjI/+do+urggtAsyqoIVq3T2t0PZWfOAa
	 Nb1lz5BThkeZ0my8cXSnzyh5Ehwu9EimQ/02ZGn1usZhvaLdlxZ52Uu+gmkcf2ZpxEado
	 DCQ1w8ac15Vo0Vpwb1DtSUnlC3C6fOE8YpuehCnXBx7qYzpeoyPJ0Hk9ojLQAE+xGNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mTypWbyE;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FTsPQAn9;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF033606A31D
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 20:34:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF033606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mTypWbyE;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FTsPQAn9
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69VJF1Y62927998
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 20:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=u1+4nnRf1i9Xkva61km0GKad
	iZZAe35/Fj/lxJjaKFk=; b=mTypWbyE7DNC25uq4Dl6xeMo/Wx5jLwWIV0BytVx
	G0YT3XnJVaVbuSKO937sS06Q9/NSvafcz/5UA1nrevHRY7V6n4I2hN/bHQNh4FSO
	EvEebdai5EEdnDT5G65XUyRGhuYf+3BzcFQNMIycpiTdfR9YTUik5lydlj1Df1Za
	NPteg5GgkUqUs0kRh/Ay1uZnhZAR+Nhx7SEuEc8lhAiYsfOvmBSA7epWt/FdLxFk
	VBwk6Vokpp2VrFA7lS1OCWsTNh1RfN4sNm7TptOW4UADQkhrExoohoeLVijd5rZU
	BTHNh3tOO45ANwInxiSrgmoIXP0LX6ehQYlM44ghSDOAhQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn8j2t1f3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 20:34:03 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93909014c85so387469185a.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 13:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793478843; x=1794083643; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u1+4nnRf1i9Xkva61km0GKadiZZAe35/Fj/lxJjaKFk=;
        b=FTsPQAn9tKuA+oH26Z/IwJZJ3slSKGjOOo7eGVtxuCwrqJup6gt1wcc0TvbKt0HkPH
         Pe/91uutfIUGmkCszjK8EpUdF+yNTERyJKTP4PeZKGpIWeauNE48o/gkqayQ0vNuTccd
         veqOzQMUTLJfwwCnSB358eAP6hM4yySKS60VhXM/xFyPWQSQJl4YlKoo15GhOPeMUMa4
         3EST+7WGxijgCqyELGWl1JwP+J9+udu9HLiZ4QpQNYAzZ1Nqvxq1qPbrKN0A7Es+Z1aA
         vzi2grfEjgFDJIGutJUUM/a9M9eHjnlprkvI3+EwQuZKanrkGtLHAOeeSZzdsomLW+uj
         DmAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793478843; x=1794083643;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u1+4nnRf1i9Xkva61km0GKadiZZAe35/Fj/lxJjaKFk=;
        b=yD3+OIwAS4NKkaf5JPS32klvHmBvJjyvrGGvQ1Lbcq3cmaEACSBjW+mCEPo0V4HoXi
         qqfhcDpDtg8arZf3bPOeUUdVKX0HssuoazHVn3DlIgztE4K+ctqR3B1t2szQVg0lnl2i
         I1z2Ihg7G7MhhaSC+UX4OUfTYYYG+lzEFQQXyTpdYePk9Nbdja+j6y+cTih90VkGZs5v
         5HXWzwzxvSX4mYsU7p0Zags7mPFELASDx7wbrjlvF5RG5It3SoUTTmI9AxLNruu5cidg
         GeLPnqEcZfn642DCnHDh+Vw2w57twoLQKxLguELgDU+jCd3Seank10ZpF6h6l7hWe4zH
         CboQ==
X-Forwarded-Encrypted: i=1; AKwUvBxdzgbazO5bLKxxH7P548kWbrw+1jJAi4XvcqQeZxBSpEAL1oi4R0zqYKNo9bFZA47YrC+FlM1BDVYlsZsMTw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIMvgZz88RhZE/EN2AZL/zPGeR2zlJmw8svfR6oMp4iWUhkWoMe
	cDPl9NkQy4qc5K3WdOUjRVDumh5v3s57XbYon5DeAM363doZ9ArLBdVBUZaQztwkAEjulj7GNXE
	1MgkUbfaJTiW4wNecpo9K41xKLMLwmB7K+XWP1l/SrNP7CmdbVS12O1J4qZIdfPHDA+Wqug==
X-Gm-Gg: AYBFou1aoo9M51b1B8nZ9UgvheD4F1YoGCg0Gz336y3ng86GwsEcMrEBRQBWn9FRmdv
	F/2aOmFI+ufhQAcDAVjTbhyEMp9HzPlNwDB2e8pSyMMNzYaPwsWBzEe8WwJRdX7fbnWvbbpKjK3
	CzLrGk5roxvRcfFIJmZwiEdofh4G04yiJxRuWIu4C5E1UuY9bt3vtU9VZlodlU37CTmi3Urc3RE
	JgnULObZGJoU6E0W32AQBuW960pYyaGNvmSQju5jGtLfGlhUt+qr8fRFnT8IeKCzy0wEMMLartt
	5vQ7iBoowZ+Bji/mYOQNeP/6wRqdTkj4McbMm+l21b0xlBHBZVIokRcfSmb+mdgHYfvn+eQ6utm
	N5Dlc/6fw9tIIBMfjKoOSEZohnEBqqNwIFgtGNlxafhcIfuSb8ozkF5sbjbP2lorq6LOeMNBbGL
	3WZ2HekAZWG0/2dSuVElQJf0xKxmrvdzHSH8lltJi9cU2JiMZVrqUUJLh2WAUaXw==
X-Received: by 2002:a05:620a:2b43:b0:93e:fb96:68f5 with SMTP id af79cd13be357-94421799380mr994235085a.32.1793478842784;
        Sat, 31 Oct 2026 13:34:02 -0700 (PDT)
X-Received: by 2002:a05:620a:2b43:b0:93e:fb96:68f5 with SMTP id af79cd13be357-94421799380mr994232685a.32.1793478842281;
        Sat, 31 Oct 2026 13:34:02 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe04edd67sm782750e87.12.2026.10.31.13.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 13:34:00 -0700 (PDT)
Date: Sat, 31 Oct 2026 22:33:58 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
Subject: Re: [PULL linux-firmware] ath10k, ath11k and ath12k firmware
 ath-20261029
Message-ID: <bfx5k2tljdl4rijelpcwgrsdvk26hf7ajv7pc5o2db73m5sgxl@72mzxbxhgzfh>
References: <1ea7911c-9dc0-4bb5-85b1-9fd7f72c30af@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ea7911c-9dc0-4bb5-85b1-9fd7f72c30af@oss.qualcomm.com>
X-Proofpoint-GUID: 2f82nnpMCm6UabimhsLQT3V7ad0U2sDk
X-Proofpoint-ORIG-GUID: 2f82nnpMCm6UabimhsLQT3V7ad0U2sDk
X-Authority-Analysis: v=2.4 cv=S5RMU4sP c=1 sm=1 tr=0 ts=6ae650bb cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=p0WdMEafAAAA:8
 a=LW1wpjZNjeFz3wEaO24A:9 a=CjuIK1q_8ugA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDA4MSBTYWx0ZWRfXyQE+M7Hs+pk6
 aoc1iWj3TXglbLa7k1c6v+PMlsikzKgVDdG99aMKhVqaIdGFHB3ZJdHH6ZBxqGn4MNhxulfwRUE
 NNrakTM1tIaugCUo0ShuyNtB9jUQN7o=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA4MSBTYWx0ZWRfX6k7edv9TzVVO
 fkUrAsJDriwSyQYDQ7ZgfYWBFs7Uh8SwuDbtDNpLUIqjbPaGIOYXbST51pzI0GixdwReCFxVpD6
 YwG4c3GYEduGLXfION3KahbScPL1x+HFKIAtFmB81opasIuJcpuJ1A9ss+p/jZ1CjASajUCdJSM
 qqjXNcA24t73hS2U6jQA9SyXAmgV4ShQzD1Av7YJnvkkzu5HERJLL5+SnWA9wG7wfuLiKVJZVL8
 2GdJOBKFY742qZJmWBL7iAJh5hZCuyvz0aT3TKnM99XMs+PJTl/irhLQCvt2xGU5oMuuhhGlvQA
 RpGYf1yYAUptlKXqrANUGb4ZN7G++hUTyk60E11h8UNFFwUaIpft1IEMHOmrQd3Y8ckoqyMrT2B
 c6HsIRMm8K8pKoVmV+bcyqVr0s8ehjyRYRNwcYhHdGFuDvwWPlKzSV+Qtth5zgCW5skrnd6QsBQ
 ne/+OXBXbdjOumlGFWg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310081

On Fri, Oct 30, 2026 at 08:21:43AM -0700, Jeff Johnson wrote:
> Hi,
> Here's a new pull request for ath10k, ath11k and ath12k firmware.
> 
> There are no changes for ath10k and ath12k.
> 
> For ath11k, add IOT-focused NFA725(with QCA2066) firmware and board file.

Thanks, merged and pushed out:
https://gitlab.com/kernel-firmware/linux-firmware/-/merge_requests/1343

> 
> Please let me know if there are any problems.

-- 
With best wishes
Dmitry
