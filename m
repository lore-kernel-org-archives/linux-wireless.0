Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E9C3A6F10
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 10:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788346056; cv=none; b=ZRXAY5hyN5beacEkW6WnsR7LCncCuUZUjSnGbvkM5WhPYmbUUXXqM7fsTnXfSvDG8zBM7KDwRnJ3/dxgzu/pRSATelDn/FRJxP+eEC4KhnAoMSQ0rKN5JWU8QHHVamBeS39p+B0yfg659c4hfNJZ04YKWvfQmQHarTFF/GuiFzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788346056; c=relaxed/simple;
	bh=3TA0tUx2G5Sr0S2yRoQ9Ig2RQrxPjx3TqJ4uDoMwM7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fHg/Qjd2rhIZv4eLradEr5ss/Fssftq34DE8JwXpj8kfLA6ejx3Kb2ElDiy9kRtCj5wCZKIU6BKaWzMoscXBxWdRQMA6zXJ4enoajmot5cSfN2ZvgFFeouodNJ3mQvRShG5lum+ui8We3vnjpwMG6NAF++z/L62Rtkduso7xwys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Xqoh47VP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NvA331XB; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Xqoh47VP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NvA331XB"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6829NIP61239490
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 10:47:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1c4l4NjJNyna0JXM1EZySsOREA38Ii81XrbtM1fCLBA=; b=Xqoh47VPX8C0zEXP
	9RODhSDri81H5k7OGC+9XV4Vhjj7FOQqaod+URJcKFFIz07OPJdk1h8Qio66IBhU
	yL/FZt3VobIiqvW37pwcnrk1hRBI6shv5NSunVPhyqlX1JbT0fWFRTTraAeVxKM8
	MNTwS9joFGNaMUWL7EvPnBzQwSBu31IPImIJHQ5WFMRLAx1rsmC18uO+3fxwGzM1
	BA5qOLlJ2uBlvrL2ngbcKwHgtAMQ8c9gecPOmfLFY1wsQK70Wb4O3aZtJDsAI2A+
	qrWbC/jRJ0+YQkVhZBIMuCbbA4CybO1mCLjv5osRY6RIFR5vMRPdMDdpsu/PUeEp
	bwImpQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ge38w3erx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 10:47:30 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d9336581a2so15900905ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 03:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788346049; x=1788950849; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1c4l4NjJNyna0JXM1EZySsOREA38Ii81XrbtM1fCLBA=;
        b=NvA331XBguvODgE6Jj/wxuUhZOl0J23bJ6vmq6bXlSax2Ac2JSIX3S1a57hqE/0M9J
         ZmOeaTMpDFZ9srpV/gaEs//dmHiPxjlgIvVwfgg59ACNYwAkDz/dZjfX+DtZwL3vnKpz
         va789zbp+G3wdLpj4oixMj4rtTu7h8ygZYBTiRTQI8TtwCLkqy++U+Wd+bmHvQvkkuPH
         YKydz8OEh/wZYOfzD3AKCD9HAaQfThKBSe4BTTAoai/lHRQ825gzhZWw1B2jYc4W7mad
         EQMQw17W7+aWZ22yqcIvBB/iohz7vvqLIUKqAGnkZezkS4TLiw944ThpgQ+tIWmgHKn1
         JVtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788346049; x=1788950849;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1c4l4NjJNyna0JXM1EZySsOREA38Ii81XrbtM1fCLBA=;
        b=GOBJJEDW2QUqvxpix5nSJk9X9a7zMPgLlerdK+7aaHRtCa/JtA1Jqd9/pDPS61Ajbe
         CWprIzKCnjgaxxzON338yzrzgpGGQXwRoMYmKznwusQxlpbpCWKXAzW8Cmf9D2XpVBQk
         3AiabmcBffb7v3+GrSkl7ALvufgGupwaeX4qkjjZqR2PygClZKSDK7aMzaETL7+zv7wc
         7CFmO4TdibG0IlgiUobHvFa4osBHtXqoQ/FvGnG5MQHcMzXOf8FQWC8dTRr5U0/dvlUE
         6B7ecDKHPt4I0F8bomqXIfOpLTo+u+zYTXM5NsW8bwwG4nhCXk8JU7nhYpFyS1YOlOiI
         tJGg==
X-Forwarded-Encrypted: i=1; AHgh+Rq0TWesAC5LjxknKXAIrbSGLnaqUtKPdyy6Xv87OyLG4V+hsBAVNrHXgkIYchnsF9h91MskMQY8wV39EOIiKw==@vger.kernel.org
X-Gm-Message-State: AFuF++lb6rK65eQ1yZh30JcRKfyNIigVzTmAXdGQKcb1vYXbgn4zIArc
	vQwZ7CCbqtjfvnRVBzC1q6aY9sRLPlfQEMfnlAtfGp8bhs4EQFQhtTylVFoYysxyjFT0y7V98WD
	fgAS/Mg2g/1sOOSFmT+1FYbvssRYCXc+KVyYObSQwioCVEdlVjvULbcjxTGekvUAS9ofaCg==
X-Gm-Gg: AR+sD137LQjuQ6dWX5fjPdjI/SxBKMlsu6iVkh9E4A38l0PqrZFnGt1DB15tRcw/CTK
	tWVXUCFcr/orDfLHvR1E2sayFdeYufSPn7MNnjRhP4Q4Wydwc4mTsdlGMoUGZ2betFoFbKyxtU2
	Dh3OiU2MAnxeVLrSplQaH4eUnSyGbaXwyHzAmB7BXVP0Kyj32TwS3Fu1WlMg8RZvm7LXKOubIwA
	N84HrOIYNncqRoWCQjL6YDAqrgYMkdxSUyGR7LAdeHdaG6W1O6W1NnxEK34IqysLeTQgjoGiTaE
	uedBVRLTvwgAuEtXvJW/sjqdVFMnOsJlo9dFanmBPTcveNZOEOtKb+vVOrzWHvvKnEm56hVco/v
	QZzUZ2pBQR+Zn0OFttv4+HjmdbwqpWrZ5oII=
X-Received: by 2002:a17:90b:4c44:b0:38d:b36e:9813 with SMTP id 98e67ed59e1d1-39aee0188bbmr6061425a91.11.1788346048938;
        Wed, 02 Sep 2026 03:47:28 -0700 (PDT)
X-Received: by 2002:a17:90b:4c44:b0:38d:b36e:9813 with SMTP id 98e67ed59e1d1-39aee0188bbmr6061321a91.11.1788346048369;
        Wed, 02 Sep 2026 03:47:28 -0700 (PDT)
Received: from [172.20.10.2] ([152.59.48.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae0f27047sm5119750a91.5.2026.09.02.03.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 03:47:27 -0700 (PDT)
Message-ID: <741d7c3e-6eea-4a84-bf4c-8d8eb8032c83@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 16:17:20 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: IPQ5332 multipd: missing text PD level and qcom,rproc ownership
To: Hideo Sumi <hideo.sumi@mugops.com>,
        Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        linux-remoteproc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20260902041339.7665-1-hideo.sumi@mugops.com>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <20260902041339.7665-1-hideo.sumi@mugops.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: _I1DM9_vPjCEMUVjjWebrbMluyfjtUn-
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA5NSBTYWx0ZWRfX6DbvetbvYSsX
 JJDFumYrrwry0aQgPIFSgABCapWnm7K05xqWFAM1HzAFmEFSYlWdqD0z2IBJOwN/ya3olXFlSl0
 +wnPCUsoO4Sjs9wZ/REOA4ffW8XEnbw=
X-Authority-Analysis: v=2.4 cv=LOpWhpW9 c=1 sm=1 tr=0 ts=6a97fec2 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=O5pfq51LmT9kH+AdY1uYEg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=4vZXxqc4KIhUxI1rvgMA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: _I1DM9_vPjCEMUVjjWebrbMluyfjtUn-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA5NSBTYWx0ZWRfX/NxkpHvpW80g
 eo3vw2Z+uiO9OhlcUK1JDAsTJx5RejB8HxixOJ0mcGchtWK73qHw9VVt12NLuwfDDw//Tux/tm4
 1JaA6A/BNr6HShL6Qbpo/bBPRdbvjqiDRfcvWKd7jYY7Jj2QcPXvceyIjHaO5IxKBHXtle28B/L
 /PziFQuTB736MXiY5K9+CUFf04qATDXZlHAxY363wW/cPeXd8Cq6/cMDGpXf0jKwr23AcGPWD1C
 G+ZWEcQG6guC3BH6iEbK5khDIbgbpSEcT/C/jQcHiLJLxdDeKLZWmQNAJ0JJns2KR0Y/kzX5q77
 adF5iGQNGLx0W0Rm11fNfaLO37pk1H/bfWHXOcPBP3Et6js8GJh1fFfJBXtShUInJYA2gD8fHZA
 c08OVuqgbFWY1fV9JuLULmJ2o8AptlPxBBBGFtLxSG3dti1vwaZenXarTk7B9bYiL8+aVotWc5a
 DsOM13NYi5xiacfC4ag==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_02,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 adultscore=0 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020095



On 9/2/2026 9:43 AM, Hideo Sumi wrote:
> Hi Manikanta, all,
> 
> I have been bringing up the WiFi subsystem on an IPQ5332 board using the
> multipd remoteproc driver (qcom_q6v5_mpd) together with the ath12k AHB
> backend, on 6.18.44. Two things came out of it that I could not settle
> from the code alone. Both look structural rather than like mistakes on
> my side, so I would rather report them than sit on them.
> 
> Caveat up front: I am running vendor (QSDK) Q6 firmware, as there is no
> upstream firmware for this part. If either answer is "that is a
> vendor-firmware-only concern", that is a perfectly good answer and I
> will stop there.
> 
> 
> 1. The root PD does not boot without a text PD level, and the binding
>    has no way to describe one
>    ------------------------------------------------------------------
> 
> With the DT shaped as the binding describes -- a root PD with user PDs
> pd-1/pd-2 directly underneath -- the root PD never reaches a usable
> state:
> 
>   qcom-q6-mpd d100000.remoteproc: fatal error without message
> 
> No further diagnostics, and the user PDs never come up.
> 
> The vendor DT has a level between the root PD and the user PDs: a text
> PD (compatible "qcom,ipq5332-mpd-upd-text") that owns a separate
> firmware image, with the user PDs as its children rather than the
> root's:
> 
>   q6v5_wcss             qcom,ipq5332-q6-mpd        q6_fw0.mdt
>     text-pd             qcom,ipq5332-mpd-upd-text  q6_fw3.mdt
>       pd1                                          q6_fw1.mdt
>       pd2                                          q6_fw2.mdt
> 
> Once I added that level -- a text PD node with its own firmware-name,
> the user PDs reparented under it, and a small driver change so that
> q6_register_userpd() recurses and the PAS ID is derived from the node
> -- the fatal error disappeared and the whole chain came up:
> 
>   remoteproc remoteproc2: powering up pd1
>   remoteproc remoteproc1: powering up text-pd3
>   remoteproc remoteproc0: powering up d100000.remoteproc
>   remoteproc remoteproc0: remote processor d100000.remoteproc is now up
>   remoteproc remoteproc1: remote processor text-pd3 is now up
>   remoteproc remoteproc2: remote processor pd1 is now up
> 
> The ordering is the interesting part. "powering up" runs child to parent
> as rproc_boot() recurses upward, and "is now up" comes back parent to
> child as it unwinds -- which is exactly the parent-first dependency the
> multipd model exists to express. The text PD simply was not one of the
> levels it can express.
> 
> So: is the text PD level deliberately out of scope upstream -- because
> upstream firmware for these parts is expected to be packaged without a
> separate text image, say -- or is it a level that should exist and is
> not there yet?
> 
> I ask because if it is the latter, the binding as posted cannot describe
> this hardware at all, and that seems worth settling before it lands. I
> have a working change against qcom_q6v5_mpd.c and would be glad to send
> it as an RFC. I did not want to send it uninvited if the omission is
> intentional.
> 
> 
> 2. The vendor DT and the ath12k AHB backend disagree about what
>    qcom,rproc points at
>    ------------------------------------------------------------------
> 
> This one I can describe precisely, but I cannot tell which side is
> meant to be authoritative.
> 
> In ath12k's AHB backend, qcom,rproc is the *root* PD. ahb.c resolves the
> phandle and boots it via a function named ath12k_ahb_boot_root_pd(),
> waits for rootpd_ready, and then does the entire user PD lifecycle
> itself: qcom_mdt_load() of amss_<n>.mdt into memory-region[0],
> qcom_scm_pas_auth_and_reset() with a PAS ID it computes locally, and a
> spawn via qcom_smem_state_update_bits(). It also requests the "spawn",
> "ready" and "stop-ack" interrupts by name to drive that sequence.
> 
> In the vendor DT, qcom,rproc is the *user* PD:
> 
>   wifi@c0000000 {
>       compatible = "qcom,cnss-qca5332", "qcom,ipq5332-wifi";
>       qcom,rproc = <&remoteproc_pd1>;              /* the user PD */
>       qcom,userpd-subsys-name = "q6v5_wcss_userpd1";
>   };
> 
> There, remoteproc owns the user PD -- image, PAS, spawn and the same
> three interrupts -- and the WiFi driver only attaches to it.
> 
> These are mutually exclusive, and on this board they collide. With
> qcom_q6v5_mpd instantiating user PD rprocs as its binding describes, the
> PD boots fine and then ath12k cannot have the interrupt it needs:
> 
>   remoteproc remoteproc2: remote processor pd1 is now up
>   genirq: Flags mismatch irq 31. 00002001 (UserPD1-spawn)
>           vs. 00002001 (q6v5_wcss_userpd1_spawn-ack)
>   ath12k_ahb c000000.wifi: error -EBUSY: Request spawn irq failed: -16
> 
> Same interrupt, same flags, two requesters, neither wrong in isolation.
> 
> So which is the intended division of labour?
> 
>   - Are the pd-1/pd-2 nodes in the multipd binding meant for non-WiFi
>     PDs only, with WiFi user PDs left entirely to ath12k -- so a board
>     with only WiFi user PDs should describe none of them, and point
>     qcom,rproc at the root PD?
>   - Or is remoteproc meant to own them, as the vendor DT has it, and
>     ath12k's AHB backend should attach rather than load and spawn when
>     qcom,rproc resolves to a user PD?
> 
> I have deliberately not sent a patch for this one. Either answer implies
> a behaviour change in a driver used by boards I cannot test, and
> guessing at the ownership model and then changing ath12k for everyone is
> not mine to do.
> 
> Happy to test patches, provide full boot logs, or run experiments on
> this board -- it is on a serial console with a recoverable second
> firmware bank, so I can iterate destructively without much risk.
> 
> Thanks for the series, and for reading this far.
> 
> Regards,
> Hideo Sumi
> 

The intended model is that the root PD is completely managed by qcom_q6v5_mpd,
while the Text PD and WiFi User PDs are managed by ath12k.

ath12k will take complete ownership of the Text PD and User PDs. This includes
loading the Text PD/shared firmware and User PD firmware, as well as handling
the corresponding spawn/ready/stop-ack interrupts.

The shared firmware support is covered in this patch: https://patchwork.kernel.org/project/linux-wireless/patch/20260811054316.518494-1-aaradhana.sahu@oss.qualcomm.com/

So, qcom,rproc in the ath12k DT is expected to point to the root PD.
The WiFi User PDs should not be independently managed by qcom_q6v5_mpd, otherwise
both remoteproc and ath12k would try to manage the same User PD and interrupts, which
leads to the IRQ conflict you observed.

The Text PD is an additional level in the ath12k Multi-PD flow and is handled by ath12k
as part of the WiFi User PD lifecycle.

-- 
Aaradhana Sahu

