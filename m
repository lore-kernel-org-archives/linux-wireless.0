Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BE9499F00
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 22:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786054369; cv=none; b=uWD8gphE7j2b2TMrk2C4gZovMEdXTM1+fhZjgd5FTAZPi5of5VmieiNT/FBttbl9hK+u12X+x11LnJkHQD/K/uNM/UpxCrJYQMyzA/hxyTg1KxVhHzRdHQu+r7jSYUoah7hAP1KZ4OF3h6CYqbi2e2AH8WIb0DVTibHKazfQ3+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786054369; c=relaxed/simple;
	bh=3irwIezjq82GDgN8EUzk6IDQguLzKWhJqqbPFgA7W3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mA0uYGf8Epyiaw0rRZBvRNOLZJGZzUgTp/JeXMwNlw/OwZaSON4zQ9ZFVF2RR13U04fFTm8PPY8+VYnEGKidEHGj5UHIXxleDFk9dFcIwDDvaJTycp9dj/PnP8zjpXITTpewG7ZfGwK2RGbg48cZERyjT56U62ZbPFjT2xEJdp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H0WyIk9h; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RtPzdOKT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H0WyIk9h";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RtPzdOKT"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676L8P1S3118739
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 22:12:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IZJ76iBq0sEb39sAQgDlURJq2rVQ0TKFN440BVikQ1c=; b=H0WyIk9hs7vd/Cj0
	p1CKjudMYmlD+czCGVSO2Z2nEWk4HuuRRTKaDtgDv1+Sf0HXWy2HfG+G84ICNdMi
	Jrb0FJtA1IWmqtffRbj49JJ3y3JwbMfDPuCQNCTyXzCdYTQd+NEpqV45ZrMMlrAR
	wlzeY4U0jE9sQe9hOZEs88spjLzfhittdnI3m1LUoX2QpUTq0l64KN6hVMNHCPmO
	Pcq2jW5MuyDIoTZ3iI4MqGhO8Mv2EDIUfgIIsPdJZrkMqr8nHISBxjbuqDG+j9Oe
	qx6P1yEH/4NgkjXz6dEIBDpj1M6hI/3+yePOMtftaCwT97y+0NeOmSTn16rYF+1r
	pdSW7g==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvy6s11tr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 22:12:47 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc640dfde3so30952335ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 15:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786054366; x=1786659166; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IZJ76iBq0sEb39sAQgDlURJq2rVQ0TKFN440BVikQ1c=;
        b=RtPzdOKTtd1RdOwvr3FWz/sVzlwFgE+RscpuXcuomF/ZQ3StqmWNiwrE66dSW5jfiM
         MLuhaE/TH700N8J5noElRlrVzQLaXlIGkVjdHe7fX+RwLsp5qVvzYyvKLQHuWTkiQF+o
         6m6Cpx8edM1yTDYqNc1EigvarJorix4B1JhLuDe4IOXGQGCe0sgaawrDZU3cHVWnB5/R
         XHGVVPYz5O5JZp7++opohw6KKfAQ4TPhrWbyrJ7wWOupr96DPRLJn4StcDp2HbCUpS2Y
         TNcQKRkYRS6Ikq52R5ouA8d+1ti8xNfPfcHKCuy1+Rq5Xqry65uEacIwHzMaVH67bw3V
         M2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786054366; x=1786659166;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IZJ76iBq0sEb39sAQgDlURJq2rVQ0TKFN440BVikQ1c=;
        b=lRT8t2v2qKwgaEC7+N6GlqkEdajhjCu9grUJBB7w9L3eOy4KsgvH6DQXlYD+PD76sG
         KM6tqCGpbTcVvMMyqI1bmbiLtwr/jow+D2EI0FsP6C9wbfPIX/YEOyhxUyVBhaXJ1vS9
         7XWUl8egS6n70/ebCKFHYM3StJAtl3zCs96yUgQhs0nPOWWMuVojtWGC+3WAI67sFDTv
         MNCwzrJeQ4H2hu+SOHv3K4G8gO/CcjCNg5sknS/CvIVA1rtfEpGsBqa6G9KeL+gZpEbq
         Ilm9EeYZmzTK7k4Ehj3WaVYP9DdI591wiThAaVzWsPqP5l5MdI8hZX/ZebDcN48nHaxP
         YR7w==
X-Gm-Message-State: AOJu0YxO2z0rl0TEapQf2mRQRtVT2A189C45Bdl+Xew6CDGCe6IeY65E
	6V0BnNqZJh0BLUj4OUwbUchUCGr+kYnSK8KzsXCdjt7U/dC5menpt1ik1fFNIOqdcBScrhp4dD7
	uSOJbm3tKPktk8f0Is9/kLIzpmPsmmdeN9jBVgI0Xqe8/Ugk9VPauFbQfoQgohopWI/EMyA==
X-Gm-Gg: AR+sD102favZD8pgL5bIwquIEMcqMwNetjs+1Xv6dojzcVBb0KwXIcemKduNv3ObYcD
	mQ9Zv/asmcuUnludVrM3pC+GsKlZJqMSl9BWw7L6hjFdmaMqWUL5yFrDeOH+yYP2JhyVzyRtbbI
	0lqRr2QKs/NMgyhkI7ngqVGw7QlW8wX/2u7fLltoogBUQe5hgBGd8eIdeCD77cRlQgpsYI1O7P5
	urvGvdlzPaFGS5960vATQjmwoIWU8q85bKoCWw2FlrugnqrrdbiDL8lPvhe6OZ8GRPKXvBcaVXM
	QdH6XQoBfZZr6HfPFzbHuzKarqVIKrMHRcZMwpMSQkUAqYJCacgRuMderEO7lcoLUyusPw5IwWM
	VA/miR9QXlKgrCMpWfc6Sf3+nZ1f6czHmayB02kK9PQGYJgglUK1KmL7E3HOP
X-Received: by 2002:a17:903:90b:b0:2ca:ce92:6e44 with SMTP id d9443c01a7336-2d0ca7b0926mr224677685ad.8.1786054366155;
        Thu, 06 Aug 2026 15:12:46 -0700 (PDT)
X-Received: by 2002:a17:903:90b:b0:2ca:ce92:6e44 with SMTP id d9443c01a7336-2d0ca7b0926mr224677125ad.8.1786054365725;
        Thu, 06 Aug 2026 15:12:45 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bc667a0bsm766190eec.10.2026.08.06.15.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 15:12:45 -0700 (PDT)
Message-ID: <fe00014b-2255-45e4-8612-e3a7debb42f8@oss.qualcomm.com>
Date: Thu, 6 Aug 2026 15:12:44 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ath12k: WCN7858 data path stalls under load while association
 remains active
To: Pau.M.M@proton.me, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <C94Xarp1XxHz1dmb60Qwptbqjpu97tGKf5C5OstCKlOZ0PmhB24l_9TSWBXwvHnEz-u1TcZ18m4962yeIJchd8DUC-dzSNNp-MInd0aoXzY=@proton.me>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <C94Xarp1XxHz1dmb60Qwptbqjpu97tGKf5C5OstCKlOZ0PmhB24l_9TSWBXwvHnEz-u1TcZ18m4962yeIJchd8DUC-dzSNNp-MInd0aoXzY=@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE3NCBTYWx0ZWRfXwpmMVcILv9vO
 p2/FHQ+LxpHyd0yskTHaV29Iq77rGcyK6au4bOYyTNY26CpYwu11INxWLWV22rqNRlJtlETvi65
 tA2NxO1mLwWYbfZu5CRKl3mtavgIUg4=
X-Proofpoint-ORIG-GUID: 0rhflUoD1_2IzxUTt0VHtIvXVvoDm-vL
X-Proofpoint-GUID: 0rhflUoD1_2IzxUTt0VHtIvXVvoDm-vL
X-Authority-Analysis: v=2.4 cv=B+eJFutM c=1 sm=1 tr=0 ts=6a7506df cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=JSyZWIRQqG05nhjM6iMA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE3NCBTYWx0ZWRfXxlnjg+P/xclO
 tIV9CXmc7UpDXTFrf3Iv9dpmmZwUXotdRv5To6mCF8/cfBznmWtxnv5Ajs/ud2EjI1BtXWRz6Jg
 YRKUhA9D0afm2K7239+IhvhINjfiJCsfdApwJN6Qy0HllOs4huk+Pe8SOE6VDlEKz7LcqsiNgov
 jBbClghXmJ+KukrCeaJXMHJAayqMm25/YN8Q1TVFj6boRsTTTC30F1nsYiW0cpmdaOnP2r9rAFA
 czubOnN8XQeEbLM65wvdhiaf2WMpLjeLGRkPJSFKuq8qnXsY2p3YDEy8uZsXYcXakA1hzzcYMvj
 B3OqBMzOXzQk/dvXOu6hOE9CAj6yK+NA2SvsA7uC9FCJ6xGpSci5yad/QfosBda4z1QQhIMKIvC
 j9B+/YoJqaPnJwmWB02XjrqZKpuQKLhsZLx7EiXjl/0GgsWlanKIxZY/kuK25o9odHe21MkM24e
 MonuywJI8Q3VuCTLiMQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_03,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060174

On 8/6/2026 2:17 PM, Pau.M.M@proton.me wrote:
> 
> Hello,
> 
> I am reporting a reproducible data-path stall affecting a Qualcomm WCN7850
> hw2.0 using ath12k.
> 
> Under sustained traffic, usually during an Ookla Speedtest, traffic to both
> the local gateway and the Internet stops. However, the station remains
> authenticated, associated and authorized according to iw.
> 
> The issue is severe on Kubuntu and still reproducible, although less severe,
> on Manjaro. It does not reproduce in the same way when connected to a mobile-
> phone hotspot.
> 
> Hardware:
> 
> MSI PRO X870E-P WIFI
> 
> Qualcomm WCN7850 hw2.0
> 
> ZTE F8748 access point supplied by DIGI
> 
> I have attached a detailed technical report and logs.

Wrong process, try:
https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12k/bugreport.html

