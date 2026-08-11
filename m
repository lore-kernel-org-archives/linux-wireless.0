Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C72441F7D2
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 08:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786438320; cv=none; b=i6O7nPZnBTEEngLm+DKnqMULaz5NS1O+5j/yY3/M77ZdwpcWw+so5bKF5247Mzm1kZVg7fLxvZ42zq8OIxlf+I+BURUtUC3XivQde5cqos4NLLeaopn3rCR+7eTKb7OOLbT8gkXuTtwklms/4QNHZcDq08NeoFpU38+YFIkqMXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786438320; c=relaxed/simple;
	bh=I7nPnuHKAd6p8Q9qirUeBbr32XOXSg2puw/1Nr5yEm0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=sCCnipbkMTndPy6vDCq8sDghsjxNCUqHJCtfDBFOH0cJV7skzxQyBXjv+Iqxj0B4v8gCPg5VsgX/IhALPxsnufEZ4ylbHNN1Zk9BXE9Blaon9/KHD1ylD6yGrjLJ6xPesMD6nbrC5J0Dn92TTefYAbRKh7LE1r7APvStahcAbog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mptQ0Iov; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cjLvkADN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mptQ0Iov";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cjLvkADN"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67B43tFJ3320878
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 08:51:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SPf3Qq35sizRfvRrlkrIrvuvqWT7RAryjsZcrodDY1c=; b=mptQ0Iovyl5nzwSj
	ktLVhbhNHYukgPzRYfj0kXZdB+EENabqatZRi1PaX4XaKAo6xmWM0j5WXvaHAu13
	kmWQzWoLWtOtG1SMUndmnMgMUolNj4+igIHS5ucD8ni3UnGVZYwep6P0J0A0+XQO
	z7ewLdAafeE3raFSWXBca+XFuwGJkEv1UdkTW5exBom63ZGLhK1FBGLHP/nXoCjv
	iSMj5rjzYr0I1UKEBMLMdMpfBGTKl2MwPBin6aBJ2/tUdLJ+2HjsPLkbpOHTAyzW
	pROeblbMy+53LiLvunvfd1ID8yOWaikgNGxASqxi+V2NEnSjncRji4VrYllF8N3Q
	MGNzkA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fyvcr90eq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 08:51:54 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c0e702df8so37085591cf.2
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 01:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786438314; x=1787043114; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SPf3Qq35sizRfvRrlkrIrvuvqWT7RAryjsZcrodDY1c=;
        b=cjLvkADNswzCKZrJDrNcCBUTBbTiiRjapumb8XUk+NbIrInzaPtqihEDM/9MyIv3S9
         n5kXPob9lylZ7cFwys/lEJKUtctKkQ5efvrey0Oi+GpQ72/F9maKCte/2BcfTgWpQ5S4
         jKrhTmog5b0azaFnl0CcO7rbi3n9owuRe2Q0/kpqUBbypjmDG0veC7aebJRkzLBiccjM
         CQvF+RPDCuDqNKXlOPBuNH4LqSYXiYsXuX3zCRj22y9l1gJU31ww8uFK22Y1+9/Q8ZMZ
         snlH4RKdB42OE+cwukE12shQrxftRfUW3WDOSEEJ/IkSXBT6QOtxd0+MwK02Vtvp8n1V
         NlxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786438314; x=1787043114;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SPf3Qq35sizRfvRrlkrIrvuvqWT7RAryjsZcrodDY1c=;
        b=X7ZYI8MhZV5uXff0iKxCENhTvjAPu/EE0AXUh7VEg3avhvUtM+4b+dvKaaKRWYabre
         ZNXjUD0LjKsNdbvFlOfUT8vPErQYXa5UDZ/LHGi1W5pkPw9JfihL+3Sr2Kiq68RRIXtk
         LIy30vNKUmF37P3DE+mNPfkkSmKryxJZVpcE3w6VWXWTQEdLciApKym8TCEMs9D39BlV
         +WPk9rC/XOiR67lKGb8Hrfitlx/DhHSi1Jk4qAwNhnhi+yFknWKOYz1Sb3JCtqnGrL4i
         bmwtE9DpFdZs4O+4bCyyiebJ+nA1B9jvX5h1e4EoXPTQan5HzhVoxPlUU3e6kCWj+AaQ
         ac5g==
X-Forwarded-Encrypted: i=1; AHgh+Rodhr+pLFyQGJo4/wZnUcXS2Thx53Q4PBRBfnq91yCkIoJ0aQUSK3IGYG3SUgtqnZhJ30bNrZgPNhMOSMx9sw==@vger.kernel.org
X-Gm-Message-State: AOJu0YycUbHMWnig3S6SBhj2ZR515OVDSBvzFvn4ys+EN1pajhmXmDT+
	ylumSq2yXqzaykE2eqA7RVEvIwaL/hzWu0wSvLiJaR7/dMRsPwyib7ItrSLsJOFmI8XJaXVFnFl
	TqOF/RtmNEjnhT/7okxRFz8mrTzyRtqr4VRtjI9LSYtKiNsW3RWQjlh95XgFpCri2hc5iOQ==
X-Gm-Gg: AR+sD13oMIy/BGtaGqS96lbLL0v++rpcfZt8mpXRCFIPfjXro6SAui+sNZVuyYleRoe
	OTiAABuNhvQven00OhjKo0eGNHfHK6t4KX8Ka+KsQXtooD1DFTxV+WdGOWm3hcacty8yS5ZcEDF
	CAvTGcQr37vdg4EGX6V7GPmzOu09A/GdpKDx9Md4Ee4K2v/mW9mXfSmofdQAaADK2sbVF9oxRDM
	A0xQ157IrBbHmCIHfrNoFA7qzTvD71hvkw/hXQ31iSZetKItGVefWlJyEfBrqX+Fjz7pwvrpmkh
	fEdys09uawPW4GWWvExeh3XO0WAjzmbofNI78fuxvadvdYX/wjqRXjuyZnRDThhAjNYNh1Xqd7e
	qGm8RYj2eEllSaOr8kuwDBUBWgMai5EFwZ9SkVHYRIUXGa71wZCM2rRiMc9Yl5CyISnnlX/kNw3
	pvujtBLcIaruNV8g0yz/A8leYv8j8nWBX6X/k92aFnczvTeh9/qnnUSe6MFJhuBgDUwSQ=
X-Received: by 2002:a05:622a:4d0a:b0:52c:cc14:ff5f with SMTP id d75a77b69052e-52d5869539amr13603421cf.38.1786438313964;
        Tue, 11 Aug 2026 01:51:53 -0700 (PDT)
X-Received: by 2002:a05:622a:4d0a:b0:52c:cc14:ff5f with SMTP id d75a77b69052e-52d5869539amr13603161cf.38.1786438313450;
        Tue, 11 Aug 2026 01:51:53 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c20e435981asm27364266b.42.2026.08.11.01.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 01:51:52 -0700 (PDT)
Message-ID: <154779e8-5f73-4f3e-8618-104effb85538@oss.qualcomm.com>
Date: Tue, 11 Aug 2026 10:51:51 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Hans de Goede <johannes.goede@oss.qualcomm.com>
Subject: Re: [RFC PATCH 0/4] device_schedule_reprobe(): core helper and
 conversions
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Golle <daniel@makrotopia.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Danilo Krummrich <dakr@kernel.org>, driver-core@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        linux-wireless@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org
References: <anpxFdwNxk0XwPjQ@makrotopia.org>
 <2026081139-strenuous-greasily-f4e5@gregkh>
 <cb0d42dd-4755-49a8-8a05-297e4283914e@oss.qualcomm.com>
 <2026081133-crazy-enquirer-97ce@gregkh>
Content-Language: en-US, nl
In-Reply-To: <2026081133-crazy-enquirer-97ce@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDA3MyBTYWx0ZWRfXxkHOFThzARK3
 +O7MtsQki8dhNPhfMmS/gq1+UPwrwgiQLLEVKs0LKyd2qiu0Ca7wVG7Wc43fqqR1iQ2cazRb7Da
 NSVHfG5ex0w3/sQNNzP2LfA8jqb7o0igVvs+GJWySWMkXotdKUf0t90BLM7SWTpUhDgP5zfFLEQ
 TmfseVOC5Ot/eA/vkOvOg78LBF7L53rtgV6ZOIRUQU9klZchi34EEZJ6iCfE1mvgwzyEzWy9unv
 PJ8TTc+NwrDx2s9oaoUBMU+VgJTJaYVJ9ESVcLU95C1Dc0mazl8Hbzt4o2JRJz7BU5psTjEiCyL
 TLmrTZV7xO/cRgFftZBDiXXACd1X2tFpyOZcfp7Fch2IILXTTGIKMdUH/PHA3LAApJ0+K+y3r+y
 yOx7vJPHPsaxmmBblq//hoBnHP2Bvu0yocMFT/OvtPPfTmKDJl/VTFFk6HFfnGOwviYMwSHIc2M
 wZfgLuJhQ1XflHhp3vw==
X-Authority-Analysis: v=2.4 cv=e/A2j6p/ c=1 sm=1 tr=0 ts=6a7ae2aa cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=66NDgXRySrwKPkD-ur8A:9
 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: oNWhcTj-NzVydgHJ7I2hBpD5ulVr4aEv
X-Proofpoint-ORIG-GUID: oNWhcTj-NzVydgHJ7I2hBpD5ulVr4aEv
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDA3MyBTYWx0ZWRfXw9U88q2ZSvha
 8YPl3rhiKC+EDnsBTsy7wSVqJldHh5ttGIO3xi1ntB48fjxMEpZ+WE8dD/wN1lb75+UY5R7bMG7
 GeBrxeI7geH0/z7dak2ACNd2FMJpM/E=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 phishscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608110073

Hi,

On 11-Aug-26 10:07, Greg Kroah-Hartman wrote:
> On Tue, Aug 11, 2026 at 09:32:45AM +0200, Hans de Goede wrote:
>> Hi Greg,
>>
>> On 11-Aug-26 04:33, Greg Kroah-Hartman wrote:
>>> On Tue, Aug 11, 2026 at 01:47:17AM +0100, Daniel Golle wrote:
>>>> Three in-tree drivers (iwlwifi, hci_h5, btintel_pcie) schedule a
>>>> deferred re-probe of their own device from a work item in module
>>>> text.
>>>
>>> That's a mess, why?  Why not fix that up to not do that?  Thousands of
>>> other kernel drivers do not do that, what makes these so special?
>>
>> I can only speak for the hci_h5 driver where I added the reprobe code-path.
>>
>> The problem is some of the Bluetooth HCI devices using hci_h5 loose all
>> state during system-suspend. This means that the HCI and the Bluetooth core
>> end up being out of sync.
>>
>> So we basically need to tear down and re-build everything including
>> e.g. the firmware upload which happens at probe(). Doing a full reprobe
>> is by far the easiest way to do this.
>>
>> I suspect the other 4 users + the pending driver which triggered
>> this are similar.
> 
> Full reprobe feels different than the THIS_MODULE stuff, which is what I
> objected to here.

Right, the helper from 1/4 to safely do reprobe from a worker actually
removes the need for THIS_MODULE stuff :)

The THIS_MODULE stuff in the open-coded implementations is there to
avoid someone doing a rmmod while the reprobe is running. The new
helper replaces this with some checks in the workqueue function
checking the driver has not been rmmod-ed in the mean time.

>> Sure we can do the whole tear-down + setup from some worker
>> scheduled at resume, while keep the driver attached but if we need
>> to duplicate that over 4 drivers + the pending driver which triggers
>> this then IMHO those 5 users are a pattern which deserves having
>> some helper to do this through the existing probe() + remove(),
>> rather then requiring those 5 drivers to open code this themselves.
>>
>> Note that we already have device_reprobe(), which has 15 existing
>> users. This series just adds a helper to do a device_reprobe() from
>> a worker in a safe way.
> 
> That feels a bit better, as long as this code really is "safe" :)
> 
> So, how can this be tested and fixed up so it isn't a RFC anymore?

To me it looks like the main things are:

1. Agree that a helper to safely do a device_reprobe() from a worker
is helpful (I think this is done now?)

2. Get patch 1/4 reviewed. I can do an initial review but I'm not very
familiar with the driver/device core internals.

3. Test this. I can test this on a hci_h5 BT HCI that will hit this
code path.

I'll try to get 2. and 3. done soon-ish.

Regards,

Hans


