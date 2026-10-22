Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792676310;
	b=zTkUh8dufwTqJa8y3u504guY73aXSI1Mpm7IJ3EQ/gMfFG9wwKZ2Wd1Bzbk03M60YwR/
	 aG1qy9HbdXljR/FZmM1bSO63doN/u5C9Hs14KgS8T5Mgo3Ug6IkcXyX8saBcjNnXE5Nmv
	 1eqoqBe2MEHqfvVwVEuXqrmNNsWOiExVb4UykoOSSY8fBXkbhyvCuRtn3j0+v3ATE5639
	 HV/pRKLiznafGMaDXgORrYkRQRmJlohcP/imU7bbUV6Mr07ZFzhOTJDdWrC6FCdFUgDO2
	 9kJ0v0H1NSDmxAds454NwqidC3JLXxmiUywJHngqeYHh5Ir2nErDWSZWRXUa3X6yGgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792676310;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=9Vw7fnKc3VAocPM27GWdWNWFuAYiQe9Qj0jcJnHPkQY=;
	b=s1V1bzDuXKgf3Of6akH8HqiyF6l7mQL1jlpV6WkTrMGQJWZe3VC6DrcIXnPN1Hs6W7OD
	 1WGlDy+GCA3hUxbOl1CxEiJj5BcO0Zq640xEgL5R8+/CZ3d9Hzj+WXrcR4UNbA66fWZdw
	 WK9iqgO1XHf1irzSaznO+/Y/sPSvNKUPv2b8fmsfE+qPFfFwwLWxDFqlGPvwuzWuN547S
	 dIant5yWHGJx1mmke9nU8R6AsM8py6jhotnzl5Jdy7yqEO9fEcDh7qx3PR7IsnmvgUDuX
	 CF48ljVB7XMfYFu9AKNtVS7dHnEUcRHSSGGkRXCSzn6p1nQ/LHKnUZ+KwneZcSfUrpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kBYxFLjr;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YLgOV4CL;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB02606A31B
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 13:38:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AB02606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kBYxFLjr;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YLgOV4CL
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69MA02aq1962798
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 13:38:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=9Vw7fnKc3VAocPM27GWdWNWF
	uAYiQe9Qj0jcJnHPkQY=; b=kBYxFLjrTr6+r+wNEyfUXpu8kTmOIFI8bJWdB/AA
	VFXovdQDD8z9lYJpybCGfPLYSURbbGYr6lpUckpQMKcAeQw3YQTYsRUlFuwnTngp
	jHtnS1eBKxYr7JXlivZITdAjsMawxTK93zRF5dD9YWYJX15jW6ui0QDd8D5WkeVA
	5Sux8FZ3be+TBrGEfcCqyEtWtTDPxvobiRPn+bv/K1haZnSy7o+Fn2LdPBG0OSvj
	TL4V7XIQKhfKormHXlAT9xunEm9cWZtNem7R3xWN8x94OlV4hSzt5UzvGJjk9NBa
	7kxzXM6BuWRe9+tJFSGXq1eh57Aczma2I05QFKfEkSV3VQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93akq6n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 13:38:28 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3580c07911eso5247673eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 06:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792676308; x=1793281108; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9Vw7fnKc3VAocPM27GWdWNWFuAYiQe9Qj0jcJnHPkQY=;
        b=YLgOV4CLBxnspR/566bovclCqQSZXqlefduvFcgc6MkqrU+mFvXK6BE36qvejnNDgj
         S8Hjkaksf9y3JxMJHVQcMewzy4cD1wA8gb1QY/JJ4W4soF67br5ps4EGXze4CrYSSwdb
         ekBmZVB38e42fu2nQ3He0C3lLkbBlnFjmKWXNu3wmTyyA82Mn4ri91iQAQzd1w7wvxfs
         gjfj5erkwslI6QygUMDad9t81eayuTqQ9yP7FirVa/Cpb0I3+SHKx8HoTRL/65Ds2rIl
         WjbiIh7jgDJmmcfAXlKW6yiq7k5rEl1X4ktiV4HMWS/WOqH5EsVC4MFfV35VC5Ht8r+a
         2RHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792676308; x=1793281108;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Vw7fnKc3VAocPM27GWdWNWFuAYiQe9Qj0jcJnHPkQY=;
        b=SUd1rbRUnyl+5DCikMCi85x+qqGmV/RWW0lj5kw9mpgqFWEavOweA/YIk7B+DC18GB
         wIvmffW+m9UxcnqvNaqd1AwbKHqIWjHsxaco4oJqPTNahZNmddAK1oOSuIuddx6He4Ub
         hrPrxBnl9wKTx/R/Ep8rJ6w0DYr3H+Q0BgtKI7C3G5KPKC0W4ib3tddqxfQrQnK7iShD
         zAhYBT0L9Ns+HBt7yHvJ0bilYJS4eSL/Ebx+O7ogT2YoB59T3KxTUS4dU0qh6P5wM/PH
         0lVKFPDF+/i58OPAMrQLD7jkXlQIm+xLTOl2gqHvrp2WNFzt6fDgFRh1l2sBraX7saZi
         YDKA==
X-Forwarded-Encrypted: i=1; AKwUvBzx9K0akmIDcLoDiv4W4oGjDg5ceZYjYfiV8IcoAIdvLbv7SCjGaCJ8SK9bEfxe31FcyS5Imb0gtTF5LqhByg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKqtpUalLGktZ/nm3CFejzp/ajSphmIinyJUZd7C+0zczbZeEhT
	xoP4mHOJkRb4bvwHIV1nA2FLV0dHRhbGlAvlKy2+Rf5Rh7wJQg+6dQ+WfKSW+UQ25VchU/YjH3y
	0RmkNybwZApLl1vEhgoq18QICTua59Zz7An5N0ErbXSm76jcf9D5RmJraovnVuSsocyu2cw==
X-Gm-Gg: AYBFou07phrDKdvwkmRV+rNs2I2kPFjVvjjRLdSfLBWPjpCK4MkdFhaPeUucsiolNom
	UE6PDknXQsMGUZyQjkfAB4Rww917eRYvJVA87aIjQ98Fv+ah7ciiw3CsWURdsgms205a3KObmvR
	kVbFpOaD9KsIkSVcHek89vg+tgwkypmP4WWV9I6G07yhDs2nLSr9BkuFoWT381ncAzdTPcxf+Vj
	tsn09ofZlCdzAoob4sQ0tLQ1HOZCCTF5ed6mN5AgSlDAFWHTjjLXj5DCIATRrFexX2bGiw2GgvY
	4fprEf88ik3j//jS22S0BtX+Uya5o2cpo74CLzlwXGJRH4cgPwuJXg93tgs7N/QhstLDSbKCnH8
	tA07Eg4WFTFImJpoDTTRxqXwJTgFqcQXlHKcaSYq7+Q==
X-Received: by 2002:a05:701b:4553:20b0:189:ff2b:b194 with SMTP id a92af1059eb24-190a6adcaebmr6406862c88.16.1792676307507;
        Thu, 22 Oct 2026 06:38:27 -0700 (PDT)
X-Received: by 2002:a05:701b:4553:20b0:189:ff2b:b194 with SMTP id a92af1059eb24-190a6adcaebmr6406826c88.16.1792676306856;
        Thu, 22 Oct 2026 06:38:26 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903aefe90asm14097649c88.9.2026.10.22.06.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 06:38:26 -0700 (PDT)
Date: Thu, 22 Oct 2026 21:38:20 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Yingying Tang <yingying.tang@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
Subject: Re: [PATCH ath-next] wifi: ath12k: change MAC buffer ring size to
 4096
Message-ID: <atoRzGmURyjFcH7Y@QCOM-aGQu4IUr3Y>
References: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
 <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
 <0423c93c-8359-4fd5-9ba0-17e5ed3927dc@oss.qualcomm.com>
 <atnVeGiu9Q07HyUq@QCOM-aGQu4IUr3Y>
 <0d5d36ae-3d65-4dec-98cd-7409ba4180c2@oss.qualcomm.com>
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
In-Reply-To: <0d5d36ae-3d65-4dec-98cd-7409ba4180c2@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA1NCBTYWx0ZWRfX9G0wPKYiox7q
 afmlNQ+20pnNjkdCAhVZoLgjZsLjXWhBPYVnXTVMMaqDVyN6iI9/GSP46A0rNQEAiLg/ePt5btE
 Hw6E+rrV9zjSb1mCv2DpKEWHqwYYs+qzLAXv9reThdaJz20J1ybmOaRS79CP6e6shf4h5KwlrVt
 xTKkAmwpxOx9cz/IS3fG/hEyItgyXnpR0O8S/KitkdHzf3j6P5Tp/Ug6XEC8Ja5vbAzePoDEMuZ
 DrMaJTEztBY2h/z9ZG1MV7fOXUALyxC/jErkmGZ7a/YCllJMddwPRW16ouFXyMYXLIDNMYEQAGA
 mn6PlxYrzYCxB6Oal/RCXrAE6GW/46k56F2sa43nGBsV95eR/mcZldEEGyzDH7RwcRBn+wuQRly
 hd4h9fknGbbdeXHuUAm7l6lb3i+/qc7H+tx34SFEVs5vdJcgu/x1yeggUqBD3zUkihryXJUwcA3
 HXgQ87pqWT1/z/455WQ==
X-Proofpoint-GUID: s999Q9jUOzO2ilNt0F9N-cMRrnib4LwF
X-Authority-Analysis: v=2.4 cv=feg4WEQF c=1 sm=1 tr=0 ts=6ada11d4 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=Z4Rwk6OoAAAA:8 a=6ugie7c4VXROldkqumgA:9 a=CjuIK1q_8ugA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-ORIG-GUID: s999Q9jUOzO2ilNt0F9N-cMRrnib4LwF
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA1NCBTYWx0ZWRfX8JNqrbKN7TiH
 YRvuXGd3UN0pslbdHOkCuZhwUCUqWnNoM0Ww1t54/hYD8dI1t/P9lAmjU4OjR5QConOqfe3vRp1
 mzZNzI9lJLnblfdSSo13CF62K4sgAeo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220054

On Thu, Oct 22, 2026 at 07:00:31PM +0800, Baochen Qiang wrote:
> 
> 
> On 10/22/2026 5:20 PM, Shawn Guo wrote:
> > On Thu, Oct 22, 2026 at 10:30:45AM +0800, Baochen Qiang wrote:
> >>
> >>
> >> On 10/20/2026 4:53 PM, Shawn Guo wrote:
> >>> + linux-arm-msm
> >>>
> >>> On Tue, Jun 09, 2026 at 08:13:58PM -0700, Yingying Tang wrote:
> >>>> For WCN7850, MAC buffer ring size is updated to 2048 in
> >>>> 955df16f2a4c3 ("wifi: ath12k: change MAC buffer ring size to 2048")
> >>>> to increase peak throughput.
> >>>>
> >>>> But during the RX process, a phenomenon can still be observed where
> >>>> the throughput drops by about 30% from its peak value and then recovers,
> >>>> and this behavior repeats during RX.
> >>>>
> >>>> After increasing MAC buffer ring size to 4096, the data rate drop has
> >>>> gone.
> >>>>
> >>>> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
> >>>>
> >>>> Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>
> >>>
> >>> FYI, in case someone else runs into this: with this change (merged in
> >>> v7.3), WiFi on my Lenovo Yoga Slim 7x (X1E80100, WCN7850 hw2.0) stopped
> >>> working with the older firmware that Debian trixie still ships
> >>> (firmware-atheros 20250410-2):
> >>>
> >>>   WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
> >>>
> >>> Probe and firmware download succeed, but every WMI command times out
> >>> once the interface is brought up:
> >>>
> >>>   ath12k_wifi7_pci 0004:01:00.0: wmi command 16387 timeout
> >>>   ath12k_wifi7_pci 0004:01:00.0: failed to send WMI_PDEV_SET_PARAM cmd
> >>>   ath12k_wifi7_pci 0004:01:00.0: failed to enable PMF QOS: -11
> >>>   ath12k_wifi7_pci 0004:01:00.0: fail to start mac operations in pdev idx 0 ret -11
> >>>
> >>> Bisecting ath12k between v7.2 and v7.3 lands on this commit, and
> >>> reverting it on v7.3 brings WiFi back with the old firmware.
> >>>
> >>> Unmodified v7.3 works fine after updating to the current linux-firmware
> >>> image:
> >>>
> >>>   WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> >>>
> >>> On Debian trixie that one is available from trixie-backports
> >>> (firmware-atheros 20260916-1~bpo13+1).
> >>>
> >>> So nothing needs fixing on the driver side. I'm just leaving this here
> >>> so that anyone who sees "wmi command ... timeout" on WCN7850 after a
> >>> kernel upgrade knows to update the firmware first.
> >>
> >> Hi Shawn, thanks for reporting this. I just had a quick test
> >> WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3 with the latest ath tree
> >> (ath-202610191908), everything looks good, simple connection and ping pass, I don't see
> >> any ath12k warning.
> >>
> >> The firmware images I am using comes from the first commit adding WCN7850 firmware:
> >>
> >> 	fb04a7f4b750 ("ath12k: add new driver and firmware for WCN7850")
> >>
> >> and the md5 values are:
> >>
> >> linux-firmware/ath12k/WCN7850/hw2.0$ md5sum ./*
> >> d3750b67b1013fe82358d0538fb131b0  ./amss.bin
> >> c79c410d585360000c0490f16fda43e2  ./board-2.bin
> >> 73056f1d2aff886ce9bff313f455e963  ./m3.bin
> >> d0ee61498bf1a205147cdbcf645391e7  ./Notice.txt
> >>
> >> can you share the md5 values of your images?
> > 
> > Hi Baochen,
> > 
> > Here are md5 values of the old firmware shipped by trixie firmware-atheros
> > 20250410-2.
> > 
> > $ md5sum /lib/firmware/ath12k/WCN7850/hw2.0/*
> > d3750b67b1013fe82358d0538fb131b0  /lib/firmware/ath12k/WCN7850/hw2.0/amss.bin
> > 5dacdfbe6c3c25d9e0605be8a9f1f6e4  /lib/firmware/ath12k/WCN7850/hw2.0/board-2.bin
> 
> this is different from mine, can you try mine?

Are you sure this board file works for my Lenovo Yoga Slim 7x laptop?

> 
> > 73056f1d2aff886ce9bff313f455e963  /lib/firmware/ath12k/WCN7850/hw2.0/m3.bin
> > 
> >> and have you ever tried the upstream mainline
> >> kernel or the latest ath.git tree?
> > 
> > I'm not sure what you mean by upstream mainline kernel, but v7.3 should
> 
> I mean Linus's tree
> 
> > be the mainline kernel released a few days ago.
> > 
> > On the other hand, I just tested ath.git tree at tag ath-202610191908,
> > and it worked with the old firmware. So it seems there are some gaps
> > between v7.3 and ath kernel.
> 
> can you share the exact tag of v7.3 kernel? is it just below tag?

Yes, it is.

Shawn

> 
> commit c03c1a14507dfaf8b856c2608f9ac216021fc222 (tag: v7.3)
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Oct 18 13:14:58 2026 -1000
> 
>     Linux 7.3
> 
> diff --git a/Makefile b/Makefile
> index 0dc1a9f4e63e..c61ea07ee505 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -2,7 +2,7 @@
>  VERSION = 7
>  PATCHLEVEL = 3
>  SUBLEVEL = 0
> -EXTRAVERSION = -rc7
> +EXTRAVERSION =
>  NAME = Baby Opossum Posse
> 
>  # *DOCUMENTATION*
> 
> 
> > 
> > Shawn
> 
