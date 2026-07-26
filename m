Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA661248F7C
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 13:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785072777; cv=pass; b=TZ3avk5EjpxsP21v1CozA5CY+QYiRZWV52wnuR5hdSsWI9YpBhoJqv+AHQ3HtxKvV1b2+yTVLYau1qPGvsNNrtrTXJxQMTrEXPSMJYF/F6ZHn/R6DprjQSb/UofXsj0mCuNRPJaxgAGRCmua9uAJaRujzMNmGP0cRMe8YQTng9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785072777; c=relaxed/simple;
	bh=n4geZ4WTN91DmkRD8ZTD9g7J9z5pNqs+jJPibZ+HECs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oyphIEAzNA77pS8DDfhBR+HCHFFOqPT0/yfkQsW2BFfC+Gg62ZN3j/VqA0ZggnvmUW+sD+klJMTzHiKTfR/RBUsOaQfkwYZp+NYm7pPkmHNiBYOpD9mm6qTQBIc1/dPoKUK7Gm29f4t9qoMCks8NvC4eijApEZpv0bjdDL2vj3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ABgvQQZc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kwFDiCuj; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ABgvQQZc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kwFDiCuj"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QB8vsS640623
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 13:32:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qRq/G4/hJawYbS6je6TnojQ+gkgCJQDUeMrpytmsE+8=; b=ABgvQQZcKYQyVDYM
	RiPWd35V05Rfn5FfbUR0RDUYkTveQdZDSK168/5XynNQD3Pg7jwY/+isvIHx4cML
	9Nvoa/kTOwVs3Oy4Td9H/Mb0bFqiLDUIH4nFLBwQvjZylwXq1MyDHwXPpkpP/B/m
	b90UxroHDh1sroBoploKCZ81eDi0r4fy9tJzYjJcNAUppUnzIx8L0po3ZD7iG7Ri
	Ob0KP8TZtWnN87iZcT3IdUfiBAS0JnRG4FiugE0Z7wXIG0fGxYQjVdF/AFvjiQO4
	OQ7TPtRWumSIsJ077+s0nJ1O59b7e2ZyN3hRyLuWRaQYG5r8YSH1d4sbcE1yoXi9
	/aW5hw==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fngysr8f3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 13:32:55 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8efe7db1c42so31170366d6.3
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 06:32:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785072774; cv=none;
        d=google.com; s=arc-20260327;
        b=dJnbX3Rijy/7hvdZfvI2vhNLZGbq+9FGFCGpxaSV7cthsWh1Ab/AKKhKjMJmikmaFk
         lctXp0fCayxI5gXlM4OKPck5JIZIv1OVODJZ2EZ0Iz153DiPkOHxWqMrrdMCOchXSc7p
         f/OJKjC7DIbHWOSoR8Rnf3ajZexT+WZOAGH+wlmR/9oC4eDr+amwlGWSgJITvobA4Bf+
         aQL0hH/zy/67Ts07kU6GIPay1bKjfVlRK/vYWNKBXA1vvI8bNAu5dGYAFoAyK/eG8IDk
         wpALadr5G3ZvROCA1gPC92E80XhJpJBTZmD9aPyVLekdDYr2u26ACIKuwP6S3Li30++k
         UZIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qRq/G4/hJawYbS6je6TnojQ+gkgCJQDUeMrpytmsE+8=;
        fh=OgXR/RPiGeSScPpyVyi1jszAPwnNU4Z8TN5bPTje7rk=;
        b=XsYnsNsCYNNMVJtr1VXIg6G1RaG1xbiQ9J0x7okHVs7pdbS90LQgYEb9OCdEgrcco/
         62y6rnhoMIxtIdVHbgc88X5MnrnNYKPrYIc2As6KKZd2F4fJ17EcIwWps8mwsiU02j6F
         oV85WJXnixEocy81Ufn2k/RxwFlUJ/rL5h5C7LVa/gxra65wdFvZ0ovmDsEOpkWUR+23
         +X8TQ8XInw5mklY7lxY9Ug5FdTNZs/W3z7MzeJ6VUolmh4Rq0cfR+op9HyHOpgvADALc
         ufxn6SLWkWfNApGhqU/4HOlE0tRqYCP6z3JXpBcOq9cE6cBJa0IoB7i8+ja3RHu5E0bx
         n39A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785072774; x=1785677574; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qRq/G4/hJawYbS6je6TnojQ+gkgCJQDUeMrpytmsE+8=;
        b=kwFDiCuj+VmRse+WzFeIglavgmSpui224qQpyPBK/k3721B4siuL+fhQcRtltbV14f
         dq1/jT6SHqllivVVIZkRmmC3QY7xVJq1VmmUfOJg/4jxdsu5M1ddkF7+VS1fjufBwPpn
         tidRHhavQDhUxpTUNvOnR0BdzajKneJ5ysxRe4A1xct+kqUNaPCp0fuiHjaC45C5K+dH
         KfF+KHuLgK1MGz0jQp6N2KGpXCq/E5cuKknZr7vpqXEFrNTNT/boafkLuHsWcE/+eANe
         JQqahsKQA0i5Q9L7QNvAZc03/s4VrZi1Ifm0AcRkPYssvgIdh4riJYvWgOGt+ZZQtWTV
         kSQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785072774; x=1785677574;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qRq/G4/hJawYbS6je6TnojQ+gkgCJQDUeMrpytmsE+8=;
        b=GfW8V+miJ4nV8aRoJzb9rLny16EelM5knytw8WAZRBKyG3XUOZQnasOKdHQGeH5gDR
         oq44RWumMNodrzjmLQy4lL/B/KQDPUHHAH/JBNLAfkOP/8JVyvKS3JXBr7mGvggRjrQK
         b8++bIZXd3CCsnSLbonm7L8k8ZGxtZE+i25keTDdfVBmD1foIM9+BD5tT3WqSDxFBlwq
         LhgI335BEjFpQYC5NScFuy4a9yD/iBP9kEf1UPaTj8ZVmvS8kPn2sG05229M2Mdloww4
         OWVywYu0yI1NT5/druU7sOg+mJBVvWbd5CRFA/YBL+c2B3qrvnWFeix8gXAHBTPaTcAo
         zQhg==
X-Forwarded-Encrypted: i=1; AHgh+RohB0p/7dZX5F2GisDc0O4LThnuqTGdFrFRHpNoMzVfYN9X7aryPn6l24x4uNhC1Fbiog9b5ui02f03iSzjzA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxNZUM75GCvePJO3hJNWVR8nTEL5v5gn5wQX99WFA7VMI0KBiyW
	MM9wTNubOv+6cDtDvOKKwpkOMi9Mptf92jpw6Yj3pD+azpcgVLHMzLreUYGJOMVe0Hh92wDlc+j
	CLl9AAxvcvvkzm3z7QFBtJtnkE4Eh1lOuBrqFHuJJ3D1MuytRGFe5qqGYesWxOTXSU2KyTKMWcl
	egh9kJSum1qfSLrj7CS4Jx5/JkskA6Xu6PlNbVHWNA1SKw
X-Gm-Gg: AR+sD10QT/y3c298hh6b3+GHkHYUX9gsldcssSvGiZtUzq0hzQjZUS0xhhSMfj9Sfif
	/VnBwrgvFJuWMP/JgUzEXyVLA9xlnA/GiKtN4CPg72efFzrGG1clqVjGgZJoKrbzBcxHwj8r3Jz
	YCEUI1xzxQOZfZWl1qMQEdKCiW915YiPGdyCyZreTAHnxOrdyrONpDwH9qeub/BaIfUqc41kWoo
	2jKbZdlHBdG/ZFSeUpeGV5HJ/5fiDQpH9gULpAHad15jOGtHiLvO1Oho8b3dfc3t6sX0NlI4UQi
X-Received: by 2002:a05:620a:4553:b0:92f:40d:654a with SMTP id af79cd13be357-932df73a90amr503537885a.68.1785072774111;
        Sun, 26 Jul 2026 06:32:54 -0700 (PDT)
X-Received: by 2002:a05:620a:4553:b0:92f:40d:654a with SMTP id
 af79cd13be357-932df73a90amr503534685a.68.1785072773671; Sun, 26 Jul 2026
 06:32:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260726074202.103956-1-shital.gandhi45@gmail.com>
In-Reply-To: <20260726074202.103956-1-shital.gandhi45@gmail.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Sun, 26 Jul 2026 15:32:42 +0200
X-Gm-Features: AUfX_mzrlaosIkwc73Us6RjV4qqxzYRFPera2Dp6kJJ2sDJHQTHymb4_LwN8PhU
Message-ID: <CAFEp6-0drJcrNW-SwNg4PRs-gAYt8UchJqjUoVikd7vxo-ZNfA@mail.gmail.com>
Subject: Re: [PATCH ath-next v2] wifi: wcn36xx: validate HAL message length in
 rx callback
To: Shitalkumar Gandhi <shital.gandhi45@gmail.com>
Cc: jeff.johnson@oss.qualcomm.com, jjohnson@kernel.org, k.eugene.e@gmail.com,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDEzNyBTYWx0ZWRfX6e0OIyFxhM/T
 RyR3AkCbndsapIFpy6Kb16XPmlY+WS+qfyxt++a1jwIrBJ8841dARI10ip23eFlADeNjYsJ+7WM
 TQDP+XOJB69MnIEU3xtJQyu7+89vXpXi9Oe4LGFs6QUI3EQKodL4nUoAqp0ZTrqK0ElK1yfbScd
 YuOin4qPno2Zwz034LwH+OegicUSl7ZfgSbzuCelIC82HdOkfa+973OtOXXddRB/AIOkqlIJYGy
 oKVp137h8ow6ipFxhBQRRsDUogC8E1reFszcJqCvRbGoDmeoJ40ZEgTS3MxjhgLOE6uPEsv1m3H
 xuUmkdi+RwItoG+MYfATHmz0SJmrXbk1ibg++RDry8E3UmF/em1qHV3hQ7IQYtr9oIaf3c8PtSG
 9MoNpGh0hRCGmwXcYEIbw4Y4uyokRnQKV4tYFyr13pzoj5WXmeb3kf4XZUoMMR/HDaaDKe4U3zp
 PdGk3IGu893mqCjaZBw==
X-Proofpoint-GUID: ee4yIQAYscQNNEDhWeUxzxdz177gfQwU
X-Authority-Analysis: v=2.4 cv=DNG/JSNb c=1 sm=1 tr=0 ts=6a660c87 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=VwQbUJbxAAAA:8 a=II-OE9h1AAAA:8 a=pGLkceISAAAA:8
 a=EUspDBNiAAAA:8 a=ssVpW01U6ZhU_pXSG_YA:9 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22 a=nd5eHX0RB9Rs0Bh-HiGA:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDEzNyBTYWx0ZWRfXx73Lhx92A/8t
 VsyjpzI8CanHUWnbVdz3khTyMiMMKL21yn7H+fWmDKD4rqD4D8o5kZAcIC9WjI8VTFJlWXzzK3M
 yJrtKOy+i7XRaZGOHw3A40/9MVotIz4=
X-Proofpoint-ORIG-GUID: ee4yIQAYscQNNEDhWeUxzxdz177gfQwU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 bulkscore=0 adultscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607260137

On Sun, Jul 26, 2026 at 9:42=E2=80=AFAM Shitalkumar Gandhi
<shital.gandhi45@gmail.com> wrote:
>
> From: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
>
> wcn36xx_smd_rsp_process() dereferences msg_header->msg_type to dispatch
> an incoming message before checking that the buffer is large enough to
> hold a struct wcn36xx_hal_msg_header. The length is controlled by the
> remote firmware and can be shorter than the header, causing an
> out-of-bounds read.
>
> Reject messages shorter than the header. Return 0 rather than an error
> so the SMD transport still consumes the malformed packet, matching the
> oversized-message handling later in the same function.
>
> Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN36=
80 hardware")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com=
>

Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>

> ---
> v2:
>  - Trim the commit message and drop the incorrect statement that the
>    individual response/indication handlers already validate their own
>    lengths. They do not; those over-reads (wcn36xx_smd_join_rsp(),
>    wcn36xx_smd_switch_channel_rsp(), wcn36xx_smd_get_stats(),
>    wcn36xx_smd_gtk_offload_get_info_rsp(),
>    wcn36xx_smd_process_ptt_msg_rsp()) will be addressed in separate
>    patches.
>  - Add Assisted-by tag per Documentation/process/coding-assistants.rst.
>
> Link to v1: https://lore.kernel.org/linux-wireless/20260725185740.56658-1=
-shitalkumar.gandhi@cambiumnetworks.com/
> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireles=
s/ath/wcn36xx/smd.c
> index c0b477345832..32dec45dbb50 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -3254,6 +3254,11 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *r=
pdev,
>         struct wcn36xx_hal_ind_msg *msg_ind;
>         wcn36xx_dbg_dump(WCN36XX_DBG_SMD_DUMP, "SMD <<< ", buf, len);
>
> +       if (len < sizeof(*msg_header)) {
> +               wcn36xx_warn("Corrupted HAL message: length %d\n", len);
> +               return 0;
> +       }
> +
>         switch (msg_header->msg_type) {
>         case WCN36XX_HAL_START_RSP:
>         case WCN36XX_HAL_CONFIG_STA_RSP:
>
> base-commit: 90883c513ca01e77c56b8d94be7de11420c1dacf
> --
> 2.25.1
>
