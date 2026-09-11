Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354D959D635
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 20:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789159012; cv=none; b=PrYcoyaWUfjLa83x1395h2ZMzAOnnqep2aR9KGHvXTZJBPAZ+MGrwodyj7nxk7yFOWseF6cQCkjowfasI7SuMZk2iQnVdyk1OVfzZgtRbJ8siPHw5zo+SaCXe3+Xb2oyWc1zOfBYlWH02lA+so0yFSbs9t52Yv/CdZrLMaQsG0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789159012; c=relaxed/simple;
	bh=G02IjyeZdh/wMIaX4/Yji+q4SDSBzhDUKdBuo/Z8Ij0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S46XGDKNBmkL3pnwS27/Ajus62uBomIZwVR+CaeO3Te/6nZnxYhmUv55wmhbKQpyyN/vvMXJ3OOMP4WcXyGPkr17fIOI6mZ6xsTXvr/jzi5Qp7x8KVv7jIQFqPZKzRfKKZhpITTxq2hIJhD2lZyoVxJPEwM7YHHv3M9mLEzzd+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MIl3+R9x; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cVz823N1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MIl3+R9x";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cVz823N1"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BHWlDb3622227
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 20:36:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	B2f1tyPzUGJPWgoXHlJFI5ih3kMGH8+HrYXagtLin9c=; b=MIl3+R9x4hdboPZU
	GpFHWznV/UTHnFtP7HroGlPgBWhQ3Dk7vRpJnWL98rC7xyvAKdf+cKKHTpug7hT3
	7espi+uVOvvtuLWpMRMLBA1T6DustWR9cpRmrIfamLI/BDL4SCxroMNbKa0kovrB
	f2vJsSoLqynl1tZhuVZ8N14oN5XmWi0QBlkaSssmYOpQWsnKO5pwD7iZj0xAheNi
	6CcP+XunN6g7xY+0B7AqF+EPkrLnT2fNk21UuwN4SCEbaWl22elUo9itSknsqcWn
	6eP2rD+NgrYvfniqs0ASWVC8B4S1bEV+83T2tVkIMBes3/5E+EQZvMPmN2GqYQ67
	kBUjHw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmmubs0u5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 20:36:50 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbe77d6864dso1850985a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 13:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789159010; x=1789763810; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=B2f1tyPzUGJPWgoXHlJFI5ih3kMGH8+HrYXagtLin9c=;
        b=cVz823N1MlGbaYnIujrSVQywEc+8xzm1S7GTylhCCR9FumNs6uJxkn157Co4OGS+Er
         6k5OLQfaR83jve57yTpl2lgLDRRt3hvW0bSx1nOUoXwyIOpZ7Wdj+m4Jx2PBBGL6JnZ/
         3qqAFZ0FtsDN0fXt6sCF2gzdRwjp/eaGifrkoM/RwAWYQotXD3wBxPHlTjeIiif+T3JP
         Db/mwRLUO+8IwL1BfUk0GnOETtIxa1BwNO0r7he9dNcP6SDzqvWsRCHG4bs/oHBbQJya
         9eKGIZp0dtj2j8YszPTrwHFyvxJ6CqWzlA1DaskSux5ShJPk25JYSm62UxQPnSWGI9PX
         3FCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789159010; x=1789763810;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B2f1tyPzUGJPWgoXHlJFI5ih3kMGH8+HrYXagtLin9c=;
        b=nOzng7SuOEWZY2i/o6LKgHsQV1ggoscS28tbVuENmHiNUxQWQurwcF3J1WYq7dsqhA
         UalOM9ihBavepgsBO4Z7S3aP29PDgVWUxqQwAGuqTplLcY0aZXJJoc1oqIqeOQgBp15b
         3lML8zhLezuVjvMnket5xanwMqvaNKmLmhGeADgiPXk2ATgdiiWDQ53yzGmYBpyBpfHs
         ULkGnbdyq20jp/UuwXmZ97alh+3NNlaCSl2O3Up8ogzgV2qdg5XHzEFUYVxPQeURtfOv
         PvuWM63qpc1yO4iTuyaBp3y/trNl2zCtVcnA/Xed+GdoWsMmfxCp/YvYYZ8L0dbXdzFR
         z32g==
X-Gm-Message-State: AFuF++mcLJHdkUOj7sofzpMkL3P4RlZA8xiJzbke91KNKs8J9Qf7SZLk
	4qzSWOu2oN3+55M3+/fcKVDs4aex6INVU/5TbuIfxYjBwMwZAtcPCwmSRg/iuURKGWrqVp2PMts
	9/jkIwJKLw3hfbQHFWZks5BKnqKoJzKD6qtuYCw1j5m3R2Y7IlUfAgh3dr37QAT7mjNcWlBOCKV
	Mcvw==
X-Gm-Gg: AYBFou15+Wx+BfV8PKwC8PAlPoMq6rfD+w6GbaUwGZUS4MvP8Z1PWgXBVbcLFfWUYK0
	UcyieTwmezzlyQ8hC53AIbI1Bk4ZkRl6cDr67lVqEZyr0aHFwvkmsfwIs3NvmIwhhNB7Vz//7SG
	cIzWn7wM5Cd6I5TpmbNEYYGj77vfz9rteBW6XwQyxWLOc5TKBIL41AsCDzt45L+ilEcGH9GOnHw
	sswniH8KD2qViwJgUj0vTnoAt6RWk9BYgwH1VVEZjAdDup2SnjmptXkYdoDk/DboRGrzLnfQMRO
	4GuK+64hHJM7A1c5B38GUHVWp2R8XV/t2sfaolp48aosFX4MzxtlE/XudIrgXwYOD8NgAgv1cRF
	YE6H8/arghpc+06Q7yEGCARZpeX4lHw76ukvxi1pvMRRTlfFydAaEWaLjKN+1
X-Received: by 2002:a05:6a20:9147:b0:3d3:ae50:97cd with SMTP id adf61e73a8af0-3daed880077mr9742069637.26.1789159009584;
        Fri, 11 Sep 2026 13:36:49 -0700 (PDT)
X-Received: by 2002:a05:6a20:9147:b0:3d3:ae50:97cd with SMTP id adf61e73a8af0-3daed880077mr9742025637.26.1789159008965;
        Fri, 11 Sep 2026 13:36:48 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4e9b359sm8535455eec.14.2026.09.11.13.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 13:36:48 -0700 (PDT)
Message-ID: <dded65dd-56df-4637-b3f5-c244651435a6@oss.qualcomm.com>
Date: Fri, 11 Sep 2026 13:36:47 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 ath-current] wifi: ath12k: convert scan timeout to
 wiphy delayed work
To: Runyu Xiao <runyu.xiao@seu.edu.cn>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Jianhao Xu <jianhao.xu@seu.edu.cn>, stable@vger.kernel.org
References: <20260717025602.262916-1-runyu.xiao@seu.edu.cn>
 <49600545-3e13-452c-8940-c3e775ac3856@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <49600545-3e13-452c-8940-c3e775ac3856@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: jQ29613LEngBKK-x125ODiDW8dUSy1pe
X-Proofpoint-ORIG-GUID: jQ29613LEngBKK-x125ODiDW8dUSy1pe
X-Authority-Analysis: v=2.4 cv=dakVTnXe c=1 sm=1 tr=0 ts=6aa46662 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=Ucu4zBzE-dK3vCHSYFkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDI5MSBTYWx0ZWRfXxvAx5g92GYAy
 Ms4zpxqRpw/aaDHfOk7sTRbhDDDCbr7TwHd4rY/mlS6PoMR6Cpxhls+kXfyNdu0ajAcrrKTZ9K7
 d9+sRLZXV17xH1PC6HqKKivVXNwBEnE5CLrnX8e3Oba8aUuQ2bAToKwALT2WHNLC93IFdByg4aK
 c1cXVIE7owkX01KNXA++tl7u1gaQOjNFioS7/7PpjSUdvTQm19BZMfwkD6GThHNCd3BAG4iBV6V
 D/1AMGzAdgFZRBsRyWjgT63BtDf5LWDwckGPrRwp/ikUvl6tvzHboM2a8b5YAmS7CB/MvM67Zqf
 SLEEve6u0wazOO789C+WxGbvV/Mb2mL4QCX76smsYWgep891mrzWUn7g9lX3CzmB6fPukZO1Ovj
 C2xqY3AFZ8P2SDxxw0NAcyZxK3rcrbb6ie+2DoJtmLkumZORYEHr4FXasjKtUKCZ7CD+4odQSXf
 sZH+VoOR6d24BSTXlGA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDI5MSBTYWx0ZWRfX3yACyliTD1OI
 1R4Qw7pqf7H9wJWQlCqQBpPGrKqMtkR2py209eqtyHsX2/uR/pGYz/56PqHEIQfrzpMWQNsN3UE
 onhHd4viEJWM0Wb9gkK/TrWa/0TdU4I=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_06,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110291

On 7/17/2026 7:40 AM, Jeff Johnson wrote:
> On 7/16/2026 7:56 PM, Runyu Xiao wrote:
>> ath12k_mac_op_stop() is called with the wiphy mutex held and calls
>> ath12k_mac_stop(), which cancels ar->scan.timeout. The timeout worker
> 
> you are missing a very important detail, namely it is a synchronous cancel
> 
>> also takes the wiphy mutex before aborting the scan, so synchronously
>> cancelling it from the stop path can deadlock if the worker has started
>> and is waiting for the same mutex.
>>
>> Do not drop the wiphy mutex inside the mac80211 stop callback. Convert
> 
> What does this mean? Where are we currently dropping the wiphy mutex?
> 
> You should describe the patch in terms of the current code, not in terms of
> any prior versions of your patch.
> 
>> ar->scan.timeout to wiphy_delayed_work instead, so the timeout callback
>> runs in wiphy work context with the wiphy mutex held. This matches the
>> locking model used by the scan vdev cleanup work and lets stop/cancel
>> paths use wiphy_delayed_work_cancel() while they already hold the wiphy
>> mutex.
>>
>> The old scan-finish path could cancel the delayed work directly from WMI
> 
> what is "old"? There is the current code and the new proposed code.
> 
>> event context. With wiphy_delayed_work that cancellation must happen from
>> wiphy context, so keep it in scan.vdev_clean_wk. Mark scans whose cleanup
>> work has been queued so a timeout work item that was already queued before
>> cleanup runs does not abort a scan that is already finishing.
> 
> My AI review agent thinks this logic is unnecessary, but I haven't looked at
> this in detail.
> 
> "summary": "finish_queued flag is a redundant substitute for
> wiphy_delayed_work_cancel: __ath12k_mac_scan_finish is always called under
> wiphy lock, making direct cancellation safe",
> 
> "failure_scenario": "Every caller of __ath12k_mac_scan_finish holds the wiphy
> lock (directly or via wiphy_work dispatch), so wiphy_delayed_work_cancel could
> be called there directly — as the old cancel_delayed_work was. The new
> finish_queued flag instead defers suppression to the timeout work itself.
> Since ath12k_scan_abort already has an explicit ATH12K_SCAN_IDLE bail-out path
> (line 5232) with a comment covering the timeout-vs-completion race, the
> finish_queued guard in ath12k_scan_timeout_work provides no additional safety.
> The cost is 8 reset sites (lines 5337, 5624, 5681, 5775, 10971, 13969, 14012,
> 15061) where a future error path that forgets the reset leaves
> finish_queued=true, silently suppressing the next legitimate timeout abort and
> leaving the driver wedged in SCAN_RUNNING with no recovery."

You never responded to my response. However, since this seems to be a
legitimate issue I did a little more research and now see why the
finish_queued flag is needed. A better commit text should explain that since
the current commit text is confusing

I propose something like the following. Yes it is AI-assisted, but IMO it does
a good job of describing both the existing problem and the reason the new flag
is needed in the modified version.


ath12k_mac_op_stop() is called with the wiphy mutex held and calls
ath12k_mac_stop(), which synchronously cancels ar->scan.timeout via
cancel_delayed_work_sync(). The timeout worker takes the wiphy mutex
before aborting the scan, so if the worker has already started and is
waiting for that mutex, the stop path blocks indefinitely: stop holds
the wiphy mutex waiting for the worker to finish, and the worker waits
for the wiphy mutex to proceed.

In order to avoid this deadlock, convert ar->scan.timeout from a
plain delayed_work to a wiphy_delayed_work. The timeout callback then
runs in wiphy work context with the wiphy mutex already held,
matching the locking model used by ar->scan.vdev_clean_wk. Stop and
cancel paths can use wiphy_delayed_work_cancel() while holding the
mutex, which removes the _sync wait that caused the deadlock.

There is, however, one additional issue with the scan complete path.
wiphy_delayed_work_cancel() requires the wiphy mutex, but
__ath12k_mac_scan_finish() is called from WMI event handlers under
data_lock only, without the wiphy mutex. The existing code can call
cancel_delayed_work() there directly, but that is no longer valid when
using wiphy_delayed_work. Instead, set a finish_queued flag and queue
vdev_clean_wk, which runs under the wiphy mutex and performs the
cancel. Add a check in the timeout worker so that if it was already
queued before finish_queued was set, it exits without aborting a scan
that is already finishing.

/jeff
