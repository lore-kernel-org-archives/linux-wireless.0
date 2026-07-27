Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61278396D09
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785166196; cv=none; b=E246xwYubXTkbltJ5+IPKrnWC7Pe3bISoAgxLXrhCp1ZKloZdhI/X/BW/DifTMXmoVaHMOBCAyHWmV56G9U3bNQ6KJO4FDgvZ20Dn0u1BELPYDZ8fwn2j0QKciArE6n9ONuxBKJQTLPCKi6GrYMNbeVmpIY2NbEVyzfsCRkO8m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785166196; c=relaxed/simple;
	bh=IZU6MDVTNHWrOxVhC8cZmK/SlQtqEcN+EhPWWcShn3g=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=KcGtLwxaZg3fbz/ZTrzwMJo8ThxyTuFFnepzUIm1+Mwa6ujASOYOZh75VlQTw2XBboD8s/5q7PTz48Stc0AhfxhXcshzNCel5ywdPVWRa+TqAIqO9U8e+lXXRa7gLi6MJVE0p/Ah9UCuGYCva+E4MRtLShiY39Ww6FSXqP85gCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WYfoJWar; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PSVYkPvX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WYfoJWar";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PSVYkPvX"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RDm9033823643
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:29:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=aCP7o02Y8I/xfGf3dGEk8z
	Mltx8sX5iT2Za0pUwKugE=; b=WYfoJWar3ooaV9cJywWtCXVn47vd44paedwCcT
	s3PiFVlFCpPityAaUTQ/e4GZHmZ66B5v41gNSlZ3imoFoTgmwRdOiRc182jW1NjK
	EDi1dgrZr/dttr4Pq1sbSbwqmr1ZNs7iE8nq046bn2Z8XTUByy6NOXA7lgG+0sRP
	R1r7zm0s06pcSlTo0T9+oAIpqfUQ6RWSI40UFkCyYk7XU3fWF4WOWKrCSboNz/eD
	TGLi7FOkYtFIjFOKHsWecvlBeAWdIS3rMuF51+cK67GOJhk0+CAA/+XnrSuPXgHx
	iUGo4mhjoW4dqgZsx38CVwtuo27ufLihgcR2if8EP6Zqifhg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fp4nbsh1c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:29:53 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e54b6556aso3376955a91.2
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 08:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785166193; x=1785770993; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aCP7o02Y8I/xfGf3dGEk8zMltx8sX5iT2Za0pUwKugE=;
        b=PSVYkPvXJdt1gWowoQ6bdvMZLztaJXiDO+Ngrr5QeJ4kh6IArKp+cV4HmGcXdY2Afv
         Txd/x9mv9CYm+AST0OkezCX2304mNc65mqEgfGloKnF5TBKlvEZYb535FB7cGDRzmGFB
         NO0HyuIVb0ANhC+0Iinng8AASpWt9SvQ37tflveu+pmyn+DSw5XsmyUW8o3y/CS3Gw37
         /ClZdiEkRiH/FDa/4j1QmRE+55UZb6aMUToK2RDmNeIjocdxMcCdmsqMP00qgCdLImB8
         pFsZ0cXCOcUsbSEiT7ijZnbdiwEe+sEw5n+FgQwK42Cv0CDAjh7H2BLeS5NCqEk9cw8h
         2O/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785166193; x=1785770993;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aCP7o02Y8I/xfGf3dGEk8zMltx8sX5iT2Za0pUwKugE=;
        b=Buzeo9WtUqjHetKmcV4ZCTS7Fos4/wIj4JPmaQPC7tGDWNAbFbV+k+r/znBnczFp5V
         9Ys/98S6ddpPL01Iwr9hPaTYg/4DJXj3Pe79KVRfywYTKUflt8qJL81zKRlqq2FtbPBQ
         Zz14HHnshYyXo92e0pLZZfLnIpU/JcQEI0hTExRAeghrxj/MPq7LZVbT2eSUj8X4hCkI
         4eE6bSTjY5mAFhRdq2sj29tjgqp5pGlNAA0i7ugAIeFENXQfiKbFl15AwwpBCz8Xtoz0
         jL5+IWhIw1KDU1Z4z/r7ZcTjD7k5dqnjUBFcbAExBmEvmEBUPPSHtvu5iqNJbZQ6JFjl
         2hCw==
X-Gm-Message-State: AOJu0Yz7ghKa9AmRonzdt7WCmIVlUNkN+l22MnCz76RJkEzfEOp7AmNj
	VJRxg/m+ZO2dEnAGr5oP8Lw5hGZUPzk9e/GAmMNpU6sQdtcaKE6TzoSFLzN+vmRuLLxtYoispo2
	vHixC38mYPQ5ettEjniqHxyvw78chZPsyOoHUwJGdef89vD5Z8j6r562zWgLkWJa7MLZ/65IQg/
	OwyQ==
X-Gm-Gg: AR+sD11zhae1qNAYjPr0FqKFFn/5WD62MsUpl2BoB17VQ7Aj28JTSM6VgkBNerhuXXu
	e/caA5D7w+Wsyvm+Ryu0eTsn+FEbgwSXqL8vCj/sl+JhTzgqS459zl1or65JBjm4s0l9lqSaarc
	vzfyVf8MT3DD6eKKjY6RkwRXlKOMH510CQib91EPtirrqUqvlIKYYTTnTSOoWrSirWOR/aaonRg
	8J2rN2al8vOEgJT8N5jCW8hr8QeyV2aRBsSNFVQqxUEbsAuin+y0PNe0wEEdXid9brHzgjrz7Vo
	uyA9zuof9bSVr1LoR6DVUkNdddNgMiQEVE2hO7xGx7jHSkbyY7HGnC/fST0YHbPaAysDkFP5ZPP
	NSfVQjtR/ejtw06FdhA2zuN1Ch0Sb1UWqA1Ah
X-Received: by 2002:a17:90b:4b86:b0:38e:a555:8fc3 with SMTP id 98e67ed59e1d1-38f2965654bmr8839882a91.41.1785166192580;
        Mon, 27 Jul 2026 08:29:52 -0700 (PDT)
X-Received: by 2002:a17:90b:4b86:b0:38e:a555:8fc3 with SMTP id 98e67ed59e1d1-38f2965654bmr8839848a91.41.1785166192076;
        Mon, 27 Jul 2026 08:29:52 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d130f55c6sm88728062c88.15.2026.07.27.08.29.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 08:29:51 -0700 (PDT)
Message-ID: <8ea62ed4-0a27-47f3-ad4f-b30a1317c800@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 08:29:50 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
Subject: pull-request: ath-current-20260727
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: VofVepeWWCavaW5CkjL_5Q-7FejN8feR
X-Authority-Analysis: v=2.4 cv=cJjQdFeN c=1 sm=1 tr=0 ts=6a677971 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=LjZE-VvXoyxWvIaTNqcA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0NSBTYWx0ZWRfX6SbWl3ta0092
 NnZE1qOMc6jqD6ZgMWF+G0RT5Anf+qwoNUPYp/Kojwh3rE/nE+2tDR693eEr4KV9J7+UNNnOyoP
 mGzGhrTUZnyrxvKjkWwMPliF+zW53Hc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0NSBTYWx0ZWRfXyIN+t4I+h9i4
 wqo3DxvqFwFaMPqHwiVctzN+/OUdzA7gNzwM6Ng621FQDFOKI8TFNT3Y5c+yv2XGrzx7dYiOTHd
 N0URkBqZrssy0nT1xwAhiUKZJAPTpi6avMj74re4OmQMUlRD6nlfxOE3DSUqgNMTqoSCjvyqofV
 Dm5PIjfuHskTWd2oi6Nr9zxF3zbgZNEsfmNMB6o/kzdauEzhvjkmsxo5GQsPTAl6MdKMLIYQaWr
 07nCyKB/wEqeSmQBx6Ew+EPGPQcHUmMbFKNdBJrSfUyzCdSKkN5zR5FTH55M2jET9INcXB3TDpL
 DVF3SLPMUFk5e/jcJIGmpfWemk+pURXsd83QjuhelZeDPkyuR/3dc9yDIUdbbmZRXPzTdtvz4JN
 3H9pfeM92NhfaxUaNySa/8h183E9cw9ducWJaokzqRaqDjSs2zGWZsSjJ4zS5AfND5KLdwMqPTd
 B6VX6wsLCH94FkS1mPQ==
X-Proofpoint-GUID: VofVepeWWCavaW5CkjL_5Q-7FejN8feR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607270145

The following changes since commit b24adfed83ae3fe623d978a30d5c6c636a874821:

  wifi: cfg80211: guard optional PMSR nominal time (2026-07-21 14:12:24 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-current-20260727

for you to fetch changes up to 469d7e6077c1665754eaf330e1feabdca7b060ae:

  wifi: ath12k: resolve PENDING ML peer ID from MLO_PEER_MAP HTT event (2026-07-27 08:00:43 -0700)

----------------------------------------------------------------
ath.git update for v7.2-rc6

Fix an ath12k MLO regression impacting WCN7850/QCC2072.

----------------------------------------------------------------
Baochen Qiang (8):
      wifi: ath12k: fix out-of-bounds clear_bit in ath12k_mac_dp_peer_cleanup()
      wifi: ath12k: factor out peer assoc send-and-wait into a helper
      wifi: ath12k: keep ATH12K_PEER_ML_ID_VALID set in ath12k_sta::ml_peer_id
      wifi: ath12k: add support for HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP
      wifi: ath12k: introduce host_alloc_ml_id hardware parameter
      wifi: ath12k: do not advertise MLD peer ID for firmware-allocate devices
      wifi: ath12k: defer dp_peer registration when firmware allocates MLD peer ID
      wifi: ath12k: resolve PENDING ML peer ID from MLO_PEER_MAP HTT event

 drivers/net/wireless/ath/ath12k/core.c     |   2 +
 drivers/net/wireless/ath/ath12k/core.h     |   3 +
 drivers/net/wireless/ath/ath12k/dp_htt.c   |  49 +++++++++
 drivers/net/wireless/ath/ath12k/dp_htt.h   |  12 +++
 drivers/net/wireless/ath/ath12k/dp_peer.c  |  75 +++++++++++--
 drivers/net/wireless/ath/ath12k/dp_peer.h  |   2 +
 drivers/net/wireless/ath/ath12k/hw.h       |   2 +
 drivers/net/wireless/ath/ath12k/mac.c      | 165 ++++++++++++++++++++---------
 drivers/net/wireless/ath/ath12k/peer.c     |  31 +++++-
 drivers/net/wireless/ath/ath12k/peer.h     |   1 +
 drivers/net/wireless/ath/ath12k/wifi7/hw.c |  12 +++
 11 files changed, 293 insertions(+), 61 deletions(-)
