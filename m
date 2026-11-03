Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793697654;
	b=h4ryFxHoSVgfhYiEpmAKc7685rsgKa69UQTj1nw+618Gvs2KsxuklpluXMGxKIBU7rW6
	 WTSzpPUTHDfBsDacou8i0rc0qQk1ghz2s2lOlk1kfzEymaDnadjpzw2v3lNIQ+pq2puz6
	 hRoa1Quif2+S+K+0QXlkVBgsrn5Qjzx191SYfKZZP7w7OJp22G4a8V2o6lOo7BscsFt8e
	 VRq0HujvfeLhLjj1TzkVJD5lYD3tsst6DNsAyKnOhHNhMVrQUlzvLGorqjad92GsLs0H6
	 oLTmQ8HTPl1zy2nBWcHRclr/KgkYdT5dN58DlpE7iiqx4mnjQrCXTyotaxTbnicKeEA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793697654;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=KUBbiIfZu+24bweR1re7NXjlbwlpg2p+g1Gnk+3cVK0=;
	b=mWiwhj0W7n0XsUupyxGxSp0mrC40gWclu+VmClauHP5l0Mq/tUvOPnCGKZ5L48zEuRdp
	 oQnefhvr1MjHBW3ZwFhZ8bGg+TuFSlxUzgjRr4k5KM1MQbOW+klVb6fZRQ/R+4YaYDCtp
	 U9s2UqHl+pGCo/O6b/q0i8YH7sCrWKFCRJC+ItTDsgURumAxVdqzDLzNF6rw0QSj82/hA
	 iYga3Qk53PSTM/VA266OScqA1KrFPPWTAxlRzvXSqvbeE/Ff0NX+onSeURHOpo+hXoiCF
	 ZpKdDutU0/RoDQGT5HJ4eTm3pFt3O3O9Qc17x/V1LmCoTKDXWYH5jlxzXeNO71XxbkQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jR4khUt7;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="Tg9IKvD/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C56606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 09:20:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44C56606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jR4khUt7;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Tg9IKvD/
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A39KoeO2715393
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 09:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KUBbiIfZu+24bweR1re7NXjlbwlpg2p+g1Gnk+3cVK0=; b=jR4khUt7auVF2cTs
	+zE1das89MxlX4ly8zfcOrManLqiiQhL486a7PFc00bj1PPUpwccm31TQKNOoyHI
	AVAUs/O4hZ11F31TXS6ZRbJE8KN8pFS51HYtVDbtdJfaqI3Kx08A/17DodSlik5w
	vDpRIYy8JZNVfd++OdET2A0fnw7JxO9zAqlcntMsTT5N0ME5LkwebEcl4BmebNdg
	QDKiWkfzy5XMLuzZaz99k5Aqngvrm1nQBnwiVZsHHpx26CMr77kFgGp0Sz5PAQF3
	8g+YTwsflDwMKT79yPcRN6H9JEdVhcKtZCfPvRQ3BLu4A0Yq8TiuMIELtxMSL6Hs
	WFm76Q==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq76d9cwp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 09:20:53 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-9308eafb465so480383085a.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 01:20:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793697652; cv=none;
        d=google.com; s=arc-20260327;
        b=WbuudALVBAGUS2Kdr0d28IbDI3iOOVYwqLnNfFt+q2/bdTkMIlR2iuKaUFq9GglWzP
         IkzvBhqA3WVpLw4pcamWhrBr2dYJu3zZShdmvy62U5JYGs2l2ETxMzzaYmn4LJBnBvWa
         mV937GnPsKvPS1m4dQVZJAHNWiWFn/88PsR+o0mSAEiaW3xZRo+07dM6iaoJ6N6304CI
         /oWwr5Gr6AxXMhofaAfufY8OJMUGG82WVN0IlAKePnu6FPFht+8ZsIViXUa+WzkWKzbQ
         sNkNQHENQBspCg/I0bFp6rDjkfutR79+OoIIe/FlKG06m/35x4PafwEsZEuojWiYmpLw
         h2OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KUBbiIfZu+24bweR1re7NXjlbwlpg2p+g1Gnk+3cVK0=;
        fh=LPGkdmuT9qJEKJH2dnFGyzPpGxBFBZ2HfCsSqGt0U2s=;
        b=XQm2kCQbNKMb+7PHMwwhz6r5Uf/XgYHfeEa0GgbNvrl66CZjfGrOo+znMYCYNyQfCv
         b7MaPzg4GFz+KuGg1Uic84Dgfg0yrjJhYuYcv0LgURhsT4X/2y7qYN0btIKeO2ZvXHYr
         HuwHcsSSmtFFnk8jBMzO3a+/FrmzpJnV9QreFI1pO6JyTiwsHFfFEM0qhzDKE0X3mE1b
         wxtmcbhvUd3x86ul3PwDADSIw4zKBan0mvi1AQmZXEwT6mtCl2fOwW6WvZXTFWRzAeVo
         7rMB2nzKy4x+buG9jmVmyo0AYrAvB1iA7iD1qGIqP/8iC1n0qAaYyLogpzqz43vzIwET
         OAWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793697652; x=1794302452; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KUBbiIfZu+24bweR1re7NXjlbwlpg2p+g1Gnk+3cVK0=;
        b=Tg9IKvD/Hy/byn9eQO4Xf7uRMQ08K2y+9cn+A1H/SYfAyUPpnWpQfU2mCAtiM9GIRE
         KJxpLQnqSXGWt5C0vXZcVzA52ZuPyVVtN4bOqqXkDaVIEnUo1/CkgJtCz+EccggT5bHG
         9CwIu3G7cCdLEXhoOn7VQIM1RDRRU3XR5VTSljyUKPFrOJuWF+PDHw1pmpOonj6IK4x+
         xpqVBcw8n+SGOHHGRfS+0+o4U9Js93gm/5ZTIgx2fDVqGVD+xbjaeYGovkOP/LBrpMIB
         oa9w8ny4CIHw7E652l6bmIjzq2EM8ByYPMLgKpTYSQ5cXzfStcbxHOq/dg04V+w4sNl9
         swpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793697652; x=1794302452;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KUBbiIfZu+24bweR1re7NXjlbwlpg2p+g1Gnk+3cVK0=;
        b=cWocJA6OmN7BKJrlLsebzQS6zAMV5aHzRsbYYBHoIBy3Cg21ZovUoL2dPt4ZHDFzWJ
         W5mWd+MvFGov2AWezJVPbTCi0cTEhrs2/JkrLgzbUzmfKTy9acRiJK3bF3TbsJGCxBjP
         wxdNR20avju+t3WzF+bcaSBsbBk1keBswjRc3Mk2n/LqkSEOg15JAa4JNoUQH+KHYOp/
         3TYxPu6pSuJsAe4ri5ncFrBqi0Zea7bI6T1Ik6507nqB79EFyFqEliikUPNZGGi3Trl/
         lsAqi6eQeK4v3gg/fy3pfrHZtn4uac29N0eDITEJ6jT0K7BoxvzHe0r0Qm+Dv/o9rTyP
         ofwg==
X-Forwarded-Encrypted: i=1; AKwUvBxXo51AhGlXfAm9j3LDJWxXH0zwkVryN8aKSDKz+UeD9eDX6ojfskDe9xWL93MoktLNYmjprXruNb2QH+DDXw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/R8RB3VHNgO+eKnEwyClUOjeIeZWJd8naZOVKIJYZzy6aPyBiU
	dpgiIFoEh2nosEZQwUR/KoVUcwffzYsdy1hXeO3PTa9QSpsnB3DXERyAwErfPQKmvC93QUOmcrh
	a0TK7oSHEnMVsyIfo4v+NJGH6IZpO6gElslAZon2HW9dy6UnJWo7qJdZfFs4ay6J7Wg4ZetWugH
	8e9NhzgEqJUja7zj0Czu9PK5DVRd/zpSh//1s+Lf5UYBLO
X-Gm-Gg: AYBFou0BW2VBlHy5s50iDYJ4RsVRXJoInM1KllPmSyAmOwibUMIa08pjcEkCoX8VpY9
	UklDBxet5Bl74cYDvNyGxIC0RrEBruZqnhgyL2h19cWzAy3MeGTQF9/EvciFPcKkC4jteie8IlU
	/RCP7Xi+bgRJ1DVq75x7Q5JxsG50UWnGDt/vEYJOffRC0Rw1ahW7i3a415TH1+f79+C4atsDq+V
	YGQP8GK1+cssTxy4KeAc068obgtDl6Q0jqcXgY//SZVbgYWfD13Tc45bcQU45B5h+Ko7f0+bLc=
X-Received: by 2002:a05:620a:2b44:b0:93e:bcbf:4ad with SMTP id af79cd13be357-944216855c9mr2096034985a.33.1793697652216;
        Tue, 03 Nov 2026 01:20:52 -0800 (PST)
X-Received: by 2002:a05:620a:2b44:b0:93e:bcbf:4ad with SMTP id
 af79cd13be357-944216855c9mr2096030885a.33.1793697651561; Tue, 03 Nov 2026
 01:20:51 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
 <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma>
 <CAFEp6-2xY_gM=FRUp3R30TZ-NgT=-eYnyz_BPE0vxEenv+202w@mail.gmail.com>
 <CACB3TCKq--tdL6j+uGR_dxGdy-gHxQhY8p0h6xxqi_4Fd3VEOQ@mail.gmail.com> <c45bdcae-63da-4552-9e35-59ec6a71621a@gmail.com>
In-Reply-To: <c45bdcae-63da-4552-9e35-59ec6a71621a@gmail.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Tue, 3 Nov 2026 10:20:40 +0100
X-Gm-Features: AclHuK9oFUU-GohF-bJ9l6vtg0lo68CrWTs2ZXBEs1Vyyp-LhH1J9qLG4HKSIt8
Message-ID: <CAFEp6-36Fc15uDWSR=v+xCMhERbkhggZOBoEFTF7pAcRLz_vFw@mail.gmail.com>
Subject: Re: [PATCH ath-next 1/3] wifi: ath10k: set the PMF peer flag on WCN3990
To: "Conn O'Griofa" <connogriofa@gmail.com>
Cc: "Nagashima, Shunsuke" <shunsuke@nagashi.ma>,
        Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Heidelberg <david@ixit.cz>,
        Fabricio Akio <fabricioakio@gmail.com>,
        Aleksei Kharlamov <aleksei.kharlamov@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=KJTPn1Fo c=1 sm=1 tr=0 ts=6ae9a775 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=Um2Pa8k9VHT-vaBCBUpS:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=3iNpH_K7wzUH7o6TWwkA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDAzNyBTYWx0ZWRfX8Z30+gjE1j/E
 7y3SmbhtZJmPrKAc4ORrM/1wqYO832h4AFL4S+OK5iWKBvLeaOJYgmR7xkt0e3CW/pIg97PuYBN
 bmmgqDHElnyXav942uGNixPEahgMoyY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDAzNyBTYWx0ZWRfX4MLZZnBtlTMR
 NmCjfzm4ADN0WP6+Wwt1enoPNTiRKsgarvRgQ0tqxL7v67FEjuoAYfxhXv/cwOM5uKEQPYqVD9s
 CbY6Fdzq9b57JMdiKDwVn7kATqSOldXo18SirQICuHwMw1PXYt7xHFTb2WNrv3tzxDCkwmZqOf5
 ZKvGtn9Sf0gM7jQQG95GO5CqmOgT8yUCDqv2GKLL+sftPf4X+mukDkV5mM5vNhItzMdwCyPtz6n
 Q8fTf/1y4MEmZpfs5KE6u16rJfVJbB5sksG735a7qXm3iFIe6HETmpSByTrVGSbLQ2R2YyZ1oWx
 Jx44p9J2wpFf0y0/HkLlPp4Bp/q9TKjNJzawssGXvhUm91k45epXxfEB+M8xcVagci+UGhsWEn1
 +XDO8mNpKA9xRzmwmRirk6LM2jHnZU/zomAAnA2szb1bqzD/wv1soo9NlLQ0tA3PDZi8TPUh8va
 sxP1TZG4uqjdTQ7VAOw==
X-Proofpoint-GUID: X9R8fUAnOAKhbXM6Uefg7yajM6FTIiRT
X-Proofpoint-ORIG-GUID: X9R8fUAnOAKhbXM6Uefg7yajM6FTIiRT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_01,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611030037

Hi Conn, Shunsuke,

On Tue, Nov 3, 2026 at 12:57=E2=80=AFAM Conn O'Griofa <connogriofa@gmail.co=
m> wrote:
>
> On 02/11/2026 22:51, Nagashima, Shunsuke wrote:
>
> > Aleksei, Conn: a firmware file update only helps devices that load that
> > file. If you have time, could you make the same change to the
> > firmware-N.bin your device loads, test it, and send it to
> > linux-firmware?
>
>
> I can confirm that the unmodified driver with a patched firmware fixes
> the issue on QCA9377 as well. I appended the mfp-support flag to the
> existing flags for both firmware variants that are relevant to my device:
>
> ./ath10k-fwencoder --modify --features=3Dignore-otp-result,mfp-support
> firmware-5.bin
> ./ath10k-fwencoder --modify
> --features=3Dwowlan,ignore-otp-result,mfp-support firmware-6.bin
>
> Testing each firmware individually confirms the flag is now present, and
> both firmware versions can now reach 300Mbps.
>
> ath10k_pci 0000:02:00.0: firmware ver WLAN.TF.1.0-00002-QCATFSWPZ-5 api
> 5 features ignore-otp,mfpcrc32 18db2397
> ath10k_pci 0000:02:00.0: firmware ver WLAN.TF.2.1-00021-QCARMSWP-1 api 6
> features wowlan,ignore-otp,mfpcrc32 02bceae2
>
> I would be happy to submit the modified firmware, but I am skeptical
> that it would be accepted? I'm not sure if I've ever observed
> unofficial/modified wifi firmware to ever have been accepted into
> linux-firmware (which seems completely understandable, given the risks).

I think having this defined directly in firmware-5.bin makes more
sense, as the feature is primarily tied to a specific firmware
implementation rather than the driver itself. If PMF support was
introduced at some point in the WCN3990 firmware distributed through
linux-firmware, then advertising that capability through the
corresponding firmware-5.bin entry seems like the right place to do
it.

Compared to enabling it unconditionally in the driver, this also
prevents older firmware packages that may not implement the feature
from being incorrectly treated as PMF-capable. In other words, the PMF
capability should follow the firmware version, not the driver. As a
result, hardware using the same firmware image would naturally expose
the same PMF capability, while older firmware revisions would continue
to behave correctly without requiring any special handling in the
driver.

For change request I think the best for this is probably to follow
board like change:
https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath10k/boardfil=
es.html

Please, keep me in CC.

Regards,
Loic
