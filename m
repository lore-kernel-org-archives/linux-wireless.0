Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25A44E0B6C
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 13:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791553940; cv=none; b=QgTqzA7JCWg5TVeESlwePP7nxyzI1X4pqNiz5K+a8dPV0M2A61hQ8PqQn1/N4WQs8GLUFkFFMKsiOsczdwLb0Y1TUtuLFqli3WacMu6dGPjnlMuYWDBpPMkeMqhgjP+Zhi7xqGTWYODAnc3xBsyJaLpVpyQ8BECIrdgH0QNHu9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791553940; c=relaxed/simple;
	bh=/4aQdUqTxbUPPFTWKc7dRMCzrpUJnRESuV+MuW7+6Eg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nZLV88AMH/sYWGnGkmiRNG4KZoK60+6RbVxHCC/PvioFvXksDoI4dZgdDXJ2TLdSwjDxDD9X8z06APLBoLHMlKy1nd2kLD0zFa4Dk936MYm8TtPtaJxY+Wkwl7ksUxq0XVeVKoQ3ttn6ShyWHIokoAsxbGlT6WUWxjs80JypGMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=d4f0SUa6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=C6kr2waw; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="d4f0SUa6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="C6kr2waw"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699DkqN41956622
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 13:52:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/Up2rgH8CAIB06bOScYSIXek5UO0Hsd5mpFy6P1dmcw=; b=d4f0SUa67VDm8xLo
	eeUij9xh6Z5WjWQed+CzeIz83AhKOSL9gdRoqK5N+gMO7iK8Cv8rPZ585TmKc0vp
	Bra0HfSyG1r0N782rnSMf6T4YnnLsNI6UK1Jm8Vm9XTTlwA4iLi+9zBgxtlp0Te+
	K1K0Pd8RXpZqbSIWNfbG2LXp/FSsw9iIGzJvXwZZcubUdfD/b7ClA93U5a/cSYXh
	OT95CNwSMvzTBOwIjdByxwgzDqPewudG3laZceV7lTUuV+2Cjh5E2oI02G1XVtLt
	1bRcWmukj8vauM4n7Hc8G9JqeaySZMM4r+vP51gxb4JzMk+9qVL/0xE22QzVviW3
	hYrnSw==
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h71f28157-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 13:52:17 +0000 (GMT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4f9b643ae53so4842563b6e.3
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 06:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791553937; x=1792158737; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/Up2rgH8CAIB06bOScYSIXek5UO0Hsd5mpFy6P1dmcw=;
        b=C6kr2waw/70kBhivAdZLthe7eI7qMTjrnSd1FE8GWBj3R3rR4xhNJAqir5b1sGBsPg
         4tKzGW7T5GSRvnTR9LP6T4pOG9KUj8Usm7GCzIvcX3v9i14A9f/+jx2iSeusfVg0fciF
         5FB5FkbE/L+d/9UNeIsC7893uSLjjftt9F+gviIr7utnqsUnONlOZsWvWmO+YO8eGuaa
         tIMWYunh5WGu2cN5hOT66AG7AxRyBaFOoK/ilvpK+BOfSpCCEDekk/QWhkZeF+vPhLmE
         4IdDqb4W7XSGDitHAVovd50WTvooR7XoMHcpU6i0vxe6tvUppRYfXaiZdsoR+4nn/fON
         EGiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791553937; x=1792158737;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Up2rgH8CAIB06bOScYSIXek5UO0Hsd5mpFy6P1dmcw=;
        b=pMVa3SGFyzhGc3Vn7bLNNNSkO+afZgKB/taqSVA/IArYM6c9GqPSB6uhmCuElHehe5
         dpUo4UoUZTztvSO6F7Y9rwdCeenzC0ISrhRbMIIK2Hjssgx8+uq9+mUP7IB/b128CLuF
         zFTnpTVNIz+r2jzmEZOe5olZTcK+Z3tUVHFJnHJsVkLYXq84QvU9uhN3e5oc4f0sMM+v
         wqBFTzTZ/k6DXOjht2dvYEGYFpuQZ/MppR0fLuZ2lyforO0/+WomiIgEnKbofRvQMQB0
         +cQ66x4eRnH7293QHJRe15BRqVJX6pUfayK4wzD2PRt+iWK076hQMPpmLPAFKGXmUJZK
         rJIA==
X-Gm-Message-State: AFuF++kKj8Tw8mAyJ4np1zDXmHkfUmPAoxcM/5u+30tCOeYYDMx4JoiP
	bl+2K58z4DvqzQD5xATfdt0Ggo8xOJmPPGzQHGYx0owuSlYc6iHIiP08IbTnE21nvUPGaUxROal
	F9PX5VbETtXev5/KD5r0qzgI8DuFAYB1T7ofACTtZQ+f9QMRAfPDsn2iVRgX7ikL7q7sBOqCycT
	OtfQ==
X-Gm-Gg: AYBFou0pitgZoe/ZjitlfRMUiQg6XDbk7xPRt9dlfFimGg17ruIDwLeg18alk2zyYwm
	euXCUfaH3MIknIm8loFms0wZ084B0I1rftqZNUwsS+RlDwRfBS+nF1oaqbVTih7K2n46HfvKk/U
	+CJGgz5cggFEv6ULiVHcuO7RfqyClwEY1XHIEQATIACLXij/ejqpgYNWChBatPB77qX/JwlGs+T
	WtBqJKdSMY2x6rGzzBteudtVUxQaLyJVHQVqbLTM56OpchhlK+buZOiWgHuQOju1ex0MQsWkwNi
	n433KW5OuZIo7n0I/zf95CJ5Ps7r04i6XVZrOkNnBEe08qqH8o62ZVBIFlsWV+i/4tc0G/by7dZ
	4q6/Da2rNTOW4m1DgyxHY+Ae21l/efw7u56+1vQ0WjD1tpSXFz76iVTE=
X-Received: by 2002:a05:6808:50a7:b0:4fb:8469:fc4f with SMTP id 5614622812f47-50c516e4756mr1948532b6e.29.1791553937114;
        Fri, 09 Oct 2026 06:52:17 -0700 (PDT)
X-Received: by 2002:a05:6808:50a7:b0:4fb:8469:fc4f with SMTP id 5614622812f47-50c516e4756mr1948512b6e.29.1791553936523;
        Fri, 09 Oct 2026 06:52:16 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-50c16755587sm1949024b6e.5.2026.10.09.06.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 06:52:15 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Cc: Johannes Berg <johannes.berg@intel.com>
In-Reply-To: <20261008165646.48866f0521af.I1c166be830384473f67677eeb187afa7e54106ea@changeid>
References: <20261008165646.48866f0521af.I1c166be830384473f67677eeb187afa7e54106ea@changeid>
Subject: Re: [PATCH ath-next] wifi: ath6kl: don't take RTNL in
 del_virtual_intf
Message-Id: <179155393521.875832.9977449792572425568.b4-ty@oss.qualcomm.com>
Date: Fri, 09 Oct 2026 06:52:15 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: 1sReDijZ6d7WXEWnwXrEhjDh6aIbCeMb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA1NSBTYWx0ZWRfX3+Z6e8hTkJZb
 wzaltOfoxg2gdqi/1qw5BWec1V01TYB1sZHBzRuPYImws6U36IHGo8wG8rF7SLqxUV8mXKS68C+
 NzTutke7w7TTEvMAv8Qb2dYvUDMltvJV4zaY6jOS6ICzKLPXsV8pfAw5suvGYw3Deaekh8s/osa
 kLg+LpNeXki1sy3CYZ+eSD40wIkwcpS90zM0wT8n9G6u8hv9zMSH34csGsk3KQA762cDpAAjOlL
 uu10nwjID4vKjJ5wiVd5YoJ7uch2//VRPFSG8u4myEYHnB/ydMOCq7lWi6wP6Db3K5fjd+RXkps
 UFWc6uo7h77acrzM5vGLMJwgBFX3Oq1r2wnU1sPegNk/qSxLuZY1OL4Yo1uBvAj1iYbtH8rMy/l
 QF4ywaLUXlTrGgoHgTNfYwIG9dPfpw8knSHqZqml7Q1/B7vc2qFDBbSuwM/ZBWWnao9Wq9Mat1L
 L+YY/99nvPzxyc56fLw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA1NSBTYWx0ZWRfX/XddxrUeQlyq
 9Vlut+ZrVpPZX0Bn4uR2OLvkoaC2j9yvEJW0e5XiZyDZcraFin9XPnAOMZbuglTQlYf9J1FNgSD
 XM95Y21lU28JzX7hZc36oxHdsEXQJ/g=
X-Authority-Analysis: v=2.4 cv=B8ksQ+tM c=1 sm=1 tr=0 ts=6ac8f191 cx=c_pps
 a=4ztaESFFfuz8Af0l9swBwA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=T1vggAMcaSG4uU9Bj8AA:9 a=QEXdDO2ut3YA:10
 a=TPnrazJqx2CeVZ-ItzZ-:22
X-Proofpoint-GUID: 1sReDijZ6d7WXEWnwXrEhjDh6aIbCeMb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_04,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090055


On Thu, 08 Oct 2026 16:56:45 +0200, Johannes Berg wrote:
> cfg80211 already holds the RTNL here, so this will
> just deadlock. Remove the extra RTNL acquisition.
> 
> Oddly enough this was all true even back when the
> locking here was added, so this is just a revert
> of a broken ~13 year old commit.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath6kl: don't take RTNL in del_virtual_intf
      commit: 97aab70a03df478ffefcf890ed4be258c0240bcb

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

