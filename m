Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=205.220.180.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793353312;
	b=hNOxEdLfzG9lGsuvHAuBT+MSn0BWWrVkiwGvnLxm3+VA/emrOkhg5pwI+L/K2kTEKupr
	 2VX42lLhO0dcCD86RNx5+jwkwTc+nsDlkNsjOnBOcz2TE8/TxfDetBpA4XNia1PJYw5vh
	 1k1YLBYjZqsTqcw2f7nwBhjZTnrZRbiTOIyQVcnDrfTQUxovZ4qfgaFZXvf6GUkoph81V
	 9I0gWXvxLRGFhwg4IQ60LZ7haw6oOfwiOV8TZMna0Gfrg/2WB5nVOHKWMib+I5pUtNpp2
	 9N2k5W1dcT/W391rbE+aIvQ0emgrGuEFU2FXXuteVHPihYL2NNVpF+Rrk2ogylIzCfg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793353312;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=uD6WtmZ8YWGFFS4OafWDNc0kV1xy7kz0GX96oxBuXCc=;
	b=gZ1qoQcUnHQqDtQ3FW2VOBSx1r+DiUSa25bPXmo7XguHh4OIxShtJMYgvVPQUeS7Bwia
	 VaDWWQMMvsvmXjuHWA7k8knyW+fQGeLuwiu4mHjgoudPv274d35prkB0l09jOMLzEYtrB
	 YFtX6Has5H0KZc9Fl5nkHUSW76A0vdPFdPVdWIb13ZWAF2MeZimN4d8xZStPMvYlIGSd3
	 8VyJeEeiB0bsFM98KutXetwYL7YLGmvC8kCMr7Z1KR5mzsfH8RZx48LDn7UyydKQRcFhz
	 KMv/SuGXZPXgOlLYJ6HU4jFcr6rWBanErLyLC1bsakce5ASrSqPpuBUmr6WZfp0Fqyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fMAxc9Ha;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QBximEv0;
	arc=fail smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739E5606A320
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 09:41:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 739E5606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fMAxc9Ha;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QBximEv0
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69U8FKUZ2733275
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 09:41:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uD6WtmZ8YWGFFS4OafWDNc0kV1xy7kz0GX96oxBuXCc=; b=fMAxc9HafL57ftM4
	FY0MTvhj3gxGQWVRAqEL8qfVFSCVB4BhWm9HZ0Kl5XsD24BHweZhXMa5YQdbifJ8
	ilGTd4IWMghb9S2E+ujc5rQ6CXYD/I2t9kUpOBCwa/UqzH3QENska+7aljbxsXUK
	oNgImzBi33U3TlSGVW5CnzDLTcLxZHSMY/WPK2hV15xR2zJDhropF6pelhqA+T98
	6FxhspGZNMPVEbSGrC6I28JgeOLR4+OZeku9AFvLV8H2tTcDYBIkhkaF2IkUTPPW
	rs3FESlRBr7I6ibkzhI5zp+731b16beh6ClHlU9QXTaqZ/mVoEdxIhhB5gWZCcyJ
	SH0RKg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qj952-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 09:41:51 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-339628f2bbaso75199eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 02:41:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793353310; cv=none;
        d=google.com; s=arc-20260327;
        b=hQfGoh3BtVwI9bGIc/X6ApyyQMiFei3kLlC8ewhRYuc160w0LYSz1T3/x/WO4F4/H6
         l/9A5Tn41Rr9+75aqEi4VxcgJwYWd5/qLjE29pnUFrNzFnUQ9qYQCGkr0pJXad1s8U0D
         Qgp6c+HP4gte3Z6s2xE1MHweED0P9p+s+AgDH8+As9+dkKIEehpE9EanuIxr8kEZvTHL
         pLY9L6c/jQeLCX+89mUPTqE1UZz5my8btJ9pjSNP/07JwGddycylhae4vR43X2CVIeLo
         LMpveSwxEjy2NRfXfwnsH4eeYhAhu/TkRN7uj8IySJamxNxoyiopgUbA7uy5e/ihRvU2
         W6rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uD6WtmZ8YWGFFS4OafWDNc0kV1xy7kz0GX96oxBuXCc=;
        fh=D2RnFWqX6jtuUjZ+zaireceX68kl4CR0cp13QEA2qII=;
        b=QD7kxG34EdMYqK1t+Z/JUf4A2GoObOgVM2sdR8y+4QehTp+ZpmkABW2es+gFMO/re0
         Yb9dwKz64davqXQpXUdBDxHFqc15123rqrQNyaDdNRaeVsztwbLV9D0fA4i73p/Z9N7r
         F/iEDCLfzCpJryB9S2pbJpjFHhZ6/73MAg+NkoD6uZA0TCgKszaZIujcDHID/VUKafoH
         DPAY5xBLQqV7JtMinJhJXcDSx6a/r9MYIxqKNH1AdarlvqzpI0rkT10elGGaF5dpL+Ui
         SmKt1dAbkPFyo//dfpOh7hRwZ5ao2eA8KziZ7Sf01XnM8yfZRRDj4BdfpJQDv1OkOWBu
         LUQA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793353310; x=1793958110; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uD6WtmZ8YWGFFS4OafWDNc0kV1xy7kz0GX96oxBuXCc=;
        b=QBximEv0P9Wgx35N7PdgmVaauSadXECAMcJEB9lf9beea7iAgsiUcF3GwVPae28NQa
         1pAPsHWFaDFZrdnS6ISXx6OLtmvrfz97FhESu5TPRxoWOvmErlK96DREHtN8i0dZPim+
         iOqG7NWIMxT5XIcKcuB6gae0mt+sVtWiJxe8eoDRuTzQqAtau0xyQkrDzD6aIwqyg95Z
         JsSzG7fOkV5zfbRjGNfGrt+eCS5u9LeKPVNkQAuyG7CEtAKIziXa/wzlCHwWUidDfYh1
         iRbRS24wy2sv29YCD4zGPiVb0gctVgjI/N4TAL/MC69AQyNQ7CKeO5TtTfIA9I6xnPx+
         06MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793353310; x=1793958110;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uD6WtmZ8YWGFFS4OafWDNc0kV1xy7kz0GX96oxBuXCc=;
        b=Eoe3rllqYABCLOVHs1um9DNNQawr8nuDHRnbEl4zCI930Gn4WBMqZnFNjQ55P2BPjq
         T6mqsdcj3hSgNziGqzIGz/xYH450SIn+wFLl5AcVTSwJNMtvVxvCXxc+qPxuCMH107DN
         1uqcvRM3LALGeVg0PgQ6HMHz5cnn98j22ni8/ojlMkXHQaa7RM5f6IM4e5Rjus8x6oB1
         zdH4vlCK6JF586HN4btwlONRRMX3BppLF+qTMhPVLkV52V/zv7z7R0BRh4U1WO0Z0GdR
         ncoEwNfgHw1yIxUWJvACHtFok35qMnO3jq+eKWmj9YpPtEFaaqnR/ln39TnbvvUVfod7
         lO2g==
X-Forwarded-Encrypted: i=1; AKwUvByOPth0ZEet8oTvIE6ngmEIcnuuoyvJUvVj9yS0nKKVNRpzZLDdqkEvhoqI7XwJCFQ0k/faVpPrcPB9Nbpp0w==@vger.kernel.org
X-Gm-Message-State: AFq9FYIpxEKvoUPNYY4U4ICsAvAgwdfN2vh722aLiSW85JP/80ZIiEh1
	HqeW5xEQcy8SZ/RxVdBFEdxgZRWKHHyCiwr6zlQCDIqaxJR1SQbvuVDjZdg4S7UqpPeVyRsPgNf
	hD3V3Qw23TaUENlUIxCsmOr/xK0Sd1XTapuhUobQTELs6OL8O2USLng0LjXgxo6m9BCNbsGB4lF
	+b1dY35XGeSNvUsI9gb+LfrmTPmVgyhNowExlkqZi3fcS9
X-Gm-Gg: AYBFou0qCz711UyhqJlw/A3HrOylw4wXotHlOnb/Ax4BG+Utt02wsG7CBZ8cHyQ44zB
	Bk1lwnkTRuFDKl9oSkjfii6eI62PN0v2qNCupdN5vAWp6SGz1O6EtezLrxWBO4nf4YzXGvKBjF3
	L3t/yZKoauwAKjtfM4A1+26BKJv2j6qSc+pegT714Tvr1QMdqvzESnsp5ukM/6DwiaYQrRdsu1d
	uwXnPB5mT2EU2tY1Rk=
X-Received: by 2002:a05:7300:e9d7:10b0:36a:1452:8da9 with SMTP id 5a478bee46e88-36a4231f759mr4734659eec.1.1793353309981;
        Fri, 30 Oct 2026 02:41:49 -0700 (PDT)
X-Received: by 2002:a05:7300:e9d7:10b0:36a:1452:8da9 with SMTP id
 5a478bee46e88-36a4231f759mr4734614eec.1.1793353309428; Fri, 30 Oct 2026
 02:41:49 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030090906.298234-1-jtornosm@redhat.com>
In-Reply-To: <20261030090906.298234-1-jtornosm@redhat.com>
From: Tamizh Raja <tamizh.raja@oss.qualcomm.com>
Date: Fri, 30 Oct 2026 15:11:37 +0530
X-Gm-Features: AclHuK9KIEENlHpS4wLIfGVb6D26SoMd1PZo5XAEkqihEp0H0825EShVfmY1brU
Message-ID: <CABkEBKZP_NFzoKEgdyTriGZqjYiDUMqOE2jL-NAkGEFBtJF+Zw@mail.gmail.com>
Subject: Re: [PATCH] wifi: ath12k: fix wrong register read for RU start index
 of 80_3 segment
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: jjohnson@kernel.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: 6qCj9CBqhbzKsc1ki4SBQmsZOh1s1bR5
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDAzOCBTYWx0ZWRfX7i9VTy8MAvGg
 6u6x2ZesFnL9HFzmUxlAQ/O2q42PsVnYxOa4hgkdhyvwIekj1+lXm2Urv0JCJtNHCgJXIUmGvNJ
 rHEDPuGW/HMg6JQGHqxo0Ht6VEaAM2s=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDAzOCBTYWx0ZWRfXwKuXXDWzLeoI
 GszOw5d2t4VadUd43rpoYp/Ys7vcV09BdwxbrkWlCPP9FWQs5PHFO37gInrAqwBSKPdiQN6Eks5
 79v6H9wSnhr8h15hP2bwcAKCfFpr1jb3Qb7YtbScFJAmcvRDDeUAsDNkBfC4XPBOPiJEbBhqLbO
 R6nG8sHfRWikiEjILdm1YcoxC3nfcXz2cz9kakEnRS//1jt7Mk6opCas7aGNhFBv2XkubuzympO
 4nDZfG0BklQusC43+0mlaGJbZ1RZrTocZxF2Sijsa4LIdXBrqL6gAP3Fj/n2rpjHybm5DKG1hPU
 SK0nuqZau80kX/SuQmRLIBbVonAb+rOreFYg9Li2/wCTw82PMXWRzSAcb94fmhC3rpSVebbp554
 3S2hfSDM80iWVINsl7cPWmG8B94kU4e1Fv7hlxa7n1wud8OHVGeYknCiKyI+kS5B5mW8z47Hpo4
 laB1ehY82v9ottLnorw==
X-Proofpoint-ORIG-GUID: 6qCj9CBqhbzKsc1ki4SBQmsZOh1s1bR5
X-Authority-Analysis: v=2.4 cv=TpVzFzXh c=1 sm=1 tr=0 ts=6ae4665f cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=20KFwNOVAAAA:8 a=EUspDBNiAAAA:8
 a=LQZMuA99dPo4G15aSkQA:9 a=QEXdDO2ut3YA:10 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 suspectscore=0 clxscore=1011 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300038

On Fri, Oct 30, 2026 at 2:39=E2=80=AFPM Jose Ignacio Tornos Martinez
<jtornosm@redhat.com> wrote:
>
> The RU start index for the fourth 80 MHz segment (80_3) is read from
> rx_usr_info->info2 instead of rx_usr_info->info3. The bitmask used
> (HAL_RX_USR_INFO3_RU_START_IDX_80_3) is correct for info3, so applying
> it to info2 extracts garbage bits, producing an out-of-range shift
> exponent that triggers a UBSAN splat:
>
>   UBSAN: shift-out-of-bounds in drivers/net/wireless/ath/ath12k/wifi7/dp_=
mon.c:302:22
>   shift exponent 284 is too large for 64-bit type 'long long unsigned int=
'
>   Call Trace:
>    ath12k_wifi7_dp_mon_hal_rx_parse_user_info.cold+0x3a/0xef7 [ath12k_wif=
i7]
>    ath12k_wifi7_dp_mon_rx_parse_status_tlv+0x621/0x990 [ath12k_wifi7]
>    ath12k_wifi7_dp_mon_parse_rx_dest+0xa9/0x2b0 [ath12k_wifi7]
>    ath12k_wifi7_dp_mon_srng_process+0x34f/0x560 [ath12k_wifi7]
>    ath12k_wifi7_dp_mon_process_ring+0x205/0x270 [ath12k_wifi7]
>    ath12k_wifi7_dp_service_srng+0x1b4/0x5e0 [ath12k_wifi7]
>    ath12k_pci_ext_grp_napi_poll+0x43/0x100 [ath12k]
>
> Read from the suitable info (in this case info3) like the other three
> segments do.
>
> Fixes: 5db19c488413 ("wifi: ath12k: Move MU user processing to Wi-Fi 7 mo=
dule")
> Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

Reviewed-by: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
