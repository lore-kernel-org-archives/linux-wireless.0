Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793052121;
	b=3hpTwTv5Lxa6Sz1kOymcPb5tfWlEXEz+3UFnTtIJ6PeyFW6OqrM5LoYtyv+cDkeNJFx7
	 l6FpnBpxCUJFsVa5mXhLSK1d9oOUSDMAoak3OSDWol91+p5SBtyzahgtz5TiMTYFydEn8
	 gh0N4BaCFH6lG7DyQtc1Xz/oxivCUPj8pbSsGYoAz+iO0RtcAGkEfOTjSR6Fy59JKT2Qq
	 kwlrnnEhS57orswbozVRV5BJkBn/o+F4j5FTXS5tVoF5QCOKhDBUd1Pk6ldBW3zrNafB9
	 J5HB2sPzQuuvtDbDryMtfbckTqCu8E9HhD9qBdDcGtNyHoanF7tvuiovO0MrbK5re3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052121;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=zIKu1svv42yZ7SvRmv7bgacrl6WK3b3yfGRojbwaluE=;
	b=0cuio4FeKIzSAOhvtciO+ebTNvkIYoyouV8pdGk4vylkfYu2hdzJT77vO7785Zh0AutP
	 vo6DmpSFD1IrXqdDuvK41S8Mqp5OZfxG1nylqfH2fCDCgxd7N/Sh/sUlHQBIyncOB+IiL
	 CdjXK7nPyxH5oka5k5vYtA0Eg976cLyNzKuRV896DgA/Iig0sRK98TKR6rVvTtmJMfF1C
	 LRrRAT0zVx1vXC0TSiYUIV8qez2zJ7Qqeg1sgPYjh7CHVhEAQp9SL5vSesLs882rV8XW8
	 8udFvcXPRMk8fa8b0iNbV731ABrtZTLovJZPwGcQ5mJzlkUbwodkER2pKDWl9gUff0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=af0rDMuM;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WskMmUq1;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA07606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:02:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFA07606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=af0rDMuM;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WskMmUq1
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QIoLGR3055282
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zIKu1svv42yZ7SvRmv7bgacrl6WK3b3yfGRojbwaluE=; b=af0rDMuM7Tqu3iQN
	lmvAcelkotXJ9dZazE8VH7s5Pc0AIhISP5RSmCIXc3AvW0oFdC/jM/eY072D6e48
	GKhhIjggI/Sq0oj9Gp76Nc7DfAMRjhcinpkBMpnyn32Pubs7zv9d6py/e+TPP02P
	fxlhJr7UmlyOHOJUV9YGwpETnvZw6sUzVyKhNAODrs0K2Nfkt6KQsk2kouHDEHjW
	LAhSiwk9+RyUemUkOV/xKWiRY3qmPNZ7ZVd6CGhCr97A9nshgy33TjGvgEyv5ufa
	22zwqjyXLR8TCoyno87iRM4CR3gOSN3BpTKQS6FvRaYH7+RlbRSNV5GgMk8Oi78r
	5UYzEw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hj8smsmyh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:01:59 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3552883bd19so3202095eec.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793052119; x=1793656919; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zIKu1svv42yZ7SvRmv7bgacrl6WK3b3yfGRojbwaluE=;
        b=WskMmUq1d0gD2lfghU9dadVRKEhNb+1iW4vQR5SjOsd/1JTgP+Nc1SWN5e4zp9ZFI4
         wKLLTesjKyrmOe+ObDPFW2Hsfon9B4kNaGtL91agX7kop7bvciEb0ACvr6z0HeVYVuZr
         ACoc3ggivl5trKmHeVxc7/ieJRfSg/kCtSZ96Fx/HY7myxJyIMTPxqiBcOBm0ynu15Ax
         NUjKyDBBIUbiTstpTHyaJhEvgw3fYVtspMZ4SAMmxd5PNWBfADc7NJTd6kEM7ivxcP6V
         6cTtw9yNPZrKvKiP048d81l9Z06xLyEYaHmnNK/mVpfDRjXkwDgAvpdsoXMleZpub6kn
         INtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793052119; x=1793656919;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zIKu1svv42yZ7SvRmv7bgacrl6WK3b3yfGRojbwaluE=;
        b=FS6ybQDVQ3+gXH/Y6UC5RdCZJ2ZVyoMKiggBYHK1Exj9Tdo9PuTCyKgGnzBnHsb1JG
         H8XlcBVrkuUfHcVijw5b+wM3ctM0siyOyUHZN2UQI0N/4As2qEqQJzIa7GFSPPFX0fAV
         FTSSeQLQGd7V3hdamNyp5hd/FtWeCIs0EWPn+XaPs6/cc+jAYMfM7DK5Lf4o/7p49txE
         wVHNdys8dWEaSOppEmN5vNoMaBRoRubIsbuFPCxCGaTL+0bVWP9YlcHaek/KGdUAaVLb
         t/+IJkRSlOHKnNd9Qw1FpiPHT8VesaYU7wc1jJy4g9OGf6m78aOOKVBMpC8OpFIYM7D/
         CA/w==
X-Gm-Message-State: AFq9FYKPyTDNk3SuRwnWFf5WMnBrkKET6/cWe5qOrhPY3LCHgijBiFbd
	BpOTsP/YXNTzWWmmVxuuMJfn7KCdoPql7JQZi6bnX5zu9Hzrq3gznR12tXbRunjwW8uhvsNj3x4
	i7yyCznRuBluhMK+DJfKf4xoGu5hvDYhigip2aK58VGMJR/NroPyNj7sD792nWoZqTJjELg==
X-Gm-Gg: AYBFou3Uzpbk3aliKLv6pa783MZvJTPmn7EoeVuFoFiaMRJBreDNYd9mrYb+fDAB1gr
	PNORiDfBDPjGoxB/4nExIxyN4gG/r4ebiJUKlSSrBuR8feJGJXc4sz+KIYgHoN5lFHWOYGT9uwP
	2X4Nv1BBZgVwBQ7PlPXijiKhqa7mfPQC1qaAJVS6PsCLymaRbng9m1xmbcWF1iCHBgZB0x8GUgo
	043gZ3yQKBxBL2I89/f2Vlx12cnV7mkqcFU+PbeI6zm5mVC84H5XzckGqrWU7cdsyVftmLzrvfe
	S/l+vS7i3N0B7ywxnFRbGeD6TEUEtM+zjOrAdgOKkptIYAbBPBH2FOMGCfxOPXidsnyY8REgcdE
	yyExm7R1kF5gG92VlniRDvnCpMeFkw0KYw7hHLJIeAMWK9DlNyHLL4Q==
X-Received: by 2002:a05:693c:8816:10b0:366:fabf:6273 with SMTP id 5a478bee46e88-369e8483c1bmr12138123eec.22.1793052118638;
        Mon, 26 Oct 2026 15:01:58 -0700 (PDT)
X-Received: by 2002:a05:693c:8816:10b0:366:fabf:6273 with SMTP id 5a478bee46e88-369e8483c1bmr12138081eec.22.1793052117914;
        Mon, 26 Oct 2026 15:01:57 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a03bea5d4sm8443486eec.6.2026.10.26.15.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 15:01:57 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>,
        Ripan Deuri <quic_rdeuri@quicinc.com>,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
In-Reply-To: <20261015-ath12k-fix-descap-multiple-rx-buf-v2-1-4cde055677ed@oss.qualcomm.com>
References: <20261015-ath12k-fix-descap-multiple-rx-buf-v2-1-4cde055677ed@oss.qualcomm.com>
Subject: Re: [PATCH ath-current v2] wifi: ath12k: fix decap of MSDUs
 spanning multiple RX buffers
Message-Id: <179305211683.3326479.10846455612333090718.b4-ty@b4>
Date: Mon, 26 Oct 2026 15:01:56 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Proofpoint-ORIG-GUID: aRDpQjwApo5ZOe_rgypR2065HWvNsKLq
X-Authority-Analysis: v=2.4 cv=Sfti5fRu c=1 sm=1 tr=0 ts=6adfcdd7 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=0_6NbyKEq3xlFscCNSMA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: aRDpQjwApo5ZOe_rgypR2065HWvNsKLq
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA4NyBTYWx0ZWRfX4nhlSaIuFBNU
 +CSbHpzoxowxawYhuMztjTZjKy1eR6eATM2Q7xyfB8OgsGz4H3ZEaCI9S8RJA2PT/7w2Fl2JoMd
 i43sdRbrSt+l+hSEbVY1jq4IeoiHQKY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA4NyBTYWx0ZWRfX6IRWTDSIct7I
 0knIih0sKwt+CzmeDOjMyK8rbTnwP9K0R9oxtXlpyJq7qDD9vvRCFp+PKNyOrWD7jM9XSdVPBRg
 9CRhvI9oLF4qyHrB/URUVyNFGSmOqbisYE5le2Pj8JyNuLMM5t4Oylw/p35zWkPqb8si11gYy9B
 xjd78DD8G7Li9JU8QQWjqhUe1IL2I33c/1RUt7y8eP/OkgXfzeXMd2AKMvi4cyI0DbFPO5wpOS8
 miPDcLjJ+GGITcOFc8bytjnKi99YOTASi4m0FeI/vzdwcNOz35kzb8I2CtYOcUV70ysQHv7aI8t
 zjDZKk5T7pf6WhiSX+hm2EfJlybznvA7Ol9DfjPlhr9Evm4yZO99UtGb1lT6qtLcK9fUTHRvWwj
 zVsryZk/Cu1Sveu1VhT3bjniB1tdXk9mZsUddaOBys+XRvcW0+OAbRMVpMadx+q+NnAaDYOcWyh
 SDMTiqvsOpnpSu7KjbQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610260087


On Thu, 15 Oct 2026 11:17:40 +0200, Lorenzo Bianconi wrote:
> When a MSDU is split across multiple RX buffers, the msdu_end TLV is
> populated only in the last buffer. Since commit e8a1e49c6328
> ("wifi: ath12k: Add new infra for the rx path"), the RX info
> extraction in ath12k_hal_extract_rx_desc_data_*() helpers runs before
> the MSDU is coalesced, so the msdu_end-derived fields (decap_type,
> mesh_ctrl_present, is_from_ds, is_to_ds, is_mcbc, is_decrypted, sgi,
> rate_mcs, bw, phy_meta_data, pkt_type, nss, checksum flags and
> err_bitmap, plus tid on QCN9274) were read from the first buffer, where
> that TLV is not valid.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: fix decap of MSDUs spanning multiple RX buffers
      commit: 1e678e37ff13e45f22d78d802fcefa8f9a0d9395

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

