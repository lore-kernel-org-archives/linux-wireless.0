Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793347177;
	b=On17L+jyhB4AebhZHMNQqOqRsOAybmG5DH6OE3d2ZAGGzQaAaVZNMJ06+290ltaOqxo0
	 yENIWp8zkVj3fsd8IFCUfrMJXzedM8zFClhooMbCIX6Fmb5SyvM80GZMyEalS1Y8LwwMg
	 wjpo7v5hO96gcyU5zJ/QCRaA+OrLg+LdLgzSE6LdnF7MHIPp6paGlvQY32983FWHfsKeZ
	 nX3/AxvudnSqH7LA4bHQmVeEin8JMk30helpUpeD/WZnDicWpn5lO5ecwHBZ2nIqL351X
	 8jsdVJnm5yElteoIObGeOzCsweg2OInzx+AQeYBH1O//Mkq2DD1hy52bQnBRLL1S7ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793347177;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=L/bbJavlObQ7jDu0caKT3HK1qaIAEj88zWLFtN2ScFA=;
	b=yDiVlzTL156UB670ARYyifRUus22IFVZe3nPS8S50G59hPMKY86REN2lJwrZbtKne95N
	 6T3saQRSMuJnj7l++SzLqK5DBaabRIIdYatJJvpfffOf90m2m6NQaxwHoa/eABuGsnsJK
	 ElgbRmPB4Nn6gNyNkQj9nVFCK81fO8sew2pl4t/jnWePEzSRMhYt1sLd6COjYPytzW5CP
	 MUc5I+fbQ2qrTJIhII9paATcQT6NFaCIZruKsoUEXSLIATnyU7k2Th9DbG9zuIYidQOsx
	 b69RzeV435RPtZ78vSrbVA94OHGn4NHb/hRNTph+fH6LEMD201JMkdvQmbtEQASMRPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jZerbPfE;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KoGCF1AP;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8FF606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 07:59:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA8FF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jZerbPfE;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KoGCF1AP
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69U5FBca2871218
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 07:59:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	L/bbJavlObQ7jDu0caKT3HK1qaIAEj88zWLFtN2ScFA=; b=jZerbPfETMR/Ugz6
	fOhQebqBFWC3NoOF9GLWKg0P4yEkFgZcTXXXL385j6rTfjamCBko5ImPJ+sIxixa
	iX1mPx4gqbuTfVZdSolbBKYaqqsc8dUaLUu7Y2KP1PUFNik4ZO4+j/UVB4RQqFFz
	0b2WVTmYikH7w4Pjn4Vu9azuPR8FqLJD0zkJRUwU7h+qPXl0YnY/x7xC9HjNwbrQ
	S7uLKrrrEG3L5tyEByhuCnUb+nTZ6FHZkSpLzl/vi2EJKeKUePZyU2zUWAJOQDQP
	f4OSe3Nb9Ku1D+i79tq+bIcOYh53J0eF9XzxkyH98xYdAXhjCNIBLk2Y/H1hwefT
	WOeDuA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qhw78-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 07:59:35 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3acc98e3b3cso431694a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 00:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793347174; x=1793951974; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=L/bbJavlObQ7jDu0caKT3HK1qaIAEj88zWLFtN2ScFA=;
        b=KoGCF1APzHL6WVHrlHiBuJvBg0rg1aoEuJbPTH9WLWQDPnDiikDWeLUvYKs5/3XC9A
         /XlRvnzSbkcAf6YM2ZtH5yOMkDMKQSubTtgFjRIDSvXa6tx292ttI4i7sXHbXGfwWkgN
         2I8gzaZrfBSntF52lNE4AbLR7tsF7EufwLEXqDUc7WNm4SKmsNvvf4tx4u3F7FVH2ia9
         5GJ9b1cOZm4ZXFpn54KjzIl2/POWk3L4Kr7RgVS/KiS6tGNv194tMy9roeo4Z4yfu7hM
         lWMG4zn5Ubr8JLjexX15FUCsiELT4U8rxWJT3jLpbjGauG3oldj4llWcOYxs+zijPBaF
         pc5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793347174; x=1793951974;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L/bbJavlObQ7jDu0caKT3HK1qaIAEj88zWLFtN2ScFA=;
        b=ZlI55qvVDAaNTupIlX5rBWnz4zonTgN1Lj5gpzmb0OsqgO1odVouy7qdRj5xAeGWUF
         FtAiRPPJ7l9oEfDRLx05opI8n0KA5OOsjDo7T9bTd7rCb9qdLGaoW3z7bC3UQHdNsnvl
         A98Hb/ZNZ2pbTLerKGfTk7vCtbAZXJ0H91NIRMYi/kZa08pYVp8UJNoYq2FtnZAzzbXG
         jTZovk4D/rHTZBbxQeQs+gdd4rFvDpozPrQgwfXlpkGva1/HJgaZxL7gmUgBCwxZ/hVO
         dldgMJuY+mrsMPH43S64PHQsmVTDe+iBQFwaxO+XXiTANAvVdFAR6z91dwylVf7fMPOd
         4ijw==
X-Gm-Message-State: AFq9FYK8n5NkqbjpkEBdM4KunVQEMRHhmMxYHnqWqKaVezFd26l0N6gL
	p4y+XzoffybCUpawcDdW/E+KzTDYSZAud+bhavntP71qTMJQ35mkty3AkfwPgJNAzULsFdSFGeM
	q9sTkCSDu16GTJuxFe3Sxu/HZM5IE2m4bpNGbitC9RHE1tTkXEY/NNHAtVA3StEXtygMvgs9Cll
	ZHbg==
X-Gm-Gg: AYBFou22OTL/u8jW2VK1OMuyGhhJXckjAFl6+B5pxt06zYEEcHPq+WAnlpc2g8dEnea
	/jLBdOqDj1VP+6Iut+WaaMgqs7q1FZg33cpCl9lDlXXGY5sHv55MJklHQGyIUaR0htQHwTq1Giz
	7qlww1jwG0JKK7/PdmLMni5anvUST0TzBexzL8v+T7Z/WxCNTu1ch6C8YB+Eh6aLSPPiQwnHOCf
	BFVGTxFy5RkOdxYPk8REtK07dO5whrX1opSG/WY19wN76h7ptpFZ/Bn5UHRr3oK3MPsTXBFs7ID
	RNenRk2Ytx3zWe+Cve9EnWZAuEuJb9oCaL4xxMZAEqr8Vqs/fzeSZhlAGFViHvGCiQyQBFWGTf5
	tuTEuhgu4wTiu50//79NDmvIUXm0hfFdb3DfdkAbbA458fypWok24tpsHP9n2DkrYUk3+AXkdFF
	V/D8+AM9CZCiMorWjKvhz+NTJdJ+iZ3mCsEEkflibwHL/n
X-Received: by 2002:a17:90b:4986:b0:3a7:da33:ff2d with SMTP id 98e67ed59e1d1-3ae89849d1amr1192457a91.48.1793347174377;
        Fri, 30 Oct 2026 00:59:34 -0700 (PDT)
X-Received: by 2002:a17:90b:4986:b0:3a7:da33:ff2d with SMTP id 98e67ed59e1d1-3ae89849d1amr1192432a91.48.1793347173818;
        Fri, 30 Oct 2026 00:59:33 -0700 (PDT)
Received: from [10.133.33.77] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845fb9f6sm2969811a91.17.2026.10.30.00.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 00:59:33 -0700 (PDT)
Message-ID: <e4b963f2-84c1-410b-ba92-7cc914294a69@oss.qualcomm.com>
Date: Fri, 30 Oct 2026 15:59:30 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] wifi: ath12k: keep regulatory frequency ranges per
 radio
To: Lang Jianjun <jianjun.lang@ntu.edu.sg>,
        "ath12k@lists.infradead.org" <ath12k@lists.infradead.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "jjohnson@kernel.org" <jjohnson@kernel.org>,
        "gsh20040816@gmail.com" <gsh20040816@gmail.com>
References: <SEZPR01MB733849AC81EF5F9EB7B9B6F0A26D2@SEZPR01MB7338.apcprd01.prod.exchangelabs.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <SEZPR01MB733849AC81EF5F9EB7B9B6F0A26D2@SEZPR01MB7338.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDAzMSBTYWx0ZWRfX3L9lfwY3PcaR
 73CGTXpq0P4HxMKweBLt+t0VM5VYSCIQJ4VnCbfEzSGIaDB9yrdMZrZCAWEUQXdtLyraUFzSHvK
 1YK5j1j2S5jL5USfCCSmBHLHXzo40//noOczhv97ySng0H/pa8KdWs1z22cPN4aYtDWCBI1kQ+v
 eKFb+AH7RwZ1B0wvxaf+zLq80qXytt5+DA0Nfs6ykL+nDXGD25P/SlGyP/JAbxKX05L3fVJLJ12
 rRmAiQdfYFhmGFcJhN8xrlarwRhx4WBZ+fEWP77Cwux1+wU/0bhkwoHD3gFD7JtHID9ssU5nFbI
 5gLNF/Xdew1x705/XTL4J0Ka+glGhceC85pTZe8mlcemrWRCCeOyr25MwHfkrOuYBLCg0/5CmfD
 vjqjsMF2qX3UBKuMBlV531Q9wn96hkYfDTCwJhod04Rw4QjCls0fZfTon/2ZwCTdCbNryzC/OqC
 TYLZDYVMhFSehj74RqQ==
X-Proofpoint-ORIG-GUID: 9aZaOMfW-qIjSd3qImg0gcT1Qg6XWdg2
X-Authority-Analysis: v=2.4 cv=IeoSymqa c=1 sm=1 tr=0 ts=6ae44e67 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=luFj5LIaC5_7LFMtheMA:9
 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDAzMSBTYWx0ZWRfX2VDJevfRCIv7
 7S8YSh/sF/gf2kMCiV/9FVklauBA3KdlIQKW7YoxiTZcfVcbBq52P81eAPwse2DQ5CoH5tJclEK
 u/woFfeYe5eyo0wPeMMtDT6/TrPiYmw=
X-Proofpoint-GUID: 9aZaOMfW-qIjSd3qImg0gcT1Qg6XWdg2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300031



On 10/30/2026 11:34 AM, Lang Jianjun wrote:
> From: Jianjun Lang <lang.jianjun@ntu.edu.sg>
> 
> WCN7850 uses one pdev for multiple bands. When it receives CN rules,
> ath12k_regd_update() skips the 5 GHz range because supports_6ghz is set.
> There are no 6 GHz rules to extend the remaining 2.4 GHz range, so the
> firmware channel list loses every 5 GHz channel.
> 
> The ranges also live in ath12k_base. An event for another radio can
> replace them before the first radio updates its channel list.
> 
> Store the ranges in ath12k_pdev, indexed by nl80211_band. Build each
> set locally and publish it together with the regulatory domain under
> base_lock. Take a complete snapshot for channel initialization and
> regulatory updates. Copy the selected regulatory domain and ranges
> under one lock acquisition so a later event cannot mix generations.
> 
> Use the presence of a 5 GHz rule range instead of supports_6ghz to
> select the 5 GHz update. Use nl80211_band indices for the hardware PHY
> lookup and refresh the 5/6 GHz hardware limits for single-pdev devices.
> Reject empty hardware/rule intersections before converting MHz to kHz.
> 
> This follows the per-radio design proposed during review of the earlier
> single-pdev fix. The earlier report and review are linked below.
> 
> Fixes: 0d777aa2ca77 ("wifi: ath12k: fix mac pdev frequency range update")
> Reported-by: Shenghan Gao <gsh20040816@gmail.com>
> Link: https://lore.kernel.org/20260715065218.41232-1-gsh20040816@gmail.com/
> Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> Link: https://lore.kernel.org/9dd4e992-5810-429f-bc54-036c4eb276a7@oss.qualcomm.com/
> Assisted-by: LLM
> Signed-off-by: Jianjun Lang <lang.jianjun@ntu.edu.sg>
duplicate with

https://lore.kernel.org/all/20261027015919.277156-1-mrmrmidoessam@gmail.com/
