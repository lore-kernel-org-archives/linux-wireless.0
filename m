Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8EA429CE2
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300778; cv=none; b=ltCLIL62qmWvdsvlDw/OsvHeeRtUCmxqoM7UyBUEOp6Qm/lXyCMSFp3WlDHJEC6D9hDoLTN5qnaxEChJiUDx1zkWv6Yf/p7EDhrInzByqgpGHhzpBkKxQh/uG7hDOhl2Dx2hf7El6qoM6KP/bR3GJxBIMWcvvtBcTOR1CFd72qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300778; c=relaxed/simple;
	bh=41pPYpNMq1guBEtWi2cH/wIXg0zV4SasR1cW353pquQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=eNwBqRPTpNE/O+/gNeNuci8oO4mBNWbXgzZDaPJOox5W10k2/k1McomfCOUM0EtaVH/JzVZtGk6y3cIIhw0LSettPqr3STrV30MeaDCqwPfs7WJbfQmORv8e8vlmzBCBD2AoCOkTRoFD3ttkVrJbOpBO4OAGxYU0dmbNpbW0OXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZGW7rUhl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=epbzjwsq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZGW7rUhl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="epbzjwsq"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7vA42106293
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aQl6l7pG3b+DF7EKLvG7yjwGoRThbyKB6bcHpVUCz14=; b=ZGW7rUhlRFZkgS0G
	iW6xuknN2PMM2w6h72kgnK9CYX/KtwEkNrYOX4YLlVkDseZOJ9c3OppMiOd4gdze
	i4hfTK6xNuR9cRF9d7TZFBwptUere6dmp+Ah2JLniNgU/wgABo0OJDLtC6qxZY98
	Y1/OV5AQSXjocm5M4oxwP4PedIdhnSMqsd0ZTJWgCphUlIl/NRYJMNh1a3X8fBvs
	TzDjPMVjhv//YNDUI8fdlkwohzqYJRhbbMCpL4tH9QSk0mZdNOHXWBBHXkun0rFc
	yPEPoH++5H7kVfP7JJbO4TJsvr6uekdu/4g9RmsD8316+59XwEw7fcaQ3GJVxcNG
	e2OnjQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffhpfha03-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:15 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c89704da8c7so11457757a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 08:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784300774; x=1784905574; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aQl6l7pG3b+DF7EKLvG7yjwGoRThbyKB6bcHpVUCz14=;
        b=epbzjwsqCKBEJ1AE+vamy+SIyKA6BUbqgJQcZGyl7HysM1DU8EM7jo1bIrlVjWVVSy
         62VFClyLyzrxcYwxxZ/NOokbNCc9Q20L0vKFwjoZfIGkg9MkAKhOZbtt6822htBpgf7o
         Nq2ODi6BqFDG2dGGdsyDAibp0LsCvMl/H8XWATaJqVFwzCLIhervEAGUOBewpHkRJ3xg
         gWbCUsRjwCuxftFmpy5WUUrDWJs7d5kxSlkTJuEzKlKqLu/od3Xg9VkMiJJCQQnANOQ6
         9FqD+n63hDeHD/GJayb1NpPMohMG5Tfx9qIb+GP39I5v2UBWG//osPdlHJPmVtLEjPKq
         Eqrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784300774; x=1784905574;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aQl6l7pG3b+DF7EKLvG7yjwGoRThbyKB6bcHpVUCz14=;
        b=WlpxOEa0amYxvlMpomLA0NRb2Hlr76tphqDVAT2v/T6eTosWj1139+sQpKA6tDjIsX
         CREy9IIi/jvB5hMePcmYBpouWGHfOm0mBSWL+P/XKQXh/medyVjCf8qNsW7FAJwiuqjn
         Cnytkaihuqj8R2hoAAXJyzoTVcHzjjvXrcrFrAGehcevkdB5BXhLhS5ZICvd8EBd+KVu
         hwIfEyMia7XvfSpcU2aV5LGI+xlshSBmA0eoemTB+iyAQv5ggZ0eR6yZPCdih3mzG9Xk
         wmswlEI//qw4W2AL4akZXTe12LHyk6TP1lfpmcAzSUiGtQw92qilnr6G8/PEUDBRvl4k
         +EMw==
X-Gm-Message-State: AOJu0YzC6k4HBbvLOcEtHZkrTSQFlC5UAGmkTB2SCfNxoCwiObz8H1iT
	QHByxRRYzVcb+Bs/mIMv8N3ukeGIOveVXWpPjddFA+KiBEYM1nVbKARcDaJQYhrwrhvg6bSJAAH
	2hVDaViwkoLPdpJMkSYZZpXoTI05hhSU811/dQXWN0pVyDryTRHxW1gupfI2mQuGvi3i0nkKUhw
	gxAA==
X-Gm-Gg: AfdE7cmKWiZ3mnHAYnLYL7MRiT1SFlU0/TaKL7bUC5i25brlp8JYhXPgSM/MHyUekCn
	iVBxDJ8fzvJQwKk5a1tk/m/0eHR8o/Byw+RgvF959qTAbCfi7l7WfPvRhPSFr8pPu2adRZ6JwaN
	7kggD3VodxitGCKVxmDfEvL18nRkK+qT4RHiThSUSJG4OdyAnQv616AuJ0NxxR6J5MsxRkyTgQx
	d/NCdGXIdjviFVNbCbMBZ+fIEsjNYENe8j5tso5/8SK3R18+298UWzVGVnNvudzZTXPFAc2XeDt
	fuJaD8dM+tMJdII06ntYaASprbejr4J52qKA0gPPbyfWndRfj3aQIJMe/yu4J189VAjG2tkI7tB
	MnMSdiDvSzni8CXi00OT96jpm8nPy7m9WJ2RedDfPlc37M2zAwW80s6s=
X-Received: by 2002:a17:90b:1f8d:b0:387:e0cb:c8dc with SMTP id 98e67ed59e1d1-38e4b578636mr3360403a91.37.1784300774362;
        Fri, 17 Jul 2026 08:06:14 -0700 (PDT)
X-Received: by 2002:a17:90b:1f8d:b0:387:e0cb:c8dc with SMTP id 98e67ed59e1d1-38e4b578636mr3360364a91.37.1784300773904;
        Fri, 17 Jul 2026 08:06:13 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm15681190eec.21.2026.07.17.08.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:06:13 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
        Masi Osmani <mas-i@hotmail.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AM7PPF5613FA0B6FDA6759CDCBE2421A8039441A@AM7PPF5613FA0B6.EURP251.PROD.OUTLOOK.COM>
References: <20260317110634.70347-1-mas-i@hotmail.de>
 <AM7PPF5613FA0B6FDA6759CDCBE2421A8039441A@AM7PPF5613FA0B6.EURP251.PROD.OUTLOOK.COM>
Subject: Re: (subset) [PATCH 14/16] carl9170: main: guard op_config and
 bss_info_changed against non-STARTED state
Message-Id: <178430077307.128359.18324883630059747987.b4-ty@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 08:06:13 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX37A/uSJLMtww
 ZIBUQGjH9+/4IkAA0tacSzaqWNLgZHLPTDPma9LjOPYQ8rl9IJ1JRjQHDH+rZwOb7+slrOOCEpV
 em4ANrQFViTc0y1bkhOIRDf8r3L2EqP+gw5LGZKhVz858RJ1NtLspextK/Oa/jXjE1WzectY2G4
 g8V6kCRanbbMMscgd37f/Yf1fNRZZd7Pt4mRWUjPSKm5Qi6KAXlXq2Xx8sxC/3p4fQVVE430QGs
 YgHqbpsnii4X2XoSxZxjtIPaBGGUZ6n57LxrghtCli+PO3wC6TFtYh0ET+47Oh/YiMKvssBNcfh
 dPTYkfRBq+C9y8ZwjlPdT5xNsDcsV7U0WW3FrnmHDOA8dfdA7QuR2ud8bRBmTRxBKlF85qdy28F
 +D7XF2C7yCM0Xj+ZTszAeFlfyGsEaKHrR9H1XQEjN7QTX4B2aQmUWQogRPbQWxjdTq4D7ohWS+G
 ao1bCE1FRp7uoQz4z/Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX4FpqBbjjr8YB
 xNYY2e6HE6O4B05KC+ZGQjDdM2U0Q3sKJsUox451umx2bOOVEyv70L74PAyFTPJMHG+gLLqtWZi
 txhkdpqifj9iJPfHWg9bx6Mzu9ONvMo=
X-Authority-Analysis: v=2.4 cv=YeWNIQRf c=1 sm=1 tr=0 ts=6a5a44e7 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=ffBYn40cunaxdwEkmGUA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: ANCOsticRZf2aw5TqaQnT3J5XdEyVXAn
X-Proofpoint-ORIG-GUID: ANCOsticRZf2aw5TqaQnT3J5XdEyVXAn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170154


On Tue, 17 Mar 2026 12:06:32 +0100, Masi Osmani wrote:
> During driver deregistration (USB unbind or restart), mac80211 calls
> carl9170_op_config() and carl9170_op_bss_info_changed() which write
> hardware registers such as AR9170_MAC_REG_SLOT_TIME (0x1c36f0) via
> carl9170_set_slot_time().  At this point the firmware is already dead:
> carl9170_restart() has transitioned the state machine from STARTED to
> IDLE, and IS_ACCEPTING_CMD() returns true for IDLE (state >= IDLE),
> so the USB command is attempted but times out with -EIO:
> 
> [...]

Applied, thanks!

[16/16] carl9170: cmd: downgrade transient register I/O errors to wiphy_dbg
        commit: 14941957d2825f62228a7db1fa6dc9cfba9fca60

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

