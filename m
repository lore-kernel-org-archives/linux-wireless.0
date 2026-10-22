Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792676700;
	b=J19HOOWLSNJc/lTBS5g2E0xoM8rfUGHL2k1fM5etySTcXzh6/d1M7nrhea1f1Cvdu0NC
	 F1TQOzhEBdRBeXD/k9wxv3UnYAHaGXV+7JHZIrzhAwja818c7LPkmPHHUrCvs66W5QTQz
	 MTMCMrPl67Vxbe8YAMvbQcr4g/pbFrbLK1/oixYIR3tWon3fDA4myoll8H1mFDIu2v28n
	 fecBdroDUmmTy5dWMHWF7e5I1k7E0OD6FRedpIbr3AnkuoBEsOekA0iY1e8lzE+3f4UGe
	 UayCcXWD7yoa9COQ3fncOxFJWHLliblrfJUstCY+CmPZVdM+MbIr/T0G4bSDm1VfzoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792676700;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=2m6HS/eDp0MfpNzLq0aimsYTbu2ZaMfn05Sksguquh0=;
	b=TJfGfITAoyhSuNyspSLJnYgvP6ZccztHZoqc3nUMrIL8WYwh36YP3BGLN3QqlEZg+ygV
	 EyzqSNd/9d9bEsWhua5zMI6ivwdRPLhQ9BU/wwWAw4+BfzDDsUeHM8tZrAlp5c91ISgFa
	 G+FVULbL7HOsEeb7+wlu0XJ3BbcUBmrFxKIp6slmSmiSE6COCvc5yboP4BCQ3fql7RZJq
	 m/mvXjQLmcx3RviREDc4nSbkFLXZW7//wLOFr1rsgVbIp7bEU1GFW+Gqo5+q0h8SgAYXQ
	 +aUZpQqwlHNJ2XSurqNuLL3oM5Vy7yRl2iREFwNVdLfCby9oFi1kNNqRGGM1IFEjxAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jN2V1inN;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UTHr8wKF;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3135B60A5BCE
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 13:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3135B60A5BCE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jN2V1inN;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UTHr8wKF
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M9xxgw1962207
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 13:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=2m6HS/eDp0MfpNzLq0aimsYT
	bu2ZaMfn05Sksguquh0=; b=jN2V1inNKhl8Rj1z8VXdS0uoWnKy+qVWis9/UDBa
	YAMAU7nvjnVNsva7AFu8PMIluqyybNIp2GCAFgQowZ+g2dtgrpZfJNvFI5PGXkF7
	wLYqCujur2qmZt6+yROQimtKwjG7hFAHLcN4huJpvmhJcIzvW/Vz+qy9xStzwbtB
	xq76n9fCAXVKJka6OKk00iflm5Cg2L0tLUnRPn7QOoPvbC5ElsY98GEqZD5zqVWJ
	1Dhu5wZBc6t0Fay1Ri0wWsZIbRl2biZAVIDRxxZmNAXcFuI/XzPtDdI+L+Spypuo
	jScRj2CM6hHnhXzJQfca9iNJUVDFdzIq2n2m1zUDrnfvwA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93akqwt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 13:44:58 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3510d0baf63so4272378eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 06:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792676698; x=1793281498; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2m6HS/eDp0MfpNzLq0aimsYTbu2ZaMfn05Sksguquh0=;
        b=UTHr8wKFYfiwZAWYtmYp5H9jYKRvMVtKXZyvU0hOSDvv16sJtbDmtw72G+gMlCUy0B
         cuHki/9+/vq4XcPckeDGSeWCTRwDPpk7X2ceLGcWgUa+N4DXjOYwTgpblevsDB5bFdGk
         Z64S9WoYwcihqfyt2Ye7/UsMbK8eIUyAVaLD/N60GA+tIpmEWVNYaMFIxZ3q9jeq3JKK
         Cqg1+YG2GXX77NUhM1f6w0XjMbuMHRM/GtElxcrdznYOuAuOxTdvU+9Qgr47A4+CD8Bq
         P7D5u3Nln15E3DtF6Ogdwy/MYS00Y4Np7lCkl9sB00+ZqXn9Jh1ZybqXcaUV9KfNVBCi
         QTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792676698; x=1793281498;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2m6HS/eDp0MfpNzLq0aimsYTbu2ZaMfn05Sksguquh0=;
        b=oulNWV7U2g313qmZzXyeTjooA0OUAG261z9i4Gs3gZLuta4PG7JXNuMTyQeNpK0Ab5
         aZ4BUuLy/ZRkB8QrnlEowghHj8ZnYRy3Rr2z72omoCJvp27ybUWVAu8KSCpgPVy38r0I
         pQy2ipY5jcQnh2W0ThDwzATtgNyCjH7vKdPU0CtiyH6V1lbCazvc5BS7yreGoNsOVuXu
         pVOizOH218+TgglnWm32s4L0E4wjVe/vIUdn9UjMJCtjcyIXpyybLNl0iGGLZgeKW/UB
         MNaeDVKXPJFy5n0fPuL1MKRjLtTC1VZ9FUQXpDLGBr7BnfCHKkW746GJzxtIihgZx4uj
         ON9Q==
X-Forwarded-Encrypted: i=1; AKwUvBxCYZVmic3I3M7HrkJtHYRZ/8UHcaMwAEqeUNZN1hQaU7koc3lUi9Y4pfbRqpp+Z0L68loeQZjzCa5kMZs8oQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLnRnZLZyTTL2EAi+2L+34EEVYXGcmTgjac2ZpSow2n1XcbnBeB
	Y7N9t//PDhR3yJ6PHTiECa+CM237QNib2y/U8wA7zMurfp5fj2Wv7UvKqt0nhyfRmRIQBs26HMS
	iMJX99T87a7q+Svss5lQ489LQSA+PHeqKWD6qBKikOypWrwaWi0IqJC/6roLBulyJAdEZUw==
X-Gm-Gg: AYBFou0qe+rZOZJnfvDuq5y/QKPqNTGHI6NsvK+c3KCIhqn4oV7vdYEmsMnzk9/vpi7
	94QxVdRmfPUOPTiJvFPYQGsEz/D/sU6rV4RwQbpq2+No7DpRYmvzYEQr1f5iAeLIr7Hx7GlhamT
	xKBuwifHfZ6cei2RYEfCPeuW+w5vREDR596hqNeI7l0WKKC4kiHl09fJUztgyScgaTgwl+4HSkZ
	bEytOZBVUr6ajwo7lc+JjGqreD3J/liLr2H3zRp+rP6bDOE2hcMT0l3C/4aKbreCwHUW/bisqsT
	9rSKG59IyV/GV+oPJeYycw/qf0LRVuZsSpE7AOLv/+/YkuyL9w10AzU8X5S0bTGPA9OqLeUejpT
	hepMvo8DZCcbNl8HW3eV7+HZtkOfxcJOdoUbtHNQJmw==
X-Received: by 2002:a05:693c:8083:b0:368:4acb:f8a with SMTP id 5a478bee46e88-3684acb1061mr4736863eec.17.1792676697526;
        Thu, 22 Oct 2026 06:44:57 -0700 (PDT)
X-Received: by 2002:a05:693c:8083:b0:368:4acb:f8a with SMTP id 5a478bee46e88-3684acb1061mr4736793eec.17.1792676696230;
        Thu, 22 Oct 2026 06:44:56 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36740cc88b5sm17397811eec.10.2026.10.22.06.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 06:44:55 -0700 (PDT)
Date: Thu, 22 Oct 2026 21:44:50 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Yingying Tang <yingying.tang@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
Subject: Re: [PATCH ath-next] wifi: ath12k: change MAC buffer ring size to
 4096
Message-ID: <atoTUgEIfkg6b29U@QCOM-aGQu4IUr3Y>
References: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
 <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
 <0423c93c-8359-4fd5-9ba0-17e5ed3927dc@oss.qualcomm.com>
 <atnVeGiu9Q07HyUq@QCOM-aGQu4IUr3Y>
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
In-Reply-To: <atnVeGiu9Q07HyUq@QCOM-aGQu4IUr3Y>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA1NCBTYWx0ZWRfX9pF83iRwF8z4
 wuy9R2x1uEaqGiZ69vJI5yFHesLx589Rg0VkP0g7BZdJOPYjpIk6Fidup5Dcff7PT5B81U2lv8Z
 OyopoO3ThXDl2LJ3qvQ+2omoS8Ohg0ow+4OzoikQNfgHJ+Hc51rMM5k16ht6IVvxYWVi5yH/ZnA
 JdFBeHwst4PRf8Z0rOfT2wyP0yRpkkOpk8Qo+Dwb5njjNGYQI4AoqxJ8e3H95z+fVTUVZISqQx6
 jztzUznSxuzwypYm98r0oCPSCLBvcDFNw/PgABf8824W7oPOfpyxFvG0mulz47x6SqKt9m9Y4Cw
 VvGbGmVl3fh7DXgGgHcXKX14M9UtRvRsgRknyHoYUioGyNl8ch3SF6N0QKWACAxmdcaEqj1Y6g4
 Eo/B7L1B/CCn++VMPvHgQ58dyFkUAVT5m1cAS5IO4/Zwk9HImX8ZUQAuhy4VLrRpNpw2hShPy1m
 DyDDPtZ5TgIzU55/jfQ==
X-Proofpoint-GUID: x3gv8WOi4Jr8Jt1Lqyfpe2VMd3HWFWXg
X-Authority-Analysis: v=2.4 cv=feg4WEQF c=1 sm=1 tr=0 ts=6ada135a cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=HcXVOmt5dcc9mTenIEwA:9 a=CjuIK1q_8ugA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: x3gv8WOi4Jr8Jt1Lqyfpe2VMd3HWFWXg
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA1NCBTYWx0ZWRfXy2pZ9sOS4Ni5
 tKTpz6Z3pRo27gioZuENRiidZZBg7FbdFTJHAic3lwBc5DzCQaRqXxQf+DyPCUxcMpmRK+wkRUS
 VC3r6OHQAXBpOCup+9RqKIDDeE+litU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220054

On Thu, Oct 22, 2026 at 05:20:56PM +0800, Shawn Guo wrote:
> On Thu, Oct 22, 2026 at 10:30:45AM +0800, Baochen Qiang wrote:
> > 
> > 
> > On 10/20/2026 4:53 PM, Shawn Guo wrote:
> > > + linux-arm-msm
> > > 
> > > On Tue, Jun 09, 2026 at 08:13:58PM -0700, Yingying Tang wrote:
> > >> For WCN7850, MAC buffer ring size is updated to 2048 in
> > >> 955df16f2a4c3 ("wifi: ath12k: change MAC buffer ring size to 2048")
> > >> to increase peak throughput.
> > >>
> > >> But during the RX process, a phenomenon can still be observed where
> > >> the throughput drops by about 30% from its peak value and then recovers,
> > >> and this behavior repeats during RX.
> > >>
> > >> After increasing MAC buffer ring size to 4096, the data rate drop has
> > >> gone.
> > >>
> > >> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
> > >>
> > >> Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>
> > > 
> > > FYI, in case someone else runs into this: with this change (merged in
> > > v7.3), WiFi on my Lenovo Yoga Slim 7x (X1E80100, WCN7850 hw2.0) stopped
> > > working with the older firmware that Debian trixie still ships
> > > (firmware-atheros 20250410-2):
> > > 
> > >   WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
> > > 
> > > Probe and firmware download succeed, but every WMI command times out
> > > once the interface is brought up:
> > > 
> > >   ath12k_wifi7_pci 0004:01:00.0: wmi command 16387 timeout
> > >   ath12k_wifi7_pci 0004:01:00.0: failed to send WMI_PDEV_SET_PARAM cmd
> > >   ath12k_wifi7_pci 0004:01:00.0: failed to enable PMF QOS: -11
> > >   ath12k_wifi7_pci 0004:01:00.0: fail to start mac operations in pdev idx 0 ret -11
> > > 
> > > Bisecting ath12k between v7.2 and v7.3 lands on this commit, and
> > > reverting it on v7.3 brings WiFi back with the old firmware.
> > > 
> > > Unmodified v7.3 works fine after updating to the current linux-firmware
> > > image:
> > > 
> > >   WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> > > 
> > > On Debian trixie that one is available from trixie-backports
> > > (firmware-atheros 20260916-1~bpo13+1).
> > > 
> > > So nothing needs fixing on the driver side. I'm just leaving this here
> > > so that anyone who sees "wmi command ... timeout" on WCN7850 after a
> > > kernel upgrade knows to update the firmware first.
> > 
> > Hi Shawn, thanks for reporting this. I just had a quick test
> > WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3 with the latest ath tree
> > (ath-202610191908), everything looks good, simple connection and ping pass, I don't see
> > any ath12k warning.
> > 
> > The firmware images I am using comes from the first commit adding WCN7850 firmware:
> > 
> > 	fb04a7f4b750 ("ath12k: add new driver and firmware for WCN7850")
> > 
> > and the md5 values are:
> > 
> > linux-firmware/ath12k/WCN7850/hw2.0$ md5sum ./*
> > d3750b67b1013fe82358d0538fb131b0  ./amss.bin
> > c79c410d585360000c0490f16fda43e2  ./board-2.bin
> > 73056f1d2aff886ce9bff313f455e963  ./m3.bin
> > d0ee61498bf1a205147cdbcf645391e7  ./Notice.txt
> > 
> > can you share the md5 values of your images?
> 
> Hi Baochen,
> 
> Here are md5 values of the old firmware shipped by trixie firmware-atheros
> 20250410-2.
> 
> $ md5sum /lib/firmware/ath12k/WCN7850/hw2.0/*
> d3750b67b1013fe82358d0538fb131b0  /lib/firmware/ath12k/WCN7850/hw2.0/amss.bin
> 5dacdfbe6c3c25d9e0605be8a9f1f6e4  /lib/firmware/ath12k/WCN7850/hw2.0/board-2.bin
> 73056f1d2aff886ce9bff313f455e963  /lib/firmware/ath12k/WCN7850/hw2.0/m3.bin
> 
> > and have you ever tried the upstream mainline
> > kernel or the latest ath.git tree?
> 
> I'm not sure what you mean by upstream mainline kernel, but v7.3 should
> be the mainline kernel released a few days ago.
> 
> On the other hand, I just tested ath.git tree at tag ath-202610191908,
> and it worked with the old firmware. So it seems there are some gaps
> between v7.3 and ath kernel.

I bisected drivers/net/wireless/ath/ath12k between v7.3 (broken) and
the ath tag (working). It lands on:

  15f7603b69a8 ("wifi: ath12k: Increase RXDMA buffer ring size for default memory profile")

The previous commit, 643f0bf93617, still has 4096 entries and is broken.
15f7603b69a8 changes one line, .rxdma_buf_ring_size from 4096 to 8192,
and works.

Shawn
