Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EAC3EB0F7
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 09:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784883897; cv=pass; b=XXKm2FffNXwHAUzt5Z+K88fmfROTs5WbWXbuxas1h6lvvkN3ej3Cp944K6DYqj9h0cx9yh1/xTuP7FqKCdT5aOWSHRDxtRmE/ijUr+zn2Dutc3nh2rgF5EAKMknLMKsU2c5meJ2B+RoqpyXyQyculiNijUmivY6gT5pPP/dBGZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784883897; c=relaxed/simple;
	bh=E6qygnatygzUiz7rwhBKalHdeKGA9Q4zOdgNs8dG5sw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SJFezCpiElusHqK141Fv1ZvfSrtYArbHD4ItrSOLz9TUtbZZrFPbJoTbTcGJUdXupKlSgajENqyINosZYDBg1dsapD22rBQgTuuzL7o2stApauPEnDsu3ObS7GOV/Wi5Z8rapwH2HJFuqtD/myNzA1mpQCbCnVcEFiPpN8MAAM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AHCha4M6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z9UKl/Mx; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AHCha4M6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z9UKl/Mx"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O4lhXE1510857
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 09:04:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fZAO5VBS8eZkNXTswb/DHceIXIheF14CYuGeiDaluF0=; b=AHCha4M6TFyeZlQv
	egQDz9kystbL4aLnNC27Y4LRGKI98RWi+yyjy8Rh9PENjQ7FWmh7kPx0R598z+XV
	jY5/Fj20q2w3xmzrdhTPdil6aDgVcPM7h0cENez3f9NEaqrHMZo4OMm5Yv8qHo56
	1I2rnksgzPeUB0vgB6oN3AFWg4fh0UkmiY81NiaWe8Q+CMci0V2QnzOO26woCPbj
	q3rrn0qy410bIMr58EFz7lcp68iH+j62skdDJPgj4YxABAKxy+7Auuzbg0mNJqbq
	0N3FzPV6i5WVtBrrwdSFrPLLyX2ny514iC/wIAF16wzgSuAePQwy0RePpFooB67U
	VKr2uw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkusrsvub-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 09:04:55 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cca0ed258cso989095ad.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 02:04:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784883895; cv=none;
        d=google.com; s=arc-20260327;
        b=D8QNF0n+cYkWhP/NdwdAPpuHJ+aB8S3BjzUTgz8lToM47pH+8GTJeFyTm4cE/mchPw
         TqQU9VPnfx+ep/8MEc4E3mSxSx9DgnnsjyPHU+/f63E3s8sqcXOBw/EvBP9utaJ8MPj8
         7/+UVmmaLcR7Cy2YlAn9i8eUAQIf/d1CKjUDYR8XzDU+ge6ZUJ/jDdiql+tp0tPbK+46
         7qfrycU1B/LzNGttX0rktga/vlhgND4Y/KZH5F8crV9Xr3e0W/FwQB40kZEtuAFtJnbS
         J70ydTxKA2/pWAjbObXUljxLG4RF+F2TfLLQf6NLHXwV3kFbC+VpTy32bui/zj7ubcq9
         HIqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fZAO5VBS8eZkNXTswb/DHceIXIheF14CYuGeiDaluF0=;
        fh=DTf8ixMmBJspDfWCirJXEqEP9Z6Xdj3Vd1I9FqnT8Uc=;
        b=PKTMpj1wS1c5Oc3jn3G84yHbTNj38+brLOVl0oHa/RkmBUDhnWPg3Up4ivdh22m56n
         ovs8szmL+vK05sJFZUwqR8IX0m4TAa1n5OqWQ/oCyLsC6IYatYutfMmTtVM3U/kSEK1f
         uM7UuayMkDFn91n8CrNyIiGqsvGa+WWfUhzQCbUKuMkZSj4CFLNSNWcvZ72zWrot5vSz
         ZxAYP2UgJYR+Hkpgjpa5vpVgr+Y38qAtdcIBpDimxPqHCwL+l8r/qcx1tWS3yCWFCNqy
         VT9KKYPbwC4xfVSjwJHDzR4v6PVnLg+yKNbfbrhWNGtknQ8K2rgCr1Cg7vFAOYk5aozb
         vPIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784883895; x=1785488695; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fZAO5VBS8eZkNXTswb/DHceIXIheF14CYuGeiDaluF0=;
        b=Z9UKl/Mxx7+8aND+ttuEd1Wm2hnnDWdh7aVwWsKrK5v0Q8pio+tRIB7IS7U292YsfK
         xd/e7mgOTc0ulsnTL+9XodopRdG8SbrOoFZD59xyRqSkQCi4LSlv8RO7BxM7zoQJqHk3
         iThurPncLNV5fAgTeyAw3Hq2gr8kTtA4uCYWyDACV0XjeLPmdIbHZtbb7uLELK4vU8fk
         GMOC5b5f1MLApzn5kQme03ce2vedsdK3IgvcAR+lv9WH6XbYVQhErma/lbWueWku10yN
         IDeYB/l45IEbs+NVUReyd9hph5aUI8N1XsNK5gAxXk/coQFXzSt/KLbasgjdzetgHpoC
         VIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784883895; x=1785488695;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fZAO5VBS8eZkNXTswb/DHceIXIheF14CYuGeiDaluF0=;
        b=mP+L/ywWUzJj9TGlhRpUDtozY5QZLY2ina32ZVF59mkIX6Z3yxrVXoPit1v31nNanx
         yWJHwSn/ggya9M35T2+4zCwhKVqCGHdLygqX6dUDriVxbU8Pes1ZBWoEysN+WfIpE1JL
         4aKHPvdiAMuyKzbWAewOsu/y4QMJFa2IqlqGjjvLIvVt/AEXes21aEJkbJyGlwMjKFBm
         g+wyj1nEY/WovQ1XG7vzvPqoLVxbC/XJr+EmKNNu3USElQ2Hr/gvsZ8PhLOVz1FxI3LR
         Ew9HATe1W5cK9p4CjsSeJduB75P8sgXA4tvDGPOLqilr4GUDm8VUfeJudSzU7/4SNKGa
         qeUg==
X-Forwarded-Encrypted: i=1; AHgh+RpP7e2Cdpc+w72rPXzgzCAS69No4DfQVYpbafIswQmaDPXsxMFoqoEuvxt3wd4FFmCTUiJaFCK5PtbpaJXkZg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv2U9LLYlaeTKZtbXsAuG1KKZDoXlWsaOXKUP1ZRO/x0gKar7M
	b7FZqiNQFQ/Z9FzLBsiVSAT9uUVgBCwyuy3uft0miSOkjy77mSVZfhhmxVRhOGwjommOop5fR3U
	XHqVQt4jVOLWRRtmlpVqzr3n9fBjQcNMISxCo/8+79BSle+FnYaxqdHlTl0RvLRYNNhN7nAhN0Y
	KqH49PJhmrJ3j4i/+b4xcVhjqQiPJ2QZVRCyEcDmdRrajr
X-Gm-Gg: AR+sD10DvuNx7By8tZyjR40SUliXLcd97lK8KWc7ysLeuss8eOtCFEvTAZFkrQmmO1G
	cctbMDKhZVaa70hBoTI/oSv/RkViYY46NkDvCqwQLHB5+cUiOQ9Z3o7/3qRZWV6Jt1S2m7hzQc9
	6YJHX9lWuGSgLBoq9YAgWDg5sqyD1mLBy4fxCaErM53hhDe1sqnxfVL3f8ouujuL5LCNrn93IFl
	sW0jvC6EPsjEx5THw==
X-Received: by 2002:a17:902:ebc2:b0:2c9:8287:fd0d with SMTP id d9443c01a7336-2cfbd0a236bmr26057455ad.3.1784883894632;
        Fri, 24 Jul 2026 02:04:54 -0700 (PDT)
X-Received: by 2002:a17:902:ebc2:b0:2c9:8287:fd0d with SMTP id
 d9443c01a7336-2cfbd0a236bmr26057285ad.3.1784883894238; Fri, 24 Jul 2026
 02:04:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724053121.15759-1-jtornosm@redhat.com> <20260724053121.15759-2-jtornosm@redhat.com>
In-Reply-To: <20260724053121.15759-2-jtornosm@redhat.com>
From: Tamizh Raja <tamizh.raja@oss.qualcomm.com>
Date: Fri, 24 Jul 2026 14:34:41 +0530
X-Gm-Features: AUfX_mwXA07Oamtx03sMzNZNVbXTzN4dYKzsEBRAeKRrqOc10ocw-mkQ-MvjSVg
Message-ID: <CABkEBKaZOEh4OrZTYfFOj8QZHY8Ruxn2rcXL-axWHwK4o6MECA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] wifi: ath11k: use queue mapping for WCN6750 ring selection
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: jjohnson@kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDA4MiBTYWx0ZWRfX75vteOthev4i
 cVI+kiJPLaFvd+Ph3hc43GkkC448kykA3U0ywtADysi+SNAdNerityb4FQrZpmIb7S8FEBlaGeG
 Sc30/Vug2KnwKTesKAuhpHAeI7i1044=
X-Proofpoint-ORIG-GUID: 6jrh95Q8C0sm_X30mMRMu-Vq8rdE4EoU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDA4MiBTYWx0ZWRfX/EIVlkQxAF6r
 JQx1lzMOEY1LpWZCofISJ5KWUCiUEgUGElq8VRyvHdL8tdieqY3FZWjBllzE4r/owK1qZABM9zI
 pixwz6kboLvrUFyDlhRwcBc+kwiStudpWzxXMFfXYxmbMW2R3vPGgj1TLIo4YqaLmxR+clLVOxj
 5DN0yQGl4vq79a4Vd7nxnobHDHsdGaerogtH4RjPY1pSHMBlclzmBuNVTfMYhu2r1YKh5QHizBF
 D0MG8PuLHSmuQINvAw63UzeLHnELOsBoFyJ4bBvR9jcknVQDlHb7XXEhJgwUuDjMpIVeyaypWcp
 37sc7+y8XMn/CLqp41Wsi/AG9W153/t29GswUza3KD241SlIw9DsxIbdEJ4ciPh1oL/3aTH+v3j
 pdE89y5wZMRkS5C2lulGni9mhofhsjJ0m8cTPTz/Nq+0VNdsFDSBdRJwE2vbsBSeGz7ipMMggDO
 3GadzyWmHEjzkfo+azg==
X-Authority-Analysis: v=2.4 cv=PtejqQM3 c=1 sm=1 tr=0 ts=6a632ab7 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=DJpcGTmdVt4CTyJn9g5Z:22 a=20KFwNOVAAAA:8 a=bisvXKnJg3u-O0vvLn0A:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: 6jrh95Q8C0sm_X30mMRMu-Vq8rdE4EoU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240082

On Fri, Jul 24, 2026 at 11:01=E2=80=AFAM Jose Ignacio Tornos Martinez
<jtornosm@redhat.com> wrote:
>
> WCN6750 selects the TCL ring using skb_get_hash() to distribute
> flows across its 3 TX rings, as introduced in commit 7636c9a6e7d7
> ("wifi: ath11k: Add multi TX ring support for WCN6750"). The goal
> was to prevent out-of-order packet delivery that could occur with
> smp_processor_id()-based selection, where packets of the same flow
> could end up on different rings depending on CPU scheduling.
>
> Switch to skb_get_queue_mapping() instead, which returns the AC
> (access category) assigned by mac80211 in ieee80211_select_queue().
> This provides the same ordering guarantee: packets of the same TID
> always map to the same AC and therefore always land on the same
> ring, preventing reordering.
>
> Using queue mapping for ring selection also provides QoS-aware
> distribution, where each traffic class gets a deterministic ring
> assignment, rather than the random distribution that flow hashing
> produces. With 3 rings and 4 ACs (VO=3D0, VI=3D1, BE=3D2, BK=3D3), the
> mapping becomes: VO and BK share ring 0, VI uses ring 1, and BE
> uses ring 2.

Combining VO and BK is fine? since VO is a high priority. @baochen any
thought on this?
>
> This matches the approach already used by ath12k for WCN7850, which
> has the same ring count and uses skb_get_queue_mapping() for its
> ring selector.
>
> This change also removes the dependency on skb_get_hash(), which
> is relevant for a subsequent patch that removes the skb parameter
> from the get_ring_selector hw_ops callback entirely, enabling
> TX flow control in wake_tx_queue without requiring a complex peek
> to inspect frames before dequeue.
>
> Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
> ---
> v4: new patch
>
>  drivers/net/wireless/ath/ath11k/hw.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath11k/hw.c b/drivers/net/wireless/=
ath/ath11k/hw.c
> index 93f9a03c48dc..d679e39dce03 100644
> --- a/drivers/net/wireless/ath/ath11k/hw.c
> +++ b/drivers/net/wireless/ath/ath11k/hw.c
> @@ -891,13 +891,7 @@ static u32 ath11k_hw_ipq8074_get_tcl_ring_selector(s=
truct sk_buff *skb)
>
>  static u32 ath11k_hw_wcn6750_get_tcl_ring_selector(struct sk_buff *skb)
>  {
> -       /* Select the TCL ring based on the flow hash of the SKB instead
> -        * of CPU ID. Since applications pumping the traffic can be sched=
uled
> -        * on multiple CPUs, there is a chance that packets of the same f=
low
> -        * could end on different TCL rings, this could sometimes results=
 in
> -        * an out of order arrival of the packets at the receiver.
> -        */
> -       return skb_get_hash(skb);
> +       return skb_get_queue_mapping(skb);
>  }
>
>  const struct ath11k_hw_ops ipq8074_ops =3D {
> --
> 2.54.0
>
>


--=20
- Tamizh.
