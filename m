Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60BD5349B7
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791995049; cv=pass; b=eLAf8gDOnnrtjx6vjdtyJz3geIupwaLFEnu3FaPO7t4fJauhNgSC5WGSLdzjHSIYWe2C0v9DMX6o6zHEt37vzpe2L7FJjikseiUe7sU6KN7d2Z33KkhTGNvNqfFuzlMaXBP/bPB+24LcP0ju2j6GXQ2X8kB1YS2l9Xe9xkO+HTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791995049; c=relaxed/simple;
	bh=TSS6WZYP178ktf/6Uj9ms2VHwcGUTf5mc6UM9j2rugc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mIOe68mF6XOCbpJvL3j4qlorkTIJMdc6gCF9wQ/+9f0Ay8ZlYlbhlW2fFKUFvo/xALAOUO5njZ8qa6G4ACQ2zbZA+LYQ2O9cesdtypYY2gmCUBghuy02hUZs/NTQR3GB1bZNjowdCIpIxG1NSBmH2Dety9slULaBMBv+K3hdadU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TVt1quCO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kZWb0vjM; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TVt1quCO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kZWb0vjM"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EEbUvY3813225
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 16:24:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ouAxRHwenlnoXS5Tux7sQi9RKyjdy7jbFf5yy8ngrps=; b=TVt1quCOhk2aJt2L
	WDTmchuxvsXQSrm6aFnTwnuNdAeUccpUmLuieI9w8wGlC5/ettWRGulXh3iRo2uV
	JH7PDqufGPJdmQ4tNxQoqfa+PADZc1XtieAy+d4s7pZe0AFpiLASqJLr5aWwcil4
	mSVl9ZoWBOr1cuhtlXX5WwH2ha7SfWcjAI0utaiq1irYwRn2muxuT9dBaYMtrziy
	cIZ/nliVPnypcI6pvmV2Oh0i9oi1Vwv6VIVcRaiM5u86fKNZY/NLjUSao+b9AKuf
	SOpafrzLnm07/pxEzoHM3Bvalj2/95ugi9vzZsp+zm9uDrWDYIk8rlUwTVlPkSc3
	JEFFEA==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha46u2gqu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 16:24:07 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-34e650cff93so738244eec.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 09:24:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791995047; cv=none;
        d=google.com; s=arc-20260327;
        b=EJxL2k12vQTACtMlWQSgMWhWywiIH/HgDq0p/vGiPQcrivPxbl46YafUbxudGFKT1z
         LCnABdy00JlVqUXisu9Fqd9l8bl8teK/QAso8h8fEqTUfqU+Uvg9bg9PyMVeHjZlDqUt
         y9ru2/UA1Ui4SZUdIho0oXt4CdTCbnbg58AAL6Ai/dPVZ+j0tBH4n7ivepgeYzJSmzs5
         QTRwxyYc3Qc713+An8h6xw2pWYCIShjtt52sI73GDJFJczYAjfmjjZDr013mhrlyt6St
         YPVniUi5Bio4dttx8x1DMeL73gm1u87SzhmCGypEqWqSPzo3E0KxO/RqL+xg+MVMjLtJ
         ztOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ouAxRHwenlnoXS5Tux7sQi9RKyjdy7jbFf5yy8ngrps=;
        fh=Y8ZmabVhu9479PNIg5ZL8ZcfRR6OjsioT5uSWUF7lCA=;
        b=fid4aKVk3ZhHcLPFr9mRFOIxKQAUcD87MFqofQKZsZeRek34/2WXyGraQ39ZzMQjsH
         TQegDQ0cGK8G/wZXJqJqNJEA0s9pI2pzQDMTrWXtCZbibRBe6yBYfcOIgDRz4Gr6hHGz
         AM8ZgqBUjBrzr2yIHUJ9NpImbKd3x226aupp9Ac4dBUZdTFpoN5bDcR1PwhTlJCtKevX
         83kHzxGF6eL6IMotaSMvM0d/9+LjAbvZ5GOeZf9LZnEC1Dy2JiFwp9YzHNoWshITolwS
         Pa/6sXBGTFSjFWSM1sL9IZ1o1vVVNoJUzWmrsBlmYsb7Tam8vdUs6EbkOq8gKfhoMyY/
         nMMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791995047; x=1792599847; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ouAxRHwenlnoXS5Tux7sQi9RKyjdy7jbFf5yy8ngrps=;
        b=kZWb0vjMFecMNp97o/pu0nAq+iqWCV+zkrpu8sR1DJPj9+N3P8EZ2LS+HOLDJi1ZpF
         BDIDfoFYnTi1b9NrfZyvy81JjMtEwzafNVASRpZNkZFQrexIzgpnatcKeE/uy5nfWXcx
         +yuhnSlwGEs//bio7oV7yL/zTTwLdVFO8dnt8wbPXIktKDNwWwn4YnqxODb8DysSrzKn
         Dgcwq/bcQaC0Ao67jRPGb1uT5kcvXe4uP+aOmhkbyRHRuTm6So9aHQe9c0ElqkrIFisw
         PoWy/MfJwwRNKrou6Gf0yfkZrcQ2oZWDRBE4CxoL7UwmUISDBVVOds62/vKU9O2+qHQt
         SXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791995047; x=1792599847;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ouAxRHwenlnoXS5Tux7sQi9RKyjdy7jbFf5yy8ngrps=;
        b=FIcFEFuZTp9jSFznMUc9IWJ1tcJaW37HZy0aO3KiFKF5qkphtzXgO+jbJkxjMH2fur
         c+0lEIzzU5ENFrXRCbM3+TRgvUsLKtZcK9PEnhIxtM4uExGUBDIEAM1biKrKV2sM2Qbf
         eEgAenbINkMTtzYWpx6bpw6R7/F1qdsT5oB7aVEna7EOORO2FaAI0Wq4tcWp8QxCEYox
         AjxNgjUqHbtvIPrKH+ae7zr+BIT7ipmeAAFE6zYPITvjc2Eqkptkutfwm6NnIJuKwW7m
         68RwZfcryrJSSYC/g6Ou2mRmJWYKvFIDluCnrRCn5AIS+7yV+QpzjTZDFcvbfB2wt5jv
         +jJw==
X-Forwarded-Encrypted: i=1; AKwUvBzOZaUg3/VwysFWC2eVcwvKt8SBbm6PGDQfq4RupOdotVun20W4vmLLy4zNtpQ2HUQT6BZyEkdk4NqWDe0xhw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKHH7URx0/3+AcU0sasm0FSvpPHx91CINsH7+R9LVhpiJhLw5i8
	xnQtsflLoXTpvvsF95JSI6MPyt5OvuZdqFzkilbZTWi2bYoV58FMev3rC7PphS38DJu0ppYW169
	ndEgHG/eYTrEPipscGnJDmoFO2jzQ7bwLNPECpixMLk4F+45tBCUKwCjIvsnBOrD9v0VVLzZCq6
	WTEDKcoUbPJfEGOBXDRdSmCJfNXJf5V3gjFAAlM0l6aCax
X-Gm-Gg: AYBFou0C2RVoQn5dQHpzzxliJ/uwhvh8itgW1gWsjnYOJxWsQOy20A2fKcGOqwZQTyz
	mrFsjPDqTTJVc2SIzNgCTVprJcsyYF1oAW6xJV1GUxaeKHhJdJrJKTMUrVN8cL7rRNyUd/ZCNu+
	4BDI3BqCsIt+qkxU7tWYYSIIysxp8MJfoqlZltP4Z70+ziL7RLXvoNLnnTp9Hwp5Ar+XJ35goiX
	OP0Zox6TV7gtQwAxw==
X-Received: by 2002:a05:7300:c01b:20b0:351:e21d:357d with SMTP id 5a478bee46e88-3537dfdd089mr41541490eec.1.1791995041946;
        Wed, 14 Oct 2026 09:24:01 -0700 (PDT)
X-Received: by 2002:a05:7300:c01b:20b0:351:e21d:357d with SMTP id
 5a478bee46e88-3537dfdd089mr41541456eec.1.1791995041308; Wed, 14 Oct 2026
 09:24:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917064825.12747-1-jtornosm@redhat.com>
In-Reply-To: <20260917064825.12747-1-jtornosm@redhat.com>
From: Tamizh Raja <tamizh.raja@oss.qualcomm.com>
Date: Wed, 14 Oct 2026 21:53:49 +0530
X-Gm-Features: AclHuK-uImdXK88rnU2XiKtyAUjSR6pC3yRcEp_C4bR0864jreBK1-o8m4IfHpo
Message-ID: <CABkEBKbHhxNsx5ZpYCSDEKtC2UpR+PD4hSF1CeUOwUBkTq2XKw@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] ath11k/ath12k: implement TX flow control
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: jjohnson@kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA2NSBTYWx0ZWRfX95e88OXKdD6W
 x8yfbFhYOtZfRZRmvYp+uQ1bMRmZiIDPyXVWC/Cbq/i2jiP1DcNsaxBIi20v3fAqYJ3JHoByXpE
 DLliwJfhoXjr1uuZolSYKPAJ/Yx45f8=
X-Proofpoint-GUID: 3OZeq0rv9dGdKss16EkSAVhL_U0e737r
X-Authority-Analysis: v=2.4 cv=Y6ttIReN c=1 sm=1 tr=0 ts=6acfaca7 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=lWMnthoht6l5_8CjfcsA:9 a=QEXdDO2ut3YA:10 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA2NSBTYWx0ZWRfX99q9pElIYWV4
 T5wKUHRZ5RWn1Kv4iAc+NpR/2ESMIVtZKHOEIsPBDOqRx3PNsIzhzATGPdJQIhZQiwCczn6oUXS
 1mwhnwDM7/LUvxGetQHsJ823up9KT+1vedQ+fXpurMMvoqf9FX+kUZdy6mN1OiMVY4pOpCPhaFI
 Z2XHwi3PBHL6A97AI65pokN3ZzxCQ4gegT5FZMjkMs4FtLgMOed+rWC1EUItxNmdDq/U1ry6PA6
 r1T+3kSg+5drRNuOT19XKmAE2aFYTMIxLgsvENlDoeXdUrJ9Qtk2yzNjcuN8tpP6wkqA9bBBdE3
 UiOeltFH6VebcApE4DDq5fJEY86DVeVgnIGnN6sHam4LtDVy8uuekRZTp/cC2ftVGGj2wMGc9Rv
 D6gpWa+m2eRLuGzmt8ZV375Z9SMOwJcAzQvd1I1AJYydDuEUbg1jRorPFMIazMZ9AP2YRH7uVgU
 q2ZQ+0Aj4M8Ym7FMs5A==
X-Proofpoint-ORIG-GUID: 3OZeq0rv9dGdKss16EkSAVhL_U0e737r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140065

On Thu, Sep 17, 2026 at 12:18=E2=80=AFPM Jose Ignacio Tornos Martinez
<jtornosm@redhat.com> wrote:
>
> This series implements custom wake_tx_queue operations for ath11k and
> ath12k drivers to prevent hardware ring overflow issues under heavy
> traffic.
>
> Without proper flow control, both drivers experience -ENOMEM errors
> ("failed to transmit frame -12") when the hardware TCL ring fills up.
> Additionally, ath12k can hang under sustained high throughput. These
> issues are more commonly observed in VMs with PCIe passthrough but
> also occur on bare metal systems.
>
> The implementation follows the pattern used in the iwlwifi driver,
> adapted for ath11k/ath12k hardware ring architecture, checking
> hardware ring space before dequeuing packets from mac80211.
>
> Testing shows stable operation with eliminated -ENOMEM errors, no hangs,
> and improved throughput under heavy traffic conditions.
>
> Jose Ignacio Tornos Martinez (4):
>   wifi: ath11k: use queue mapping for WCN6750 ring selection
>   wifi: ath11k/ath12k: remove skb parameter from get_ring_selector
>   wifi: ath11k: implement custom wake_tx_queue with flow control
>   wifi: ath12k: implement custom wake_tx_queue with flow control
>
> v7: No modification in patches 1 and 2
>     Address comments from Jeff Johnson:
>       Patch 3: Add the defensive pattern _bh in both spinlocks (ath11k)
>       Patch 4: Add the defensive pattern _bh in both spinlocks (ath12k)
> v6: https://lore.kernel.org/all/20260811172435.616200-1-jtornosm@redhat.c=
om/
> --
> 2.49.0
>

There is another series touching the same area: "[PATCH ath-next v4
0/9] wifi: ath11k: airtime queue limits, fairness and a driver TXQ
scheduler".
It looks like there are some conflicts between the two. Could you
please take a look?
>


--=20
- Tamizh.
