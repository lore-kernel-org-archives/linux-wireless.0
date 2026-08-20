Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA1437AA7D
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 17:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247648; cv=none; b=F79wtNIari8EwFfT0RbUIYugJYwneNVTsIqV8AvQKwk7uZw6bEVQkiip57uo1lxQYS/dUM0ru/H2huiG4vGx4XuqvuIJZcMgVnhlh4AJWM0jHK1oROUa38nnYTc4Fy6NeRdkj7E91Gw6lvn+6r9Kg4RFpISA6icGeqdNs9FdBWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247648; c=relaxed/simple;
	bh=eyvVMNnSHQRd17KJq3rwbV9DOJ8cp9AOfAXyWtz2edo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X7bK632vQ2hw/BUaVkMeN3BbaI1xFLjeu/UjyTbxyM8loaDNqE1FIJBDIhsiKCzAjZJX/2MgWz4CEEYVsmnREhrWbq6EwGCrUmuFVdxLeeY3LzCQY5GZisFs4BQX+c2mm9LxAM2DtqTyzmh+NY/C0F0UIBJ/C02Qqf1QGlivsXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CJZ22GQZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J+a7+mUD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CJZ22GQZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J+a7+mUD"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67KG6wwa281871
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 17:40:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eyvVMNnSHQRd17KJq3rwbV9DOJ8cp9AOfAXyWtz2edo=; b=CJZ22GQZPhA2HOxv
	SSIjYKrOwKpLDnbPjkmy1agfxPk2AvUyJTmi0uYYE1vVbUIlq69+QQ84xZYNwAOR
	25gqXnymDAV4iAKrfeFsvu8Qplds9at0xjgWdooDJyyuqcZ4vsbZjkxP34l/sz0G
	AZL8pmKwkodHkI1c3mTr/s2z//jNCz7KxfN3OnWK//q35bgNE548PXvZqwNFhA8z
	LgoRwo/fbucHtNszvR+iYI78mPs5kw03u2JCI6OW87S4D4l4cUBjGIHeDiOY5Q3a
	ZskUsHIttP1TczLuqPsKKTYCaUJLErxTNKvnqA+KRBNIdFMqMeNMZkTrgTv35vYQ
	mQdSBQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5xgcabg4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 17:40:45 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbee57593baso74167a12.3
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 10:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787247645; x=1787852445; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eyvVMNnSHQRd17KJq3rwbV9DOJ8cp9AOfAXyWtz2edo=;
        b=J+a7+mUDEoIGK9DqPHuDRgatW+nNPGkGDkoPSFCFBIm8hoT+PH22Z6czbFR3k4A7Ka
         XcxfiES9GigXmVHQEvGsspU4dDQdFqaol7WbImZ85y3eGkjV7SG0VRsmTA7W/CChR3hY
         Il5TwiWrMNVIWHECYuoJ8FDmytC7jG/9su7+wXBJWyJmawls9hMyqBbyaaDQ9yLVbKUA
         RWQKwQWYFTHJMSLy+BFusW/Ai2kw7LPCAwLq38ym6F+uH3lh2qzyQKyET8PFVLt9AH0m
         zNDu4r/uyr4J2I3fXAInKLnul19H59hRhlT5ZGr+CUtp0Lr3redbATD4mG/FS+vBn1Uw
         +tRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787247645; x=1787852445;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eyvVMNnSHQRd17KJq3rwbV9DOJ8cp9AOfAXyWtz2edo=;
        b=IC5YlqfFFYAPSQW4ReIpzqIwZYPxx6jErr9xxKIgtGT7gXBpA05FqsG6R9HLQs+aOe
         7hLhSd6Tk/6k9MCJUyHFcEB1F7cg6TaSYZxOEkVyJS0YAIIOSZezcOcifb+iamXVUocM
         lX3XAsJV01yL60Clli6p3namTiFjNTrLYpRlE5PKUngCeRbE/ndRI2AryL36FlcpYphw
         3FPlpliHnv5DVVIRXq/MKWBruNLImyJOk9EKFonpO/kwjKCa1honsSbt/KnI97jVgu1o
         PSsptMbCF+Ho9zisPkVOAHb+89yu1kX9ZE0Zr+vWSYPS7xOGkabYpYcDhzAWL9gEufXl
         +oQQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrh79sOa5mVQ2iYByyWiFWpQEv9RZx2eicWc92TUSK5CG6Xi+BDEZTpH9rkuMMmAzyWDX0Xm3WFuRV8o0qIxw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxH7aF9bNXqQsxKrEgUvVmlOFwnl6Kx0G8QQbqikF09UxTzMhiJ
	JmUUYH7xN96fzceoxpB0ideNUtXgdjXw2ym4CGlZYgnMLrQRppVzKPYSLo1/vZm8QPaMsW8hJVl
	GdV20w4FaWmmEnxGNKvwmCzQy2ss4QIB9HdqCStaMgU6KWOiOatSVS/uR0LDKUMw1fDWiVg==
X-Gm-Gg: AR+sD13Y1dBBsavU94SKCSTG1t9doROVzbzPn5aUbmU4lPEbWZ3+SuPA5H9RFxkRrEw
	JJCFnmsSAyGjOavfHYe5nx0s4igXVAQllB2WhuO3bTryzPNDuV+pcIqoxpOYt+h5f7AFHOprNBr
	b6mBT0t6TcE8TZlxyk7GhCmRMf30vE3m70SR3cMTId6AzdmurjkH7dZz+SV5OyTXbn+MCHCHLN+
	8VT+pM1cC2WhQcJgNPGRAe8hEk1wE++9JrvdujRch1aVfmSOgqfZpfbmAeOJk6qjqc5gvhtrrd0
	S9TypCD6QyaMZ4YEgR+TXazIvGUBTOwCMjW+irjRjjnQ05cVaJkec54el0fJ0teak+Ny8eqjI1c
	fGQ9PLjHV1UigEwQp+gWhWNn+wnGqAGff/A4JLYxS3akP2tuHdr8/5e8=
X-Received: by 2002:a05:6a21:918a:b0:3cc:841d:bb26 with SMTP id adf61e73a8af0-3cd301379e2mr97390637.15.1787247645260;
        Thu, 20 Aug 2026 10:40:45 -0700 (PDT)
X-Received: by 2002:a05:6a21:918a:b0:3cc:841d:bb26 with SMTP id adf61e73a8af0-3cd301379e2mr97301637.15.1787247644794;
        Thu, 20 Aug 2026 10:40:44 -0700 (PDT)
Received: from [192.168.1.20] (163.sub-97-215-3.myvzw.com. [97.215.3.163])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327c3fc6675sm26861387eec.13.2026.08.20.10.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 10:40:44 -0700 (PDT)
Message-ID: <80f99583-eed0-40bd-856b-56cbad973912@oss.qualcomm.com>
Date: Thu, 20 Aug 2026 10:40:42 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v3 8/8] uwifi: mac80211: pass error station
 if non-STA transmit was requested
To: Benjamin Berg <benjamin@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes@sipsolutions.net>, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, Benjamin Berg <benjamin.berg@intel.com>
References: <20260819135703.4072215-10-benjamin@sipsolutions.net>
 <20260819155703.64912484c2ba.I5ffe7bc0d4ccefca5c1e506d5d3d482e13989cda@changeid>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260819155703.64912484c2ba.I5ffe7bc0d4ccefca5c1e506d5d3d482e13989cda@changeid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=GPM41ONK c=1 sm=1 tr=0 ts=6a873c1e cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=7QqFuFOOHQR3GLhHC5mhXA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=mPF9hNEBIKWWczyiqVwA:9 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: 6aMkwUsWapmJz_jW4eUN0ed-FbTw05tW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDEzMiBTYWx0ZWRfX9RlbjPzptNJe
 P35y+5c49HDPm8F8URdzD8zGf7zCKUjgksOM4mydA9hpvfhECkoXOwKbcOGjnD9N6ps+QEq5pNq
 bBK+omKweDLDivPPakx7S/vIxTcGIAjDO+pcmhzibBxQkFh99xzJ/Qm8ayfZDSlPwOb7X+H8fNU
 Iwi4+uA4UaAS/RJfjL1tKBepo43WyPdRSrNlHPuc//NrfOi4vOesLpn9b1k+7LwQJrNheX0kXuX
 4IQsLRPmGmw4Lvsa/GFQG8INeF0cuyd/xa4t8lB1Zra46WQdYXczdgzj4kLSJlipxIYInnvOKUW
 MZ4sOCO27FbYKBndLQ0ltwUQPKeyjKM2Sxgh5qH01E1nisKE2b5bzOEo3y/E6I7mlSkP3qFA6F3
 mEAIBs413PGE9ZT9VqK+aim5Vr0OD5ZmXZvxCbEi+kZk/ulHc9SheJ4z96P2RumrsmG5mWTbeJt
 UqeNyX8P/8HgikiHDJw==
X-Proofpoint-GUID: 6aMkwUsWapmJz_jW4eUN0ed-FbTw05tW
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDEzMiBTYWx0ZWRfX9N6xdiI6PaH+
 FUdzBxdQI4rHOtf5x5tJZ7kB1mZil/bSW61/D7PkIE7UH7Bt36j/qBtZjYaKi3Ef/lob2HNWGg0
 uYwT6Sg/0tLbKVyif978plDFJDb6wWQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-20_01,2026-08-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200132

subject nit: s/uwifi:/wifi:/
