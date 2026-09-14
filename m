Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF66438A720
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 18:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411590; cv=none; b=FBZnWbkZ9KknVDupbzQJ9y2wu8Hz9AIS/8XuiE/bO0wtgIBEeHDyHl4h7ytxjoE1gkQNrtL1eugblJGwKYWLG4nB/Jc+SXNwKwom2haRO/ySV3vfAbbfshfdydHIUfupVuKlXouJdzXsRaYFntNd1aYZsBrT3LqQAos9wsBK1qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411590; c=relaxed/simple;
	bh=6qwHU1pBvwvVeiB+EwvHmJAzlh7rgXNsJCuNwXrKbSE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Ha6IPi35pzKOfKezjAWbupYhQzpy/T+ryG22UNzRUfGSzANburP5Lsq0j0glkR+kgbMYVKKWIUAFesmEgvJJk9pCXiwwVzJ1Jg7NeiTW1lYzn/DOKrYPnuK2o3KZaAA239jl1Uq++8yF5e8odldumiA1CSwWKgRmFZ4myRFlG/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bv29eTBq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=c4Gw57c/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bv29eTBq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="c4Gw57c/"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68EHBcC22087280
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 18:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	unaeFtXbw5/nkCmiogEEEYBGyDsYb3eZMTtNUOv+ZZA=; b=bv29eTBqKmBmy5xR
	bKYROg7AkSFE5e5NsNya5H0jXybRrbEM+yZ+xLOECbgVi0RjE6E7kUya8a6AapmD
	imgOxmDIloW3xy3RZhoPjghgfL4a8T5m01ZGzWZdoWMV9fRsuQIo/+Gdhm+OjtLs
	+LhNNQaU9HTukydmkcWndH9eOBUAT4+YZGKQEUQrDennMH/T/THFz2fGCsR39A94
	7xvjhOGEhW6UDBzlIR7xvfoudCTh+zIVfGCR5hu/Wg89jxCWf3WUTGVHdo8IZE2f
	nrhg4PGcgChp4xOW50oza7eYjOip3aaOUBjQbA6VvN0TexhJMCzW5m7+tj+VZXaV
	ZsNDAg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gpn41rbhs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 18:46:27 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d02df2bf09so34228155ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 11:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789411587; x=1790016387; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=unaeFtXbw5/nkCmiogEEEYBGyDsYb3eZMTtNUOv+ZZA=;
        b=c4Gw57c/OUJ24RDBt2JbGGp0RKVZK6TnrUw/snwt37ZxWvGGLYglwQ1GzyQq0Prw2g
         AbVtdCfu/9kHNvRQKIjb7xz3VW4HNWWYAiHB2k1AP5FF9CVVnexwstS2Jp3QQdAXOfUc
         kEWBTrmJH1FBrpCAORLouC6yooOC7XNNgE/Oa//N/+maZ2yKyqoCj5gwUEoQQpr9Mohy
         YVlez61IAEaH4nYvb/U/eC7gJD+sQxjKJqTVqM9ofU0yKM6HPj/l8DpGZEm5oDqgf5Je
         bjete+Isd9IwLnLVTjnXopA/43Fl1fmFsiGL3KAjYVAG0J2eiXm5BVW4ql0iyFI82pEo
         Jypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789411587; x=1790016387;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=unaeFtXbw5/nkCmiogEEEYBGyDsYb3eZMTtNUOv+ZZA=;
        b=Bwc2CmZ4BG/aY9VmPD+kCleKq4AcTWq7q60Wa6W9Uc9k8s38ac/bdRx6vRaRMG3394
         CNqWgcmHHdvC3Kp26F4r9UAn21dGrrfwvKXVLr64HM/bto0470gyBpSHRMZZuOIVZgHS
         Qm6ddNYpdWc4X+5UAkJI3E51o5smogB7+Er58oduRHiVmBNoGVHMD2OVaAy420AbTtR3
         i2QMo/wjgYcFyNYr21G2tFxOFFEt18S/PobBDAgZGuJN/bMW2vOLVgVZZWkgoiZeJkPb
         EfNMwKjVHD8c+4KeSlZTCW/wkyI1zMlvrzBwfEdgsKG5UltiZ0J1hzdoO17ysIFxQT9Z
         8gRw==
X-Gm-Message-State: AFuF++lVpDZokdDN7P+yMUVMb9xjPV3+rINzITpr1rDCVraW17KduNHw
	wsd2EiVFihqylGXHt0uDYB0y7olGXZIgJ3Y7QNmVHvJ4xBAT2Rdtp7VO4EI5gmBEF7KpdWOrqHx
	vPnwzvH+btwh9GCPMHRYvP/RW6ZrlGPsQYpNrIhcSmf3ZDJdLzP5akk0/Iyqj4JdydLTG0NBhOx
	QWtg==
X-Gm-Gg: AYBFou04o3vWn4WGkVvioQYybaUJKHaPaf5dY28xHjS7Lr7Qr2hEbQNqO42XB769Xm+
	FbAgCV8yJslhMGYNxnMk7zHkfi7eLjpUs7+LK7dTacQdkxJfJ7etTte+aMRho1pwOjRzfjqdaD0
	0WB4j2GRmWcYLRCoPw0oGNHT1Qh5+rzoSxkfDgmFT1cXFyDJG+BmleAGDpnWJH0ELIcCK9z/ukJ
	FE45r+isVbxQO//cqtdC+9DcQM6NyYsPJTPpIHYydELq/sx8DXOlfmv+zxqNEqT1zeH3F19Puk3
	+C37nmGMH8jHf7a9+c9CLW5qLcCI+lIWbIYv9/DKZKYnlPS0nUsdIRo5w8TM0C6tc5pCIPRUY6G
	Z2LBFBIPcqi5YUQrN+CXIiVKh7hep5uGcur6oi+cTnEqzECfV23F2m7U=
X-Received: by 2002:a17:902:c94d:b0:2d6:df31:5bd0 with SMTP id d9443c01a7336-2dd6c6db162mr73205995ad.10.1789411587221;
        Mon, 14 Sep 2026 11:46:27 -0700 (PDT)
X-Received: by 2002:a17:902:c94d:b0:2d6:df31:5bd0 with SMTP id d9443c01a7336-2dd6c6db162mr73205305ad.10.1789411586736;
        Mon, 14 Sep 2026 11:46:26 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4f06423sm32032524eec.20.2026.09.14.11.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 11:46:25 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath11k@lists.infradead.org, Nicolas Escande <nico.escande@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260731145830.769811-1-nico.escande@gmail.com>
References: <20260731145830.769811-1-nico.escande@gmail.com>
Subject: Re: [PATCH ath-current v3] wifi: ath11k: cleanup arsta in
 ath11k_mac_peer_cleanup_all()
Message-Id: <178941158566.2896945.16894066499695332359.b4-ty@oss.qualcomm.com>
Date: Mon, 14 Sep 2026 11:46:25 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDI2NyBTYWx0ZWRfXzG+oFJbwe8de
 orwbGgsoLl/UhucvDUdGg4xrpIoGo6xf7KZoUZU6x03E96UtgNu13gUhliq1+hUxwb5QUk5SRYs
 hcsRsgVQGLjh/CLjBW7nkPBZouPNd+S9qe56WEv/Sa4/jbdS+d75dHOvFWc5YNbWxPhB4+aU+rH
 npvYciHmqsxa/ILZJjoKQwWY+BI2UCEZyXpEH5AMWzCRdfZK/tJKKWIWaHjF71iy2EksNy9S6l/
 gYLAhLX+lgd7FZilKATydClWRYGG1IHpCVVXuYQXFgoLDwD2l3I4sgIYt5i9ioFTlS5eOvsCZe3
 K2akufDrZmwoK1vHoj0FzYKlloQbce2WnfYHBjWhJk2/5krDxTbKMq0QyUsjqddGPOwcv/8gzYJ
 Ua+0vTH71yObqhGhqDb6zbNj8Kc/RuaZClY/llKOMix7YFmDvMhS8Id+Z6aHQN890LW2SnfX6LN
 i2PG8UnPm4Ovxm0iQEQ==
X-Proofpoint-GUID: cFlYwZQDWhVJI2or09SDNdCtdJ0erm-j
X-Authority-Analysis: v=2.4 cv=cqQOAF4i c=1 sm=1 tr=0 ts=6aa84103 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=5_m9DTtpo_CcFsMShjoA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: cFlYwZQDWhVJI2or09SDNdCtdJ0erm-j
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDI2NyBTYWx0ZWRfXzuVJE+OH1HFu
 xBEKacVgpdb/XVscdI9Vumt2GYa5YFMs1NQRnGON8oBkPUkOw9KjDDvSFDOHkU00bCexHat1Qdh
 0Y56CmHVTIhNaHWI/wAWSe2bpD9LJuk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_03,2026-09-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609140267


On Fri, 31 Jul 2026 16:58:30 +0200, Nicolas Escande wrote:
> When mac80211 removes a sta, it calls .sta_state() which in turn calls
> ath11k_mac_station_remove(). In that function we clean up both peers &
> arsta related resources.
> 
> But when the firmware crashes, ath11k calls ieee80211_restart_hw(), which
> assumes that all driver related resources are cleaned up beforehand. This
> cleanup is supposedly done by ath11k_mac_peer_cleanup_all() but does not
> in fact free arsta->rx_stats / tx_stats.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath11k: cleanup arsta in ath11k_mac_peer_cleanup_all()
      commit: 820b8cff81c796ba20573e04722ab62500713f97

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

