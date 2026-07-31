Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDABE3B583A
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785519409; cv=none; b=tibuAJR2JcX8aiqKiINzI0fAQBB40O5d3Ot/t56XbXgqnpSn5BPsneANQDJ6BzINiNw8tBQwZ0OJnztkgR1fliUiZJ2pHsDmoloM8Ta2IaQcrDhUYshr1/pvZhXvVSqmqsDZapzPaZU1D6rzgsAedlVuKPeAsocbGTlrYjh7co8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785519409; c=relaxed/simple;
	bh=5rMAalagN56/weROSlL6wJbFGqOBGeThRNRcu4xHlZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XvZZnJO4zlF05I7dAHIw/biG3L7gQqWcHLWqNTd3I6RZJXDEfLAD7hHk7r5jNTqOzh+r/fskPEdrzTrC7oAM0x6l/uAXV3YhfFk7Lso3QIY1AU29Bn9+IBUaqcVa3rVkyuXD9RojvOqOyG19G2jQJ/yw+Clabdg5x52TxSHJsUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=e+YaYwMt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=B1ncW/s4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="e+YaYwMt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="B1ncW/s4"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VFOOZS215387
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 17:36:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0gEn7xw74OTgVFYsNjZCPpjdx5PO6g9E5jzZSDfnuIg=; b=e+YaYwMtjJZQJ1rn
	5tP7le+ir/4lsZo2BN2rMfNaQGS1YLtY7VhVM2bOmKR8ci2W3EAh3YLI0BtZGVRJ
	1sXLGkWMWP3vXsw75BlddZ8RFxOgUAEdy83K/I6jjlibYSSMDMAZ2mJSesDCYOjN
	bXTjZxBe0tJ15y5a8zkPQvTD9VJngy/NOa/x1zNVC4sNCmOK1X+tLkd7SBybT27B
	mhlrfh6Qgca3aOB51/87X1pjcRvZDqs6Xvwq1OjiLr+3cjyn6k2z4etuU8Odu4vK
	gyAUyYZ0ncb0KHyogjQrm5Inszia+Qf2xwPft4xiAo8xFISo6LE/AfCscW6HW/Bk
	6jjhwA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frujush4q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 17:36:45 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbb467e56aaso1460760a12.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 10:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785519405; x=1786124205; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0gEn7xw74OTgVFYsNjZCPpjdx5PO6g9E5jzZSDfnuIg=;
        b=B1ncW/s4EpKLA0vDn+8ZmolzHwvKBOOHw8DcLelDiwDBdYjLsyQHn71nhVd3mopX+r
         +ofhETzTKWmrtQglFuH42LklCCXb14XyeqPV1F2lGsHPBn0aAhMMFbJ5a5taZju77y+Q
         6dF0o3oXHAM9tI2mferKVu1iu5pfRcl47l5o5Uv9lQEYRXF2WcIrxEUT6sTWZvmgmk83
         NV1/t0Fm51IDbLfgbNfeHc5sbq2i1Dz820hMz9+4hJYp+txvYnQpstq/p9piGeaqLhNz
         mXZPXVG5xU0rDyvDjjmvgpeVQBHUcu5QXKIGjPggcl/cbf2CQaLy6VtfLBIIeCi0DtZ1
         9yYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785519405; x=1786124205;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0gEn7xw74OTgVFYsNjZCPpjdx5PO6g9E5jzZSDfnuIg=;
        b=XezfH1GdyhT8rqkA1rceBxo1bnPOpJoD8iCkit7ZO4Z1PCOVxzA756UwGIoeG809S4
         +G/k+sOQnc0cLgh+aPlPjgVJSI7TON/amCrdTH9q2E2K1stItCKw6W2muCJMUS0/wYRS
         2MQEN9b3hinezqiJzdSQXMImtBANNyk3kzDAtG5bE3Q30D8hR6dTzvJDk2BZ4aNPE1VG
         vd2SjLXizHi7nCSFubdkDb2F7sZDsfrosGhQGPusTNmm6HcUMIT8MYMg0O1oaTa6oxeI
         EGnitgZoYgdWqfAbSWmV+ouvQq8V+icWwMYm+o/EHW0ELkDzs29th5elBPwVDmttcyNB
         glOA==
X-Forwarded-Encrypted: i=1; AHgh+RpAVsF3o4N0nO4VTCtfBmjeWV85gkhSOByqj80nFH7EMR5+fH6B1K5o63vOnmvN1QeYnAM7c7PG+jWxaSCkHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzUwBkW1BG59MaATNrcX/Aj4LG+ud+RdadnF7D4/Yc8urZJNNox
	ZSH8zHQ1ajIjicXmOQtTXbqucJnrnJAGAfnLKHrqg+L7jDSQw5v//IHNbAquw91kornqwY2GNqK
	l+A43Zkli5xcYt5IOOTMshHkGu1HFS7dhalnNr/AnxrAlCOPjzoV/jBDromvbIOa2M0MUaA==
X-Gm-Gg: AR+sD13VKxidAw5vvxPKIM70r7PxLdUXeA9mbj6lOFGQCKT/mzOpU4sRazGllsrJ4Bu
	6I8iaHBms73W6KNUEv3jraUhM4N+cgmLWy6NcTHfkMjQEkrK36XJ4e5OvlEwR1Ge4Y4wr1mxYUo
	2g9TwKlDnYfEdkvJCusHK5KTM3pOTk5NoiRiRlWTIFvu9pHIMIg2sn6dmMJZJEllfM5jdokjoo7
	MKgFrHDZf021btnyhPatfwFQhdHsedo6f+2vMJopwq1Ac6c8Ase8G8E5v1nbMtkhHQRkogJuRrU
	GO4W7g32i8p/4JxQrAWOZ/+VmnIsbWRo5ViWXPOjs+4qyP7bf1aMaWXYMz5N+0ZNG4/I2FXhp+e
	fdR2aqWEoVFda985eSLyjxWtKuy9osU5qMkg6+GS0zWE/+4Wf5/e6HwfTTxmu
X-Received: by 2002:a05:6a20:4387:b0:3ba:e5e2:73bf with SMTP id adf61e73a8af0-3c92a8139b0mr653024637.43.1785519404681;
        Fri, 31 Jul 2026 10:36:44 -0700 (PDT)
X-Received: by 2002:a05:6a20:4387:b0:3ba:e5e2:73bf with SMTP id adf61e73a8af0-3c92a8139b0mr652994637.43.1785519404267;
        Fri, 31 Jul 2026 10:36:44 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e06f8dbsm8202554eec.22.2026.07.31.10.36.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 10:36:43 -0700 (PDT)
Message-ID: <dbe5b96e-c95c-474e-aca0-8227fee4682a@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 10:36:42 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: zd1211rw: reject secondary interfaces to prevent
 conflicts
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
        Slawomir Stepien <sst@poczta.fm>, linux-wireless@vger.kernel.org,
        Daniel Drake <dsd@gentoo.org>
Cc: johannes.berg@intel.com, kees@kernel.org, linux-kernel@vger.kernel.org,
        nihaal@cse.iitm.ac.in, syzbot@lists.linux.dev,
        workflows@vger.kernel.org
References: <0720e3ad-d98e-47d7-89af-4d22416b0fbc@mail.kernel.org>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <0720e3ad-d98e-47d7-89af-4d22416b0fbc@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=U6Giy+ru c=1 sm=1 tr=0 ts=6a6cdd2d cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=edf1wS77AAAA:8 a=VwQbUJbxAAAA:8 a=hSkVLCK3AAAA:8 a=I3P1pAe5SESMdPKYoDcA:9
 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22 a=DcSpbTIhAlouE1Uv7lRv:22
 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-ORIG-GUID: 1isF7kxTlTeIcJoZeBJP2I7qhCWlJ2F0
X-Proofpoint-GUID: 1isF7kxTlTeIcJoZeBJP2I7qhCWlJ2F0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEzNSBTYWx0ZWRfX9Ys4aIzbKF0u
 +ciK4/V0rdt5Hc8roSV+N7xr0v1kc/gug8YJahNAnWQqdptxmNADK7Hqpk1Dp8V8v4jGJgzxThY
 j7QsanBMGJvjtee1zNPAADBjtl7HMxqIzjZDvvMCFjsLPOLK3EBcsaBVXasvRd6PQBId8Nu3uOh
 FqXIUObLMl/ufib+EF3fT1ZH1x34OaAi/4uXVvpETu1clK0ZxaceV+vXzvsrJ0CfZXrybf9btjF
 g0wwgitetK4OtFsPZGKTPIpRk2ly+ZWfw3g63E4bfbKNgHdBpCVkZ2UG7g00pB4/gWGiGSYPJoX
 iHG8CgNAQvqAl6Ls4E//mu/a5zbiacLV9iMPiO9A9XgfzbVS+uCwIQ/adjfDkVbnqnhJfCrB9sx
 XgvI9T++I2hAqBvlD8A64menPKr3frn8/vYacx4qNzgZkB/khr1clRzPSmVVEm11z4TVNoFUVqf
 QGQ1is1IN4zjjjT8Y7g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEzNSBTYWx0ZWRfX+o63Xs3mm/QW
 MByRnE7+ow7NMgevLeR7BY90jYcU3TN5oOXCiqsPtQlVmhonnHnZQOoVxGn0fbo9VKriS+/b2+y
 ZDlNP4oqoyoJxOvqUlNXBtjKE3v8FAE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310135

On 7/29/2026 1:04 AM, syzbot wrote:
> From: Slawomir Stepien <sst@poczta.fm>
> 
> The zd1211rw driver is designed for single-function Wi-Fi dongles and
> hardcodes its USB endpoints. When a malformed USB device exposes multiple
> interfaces that match the driver's device ID, the driver blindly binds to
> all of them.
> 
> During probe(), the driver calls usb_reset_device(), which iterates over
> all interfaces and invokes the pre_reset() callback for each bound
> interface. Since multiple interfaces are bound to zd1211rw, pre_reset() is
> called sequentially for each instance, acquiring their respective
> &mac->chip.mutex. Because all instances initialize their mutexes with the
> same lock class, lockdep detects a task acquiring a lock of the same class
> it already holds and flags it as a possible recursive deadlock:
> 
> WARNING: possible recursive locking detected
> kworker/0:1/11 is trying to acquire lock:
> ffff88810371dde0 (&chip->mutex){+.+.}-{4:4}, at:
> zd_chip_disable_rxtx+0x20/0x50
> drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1465
> 
> but task is already holding lock:
> ffff8881138ddde0 (&chip->mutex){+.+.}-{4:4}, at: pre_reset+0x28c/0x380
> drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1505
> 
> Fix this by explicitly rejecting secondary interfaces (bInterfaceNumber !=
> 0) during probe(). This ensures that only a single instance of the driver
> binds to the device, eliminating the recursive locking scenario.
> 
> Fixes: e85d0918b54f ("[PATCH] ZyDAS ZD1211 USB-WLAN driver")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0ec3d1a6cf1fbe79c153
> Link: https://syzkaller.appspot.com/ai_job?id=00724ef7-fd77-4cde-9779-895b8f63c2f6
> Signed-off-by: Slawomir Stepien <sst@poczta.fm>

E-mail from syzbot but SOB from a human?

I read the trailer, but this seems to violate:
https://docs.kernel.org/process/coding-assistants.html

Namely:
AI agents MUST NOT add Signed-off-by tags. Only humans can legally certify the
Developer Certificate of Origin (DCO).

+workflows list
