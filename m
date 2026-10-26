Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793033498;
	b=sEEEHecBxv2iItebVuhCifZt8KmGbBhXdrlxwwxJaig4ngIP/cu2VrxkacEBozrNOT91
	 c8wSl7orLG3y4H/CheEdaUfaSHL3MJ/Ln7nD7G863DjmpnBNNUAiJ/vV7gF2uDBGYj+3I
	 MRFEVZKQCh2+rfF4PxmvJ2DlvkQ9tNe6nFkk5kC3LvfyQNI+wpy/zLsX4+QhyLyM72Aol
	 5gJpEAqk2VF0m10V/DYUnaiRSCBzP7NKskPeSJMWAlqggGTqaHJl5tQgUVdShSV2otWEJ
	 WeBUedQ3pogj35O0aagCcSM0lZzWGLTR1OJssLoTPVkcr6eCn7CcM9WldgrB7tjg+RA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793033498;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=mSu8bIwllQ/UcPEMwqmNzIwVAcXZ6n+a4SKSGu5Wnys=;
	b=UXo904CCj+FAsASaYTJQo7du4ciPlqmfpgcs2PI4O6HoPy6yXv8nz4sG1jWs1t9hfHpK
	 T+pqNY2CnCfXqiYsdNLAp8OEQ9b1C8Q21r/pC28Xg21/gSDHKJy5A5WUNkce0Zz6G/Q1m
	 MWgDPbWoLbfjl8zC7pq3ibaJ5l7MkBtJUwQXcx9OEIlhIe10Rzggm3nZh7fkpdT/sHRNv
	 Drg5MTTZyAAAcwjw6u8KYhpirpgF5N/J3/lsP4LfmIQLBpZTiw2pSYUwI6dP0DTLgXNNo
	 HywvII0bsnPKWQt6pO4C1TOgd3zkGGguCsan14L43NmgMW29WPQqCyWmDQFjhf9PmxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=EoCgWx2Q;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QOBWxgcf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54970606A324
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 16:51:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54970606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=EoCgWx2Q;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QOBWxgcf
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QEvvXA2707728
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 16:51:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mSu8bIwllQ/UcPEMwqmNzIwVAcXZ6n+a4SKSGu5Wnys=; b=EoCgWx2Qo+MPAhRX
	yKavjXnpRQz4TtILPEfZRKugZaBzRUP3AQALpNBmKABPC3PQYaXsEZ6aQhtM3zk2
	GtYdkV5O8ULL58BdofZ3n2d/wT1Phqg5SqbgAKbHMlRMUOWJKxXjmfiYRPNPX2Y5
	Ov7aZtKKyyLC3x5dPfVTbf5xexS71xkjQ9M3VmprPt79sqWElxGelkQmNOHZTNwK
	CFRD7HBjVV/J6AE3rieuj0ptNcWmnpR6DryEKh25NPjvqurk6nh5bKJHOZIiZ9Qr
	Xv0B7sdGbbXpm0F360sMJk/cAIr5+LS7NlOfmYPwG9i7QqPPRldmcZxesM6YfDcQ
	17uJVQ==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hj3u61t6g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 16:51:37 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-5587351d419so2597458b6e.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 09:51:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793033497; cv=none;
        d=google.com; s=arc-20260327;
        b=PyadEmXLZkZZVokGPef9QWBvT9jO1IdTmY2h42iTRF69grqFNXQMZyy798HLp6XhnW
         wmLIXMEB0YwOiAjGeDhRkovGOpWKOpD8LJa0ENKLlm1VW/HbMJ/3CvF7ACEJjTANOODI
         wPysiESiIplNXbLqs8g4IniLmqjx18FPXTeAAOPzeP9gjAgBEIZ+bAlXTRDHSHFtRiwf
         oUu/t7JjSubS7rRhN3mR5ICVltp7vOma0jdhcygf9DXQHpW2zxaFoEjFq/B/8EEC6+9x
         6Tj7BIqpLu9HWjHNjX2XipSTKKzpv5ogqxZ8kMxfC9okTzTmMRq67pxKunxUEer/6t40
         58yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mSu8bIwllQ/UcPEMwqmNzIwVAcXZ6n+a4SKSGu5Wnys=;
        fh=ix84u9CasD04wg+P2w55BiV0iu64xTDzXREwUJdSzdk=;
        b=rZQv9p2/QZGwDWQNOSe2qI2iwmp0QAZDB8MUWLA8FhPYOExiQY6yBb4VBerJX0JApj
         mj3TdiQ9cUHp5r/CD7P+KDmsmK7Zn/0unrjgCkSnuJuMZA2xZDc+2G5Fae+8mmCn0RDc
         Cz9RCh5aFOajsx/3fd0o2WVr0+DQBgjEjyLSwb+VwNNktRnT5QEoWMu1rmXp8rD/YLqI
         JFTWv7UjXWH7ZOzmkdEYkG9pllAIMds8JzgeEAlJiW+gdIMZo7duk4GZWiKUaUgki73d
         02CWQzctvG8WfL43l19pOMzDwxKhTguS1juw+5yKcYIbJoxQBFvz9kkr+p7zcDM/MZbV
         Ypxw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793033497; x=1793638297; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mSu8bIwllQ/UcPEMwqmNzIwVAcXZ6n+a4SKSGu5Wnys=;
        b=QOBWxgcfwOxW68Fc2s7t3fpmjeheAE5h0kIdir8CzCOsliMP8H/WQ9WsPN9Nde/Enj
         tgDEuS62QY1SmgvS8oZsswt/1Du7BTKEE0bO++OhbmlUw8xNxXA9niDSqCZ2GKHOclCk
         dk12yUPb6jXkE0v7jGAQQIjK8Qo/1n+Dk62+mse6zlxVqYZgDlaTBMBBo6DUHyuRmmed
         qQJ3uduLagUR5tpOKX7U5MmUs+z9wPPkKpqT0fbiChylxBln6jTUE60AjHHUA2GvXXLT
         S1/2Iw/oWEJ4KL8dx92ajYL8V6N8Jaz1KJHRQUjYIjCHyKiKWeBM8UYaT9Xc7Q/y4QCR
         VgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793033497; x=1793638297;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mSu8bIwllQ/UcPEMwqmNzIwVAcXZ6n+a4SKSGu5Wnys=;
        b=rpmzpPvG26DtxvowGVrRYH7/J9ip86GypvLW3TuRuO136NHQMrYK4fwBPjdqTj6NuX
         6isz/n7S1gAOCJPIBfJUJW2ChnDQ15xvTV6QSCZ/JZT7eUplrQC+wM2OGYVzPYCy1VTF
         /8BhWOybp1I9toyzlOB/JoN6sZeC3mp5cg1LIg1nE+/i51zF3rl6A1Af/FdU0yeq+NBk
         5KZn2XE3YfuGSZPbtgG8RRme++b+dD+Zng0T79c0zZSks8jCyVoZ33n9RWqMMkY5C7ov
         p6QkyuA/5H30xpU63sGRkCuN7ejfBDUk31xDPvipb5vjBk/TB57pWMX+FnmjvQqU4COw
         JQ1Q==
X-Forwarded-Encrypted: i=1; AKwUvByBPDnjdNthYhnO7QJgyFDdElupRzPAxYIkXcFTrkp7/4Tm0BPf+gMT2f29CaprvRyLR/PxpUOPo7ZN4Y7ElA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLQEt3hpWs67+weuY5CU5NXJhRM6YCDDeBgmiMD9CYrIcrpXxGE
	CiK7GVCk2dEw5XOPHjrNHScSREt35X2dwHZ0zD8Uzto1xmNJ1vPHBCSCGvEpdXZJwac8YaLWJIC
	1CbeOm38BCcJWuqrk5I0uitLc9C11ZoTgMnSNqbl+UIaZ0hZTxGcv+Lq56VmKuLy3TZIL/M7Noc
	298B/g3eHqM4uORu6PnePHADysPu7Sb6g3j+l9UnQpBcdJ
X-Gm-Gg: AYBFou1zjNeGjAbTZnwVH4Uxsykuts548XvT9lSBLEnvc+g3AAwqPFJOiBv/I9aDSV6
	JFiFOnsjuww7BeF/G/3k2pWKuxCqTosdIyfQH9VB2p3VNiRFIn47sWKqe6v5VYgVr5LkwNq6bmy
	278aZTiTvunPgn2hr1lfeAWefw17j1fFeRVbzN6Y4e34n6bILhsgjygcPZevKL17YHBFNhfxnzy
	fLgPddaTYWDMQ4rGImnOckKpG62tZyf41OusMdvUkCnSV7uMMC/eypGENYC4UAGvPLUh4A4tqBx
X-Received: by 2002:a05:6808:30a8:b0:4d6:9293:9bc3 with SMTP id 5614622812f47-55c0035e0d8mr4594271b6e.61.1793033496508;
        Mon, 26 Oct 2026 09:51:36 -0700 (PDT)
X-Received: by 2002:a05:6808:30a8:b0:4d6:9293:9bc3 with SMTP id
 5614622812f47-55c0035e0d8mr4594249b6e.61.1793033495896; Mon, 26 Oct 2026
 09:51:35 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026-ath10k-temperature-v1-1-e5cd6fde7f1e@gmail.com>
In-Reply-To: <20261026-ath10k-temperature-v1-1-e5cd6fde7f1e@gmail.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Mon, 26 Oct 2026 17:51:24 +0100
X-Gm-Features: AclHuK_Jmeq84Mm4fd65kQjsPYcOJSPjKDNZR_s6Js0HaIcEN6qdLR_UOiC3E4A
Message-ID: <CAFEp6-0LiHBGz+yZb4+fExSFR3U=pgKbCui6ZdTxVc39VjHbQw@mail.gmail.com>
Subject: Re: [PATCH] wifi: ath10k: Stop unanswered temperature reads
To: effeffe99@gmail.com
Cc: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: s6TH9SM5a5fALVRmGCAUZ-AWbAprP_3k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA2NyBTYWx0ZWRfX2UgrhbM8XV1Z
 dWL8C5+rtyN7kZxeejxwqc2cB2XnYhVyXVraGBGhxEhfTmy+97gmLFAcDM9bQ8DBPUZcfkcQdIG
 jwBYRkpdImMWi9rHY7KfHViHWxCT3OYQ+8i3HchmjDUjz4SFZkWzK76DUoLE0ukLtiCaUBraouU
 R3bsCMjL9aInJHw2wO5cYbSXroh/Y2gDBAqTE20tDTZh+zN/asOu/gABPAEMPBRIgnAalrE7SN5
 mHL3z2r0M3B0XZfxDb03AYwrloT7xSlkmufNfT/gulDAoqdB2Vwtx7qyFo6UZesDwAZV8yoEy4H
 o9itvX3wlEE8bEZtoI1vyUNVU0yuC+tQGpna7AWW6xrUAv1jt97/Q20KBR7kNmRfraV4TdI6gxw
 bRXeDUJFsx0o9jXsb8EF816e6rrUFX/inCHkDMlO0hm7UgkEUvEI2lCXqyVOZ1ObkUPQhkpjD91
 QsWVxk8C07AmxguKLRg==
X-Proofpoint-ORIG-GUID: s6TH9SM5a5fALVRmGCAUZ-AWbAprP_3k
X-Authority-Analysis: v=2.4 cv=K823jCWI c=1 sm=1 tr=0 ts=6adf8519 cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=pn2aKBgt1YT2jw1FRdIA:9 a=QEXdDO2ut3YA:10 a=efpaJB4zofY2dbm2aIRb:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA2NyBTYWx0ZWRfX4KNL9HXkoQFD
 xfvCrBt+VZ9HELSLXWStMNDfO74mjm/4sjFP/w7fDKagepyblYAvggJNWgT7F27ZW40/M30rN6G
 0S9uNbzEk7DoeO6wMl6+iLrJVyzI0II=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610260067

On Mon, Oct 26, 2026 at 5:36=E2=80=AFPM Filippo Falezza via B4 Relay
<devnull+effeffe99.gmail.com@kernel.org> wrote:
>
> From: Filippo Falezza <effeffe99@gmail.com>
>
> Reading the ath10k hwmon temperature sends WMI_PDEV_GET_TEMPERATURE and
> waits up to 5 s (ATH10K_THERMAL_SYNC_TIMEOUT_HZ) for the reply event,
> holding conf_mutex. Not all firmware answers: the WCN3990 firmware
> WLAN.HL.3.3.1-00694-QCAHLSWMTPLZ-1 on a Motorola Moto G 5G Plus
> codename nairo (SM7250) never sends the event, so every read of
> temp1_input stalls for 5 s, logs
>
>   ath10k_snoc 18800000.wifi: failed to synchronize thermal read
>
> and returns -ETIMEDOUT. Tools that read all hwmon sensors, such as
> lm-sensors, hang for 5 s on every run, and configuration changes of the
> interface wait for conf_mutex in the meantime.
>
> Whether the firmware answers cannot be told from the chip: firmware that
> answers and firmware that does not both advertise
> WMI_SERVICE_THERM_THROT, and WCN3990 firmware differs between devices.
> Instead, remember that the running firmware did not answer, and return
> -EOPNOTSUPP right away on later reads. Forget it when the firmware
> starts, so that a restarted or updated firmware is asked again.
>
> The first read after each firmware start still takes 5 s when the
> firmware does not answer. Reads on firmware that answers are unchanged.
>
> This change was written with the help of an AI coding assistant; see
> the notes below.
>
> Fixes: e98199a8c27f ("ath10k: enable QCA6174/QCA9377 to read the chip tem=
perature")
> Signed-off-by: Filippo Falezza <effeffe99@gmail.com>
> ---
> Notes, not for the changelog:
>
> - Tool: Claude Opus 5.5 in Claude Code wrote the code and this changelog
>   during an interactive bring-up session for the Moto G 5G Plus. The
>   request was to fix `sensors` hanging on every run because of ath10k.
>   A first version disabled the read for all WCN3990 through a hw_params
>   flag; it was replaced by this one so that it does not assume all
>   WCN3990 firmware behaves the same, as Loic Poulain asked of another
>   WCN3990 firmware workaround ("ath10k: WCN3990 firmware workarounds for
>   WLAN.HL.3.2", March 2026).
> - Tested on: Moto G 5G Plus (SM7250, WCN3990, firmware
>   WLAN.HL.3.3.1-00694-QCAHLSWMTPLZ-1), linux-next next-20261021 plus
>   device support patches, with this patch in place of a local WCN3990
>   quirk. First read of temp1_input: 5065 ms, -ETIMEDOUT, one warning;
>   next reads: 8 ms, -EOPNOTSUPP; a full `sensors` run: 25 ms (5 s or
>   more before). After switching Wi-Fi off and on, which restarts the
>   firmware session, the first read waits 5 s again, then -EOPNOTSUPP.
> - Not tested: firmware that does answer the request (QCA6174, QCA9377,
>   other WCN3990 firmware); for them only reads after a timeout change.
>   Not run: sparse.
> - Build: W=3D1 for arm64, no warnings; checkpatch --strict clean.
>   Applies to ath-next (cd026e68f).
> ---
>  drivers/net/wireless/ath/ath10k/core.c    | 1 +
>  drivers/net/wireless/ath/ath10k/thermal.c | 9 ++++++++-
>  drivers/net/wireless/ath/ath10k/thermal.h | 2 ++
>  3 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireles=
s/ath/ath10k/core.c
> index 7c2939cbde5f..9467e4c3099a 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2985,6 +2985,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10=
k_firmware_mode mode,
>         clear_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
>
>         ar->running_fw =3D fw;
> +       ar->thermal.temperature_unanswered =3D false;
>
>         if (!test_bit(ATH10K_FW_FEATURE_NON_BMI,
>                       ar->running_fw->fw_file.fw_features)) {
> diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wire=
less/ath/ath10k/thermal.c
> index 9bb486f8e920..1079d552cff4 100644
> --- a/drivers/net/wireless/ath/ath10k/thermal.c
> +++ b/drivers/net/wireless/ath/ath10k/thermal.c
> @@ -75,6 +75,12 @@ static ssize_t ath10k_thermal_show_temp(struct device =
*dev,
>                 goto out;
>         }
>
> +       /* Don't stall every read on firmware that never answers */
> +       if (ar->thermal.temperature_unanswered) {
> +               ret =3D -EOPNOTSUPP;
> +               goto out;
> +       }
> +
>         reinit_completion(&ar->thermal.wmi_sync);
>         ret =3D ath10k_wmi_pdev_get_temperature(ar);
>         if (ret) {
> @@ -90,7 +96,8 @@ static ssize_t ath10k_thermal_show_temp(struct device *=
dev,
>         time_left =3D wait_for_completion_timeout(&ar->thermal.wmi_sync,
>                                                 ATH10K_THERMAL_SYNC_TIMEO=
UT_HZ);
>         if (!time_left) {
> -               ath10k_warn(ar, "failed to synchronize thermal read\n");
> +               ath10k_warn(ar, "failed to synchronize thermal read, not =
asking again until the firmware restarts\n");
> +               ar->thermal.temperature_unanswered =3D true;
>                 ret =3D -ETIMEDOUT;
>                 goto out;
>         }
> diff --git a/drivers/net/wireless/ath/ath10k/thermal.h b/drivers/net/wire=
less/ath/ath10k/thermal.h
> index 1f4de9fbf2b3..cb930da5c04a 100644
> --- a/drivers/net/wireless/ath/ath10k/thermal.h
> +++ b/drivers/net/wireless/ath/ath10k/thermal.h
> @@ -19,6 +19,8 @@ struct ath10k_thermal {
>         /* protected by conf_mutex */
>         u32 throttle_state;
>         u32 quiet_period;
> +       /* the running firmware did not answer a temperature request */
> +       bool temperature_unanswered;

Maybe just "bool broken;" or alternatively a new
ATH10K_FLAG_TEMP_BROKEN dev_flag.

>         /* temperature value in Celsius degree
>          * protected by data_lock
>          */
>
> ---
> base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
> change-id: 20261022-ath10k-temperature-22b119fd615c
>
> Best regards,
> --
> Filippo Falezza <effeffe99@gmail.com>
>
>
>
