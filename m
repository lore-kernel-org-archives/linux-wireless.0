Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDA0599A36
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788887454; cv=none; b=U9sZR4AktlquPnttjqvBFBuSbi2Tt9DYUt1UBnXgjHzKYh+Y2chH+TcVnIGJsJuyY9Vgzz4DLigyKX9Rfbx6JqCmHU9+wlVqNIDQN8SaKfkLid6xcER+l1J1XYAR35Wa97ir/RFtxY1R8Fz2Q+XDLY8NYXMIoaxXpj6RM1woiLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788887454; c=relaxed/simple;
	bh=slxYMd9pIzQAMKVqHjrMfdvbnPLm31GqOFhQsu0FO7Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oq7+kmQw371IyF4ckGD7CQc+arn6lON5aaD9VPJS4GkaMoKcc5W+qHWJUO1BQTuuOrdSD4m1x6U/vCVKziZebK/kPBW2Zo2+PTNa/3p72wgy6bx9VIRQ+6Vcrq+HymAzorHO5TDfFPjG9iMK8wu3rThGIfFpjvYtgya0dGJEwxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CSY/M17b; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gXHor+E4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CSY/M17b";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gXHor+E4"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688GLujW3502151
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 17:10:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gYoBNxGLCxDZv4uAHMCNobIrbYmFXndZnMWIP9T37jE=; b=CSY/M17ba+6JAN7m
	qx3NtfOgCpD8hcuGCh/RO5fAabZDu9yP5NBAirlQ/4b26HSYwAgEy/+EsHgYyIXC
	f15jtG7LPIbMXrWdb2xScDbC5k+Fz1ziskjIyapnTdZbemz05lXbnvO8pZeuP0fe
	GpaV1VSy10hT8iL6btIMcHiKClqpg3p5NwDhjuOKukvLh6I858kM7B/nxBy7smRb
	9OsW/A3Tqx5knVYpFIabbVEsl93EJLHXgtuuHh0hs7iUOqegKXfXHolr9M3Ixlf+
	PSD0WdwKUT36xjPTDuw0zE041/cT2ByCXZ4ktlDy86eQkwJhBi1NRrjuXeFS6vdI
	5palaw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjntpg8t7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 17:10:50 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbe77d6864dso6987747a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 10:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788887450; x=1789492250; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gYoBNxGLCxDZv4uAHMCNobIrbYmFXndZnMWIP9T37jE=;
        b=gXHor+E4Iw8U37yF05rTH9bWGprzM47aWxpLIxYRDVA51BWfhN3DEe1Lkc1YeSw2aj
         fkaMSxmiRlVMrksfv5w5vGp0BJaLMoLFalJn5IG4ZXOeI1SQwphyPzxrSZdnmckXdui2
         30PPRuzk37vqDjIDDva8W2Z/vKc+a54AJGXGkncUdbNy+QDSJj7AKCqdqWEQ5aM6LBr1
         icIlV0bX6qfcfahxJGRqDE1GWx9lsCwvGEEdvLRgo5mecEeFyGR/T9HiF7KncWidFQi5
         0U9qo8fQkVqU4n76h7gNW4NH3F14Ezb41K5555DAechdt1kxi4OVMXRT9IZG4gm9hAHH
         Wj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887450; x=1789492250;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gYoBNxGLCxDZv4uAHMCNobIrbYmFXndZnMWIP9T37jE=;
        b=cA6pLP/D8StxYQEXIxoIBOfSZm9+nfPQ+GyQIVKeO7WXaz16lxvyqFrN8Z8NNoukUI
         sNsCxMT/m0hyubqNnNfr+umGid7hzMqVL6x0Ndsk4fkelc8wsTaQo3bt93RJ0mVLX9B4
         ZCaJE06WkJRdZAw6q5k6GwMIu1n/VNdD+iBZpRBT5zB6R8UjHymO+ZUYvxH2AE39t9JG
         b8ocFh9d2ibQ7qTlE1YYTDChggMb0W6BZu9lczP0Qs/8oq4mQq8flaEmB+Ne8sQtfNeD
         TBjJXQ9DveTJeNRWYktBYutuKA4siyoFlM1XuDw8yvwH6HwER4uArlvl4jwyUxmcKIwP
         3NHg==
X-Forwarded-Encrypted: i=1; AKwUvByRIYUm7eToFSBxX1rPAh+8tWpqjRqDZwzlPvxaS0nRij+VLzPak/0cKn6iFlbDW0daLBJVUvfeZ4lmqH0hlw==@vger.kernel.org
X-Gm-Message-State: AFuF++m4DMDMu8r4VQtJWxtYF28uXR43XUZmjIXiyANDHeIDin09gVHR
	qIiUTvVA05MHiAc82sEDU4HRr3tropduUPJVm2JpMNJVmy+EcagPfbMiDEPsPjA4jo/g47zEBBh
	rM9CZyLh1nOhqSvrDsT62Bg98a2Cb1dwQHyBQl5VJ2blO0PfaLfmJX6vpHNeiEF6SLIrs
X-Gm-Gg: AYBFou1uJ0t9EApLlK0LbTlJureA60Z1XQdH9h/7iE3dbbWQDXU/59NvL4i5VKfeSRc
	KNGaPrfi6OhR+Ek90lJeabGRX3psdZvOgk9/zJdLUUb53IU3pe/v25+AIBQ/niLWCRrqQ63L6pu
	FAmuBCmcfeXa5pTfzfYiyuH7Tna+eXrYgkYpyyf3selPmejfrMm4jdPNTQgJREOGzrvp0S4pMav
	041tTHGYO8FTZl9qR6OdgInwwXsGu97zGomwJxWDzNA98/dRqLDay3+M4xXDtRlVqdfgRihSnaq
	eupe5sZkjCE0t7uQKenpri5sI0Yz4j/rJC0hdE7foSSS9hJvWCP/d910hJY2IHyDBGPcayo6Be6
	J46VD5CWWB6Zv8rilW+oBKzQXM4jIzyUP3/DdJW/XrWL14AvfUnxwZyaFLETGJLNUTSwbqOouqr
	UT89aRkTiPU0qoIHArIBQm+Q==
X-Received: by 2002:a05:6a20:7343:b0:3c3:88a5:83e4 with SMTP id adf61e73a8af0-3da39ee2718mr43902283637.10.1788887449963;
        Tue, 08 Sep 2026 10:10:49 -0700 (PDT)
X-Received: by 2002:a05:6a20:7343:b0:3c3:88a5:83e4 with SMTP id adf61e73a8af0-3da39ee2718mr43902199637.10.1788887449336;
        Tue, 08 Sep 2026 10:10:49 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm31773675eec.4.2026.09.08.10.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:10:48 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
To: "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: [PATCH RESEND wireless-next 11/18] wifi: mac80211: Enable skb extensions along with mac80211
Date: Tue,  8 Sep 2026 22:39:39 +0530
Message-Id: <20260908-smd-v1-11-9fd2d876a1fb@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.3
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX7GwTAj8UE3lR
 YlWv32fbMjnZlohR9pKJrm1WsE8Fg8kdhQ36nth83wLm4Wrnje1T+aRtYA56MEURDUa8zKQ6A13
 AxPAssXFDDTdhvcGdU2lsgfc+y5zStG549dVY7AChmmes5MmzgOqkVDz2/IBieCxn5jYjlqkk28
 L1mTovvv2RYF8/nOIPEkcZz91zoNlZpBrkwgzziPTLNpAI8TdMzBgHtZkHlu1EGPeFBx0fDgtCy
 bY8oylKmUUlbSlQLr1Yz30xGKIqe+zQNxaLB1yjNo77CFC4rogx1GSRqN2KqCaHKbHU6ze8E+j8
 8L08MWyhiyKgRez4JwQ7+odITRJ9pfxmf/8IHkvN9v0KAuu6gikTDCuJHSIxiWnzbdtF+PC0PGu
 dsQy8IoOvXdZ9LRHFHzyztG2mK3ZtRwJ/etUkwwcUZDobNa8VGg6QtOxznqTvRNcDbDs6GF455/
 gXgMOHAXKAFeIOUS5nw==
X-Authority-Analysis: v=2.4 cv=N+AZ0W9B c=1 sm=1 tr=0 ts=6aa0419a cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=iJey_kD_w1PlP-9owF4A:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: OMNYKeiAoo2IKzVSyb6HBWnArW74mJWT
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX7LAU0ERZtp06
 1JnG+9CEeG4EouA0XAXvs9P22WzTtnCwge//a2miCoFCV4ygZDExjx6E1OcrqKaEkYbW+1pW1SN
 RUHokl7imOneeN4rj6DgKvwWLR1ZXnI=
X-Proofpoint-GUID: OMNYKeiAoo2IKzVSyb6HBWnArW74mJWT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080185

When mac80211 module is selected in build configs, enable SKB_EXTENSIONS
as a dependency since mac80211 has started using SKB extensions with SMD
as its first user.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 net/mac80211/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index d6bc295e23a1..10d28985a1ce 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -9,6 +9,7 @@ config MAC80211
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select CRC32
+	select SKB_EXTENSIONS
 	help
 	  This option enables the hardware independent IEEE 802.11
 	  networking stack.

-- 
2.34.1

