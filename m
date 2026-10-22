Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792660864;
	b=CKXyEyfrBkCoebD0LGCNEGaqDerf3ZT1bSN1kTPAFXEuNCj/eCj+kpuvbmTEkHVDsXAr
	 m1wggvGAzONscv41EqAVoBgE6Zq25TrsUzJTkM03uYPdNIdnWAH9qxKYM02hog3J5GnI0
	 83MaOaA+vph1WH9zmI8eLmJCzMuKplnrTnMlje2/2pYbcFN3ynTGLJHzOFoq++f3I6tTM
	 vJmuaNlKcdoY5ssBUoswb6tvSiB5+xepsrE4VYBgwJwkZHT6xkHhorFadO2qqV4zuTgBC
	 /jNEUJuCYp4TGiTe5BfBlNX59jcKfRFz+Mhsxji9ewAh3yJvEW2L1CLhi1zDcrGPPuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660864;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=NVpZTOS39bJD86GMEOLkvTbG4Abg3hAHRNogiWaaDMY=;
	b=G6/ad2jpCk3Ed3vQq2UejIZWXkcDocVPh0GXI/I2FbM01Ez4FI+GjNXrnQ8xQyPl9pAO
	 6LCxGN9eeM9krNwVn4f1WZ8UNAc7Aqwc9ggHgJInXftOs4UVeyUjbo4YTYwyLu0AqQs7m
	 D+biStQq2GCRs6PCiP59mmvzb5V5cG+cZJTnhsdBeJHzzklJ+Y5RjhnWgh69L8svorVmr
	 wmpKiTBShjoeX8l6SEjp176xiWGxU272Ol+oI96Ect8+hpUyJkUKwSJ7pt3u1dmNub2iH
	 6MrLEalO1CNxZw22/L2Ff4MqM8oKZ0uYjfS81TiVuNCvYMUyLJ4YeW38xuV+Oua72GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LmqOGSLG;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Afur+Cjl;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48245606A320
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 09:21:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48245606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LmqOGSLG;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Afur+Cjl
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M70KL42174683
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 09:21:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=NVpZTOS39bJD86GMEOLkvTbG
	4Abg3hAHRNogiWaaDMY=; b=LmqOGSLGYOWzGrKYFVtIei8sWtRTw/GT/JAqZbcb
	SjuH/NTEV550ufgxdJ+sanGKyDZvpG3M5CmJ/vxvGNL4REDOY9BVnMraIrJqOk7D
	imS7hFYB1x4b++4/WKhZ6+TRJKLuf1v1fQ03iA6/uL6E6JSHDSyq10mzh3qHMng0
	DCEvz4Tkru+Nm2RTPpYwdjqUVTDgfe7UAexEJh06SzbobnjrXfxM0JErZcxsTmxi
	VpL9HBlKxG3rLgz0XvTHaMKEW4rxcWFWvtvqb3mTDsAUR4IRVtZQFacVtl8MMGR2
	HyHlipI66oUKzsJ6TlqKn27/XYGA0MBeip6Oeivae1xR5A==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93ahntp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 09:21:03 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30c0d568830so3967531eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 02:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792660863; x=1793265663; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NVpZTOS39bJD86GMEOLkvTbG4Abg3hAHRNogiWaaDMY=;
        b=Afur+CjlahluiInLfdpjmFTCEv/rL0ZendFszspciXyrU1Fa46byRkCPv6qhfseOXG
         PtMYkXK7JCBYaerU6MlLyjo2QosuwpyjlwVoePM+ztYPpxTsUwGuYHUf0p17Rn2NhDvN
         2f8r80iYRyxKujXlrz91iuDasikA5bZbEwI9NDIdlfmsImIGOAJnrG3lK9bmiL9tMetq
         gGNgFpV4UThAzwWOB9KzyQfO7Sf+fGh1+nfJ0wm7OC63/noVvjEt0B8DITmpAqhPqo1h
         1Rj9nUhpWQGZxBK9EG2LXwtcBJ1SFHOC5t5t54JfVO30RQOsCYdESLFxh45ln7PS5oTG
         hD9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792660863; x=1793265663;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NVpZTOS39bJD86GMEOLkvTbG4Abg3hAHRNogiWaaDMY=;
        b=0r+8k34m48J0gWlkLHLhwkcOzOIWsf9aYvzYb/v7ADV912U6e+wVVVuihxQhxLYnfL
         xG+ly2ZMC454H+lTF/o3GP0aeyzN164w0+msMnu+LcprmFKk8WfnkZiC6OIz9G59xNPh
         t3LLWRWvqC+nxQqeWXEGJSLsyOGIEP2jNfZjy0OqSAV3Tm8PhamzXA5HSmI0tEtWN8jZ
         wR4Z3rXt4rHQX5v5iZ2ZnSBeea3jIrM/jIKHVXbYN/vp/hQIA9Sv+tqVPlQ/C4fcsQ0K
         +Da3Cl8OxSl+Cohhwn3i/4UV0bTsJuWmeRWG1IxhcJeXn3Wmb+CDbpMTcP/yEf9h4oW2
         46ng==
X-Forwarded-Encrypted: i=1; AKwUvBy7OjEzWkpV4hjbngis4snzKneA6FKANdvwXsFinhWEY0NFFTB2yJYQoJFwVUbphqFTCDRmJ9APJrkMqzVQig==@vger.kernel.org
X-Gm-Message-State: AFq9FYJooEJSYs+LQgS+KDb4/m31XXsMRPtuJL8EhGwdFSspk8R4btDd
	KjkBA1U+6Bnj56DEcJMellVUBCupt8leeB9FqKaoHPth7J7F3F/0Mb7SKg7Rfbg6TcGRsB21PZi
	55iccaUOe1ja0VHGO2a4E+Y3JLG4cGszXQSMUWSd55l1O9xFAb191Uh47m7RXkNEWeiKH3g==
X-Gm-Gg: AYBFou0geLatkykTZxVCezoo638ILClIevRSqO8oVzeKmQzQRbSnpf73OqmXHiIHs/x
	QtcE/35UICDzCL7gTnosvi1K4NNz9RJJN7Vqq7gOzExHwmi97IjTn3Z8qhwtCTwzszsKiaBkFR+
	aFbZ/5vxWK/0LSEqwgfSnqBg7bYeNVZu+DFaubVYhWj5GHsbdK5esh71N+KwiEnsh9FQl98n5Xz
	xnVPiBM7LjeyYVK1o4iofjjvsYTMAIqIhwQchnt+u9zdKwKJGRQOjZXesW7rT6E0wx+BzBfgTws
	K8DK4pX64h7d0+JeA77SmzWo73DFsYtQFpKCXY1orxMcjYf5hZaihvecwpcSbNsdcf4bMMZ+kD7
	XrgHPp9gLmDoeTHns0xBbsA0GxD8zdj4/DDLM1gwi4A==
X-Received: by 2002:a05:7022:fa9:b0:154:dc96:c1d8 with SMTP id a92af1059eb24-190a03343a9mr7430760c88.2.1792660862389;
        Thu, 22 Oct 2026 02:21:02 -0700 (PDT)
X-Received: by 2002:a05:7022:fa9:b0:154:dc96:c1d8 with SMTP id a92af1059eb24-190a03343a9mr7430729c88.2.1792660861822;
        Thu, 22 Oct 2026 02:21:01 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903a275026sm19923167c88.5.2026.10.22.02.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:21:01 -0700 (PDT)
Date: Thu, 22 Oct 2026 17:20:56 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Yingying Tang <yingying.tang@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
Subject: Re: [PATCH ath-next] wifi: ath12k: change MAC buffer ring size to
 4096
Message-ID: <atnVeGiu9Q07HyUq@QCOM-aGQu4IUr3Y>
References: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
 <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
 <0423c93c-8359-4fd5-9ba0-17e5ed3927dc@oss.qualcomm.com>
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
In-Reply-To: <0423c93c-8359-4fd5-9ba0-17e5ed3927dc@oss.qualcomm.com>
X-Proofpoint-GUID: jDilKmjUaZnv2ajacFq8j_bqmrR0fL_S
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAzNyBTYWx0ZWRfX/lzBljcQGSzo
 0A7N9s52m0S9RNE9/KaberGy2uBu0keAE9kQP15eWO55dcd+ovVY3HF+53lE76dWRfRFQWDk6h8
 i51s4m29X5YsStrpMwtNXuI3ih/Sok0=
X-Proofpoint-ORIG-GUID: jDilKmjUaZnv2ajacFq8j_bqmrR0fL_S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAzNyBTYWx0ZWRfX/HMwqCMOrqEj
 /4ZTDdkP5+TF717xby61M3q55WtDpFyCVjb1wQzysuFO7Od88So7sk9xfWzBvDptkpINvRI+/4D
 0/f72Z21a4IN5599BRaXHA0vGnYGRcXchgqAdGt5FrDZF+mWAsrPB55IcGO8oaYBNcrw0k7w8cG
 JvJjjJl0iMSI1x5CY934wkZJyuc7ZB09A3ZV8rhiLdJTCm5hbLGkbTe81h6wIwG5q2qMjLkgn3X
 ITc+I2t5A97N764zyE4TbrgbOzCL6F0ir8XBtmX6z8Jv7Iy7MektuyiIU6kovyNkpCsQguHFZie
 bQ4WAkXbSafO1cl5UQ0wiv91zL1g8acjIl79pqssq9kXHnULAEyNrYkPTRR07hnq+UH9CwTwNEX
 uXz74MaTa2oQlDP8h476P/CTsUFImnXXoouKN1i+jrL7Y16G8Q/T+dPA33Xsn0ThUMbaYOqnp0L
 P69f3isUy2uiBhDG3Sw==
X-Authority-Analysis: v=2.4 cv=dOszC+Zb c=1 sm=1 tr=0 ts=6ad9d57f cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=08gsXnlTphqh1DqfKuoA:9 a=CjuIK1q_8ugA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 spamscore=0 adultscore=0 phishscore=0 bulkscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610220037

On Thu, Oct 22, 2026 at 10:30:45AM +0800, Baochen Qiang wrote:
> 
> 
> On 10/20/2026 4:53 PM, Shawn Guo wrote:
> > + linux-arm-msm
> > 
> > On Tue, Jun 09, 2026 at 08:13:58PM -0700, Yingying Tang wrote:
> >> For WCN7850, MAC buffer ring size is updated to 2048 in
> >> 955df16f2a4c3 ("wifi: ath12k: change MAC buffer ring size to 2048")
> >> to increase peak throughput.
> >>
> >> But during the RX process, a phenomenon can still be observed where
> >> the throughput drops by about 30% from its peak value and then recovers,
> >> and this behavior repeats during RX.
> >>
> >> After increasing MAC buffer ring size to 4096, the data rate drop has
> >> gone.
> >>
> >> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
> >>
> >> Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>
> > 
> > FYI, in case someone else runs into this: with this change (merged in
> > v7.3), WiFi on my Lenovo Yoga Slim 7x (X1E80100, WCN7850 hw2.0) stopped
> > working with the older firmware that Debian trixie still ships
> > (firmware-atheros 20250410-2):
> > 
> >   WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
> > 
> > Probe and firmware download succeed, but every WMI command times out
> > once the interface is brought up:
> > 
> >   ath12k_wifi7_pci 0004:01:00.0: wmi command 16387 timeout
> >   ath12k_wifi7_pci 0004:01:00.0: failed to send WMI_PDEV_SET_PARAM cmd
> >   ath12k_wifi7_pci 0004:01:00.0: failed to enable PMF QOS: -11
> >   ath12k_wifi7_pci 0004:01:00.0: fail to start mac operations in pdev idx 0 ret -11
> > 
> > Bisecting ath12k between v7.2 and v7.3 lands on this commit, and
> > reverting it on v7.3 brings WiFi back with the old firmware.
> > 
> > Unmodified v7.3 works fine after updating to the current linux-firmware
> > image:
> > 
> >   WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> > 
> > On Debian trixie that one is available from trixie-backports
> > (firmware-atheros 20260916-1~bpo13+1).
> > 
> > So nothing needs fixing on the driver side. I'm just leaving this here
> > so that anyone who sees "wmi command ... timeout" on WCN7850 after a
> > kernel upgrade knows to update the firmware first.
> 
> Hi Shawn, thanks for reporting this. I just had a quick test
> WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3 with the latest ath tree
> (ath-202610191908), everything looks good, simple connection and ping pass, I don't see
> any ath12k warning.
> 
> The firmware images I am using comes from the first commit adding WCN7850 firmware:
> 
> 	fb04a7f4b750 ("ath12k: add new driver and firmware for WCN7850")
> 
> and the md5 values are:
> 
> linux-firmware/ath12k/WCN7850/hw2.0$ md5sum ./*
> d3750b67b1013fe82358d0538fb131b0  ./amss.bin
> c79c410d585360000c0490f16fda43e2  ./board-2.bin
> 73056f1d2aff886ce9bff313f455e963  ./m3.bin
> d0ee61498bf1a205147cdbcf645391e7  ./Notice.txt
> 
> can you share the md5 values of your images?

Hi Baochen,

Here are md5 values of the old firmware shipped by trixie firmware-atheros
20250410-2.

$ md5sum /lib/firmware/ath12k/WCN7850/hw2.0/*
d3750b67b1013fe82358d0538fb131b0  /lib/firmware/ath12k/WCN7850/hw2.0/amss.bin
5dacdfbe6c3c25d9e0605be8a9f1f6e4  /lib/firmware/ath12k/WCN7850/hw2.0/board-2.bin
73056f1d2aff886ce9bff313f455e963  /lib/firmware/ath12k/WCN7850/hw2.0/m3.bin

> and have you ever tried the upstream mainline
> kernel or the latest ath.git tree?

I'm not sure what you mean by upstream mainline kernel, but v7.3 should
be the mainline kernel released a few days ago.

On the other hand, I just tested ath.git tree at tag ath-202610191908,
and it worked with the old firmware. So it seems there are some gaps
between v7.3 and ath kernel.

Shawn
