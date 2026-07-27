Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51EB41BA77
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164574; cv=none; b=NfzyfRXYbOL2+b5/B3BaK9mia+PsWwfFPptgHCoR/JR9xHc7i/GbB4TLZLhd1swfEgFkTaZI4QsEgJdcLH/p5vAwQacjVbjFEq5L4g3tL3INza95Z8Fbt9InG4b2pvrCbJwVVTFFrDii7zXt9YT7qzENoc9dlAko2h2gP/7x4X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164574; c=relaxed/simple;
	bh=lxYsYUNFsguALrSKbsc2wZogIPPvxXCEexsZsqXqcxE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=PpItq10a6j82KZThNPqReL0V6R5KA1KwG0+phjVGoerUnIvHHdsb064vcI4M5uCIPltg/Z1TeQwUofBa1Sm1uWks4tJkW6852KRxOu2/xdW5yF81abv6kTOsSIz3O7R1OFANq+vp3nLgIxQZfgmXxn6TFhENLIQ2i5nytEqxTsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DRjdqZQs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=M0wCmFVJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DRjdqZQs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="M0wCmFVJ"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RDlZHu3663505
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:02:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SdBQPrjwPQsdDUmRMTsaOQd2S4oN7+S1ppeJTDbsgaQ=; b=DRjdqZQsAaeBv3Ss
	4gLL3q6RuSip80ZoGlJ7/L9FBjDQzU1ngkkmb7RXJKGgTC5gFOuYRQLbpfuzjkF/
	cEXH6Fm6q3SmSnJlvwPRdEGYVEBO1Ck8TbMVx368Vw5P1wF+cLwJ6w0afVI7t/do
	qmFB+OF0vatW5ZMyoytcb8F+qSIJCn6tQapxL1ZLiqDjSl99hg5p7+4IykXlzbqp
	s7XOz5VxxyYl25FsejMGrZbyEjg5rlsZToveq3obSNELRVaGcKLHTr9V9T+ejbGH
	DYTlIxSTCHiB2VGNNyMK5h7EUqNi/b/Sj5huPcQw9K1RfojSROdJrNUFNzwXwDpX
	AoEk7A==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fp2asj1dn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:02:51 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c9fe4c5eb39so1892374a12.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 08:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785164571; x=1785769371; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SdBQPrjwPQsdDUmRMTsaOQd2S4oN7+S1ppeJTDbsgaQ=;
        b=M0wCmFVJIJBbpAj5HkdXqMOXCE6OWkkzwPVYsuPZrY5yGddMfCIbYafWK1Qua80zSf
         dNek+bwTtcKLAONP6cTp7q3YKsLuyp3XGub9ME3Bg1uWMPoMvEKbx9WcuTTtVXv0262Z
         cUyMM4o2PhUP20hgjvA2fi9S0paP+XodEquJuvhGkWzDAhDro/+tryKPcq0jQW7LXE7C
         kn8uSWzrArjTKr5G8njRZnX1ukpei0PqsZYeZURCyu1oJJANB8wFP/c+C2o/DcafF3IQ
         x5D8ZQEpMyzYg/9lKCfD2aBpoWglEv20LWVKjQq5VdajgYUPdAtEZxZrp1dsYcbtSNui
         gI4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785164571; x=1785769371;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SdBQPrjwPQsdDUmRMTsaOQd2S4oN7+S1ppeJTDbsgaQ=;
        b=Gvzhgz9S6Kw3b1laRWKsG7UI4O8YuhD235ZeubhDw3MFQ2eiXicyt0LZ8E85EEihJX
         lUzaINWXDEZOhB0gDBDzHlYT4Hz3RSXWciVZPFhBMEb5Iftg6lzghRSmWfh0dFAfGLa/
         PvsSH+y48K6doa9S2S6XOLVSgqzRGpBXTRqIMONodBi/qy3dudKFjDOmoevmjSvH6b/e
         PZwUIvMlnct46YTfRzC79GZtviEdakw0AWEyh3wcQuKNk1nEQ0ph6wcoaXnoyv0dMXmb
         hp1Lh+Fn5VW6Cx3ZpLIVTPsdBb13L3QjEEZdAn8XsZl9cdnNrzr98Xxj2qzhSKjpUmq2
         2MYw==
X-Gm-Message-State: AOJu0YweO+bPfT9tLxJVHlaScAtGH/1sp7CO0GDrCFOo0sCN21Z/e/Ww
	5RWJfCr9Coo3HjSuYTZ9MG5mK/nQx9sYwoUsjJCJO6Pn1RRKoHaZNSsy98K0ONCLKjXd9Vu85V5
	M7K3zl5Oq9YRvgsPHcxjFBi1dobiZxOpCP8xKD1Msk5smBro2m9KQMhdfaCMGmA2VUBKr5g==
X-Gm-Gg: AR+sD126N5pMAvDqyfNmUqx6kqypOvqIi3u9SMY8H2WtwOoYw4zJWpTvVdVhLIcR5QD
	sQDE5xOwzl/EiRA1oyPe6mK9zKnbVTEEobdjej9sDjYKaWd2Sg2Ntu3O5RElQbxipSg4dvfE7Ce
	u5oSY30MpJudAHZfAi411WrpNBzb7I+Q5+3sBIalsJ0UWDUOz8n/0+20QrSlvlaqwpcOMFstqB9
	e45bWpnk1aZuK2rDktrAclq87Tf3vp1HwBy0rHaQmuSYJT9J1Thqf9Dt35V6Qb8IlP9+2MwavtD
	CeV1e7pLf3zKdnrHhrtuQ8alZuLoH6lQW8qC3yeqaxDrDDhn++/SmJ/MJiC9uqXuZw6nS/8OFCq
	brlKpb+wixY7UwegHoJVMIbUxTCoDMYT6kzr9uUUA8RY+g3KMEdZZM8o=
X-Received: by 2002:a05:6a20:d4c:b0:3b2:924c:566e with SMTP id adf61e73a8af0-3c67ddeb79emr7974005637.36.1785164571169;
        Mon, 27 Jul 2026 08:02:51 -0700 (PDT)
X-Received: by 2002:a05:6a20:d4c:b0:3b2:924c:566e with SMTP id adf61e73a8af0-3c67ddeb79emr7973957637.36.1785164570537;
        Mon, 27 Jul 2026 08:02:50 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc593b57sm48099150eec.25.2026.07.27.08.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 08:02:49 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
In-Reply-To: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
References: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
Subject: Re: [PATCH ath-current v2 0/8] wifi: ath12k: support
 firmware-allocated MLD peer ID
Message-Id: <178516456886.365144.13053000495795767210.b4-ty@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 08:02:48 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0MSBTYWx0ZWRfX0QyM6Wm+gkUq
 5noNNYcAfBtVvOLXQNdbyefN5Uw3FrMputZ8O+bW8IdAVwlmKilqCxNypY9tOrD0h+gGF+jh3kx
 VFEcJqQO4PKXpyOqBK7gYhckOFi615X55vBnyW8TJtYJ1spBJLUwYnhVYIVtuNaRAI+mSEh/BdM
 LswZV9Xuyc241KqMy9Ldr+tX5ZTwSRdqK/f5n7E2Q3hD+YCiPpT9xjz2+UFUzdTGSy+v55LggXx
 ZsJaDujtVO21NzqlNmXIv0C+s0e+Z7eC2CexZGVSfI4BdjkB6V/Px5Rq+JQnXF4X8Hn23+Euyg9
 8bYx9lGPRmcSE1Rfc2bzOvqwsfKPGH0Nw7H5iYbXlPrFgRva/+GQIzO0VOdIcgfuS4HlqFte5is
 X9tGq36ztR5Mf3mIECY6a1B5uN7aS5mBWBERXMWlTjeGRXulzETkx9j87EJLEd9Qas/O7wFjnVh
 AFf6diKjEQ1v2WDV2mw==
X-Authority-Analysis: v=2.4 cv=UPbt2ify c=1 sm=1 tr=0 ts=6a67731b cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=Oofje5pS8FeG0v4RG8MA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0MSBTYWx0ZWRfX1YajC8oEKqRS
 dMNmBiogc5tj0IwRKLYbukccIQ8KBXf6vS+PZzH0/DefrQe3qpFqJepsSX5x06Rro/MMyNV0xpt
 F/mfg0EAGkrhyNZOvkHW4ZeD1DjI80U=
X-Proofpoint-ORIG-GUID: cnxwMxVMshr3FyP85CUJmz5bK_FY8pP1
X-Proofpoint-GUID: cnxwMxVMshr3FyP85CUJmz5bK_FY8pP1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607270141


On Mon, 20 Jul 2026 14:43:21 +0800, Baochen Qiang wrote:
> ath12k currently assumes the host allocates the MLD peer ID and passes
> it down to firmware via WMI_PEER_ASSOC_CMDID. This works on QCN9274
> but breaks WCN7850/QCC2072, whose firmware always picks the ID itself
> and reports it back through HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP. As a
> result dp_hw->dp_peers[] is never populated for MLO peers and the data
> path lookup fails. On QCC2072 the firmware additionally crashes on MLO
> disconnect when ATH12K_WMI_FLAG_MLO_PEER_ID_VALID was set in the peer
> assoc command.
> 
> [...]

Applied, thanks!

[1/8] wifi: ath12k: fix out-of-bounds clear_bit in ath12k_mac_dp_peer_cleanup()
      commit: 47abd2ca281531deee38a3b3770d885e270e9fc9
[2/8] wifi: ath12k: factor out peer assoc send-and-wait into a helper
      commit: 21ca38bb6b53a0b610998f370a91e656dc9e0542
[3/8] wifi: ath12k: keep ATH12K_PEER_ML_ID_VALID set in ath12k_sta::ml_peer_id
      commit: dd121ed779dd62c7679815f7c5a0b07da60a39bf
[4/8] wifi: ath12k: add support for HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP
      commit: a08455ee85a2b32a5503b84fdc6b88a144cb2388
[5/8] wifi: ath12k: introduce host_alloc_ml_id hardware parameter
      commit: 378e659029d55cf57ee2eddf1d67672ed53c3bb4
[6/8] wifi: ath12k: do not advertise MLD peer ID for firmware-allocate devices
      commit: 1726a7a10c4fee262549bc6fa142e1051192be0c
[7/8] wifi: ath12k: defer dp_peer registration when firmware allocates MLD peer ID
      commit: a7619b3bcba42be62b3b4b941d4175234dce34f0
[8/8] wifi: ath12k: resolve PENDING ML peer ID from MLO_PEER_MAP HTT event
      commit: 469d7e6077c1665754eaf330e1feabdca7b060ae

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

