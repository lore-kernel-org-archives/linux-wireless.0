Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793620624;
	b=0eTfT5BvHW8zOAeJQkHBeMS4n4MUE1nwI27Ui6tf20ag2GkraSUkJlUT3KchWkzN62AN
	 s5bMgkTuaRbzcK4iMt9+F9BbbL5vhBbkveK0kvtwJ4tPnJqaeZBGpYiGB4HUs2ec+iXmK
	 sdWdgaZBhzjXYoceCSfe0LKalqJwNcpdVXEpO9dajddTK2DfSftsOloqsMmD4oBP89CyT
	 VJQRys3BgETaZWH0VCyPfeEqV3/YWj2JOl2VkKI2/ar9so68BfLC2UxALA9wajmLIHaMl
	 cvoupaH3cI1/VrYeQrV7HrHoPEBwB67mNLNtGn/gArn2LIfANl8oIVx5Sv+nmgNzk2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793620624;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=mmnkq7r8AkdD6QmqN02tP8SKsnUa5f5femOn5SNpdc0=;
	b=NZwvH5FwkyH8dMkQqCaEQylFZfP1x677BSz8YsZxO3jTct1H8/KnymX8XGoxlydEBG8h
	 jbuiDrQ+5LmlCEBUZYRXDuXynamgCCgLmYVv/p3T5TJo/UE9gDToExFuJhrYXOcMH62Bf
	 ADIAH2puYnrPWDQgitTwZUe94zVSDPnhgwKi0vtOeYq3RCbhMZ9/8OYztYl+DPi0j3x/M
	 MChqVL1GdJCLLkSnr2Ui2fqqWoTvjW0eYDXHlN4pPKGLzmj4/TQP/KKQi5T/LcTqiFWW4
	 TLEaljg71haBHO2RmFsCxcdHillRdKI1fpimm/wRfIqq3c1MIA8wBgkWEvOUkHI8HyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="X/Z3XcP+";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=T+SNqlXU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A148A606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 11:57:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A148A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=X/Z3XcP+;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=T+SNqlXU
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A29A3OX2466298
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 11:57:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mmnkq7r8AkdD6QmqN02tP8SKsnUa5f5femOn5SNpdc0=; b=X/Z3XcP+FasA2u62
	hBvPEOch8XR0fLIRDTeJplMth0A1Vs9d2y6vGzXiomLEN3RxdDoUPsIcdd15wBJE
	uiFJqYjqNMHkMdFCuarhLny9JH83i8LibaJDpKNNiLVuVUWlvcBGUC4NZGYGneZv
	DRfVyKUvFgTHcmGz/f6bgFyhW2QtmnYLEwPC25uFpEOk0dVV/MPL4OUjHRUzZMwp
	6W+ry/n7rXYwTZRLKj2eYEygt/14aI0B5BfPoIT7yW7WBysaBxaOVFKNjWbvIesP
	B/IS2ZmmQYcUe44EM/n3yWKDyhpL5kyCnVOMx6W89WqWBCkbCAlSp0W1AL3kYPPq
	Caq/Eg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hpk9rhnbt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 11:57:02 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f26dd2165so299452485a.3
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 03:57:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793620622; cv=none;
        d=google.com; s=arc-20260327;
        b=JOJ4am/5BBYyrmOEd3YMyuD4iK9jfaJT/VioQHumkVlWlXpgExoP4Dnl49dZZ0aQOq
         Fm5PMFrH6dPGeyrwEdFtpPp6vUWz3mFPulAdOsP9jGDTA9hzY3wI1bPiVP3NnxKlC6Hx
         ZltJXSW+mYjncAMt2IjMZIqHGkj9aUAQPygGVcgGIm8RFP/ou/YndQzJG4QtliwIZMwF
         RsPAgG1sY79oZCEZ9u56F/hVy/qpKbME754azqgJsAPsAK1HCx7rwq791gBUbTOqMbyr
         vuMDfeFMVcKNHbyYOhXVkbcrZrxSrDMm4DMF/mR7y+ux8xmhfTVyQcbFZh4/LRFQzycB
         sCUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mmnkq7r8AkdD6QmqN02tP8SKsnUa5f5femOn5SNpdc0=;
        fh=1K5Ezv3/1o9h5G4K28/H2GSVCIvhA1lnuU5Mokq/kD8=;
        b=iV6prpk8HcO0OJu14AuhN4m8Qug/ye0gu/AlQxnBFRmgHXqcUGEsJjuWCJCcyXF32x
         bSxXbMYUCWpvNoqdtaXyLWsSy60pU83KythbWB6Jz4+T9jbtmVdtvfN1+RyMo/iAkgUN
         qq1a9v+f36lsN0uuWZ0gt8n8/2cPZzmBgC/fgXz3Au9JG6vOli7dHJNXLpPSMOE76Yfo
         bERnBIQmW8W30IA0hT7hN2X4jsQVUHqy00MsaxR++QduP7rxa7xbWUPY1TEdbt8IcN22
         zKerJm0goN1CdywKyr/tO2ALcVFA6yp70xfiP/rhqvo5J7ohBrc0Z0zbv/sblx43mWJ8
         DYUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793620622; x=1794225422; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mmnkq7r8AkdD6QmqN02tP8SKsnUa5f5femOn5SNpdc0=;
        b=T+SNqlXU/r9+mWB7wSrRK6iFvwrLbiwbyaESIy7SEADBQchc5Ikh9LYVIQiQ4n1vX9
         y6esBzHoFVLy6Te9rWnKIm76KNdN4RbsxPOGCivZn2Fn5fQybklk1p6IBIYfo/C/BH6z
         zpXGIenbor5Wrg8kEhRawrDTzQFTcySEcdKfYC0cCuKrKg+idhIooHH3Bg/vquRIfVQZ
         ui7i6iKr6+XBiTm/BiskJw7j2AeFHmewca7DXCZpsI/QqieIu/33720/w+urK1deffZ3
         PuuTpUb74JidCvWs2C7NOxuzI/o+h2IOb/OWFuaQaN84pjBGesFPkGROBkzKTpsKqjf8
         YZmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793620622; x=1794225422;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mmnkq7r8AkdD6QmqN02tP8SKsnUa5f5femOn5SNpdc0=;
        b=mM3BUTYdv7F3FDJ2L+rAoqhKihR8dMQltGFMpnI7JPcfA1lWZ1m6I8+d19nQcehxgE
         8CyAOradwbuhDDR6Y2wkSIpd5lm6MMs0KD3CX/UJ8e49InCPrBC4JwFATB6bHpDKuHOs
         1HSmIlIWforS1zVEWCOK05v3qe760FI4SF6zGUgtGQECq5MTqHYD+p5m8HIWCzsIvYkV
         4mkuBIVPzbQ25PsTL1BFqSbZh9CKGbUqrFt4BzlzR7b29iRTZaCgeC37Dhs2fQRDxCiW
         u/4Dw8lNuqBo4mxlwGUUiOcdGqywsqm6xJn8jczbhVf46zRfogmiV/ePKMwj00SYbgz2
         Qmtg==
X-Forwarded-Encrypted: i=1; AKwUvBxHQRbyFUVcjBrCOedRK34dcSHnDsv9Jy3rjp5RTRbgmiCU+Tmfb/NKYgOiqt4rRmbujMwoaT/D3fqe44FvhA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLXEUpHhTTSb4MTWrlmClT9YYruVJTJ+zBGQ6Z8g0Zz+mpIXUiF
	70ANXi+4aytec8X7YbCKO5qQFG8+Gq/0Sb/TKQaCXujNZUd3Qc4tyA6kyQZIxK7Umtcz67wiRKs
	xJ3lrdhVPKUbB+VZsahC4P+FBe2M/KNFAtYP7tQ3+U5VSRpkFWAbTyrssUdXTkE2Z2GDb6dVmSt
	aoCfpjtoq4XvLoCklctfV9Qkl39DIA1txr4WpR/5b8hx71
X-Gm-Gg: AYBFou3xMWiMD7BVtDyWWTdhH52l0awO2L0CgdT4T3vNQTJnFV5mThMQIVlhUO8cqPE
	12+faD1QZFycxwu+FH/NWLk9z2nQDg7Wts3JgvpdAotII0UhRPcN8oX8e2wHXjofd5yuaqu1xw2
	KY8a2IfNwGj3lUWagbc/GZlqb2YzHkwucAXYh3lYVAbJuDjHvogCKR2N3801/17DCXr7LgzZOYk
	1oGi7noO96FGm6e1D4eVxHY71x5UPRxkyo+fUIHxgek3lvWxk5gbHRimPq3xujLtTuq95Xl2gc=
X-Received: by 2002:a05:620a:46a3:b0:93e:5ef8:c794 with SMTP id af79cd13be357-94421696949mr1686125885a.38.1793620621501;
        Mon, 02 Nov 2026 03:57:01 -0800 (PST)
X-Received: by 2002:a05:620a:46a3:b0:93e:5ef8:c794 with SMTP id
 af79cd13be357-94421696949mr1686123685a.38.1793620621019; Mon, 02 Nov 2026
 03:57:01 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma> <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma>
In-Reply-To: <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Mon, 2 Nov 2026 12:56:49 +0100
X-Gm-Features: AclHuK_UmYFEmXEjOcETGfLtpQP7k9aqsLUiYBNqC4WONvGRfPM1oQtAQ5xC4XU
Message-ID: <CAFEp6-2xY_gM=FRUp3R30TZ-NgT=-eYnyz_BPE0vxEenv+202w@mail.gmail.com>
Subject: Re: [PATCH ath-next 1/3] wifi: ath10k: set the PMF peer flag on WCN3990
To: shunsuke@nagashi.ma
Cc: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Heidelberg <david@ixit.cz>,
        Fabricio Akio <fabricioakio@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: Wv5RF7A_jC3Jii1jBDMvukrjQ7WocKQj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA0NyBTYWx0ZWRfX3vFk4k4bj5u7
 oj3k/1BDURygvCTase0NT2NPON+nE2DcI41B8mk7L4qrttL8aeVWQih8QBWQPikU74a8Glmzhx8
 9QYo3CuGshCOi0WyjBhF0e8kKPNtrtzTwtoIcGHiVmgdRZ5OJSx50l3GUYJ+dVXGG2r2zdmfkYD
 c+FDjK+6+LTE7Tn4iM0jtkI02iwMDy5gr5vLRjTouM3lKtQX2UMcczI3Qh/V7JZflr9OlhctOVA
 0VbM7uqeYOe2u5Fgo0SWJTbHaR60pT9TX8etKKedj8abMr6RIy7VwMpNNJbii3Sg/0JYCu+r1Oa
 7UWvM4XDJorPFLfuUEwf3lCu7qSBTo5yEbXg1GX9LyEl6o/fAhmzF3UQpT2k85+3mYuoLDR7LGR
 TPYObixWX3nH5ckQVfrh3EHDeI+qWr0nwiUjDd5T6zyuc7nkjNquza+HKcODDf7LsK7/T6NB8OF
 9f0rhQ/O1hCO0JJRgEw==
X-Proofpoint-GUID: Wv5RF7A_jC3Jii1jBDMvukrjQ7WocKQj
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA0NyBTYWx0ZWRfX+uakP00RxObd
 lsRsVihIB1LD96h2Z4YdjAI1oXZf9JB6qQqv6VAxjxVeSp/0Y7ZL2h0w1bhFz3sjdryBJXmoM6S
 LrwfmSX33UrShxaU0OSC7JvOLhUTGKA=
X-Authority-Analysis: v=2.4 cv=LvwHWXdc c=1 sm=1 tr=0 ts=6ae87a8e cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
 a=nt0wqAW9UeTKEtDnEAwA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 adultscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020047

Hi folks,

On Fri, Oct 16, 2026 at 2:18=E2=80=AFAM Shunsuke Nagashima via B4 Relay
<devnull+shunsuke.nagashi.ma@kernel.org> wrote:
>
> From: Shunsuke Nagashima <shunsuke@nagashi.ma>
>
> ath10k sets the PMF flag in the peer assoc command only when the
> firmware file advertises ATH10K_FW_FEATURE_MFP_SUPPORT. That check came
> with commit 90eceb3b5fb0 ("ath10k: set peer MFP flag in peer assoc
> command"), because at that time "only firmwares 10.1.561 and above have
> support for MFP". The WCN3990 firmware-5.bin files in linux-firmware do
> not set that feature bit, so the flag is never sent on WCN3990, although
> mac80211 negotiates PMF with the AP. ath11k and ath12k set the flag for
> every MFP station.

So why not updating firmware-5.bin file instead?

There is a tool available here:
https://github.com/qca/qca-swiss-army-knife.git

And you can retrieve info with:
./ath10k-fwencoder --info firmware-5.bin

And add the missing mfp-support flag:
./ath10k-fwencoder --modify --features=3D[BASE_FLAGS],mfp-support
~/Workspace/linux-firmware/ath10k/WCN3990/hw1.0/firmware-5.bin

Then you can submit a firmware update.

Regards,
Loic

>
> On WCN3990 (firmware WLAN.HL.2.0.c10-00459) in station mode with PMF,
> without the flag:
>
>  - The firmware sends its ADDBA Request frames unprotected. The AP does
>    not answer them, and no Block Ack agreement is set up, in both the
>    2.4 GHz and the 5 GHz band. On a 5 GHz WPA3 AP, iperf3 to a wired
>    host gave 22.6-31.6 Mbit/s up and 21.6-21.7 Mbit/s down, against
>    280.2-283.0 / 264.5-272.3 Mbit/s with WPA2 on the same AP. A
>    WPA2/WPA3 transition network gave the same low rate (23.4/22.7
>    Mbit/s), because wpa_supplicant chose SAE with PMF there.
>
>  - On 5 GHz, the protected Deauth sent at disconnect carried CCMP PN 0
>    (56 of 56 in one capture). One AP dropped it, kept the old
>    association and answered the next association with status 30, so a
>    reconnect took 24.3-24.4 s instead of about 5 s. Another AP accepted
>    the PN 0 Deauth. On 2.4 GHz the Deauth carried a live PN even
>    without the flag. I could not tell whether the band or the AP's
>    HT/VHT capability makes the difference.
>
> With the flag set (this series, in a build without ath10k debug):
>
>  - ADDBA Request frames were protected and Block Ack was used: on
>    5 GHz with this series, and on 2.4 GHz with an earlier revision of
>    it.
>  - WPA3 on the same 5 GHz AP gave 264.2-279.0 Mbit/s up and
>    236.8-246.2 Mbit/s down, and WPA2 283.4/261.7 Mbit/s. A 60-minute
>    upload with 4 TCP streams averaged 277 Mbit/s, and a 30-minute
>    download with 4 streams 230 Mbit/s.
>  - Deauth frames carried a live PN, except when the Deauth was the first
>    protected frame of the connection. With one MAC address, 100 of 100
>    connect/disconnect cycles to the same AP connected, with no
>    association rejection.
>  - With an earlier revision of this series (the same code at run
>    time): the transition network gave 276.9/249.6 Mbit/s, and in about
>    8 hours of cycles, every association that followed an acknowledged
>    Deauth with a current PN (not 0, and not older than a PN already
>    used; about 1,300) got status 0.
>
> The vendor driver for this firmware also sets the PMF peer flag for
> every PMF connection. On the same device and firmware it reached
> 259.0-269.7 Mbit/s up with WPA3.
>
> Add a hw_params flag and set it for WCN3990, so that the PMF peer flag
> is set for MFP stations there as well. This also applies to MFP clients
> when WCN3990 runs as an AP.
>
> Tested-on: WCN3
