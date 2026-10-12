Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751B63168EF
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 04:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791777723; cv=none; b=rhAIgHginGK1Z/FoOR7ZD9Eg5eI0hF6HP6TY2Lj2XnT/7XKLR+PzA8ono2FjLksLIuKXh1DykfJt/MkAVy+POfnhrJXQz7M3qugn1Je87AttS8TsbxMvZ1+mWVlfyiQs4RlVdCFsMpZOoZUccpgKUbJlEDNn1YfeWwYTm3faTSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791777723; c=relaxed/simple;
	bh=cGGF3wE8/joo9zfTxvAyOyq2L5C2tck8wSXJ+fBo2VU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R3S9k2VW8Cxyu4GOpDkBYFzB/aGpa1taR8Jwque6UN9pQ5TM9wqZgiEK0CC2+iMmTWEsZ/W3CsuBsb1KZXWLLY0IygXiK4cHWeOCSe7WiwLSDkZ29ZruChclUD0E7VJWb1JKkoa9UDvNiOhCKL099afsYvHZb1AcnLwxjnVS3es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dlmBQO3W; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Y3eYZIa0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dlmBQO3W";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Y3eYZIa0"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C1lDUi052408
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 04:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TAFxtCFAGkhf5HjW2o1fYPliXJnjW5EUi91jOMKfn28=; b=dlmBQO3WNOJdbmS8
	7HXQAvakbNMpJSlpyE8IeYW3rBxJ57K8SmrJnnDDPGMYR0iPqgy6R+1rcWnJz+p4
	28FcKNyGEuro/pFz6cv55zlSpn0Lt9Z5Q5LkKAWaem6lSQ53Dy+44jMVfUFQtvlV
	gQfKF2OSWmircSjetdquf7RcEjDchfK49QSn9pvlg+92HgGHpotuMdO2EcEpR3Oq
	l1DBeHEjm6PPHVBKxyV5Oopt74985dOocDnaFa2YkCnjH7ZwELbHjepws9hXP1Ca
	wzi4LXVMQus88qFZjpE43JbQXwH9/YqvVZhZyYCRdQRPaU795txz952P3mBjcWZw
	IDFxhw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7en9vesh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 04:02:01 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-34ef0362d95so1481496eec.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 21:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791777721; x=1792382521; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TAFxtCFAGkhf5HjW2o1fYPliXJnjW5EUi91jOMKfn28=;
        b=Y3eYZIa0Dbom4FIivb52rDTEyptwo+Ddw32LikmMgmWL7VWXgpKMcemn92d7JJBhxx
         D3WrLQWduz/KnTuz2MWb23Zagr/7sXxxgqxKP3dNp93xmX2mdbL77jLcTwx8CGta9/kC
         rPp+V4AoYQaxnW2+MS8ko94eIQ3yPYTRCYXoMtrMH1i5jGTnrgiBSnNcvoftTxIQGDKe
         WIe3Q9KD/lAt8INKFGsAZEJY6p7Mn/cwqlZUFCvwxYx8/Vcl/QR7I+j12MekvboDbRI5
         n00G3JYFwQtpkWlIBoo1ajYOMVd19FodYh0v+JN2AYvuvkLN+wrYnm8e1y1paoHhpMxj
         VcWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791777721; x=1792382521;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TAFxtCFAGkhf5HjW2o1fYPliXJnjW5EUi91jOMKfn28=;
        b=RB31+g1cKm8p20xTlwSXBdbFkPpnHj2wtH1VlNeuqoVhM78yAcCCu4BhbLbOmH2rCV
         xxZsn4lLkem0fkhKYwCaIbMcKqvtaOTs8NifcbYVb0wXCcSkaadeYuL1VP39kXkpKLP5
         6pZx3HBlDXMdwvvT36ou+9YkPLG88V1M5H2fj5hZ2pX7wQ6LNhbD/q4tHZ4oPNF+zTJ7
         ti3RwPMSAXKrWlfr/PhAl8dMiCf5jpyTNcO9JEP/pDpbQZoyV9Ym46vEfHTvTjTJhdJ1
         hYps42dNcnU8V2Gf+h/L4Rl9yUxq9Y78ZfqQcMOWIJyAd3dpUxcJhYaoJ7H+cReX087R
         jqpw==
X-Gm-Message-State: AFq9FYKmYI4d2N5weM7K9ncv0ehCYIhAhEWoA9U9tXq8Wa4R2bH9pqIw
	d15l274hQqIQoNhaVdx5wUO/H20VLpTxiJZuQtChN2wV01ygk3DXoGAvrRaIdIT8vLN2gs0TAWl
	pOKGs529+ZTa8mUhlxYJVkGI06QT08G0yLrYgaWiK/sJAB+2PNd3Et1AWYpqq0Rh3EbKs38NdLB
	muag==
X-Gm-Gg: AYBFou0HO5f+nx6Q8O+4j34atGF/YpUy67P0SzYfBUVwnSnRwI3ZRJ6lkfDd3/EJdj4
	pJd3jor+SrJc/TR7o4+vfsWhC4ELVZQbk5CYI7rrL+r7SqskNlRxz9YSnGzrYxDu+tSkYOt+EWA
	FvfsTKYoV02idp5T9wX/53K709pKxx7UIb5cwQhCtvt+POd/0/jHA6mg2sx+t6DOjlYsl7Xe5ci
	CpkUOfebDpaHDbqk+e4fJBoQ1Z7Ppiy8rpiq9mHduwt5hT53ko3yVOg4MTUFQGumLxm/DNmOPmi
	6eKqrRgVPCPA3lbfta3I/4gTNSlA6jcDjVqEZmNao4KA6L8MWP690Uy7t7MxpYYyEEzLOsexsJP
	dekG4ipAOXZgcJKDB3pJFIuHfJ6PM
X-Received: by 2002:a05:7301:4e88:b0:35a:efce:6190 with SMTP id 5a478bee46e88-35aefce65c3mr1618225eec.28.1791777720910;
        Sun, 11 Oct 2026 21:02:00 -0700 (PDT)
X-Received: by 2002:a05:7301:4e88:b0:35a:efce:6190 with SMTP id 5a478bee46e88-35aefce65c3mr1618182eec.28.1791777720174;
        Sun, 11 Oct 2026 21:02:00 -0700 (PDT)
Received: from [10.152.194.17] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b29c2f861sm2387933eec.11.2026.10.11.21.01.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 21:01:59 -0700 (PDT)
Message-ID: <4a66d34b-e752-48a7-87e5-8a189532941f@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 09:31:55 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath12k: remove duplicated STA state
 from link peers
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260925051036.2838210-1-aishwarya.r@oss.qualcomm.com>
Content-Language: en-US
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
In-Reply-To: <20260925051036.2838210-1-aishwarya.r@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Woe+otfv c=1 sm=1 tr=0 ts=6acc5bb9 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=FAEhTdbA7TVx68QRkYkA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: lYw5fi3K_n9fxNNS09TihbRrs6kBFXhY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAxNSBTYWx0ZWRfX7SLwSWnwFJ12
 UPEOU8nmAxl/MIRQzvQz+LhAZIk8UgfSeFTx6ojQ5D/phzxNroDmKv+12bh7ynxhxmmqWdUaT2b
 E9u8rAJi2wZvEtoJ+F5m/Eu3V2P9cT9snAj4PkfLw01AHBaVIftu1Ice6ZISWnqnonAWyVo5LmR
 pRg5QnqbGHeubFUMYa98FCjSxugvxiF2FTK1mP/xiMjQhqd9zwGZuUV3zi6amgCrMUenFkbsIqj
 fz5J6pFKaRmuRtIkxBBaPngMP0eqCYn91LZRzRvM7teeHGJzBMru+DE9dg7ugjPFVyS2/jTgVMi
 UqqyeqxLFAb9R+3rEztPmLqT2viFgWL5zq1MLxVxYgISBdPeQv3xuf+aEqwERvXYge1VKt+KUYJ
 FfEbaUeaHTJHYNSSFMaFi60Y9XRtTZ2gL++8RMYRK4qOtqqQq+0w8e1AyBP+LREDl4w5FHOBgVR
 KCBJJ8cxaqofzMKEGaw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAxNSBTYWx0ZWRfX3GycRnJtE3rS
 Ogr0AIz5MLYvg5KOzryCAq069GH4eNwdvQ5PgAkNIFFGqmYd3WezLY/EQTOZKHj8Q8f9OZqJ/jp
 uCFnz3SXEsWqkuvPDDs4YFoeOjeStvA=
X-Proofpoint-ORIG-GUID: lYw5fi3K_n9fxNNS09TihbRrs6kBFXhY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 priorityscore=1501 phishscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120015



On 9/25/2026 10:40 AM, Aishwarya R wrote:
> ath12k_dp_link_peer currently carries state that is not inherently
> link-specific. Both the station pointer and authorization state are
> shared across the links belonging to the same logical peer or station,
> yet are stored separately in each link peer.
> 
> This series moves ownership of these fields to structures matching their
> actual scope:
> 
>    * Store the station pointer only in ath12k_dp_peer.
>    * Store authorization state only in ath12k_sta.
> 
> Doing so eliminates duplicated state, reduces bookkeeping required when
> the state changes, and makes the ownership model clearer.
> 
> Patch 1 removes the duplicate sta pointer from ath12k_dp_link_peer and
> updates users to retrieve it through ath12k_dp_peer.
> 
> Patch 2 moves is_authorized from ath12k_dp_link_peer to ath12k_sta and
> updates authorization handling accordingly.
> 
> ---
> Changes in v2:
> - Rebased the changes
> ---
> Aishwarya R (2):
>    wifi: ath12k: store station pointer only in dp_peer
>    wifi: ath12k: move is_authorized flag to ath12k_sta
> 
>   drivers/net/wireless/ath/ath12k/core.h        |  2 +
>   drivers/net/wireless/ath/ath12k/dp_htt.c      |  2 +-
>   drivers/net/wireless/ath/ath12k/dp_peer.c     | 29 ------------
>   drivers/net/wireless/ath/ath12k/dp_peer.h     | 17 +++++--
>   drivers/net/wireless/ath/ath12k/dp_rx.c       |  2 +-
>   drivers/net/wireless/ath/ath12k/mac.c         | 47 ++++---------------
>   drivers/net/wireless/ath/ath12k/peer.c        |  2 -
>   .../net/wireless/ath/ath12k/wifi7/dp_mon.c    |  2 +-
>   drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 15 +++---
>   9 files changed, 35 insertions(+), 83 deletions(-)
> 
> base-commit: 414f2b40f7b0244ea3ec1f7411d194a6d9c89c33

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

