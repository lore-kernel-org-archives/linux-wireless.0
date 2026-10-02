Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A1C3D6CCA
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 19:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790968278; cv=none; b=gqis0MMaq1cbTUqVdIwk3PnRv7M7v/Eghctgcw/uRW3ZJ8VGMzoSUAMB9IastBFv5TE97vwyl+ikk2+2jbxB6TuADLbdtnsixMk2bGZEgJiVUJoPZhYh0tctjB8ehg5MqBrTIE2JMv6nCE/DCKS+fy0Q9NiE/ZJvCcPqcdWhCYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790968278; c=relaxed/simple;
	bh=vUNlVf7JESsv6d6O+/J73fzOkNK0chAaUef2GsfGc20=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=b35WTpUlkmKzQX5dEHldmkFF80ZLd5L2NkdpS4i6gskE7PQUhPaxUDwnCFcsrY+TV2jGlgApjBVlsrFsPSFToQUj7uAU7siHRkq4SlCdkZ+oWBEY6UifFpKGFWNYmenEyOMhJUXBvyHEs4eNCJ0Ovt3mULZMq2CSYYTmgYqBaFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZqWckFmv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VFnJA8Oh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZqWckFmv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VFnJA8Oh"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692H60J03057710
	for <linux-wireless@vger.kernel.org>; Fri, 2 Oct 2026 19:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=DCfqsaz7dzpRPunjkmDe3O
	ygx34GPQDXl5M7ZEAewsA=; b=ZqWckFmvNfcgHrh8nD3OpE+mpSmfm9BX2IeoH9
	4vQBBiU5JGSCUCiEMZmPyhw2rZgNQBwWNp1+U+31nri1FKYtsTG/dgUc+j+MPNdb
	vHGjK/vCvuGFcD01ofi1sj4WDeYuexsLuFA1ErScBO5ZXYGYGbsfGZWH4d5RP1Ea
	f5kjfEqTewY6HlpUOdgBD6yKw4GekZpwlOwBZgJNuFHcRBjkUPD2gJ5nHGacuIpP
	b273jTDRoCXyP0nUiAHYQF7Bp3KZC44YtwxrDxsQRIjjEXD1/K+tBUDk00wuLIGC
	sIFY9Ys3YIzDxPAE5HYpsjG1BbZzf6CD1tfgQU3NJZB6kMnQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h26bp30a5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 19:11:10 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-341eff9e381so12579675eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 12:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790968270; x=1791573070; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DCfqsaz7dzpRPunjkmDe3Oygx34GPQDXl5M7ZEAewsA=;
        b=VFnJA8OhSbDUoUEjdQ9FpHurTXnaWy8qJnPm9KfeIJcwrTG2+1g5k2d8Y4d5TIcIGy
         3Yn5jkzqLrHOaAgl43BCOhxLwaHGpQmQrYgJ54qdybpEH57Zc3WhsHEtTcyQKCFZqKet
         WcGkOoJUWvKltuutB2x+aaJWiFi8r3KnMOr8vy6ouY17d+bF5cTiyyXrMMys2ECX4YJp
         hxfFkugtqk5KGuGD0/BVFREodEjtk5sP+Ayja0L3v/p2e3VchgRDpK60/EhKPm7zLT9a
         47WwApF0/VMgJGhjhivKFpfbEV1+FkXFaDSWtoeToUzf73Gm4owTClnbumlB60CkeyBC
         /vpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790968270; x=1791573070;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DCfqsaz7dzpRPunjkmDe3Oygx34GPQDXl5M7ZEAewsA=;
        b=Wo/oHWffBCbxIr4rRioA1q+5e+ZP5Zp3niWuHoRPkdszvMh9n3dB55epPpiYL/dxOf
         Tgv1Lhi33GMEmEwlwczG1aUV7v0oH6Q2ZwOO4VhEp8pO+2hbMqcMsi3l/RZ19U5QBnPi
         +EZczM98TFPmhu8IOiUgl3m6EyV4hGlFPti+rpiWpCANVjeIXVH+Sw40oKElR9Jgph6y
         dRvnUYAuU6XeLhDG2a4eSSNzDo4uoi7l3+TF2Tbmvjafvgln+tRcAbje305wPjNqxAxE
         zWfYsCaWYfmR/tEF+MzKa9EIOlxbPkmWhkc0N7SYwQCz6R26W7juyck4JZ/DpBG4Iw2d
         WhZA==
X-Gm-Message-State: AFq9FYJJe2TVB6eVq0vEqjsQqno/NSCytplN7Ed3yK+D/D53f0QI3jWu
	XmHq+e1VBg5ZIEq7fXUEwjyIJmRgQ9USbRoruI5F6x3+NDnJyEPPG+rPDLJgFd0L+cOKeO/mrKO
	Yt/8szlJT2AOoxipX/IvGH/TFPg0Dggj2k5NhxpXoRpQJ5xEpwXqOMl5elEVeoAv9LBwKcg==
X-Gm-Gg: AYBFou3gF06pgLQC7hzqpN5629Xx+U5tT95TNsee/K0Ch/Y94/wty4AYbSPDem8hXna
	zFpatS6keQWtr8pgperDoq8kV2GODkO4tNiJZ8/NMRX189sYZB72IOvZWvydXqg7ZlA8mgUzyyv
	1OMHkQMZwNcaomKJXhvfQ8Y30oNcJtCMjVBU+IeC8emevnVs1zJrdesOn+dS/5Ma3kRzYIfqpAl
	EflWUXd0E8fh1RMq3n3eIluiluVEXnalu7OOURL+5wxj3reg8I0bc0/UE3VC4KYdJ7wFWaMvXDy
	q6oFJ82ICYX55Hek59cpJJYWCx16HVrIU9FsM//ENKgQMkGgsiCu9akjpzc7El6d46CKkine6DE
	kgVRV8QCEP6JMCcJX1n3gJcGMxcZAcZyxuLecEX2708h+JR8HS+E2SNg=
X-Received: by 2002:a05:693c:41d0:10b0:34c:5de7:6a96 with SMTP id 5a478bee46e88-34f21994aa6mr3924771eec.35.1790968270044;
        Fri, 02 Oct 2026 12:11:10 -0700 (PDT)
X-Received: by 2002:a05:693c:41d0:10b0:34c:5de7:6a96 with SMTP id 5a478bee46e88-34f21994aa6mr3924742eec.35.1790968269428;
        Fri, 02 Oct 2026 12:11:09 -0700 (PDT)
Received: from alokad-linux.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35105dd1dfasm5263296eec.8.2026.10.02.12.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 12:11:08 -0700 (PDT)
From: Aloka Dixit <aloka.dixit@oss.qualcomm.com>
Subject: [PATCH wireless-next 0/2] wifi: mac80211: fix CSA/CCA regression
Date: Fri, 02 Oct 2026 12:10:55 -0700
Message-Id: <20261002-csa_cca_fix-v1-0-b83a998aeb44@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAL8BwGoC/yWM0QqCQBBFf0XmuYV1Fwz8lQjZxmuOyBY7WoL47
 031eM7lnp0URaDUVjsVvETlkQ3qU0U8pnyHk96Ygg9N7X1wrKljTt0gmwPHGPuzeXiyx7PA9K9
 2obcUzFB1GdtC1/+s620CL98iHccHkhLJZn4AAAA=
X-Change-ID: 20261002-csa_cca_fix-ec333d7100e0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aloka Dixit <aloka.dixit@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=OMqyTiaB c=1 sm=1 tr=0 ts=6ac001ce cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=0AfnAU6H5NbzKUBkI2AA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: 8UecTeSupXHN1ubzBee0oYu6VADX2qCO
X-Proofpoint-ORIG-GUID: 8UecTeSupXHN1ubzBee0oYu6VADX2qCO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA3NiBTYWx0ZWRfX87H9GWKK1zEE
 avtiLSJcEr5EB6EFjZiH7GEFNel0UUuqImlDWojhuPBEfE0abhkqRUsTk2f0yOUYIE+9kxlza62
 LoapTacd0mmUo2a5s478sWd2AtBoIZM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA3NiBTYWx0ZWRfX8JwNnWUMBf6y
 q0ap3crd5OaahSs2AnJB4zKBW8casy6ySJaHGxhMZ9dDrTnQY6P/sFWlbmItleZnlreBfDBcYEj
 nIZ7LTee0O/JBAo83hsUKI8JMcTqR0GX5fv30Db1U2vrIBYoavEmmHkdLFKdkx2M+GUmMsjf8L5
 mAzPotJtDKgoTG/P1HODWuFYKfWREqVHjjE4XP2ODnv99jVMe3bOcJ4kC/Y75WFRlNJ8yQTr84U
 t8PloCJPspEqrPW0IMByJHfYcbdniEGFmqRxN/GyWPp/ACQyn6RoK+bQed1MzpfXgSftxvN0Zoi
 OXgQ/qSsGi+GJDgMy5hAMQyI8tl0j6VKk4aZl96njn71JgbmhuSlLZbilTXrXgLNZaLZPD1xQXY
 0PMCKeFINmTCCYDIZhccRIc4K/HQ0eyIYih702mJRK8h0edpQ5dj5wKfE/74bBoczdLkxIQ+xpv
 oHjxP8YjPeSP5JycDNg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_05,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 bulkscore=0 clxscore=1011 priorityscore=1501 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610020076

First patch reverts an old commit with detailed description.
Second patch removes a minor redundant check.

Signed-off-by: Aloka Dixit <aloka.dixit@oss.qualcomm.com>
---
Aloka Dixit (2):
      Revert "wifi: mac80211: do not use old MBSSID elements"
      wifi: mac80211: remove redundant null check in ieee80211_assign_beacon()

 net/mac80211/cfg.c | 10 ++++++++++
 1 file changed, 10 insertions(+)
---
base-commit: f49defea7668d8c68ec19fa085ef3da6075561c7
change-id: 20261002-csa_cca_fix-ec333d7100e0

Best regards,
--  
Aloka Dixit <aloka.dixit@oss.qualcomm.com>

