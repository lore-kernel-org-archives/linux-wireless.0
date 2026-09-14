Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59523E51D3
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 07:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789371969; cv=none; b=UwmgDa9phqVB7HAdQ4eq8qmVCmPsYUMMNPSQR1cgVt5RN6M3AD6o9rx/lgQQuVj+OI4piO24V0L03HiRNZb1cOv5aoVS9xtwmg+bjW/yytF9YQJC5RlCVTVve3w1qYM5WLUsnJ7/GSGYZ5k/XLKLOPoWp+a/F72NjSvYd78qnwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789371969; c=relaxed/simple;
	bh=Ze7U7a8Nd4m9h+cu3oyfLHxjY6z8eCdb6Vjwi8EIgdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RS8BnGYQrp/U/K0y8bsDJgFf4TUhXawl/FKNscSQgcmwrBE7EzdJlbYjB/NXcwiYTal7J3KAPdI5rVa7yZ9MPwqbFTCXA6tlRR80OYr1hnUzVt7vyCMeqmRhkkCykycoxtCqBDVHmyoz4B/aXR2v1bklAe4hMIF74nOCoogdEfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GfCe2D+w; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RbADy5Q2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GfCe2D+w";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RbADy5Q2"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68E5is783196659
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 07:46:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	knqANIErUpUvoioHZKO7P35KQYo131cMbZHTXuFrKGk=; b=GfCe2D+wX97VOWas
	ig6q5xqgHwAhEHWKY7GNiWz12VuhT4HB1624DF/y/pXwvvqKLofFlqU0Shlija/C
	DtnvzJQZKioSNAZIYZmLoJ6/6v7dOZlgSu0B96IDj8hCoygHVzztzM3wYqSo/FBT
	yhpCK6AWUNZ3DqI1+qRwYr4Ejir2Gkb3Or3DvS1/qL4frQ66KUYzG0HQ0+HmMSEC
	ATCsVsXcWcKFAPnF9tom9tAMn8jGAIwLbozbQOl5ZvFJQkFpaaq1cnSBRKGBy4in
	KPbG+737yQBt2lDAYu71wGZKt85IVXeTKnSL+oQZ/GDA9VQBiqPEFgAABKA8uUnZ
	XQEcqA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmy9cdjdm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 07:46:06 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb835525b10so3831987a12.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 00:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789371966; x=1789976766; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=knqANIErUpUvoioHZKO7P35KQYo131cMbZHTXuFrKGk=;
        b=RbADy5Q2xQEYl2zGsmpaWEyMVrQRH1Aca1dtpMqh6HzRk6b58yb4GFT1OPc72nMp5j
         5+hAUb6CQKr43PjMHK+AOePys2b5u1x/6qcKZbKYOScumvwqOcjOqdVBi9OJGgYhwNjD
         Tufyq7akqQpdLEGD+1UAtyJvAO1ZpqY/eRak9kjYhkVlwauKn7Gh1lTZf8gZcuWW9aMd
         bJ1vuZyeRN5KP3vWrD81mEUz82VjfI+qcv/biJlxPU2xi/ZCgIoDdMlssK0mNMTjA/1H
         sIa2c4rVTiP32DvpGJfFWKBOgdZVzrwa3H6dbgC0NjUmgpNwv62SCgFmZsGMs8lg22pr
         6gpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789371966; x=1789976766;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=knqANIErUpUvoioHZKO7P35KQYo131cMbZHTXuFrKGk=;
        b=eJUxBgiF4mj92McTH8A1OoZ5F93uAWF4IiPglNtYTveQJ0Cl07EGcMHEh++JdToXgq
         rrwS0pani+Q51C+fvXQYLRXgYoHe6zostdPzxPHr35OvoZbA9gaedhDVGZdWo6ZcToyQ
         nfqfZ0NN5U+8S+TXDBgGYsYUDfRGV680F6xqB2BSbd4z8O0SSRgoiy2dUHfmsI8rqoCI
         x5bT1EYfmzvo/YRx1z5cqRxipupASWc8naeQyoXsoXZ4P6ZShL4pKYEFDFrzwjmsewqB
         u+HtvXPlSw65vHIPjXyMKJQXBIU22K/c3lleXm/w68FuwsSJSFxaRjBtRKRneB8pkvZc
         d/Zg==
X-Forwarded-Encrypted: i=1; AKwUvBxa7OiV0MFJcwnbXiS99YVOWYbXyyNHV8WYqQGJ5BaLZXRcoHDFDaw2pYWjSa16EVbzZd07WLGideeZyN4Kjg==@vger.kernel.org
X-Gm-Message-State: AFuF++liIKtS84yjzDttttfrdB5hLFpkswygPSuMdDwb+5gHPdzdk3Z+
	Y1NWu2Gz1bbvcXgXAtu13MQ9kGmc2uWHzy2gs9zI6WQi0GNjneDdfK+cVOPjNoFqgIqkn2FEErF
	TzVOxEM2BCE85yGViPWvLcOI2cQNETFFvvCs3H0wWtnMR4mkjZwKYh2B5XoP3mLhBwo5n566B1B
	Ssvw==
X-Gm-Gg: AYBFou2qQ2cI6lbgGmHc8npEps7ASry/1Sm3rfbSaALXQFVQ0mpSkn7VRN1GxEE62DY
	HKCrmsv6H9XPxWlfAbXDu8aG4XVKaRA++vDM8vZ/8xUQr6FCfe5bH3QANLd6o5M9PztKS90bihD
	KBpHHzgPXyX9nnEtDuWj7YOX21K/YfQXRPQm8PjTDYCEkgTpHy7XdJbAruIx265pYkc3yQnM5Hl
	MrH1SgcRWCperZnOJikc6s/TLJa9cDxc7u8FIerahxkP+qwOr+bHA63o5JMKx0C6Pfv5nwrCF+L
	ygNj7GrvwPe5GJa1uQue7xzbWTa+qCoTqETb32wYLugMfI/hlQgBdMe83XbwK/fA7ZNF/ShH7e0
	5SjCROdxxqqpUtTuDrTCYGXe2LHfSopckQ5ssC1Yzs+Kdw7MZihhYlj6/548EzAruZRrgcLz4RI
	JtvA==
X-Received: by 2002:a05:6a20:d80d:b0:3da:e7dd:45d5 with SMTP id adf61e73a8af0-3db40568311mr2844494637.20.1789371965586;
        Mon, 14 Sep 2026 00:46:05 -0700 (PDT)
X-Received: by 2002:a05:6a20:d80d:b0:3da:e7dd:45d5 with SMTP id adf61e73a8af0-3db40568311mr2844434637.20.1789371965162;
        Mon, 14 Sep 2026 00:46:05 -0700 (PDT)
Received: from ?IPV6:2406:7400:c4:1a3f:4c9a:bf20:8238:da9? ([2406:7400:c4:1a3f:4c9a:bf20:8238:da9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4fa50efsm27897775eec.28.2026.09.14.00.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 00:46:04 -0700 (PDT)
Message-ID: <9ddb130d-9e08-41a6-b76b-678b045a22ed@oss.qualcomm.com>
Date: Mon, 14 Sep 2026 13:16:00 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ath12k: QCN9274 WLAN.WBE.1.6 firmware drops pre-auth EAPOL in TX
 encap-offload mode (WPA 4-way handshake fails in AP mode)
To: Michael Pfeifroth <micpf@westermo.com>
Cc: ath12k@lists.infradead.org, Kalle Valo <kvalo@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org
References: <app7ADVti1eiVQr5@mpf-ESPRIMO-P9012>
 <cbbb5555-60f0-4a4b-881d-403decc53ca7@oss.qualcomm.com>
 <aqFARFlTS7757Zks@mpf-ESPRIMO-P9012>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <aqFARFlTS7757Zks@mpf-ESPRIMO-P9012>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: NLmzIiQFiMrYU1ccjL_r-4yX-pc4gNZL
X-Authority-Analysis: v=2.4 cv=Pv4G/AM3 c=1 sm=1 tr=0 ts=6aa7a63e cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8
 a=7v_02ZIBZ6jUZCODSU8A:9 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDEwOSBTYWx0ZWRfX2YU3/fVpjLbb
 KDoB0AjDi1ds7sWzxXQ+2arRMod++wMrAXsf4n6+NpH4xrRMVoHoMB4tjs+/BlwJCvxu3sGmXzO
 Q9viKDmCAvXQWD9W3YBFUG54s6q8kcQ=
X-Proofpoint-ORIG-GUID: NLmzIiQFiMrYU1ccjL_r-4yX-pc4gNZL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDEwOSBTYWx0ZWRfX3HtfUFBJ4ptP
 5JTdfMqT/R1EqGL0gqflbORLJo8uaNmz7QrFxCxPREubwIlqnhbv63CsM196n0eDPNUh+3dPOPA
 ZDvPawdyvqMYKHU7wu340gmy5CHMITaewkg4L5q87v1/zuNyVQA54LTcZ9g4y0RoVflPlKn9/JL
 vwV6522mKNQ3JI3Tr2VuOox6MVtlguTkLAi5CieItf5fx8QNwnu1buehIOOjtMVU52KMQxTGhVq
 Cd849VrsdUo8dqlEOKQffiWxrWMlwTSfPKTiYhK6eyQaiLH4uh/fuObumCK2hHvE+DHKnFnpHRk
 kNLvYwWRKCUU3h2ytflf6JuAF9CmXRw6kjGx7s/45B5Ve90YGpEoqtBf/Muv67lK+PrC/nHIWLi
 aqLZr91yTFKWaU5sKW8y5t2LIdpnqc5ZnX4Uxv9+vBSFKnNasjw++N75bzjLzGcNB5LRHzUIDAU
 r5oveNr0cDXAgMo1uAQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_02,2026-09-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609140109



On 9/9/2026 4:47 PM, Michael Pfeifroth wrote:
> On 9/8/2026 9:59 PM, Vasanthakumar Thiagarajan wrote:
>> Worth trying with commit
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1e33f8acd837420160ea088160d8648a3db54c3b,
>> if it is not part of your image already.
> 
> Thanks for the pointer. I backported 1e33f8acd837 ("wifi: ath12k: fix
> encrypted EAPOL TX in encap offload mode") onto my tree (backports-based,
> single-file dp_tx.c); it builds and loads cleanly. Unfortunately it does
> not fix the symptom I reported - the 4-way handshake still times out with
> reason 15 and hostapd still logs "did not Ack EAPOL-Key frame".

Thanks for checking with the commit.

> 
> Looking at the commit, I think it addresses a different EAPOL case than
> the one that fails here:
> 
>    - 1e33f8ac only re-routes EAPOL frames that carry ATH12K_SKB_CIPHER_SET,
>      i.e. *encrypted* EAPOL. On an established link that is the GTK rekey
>      (group-key handshake), which happens after the pairwise keys are
>      already installed.
> 
>    - The frame that fails in my case is EAPOL msg 1/4 of the *initial*
>      4-way handshake. It is sent to a not-yet-authorized station before any
>      key exists, so it is *unencrypted* and has no cipher set. It therefore
>      still takes the unchanged is_diff_encap / TO_FW RAW exception path in
>      ath12k_dp_tx() - exactly the path the 1.6 firmware appears to drop - so
>      1e33f8ac leaves it untouched.
> 
> So the commit fixes the rekey EAPOL, but the initial handshake never gets
> that far. Test details unchanged from my original report: QCN9274 hw2.0,
> firmware WLAN.WBE.1.6-01243 (the latest published in linux-firmware
> ath12k/QCN9274/hw2.0), AP mode WPA2-PSK/WPA3-SAE.
> 
> One thing I noticed: the commit's Tested-on tag is WLAN.WBE.1.6-01270,
> which is newer than anything currently in linux-firmware (01243 is the
> tip). Two questions:
> 
>    1. Does 01270 also change the firmware handling of the unencrypted
>       pre-authorization EAPOL on the encap-exception path (i.e. would it fix
>       the initial 4-way handshake, not just rekey)? And is 01270 planned to
>       be published to linux-firmware? I can't reproduce your test setup
>       without it.

No, the EAPOL packet Tx handling remain between those firmware binaries.

> 
>    2. If the initial-handshake fix is expected to be driver-side, should
>       ath12k also force the pre-authorization (unencrypted) EAPOL onto the
>       native-WiFi path when ETH TX-encap offload is active - i.e. extend the
>       handling to the is_diff_encap case, not only the cipher-set case?
> 

We do not observe this issue in our local setup. This behavior needs to be root-caused.



> Happy to provide full hostapd -dd logs and tx-path traces, or to test a
> firmware/driver fix.

Sure, the below logs and configurations might be helpful for further analysis.

- dmesg output with ath12k debug_mask=0x6000
- dp stats output before and after the issue:
	cat /sys/kernel/debug/ath12k/<pci-bus_id>/device_dp_stats
- hostapd configuration in case this helps with the internal issue reproduction
- hostapd logs
- OTA Sniffer capture, if possible.


May be continue the debugging in a Bugzilla tracker for this issue?

Vasanth
