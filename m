Received: from forward.mxwww.masterlogin.de (mxwww.masterlogin.de [95.129.51.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C0E3C1F
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 02:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.129.51.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791599138; cv=none; b=f82rFnmdJTbvWZguxrUx4djv0iPY60YKPTH4663tpf1DOtOD2LzDk/8DyK9ltEYIRtd+yZmV0ze5vNyt1k8/YmUkSOkFe2xpFetFS1xsMdKW7jKPmUBtOY8/kLtC+n6c2vnL9Uovcu1GtIFLcuqBu/D3xPIMadp22LEk9Cft0/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791599138; c=relaxed/simple;
	bh=km3jZchuziAQlJjH02bGkzu2uqL5cRrKV4HdcP+Pfz4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XVnpY8ioksohuBzd7/MHt2kXkf/UahdDwE+l+Sw5BN5tUANVIJ7GykDk6jHTvNUwJwM/lpZEZF1vgVEsDPE2T0ivdlc6t50YuE5dsPlOnUr0zSW2/vjz4mCvIcpLs+a7juOoz052AFRagafZRY7rXLP9di5nMIhaYCVxWv16Iac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0pe.de; spf=pass smtp.mailfrom=0pe.de; dkim=pass (1024-bit key) header.d=mailerdienst.de header.i=@mailerdienst.de header.b=w3waspj/; arc=none smtp.client-ip=95.129.51.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0pe.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0pe.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mailerdienst.de header.i=@mailerdienst.de header.b="w3waspj/"
Received: from mxout3.routing.net (unknown [192.168.10.111])
	by forward.mxwww.masterlogin.de (Postfix) with ESMTPS id 73FD082C3F;
	Sat, 10 Oct 2026 02:25:34 +0000 (UTC)
Received: from mxbox1.masterlogin.de (unknown [192.168.10.88])
	by mxout3.routing.net (Postfix) with ESMTP id 4002F605BA;
	Sat, 10 Oct 2026 02:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
	s=routing; t=1791599134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i+h7lDJU8m54d4aU9LHWn640ahYL6/I5nFJ1o7A36vU=;
	b=w3waspj/n2JMn9fz8+DWBwasEcMehncPlnk7G/jitrb0Ar+F6nU9flmSC6Lt9/YjEGmyy8
	dXoIFNRwmplKKMDkeBosAr4jyukY8j1VlpZwZ6Mv3Ak+bkZFLUgfL85t/pV4msJ2PetbnL
	j/UGk3YZaQr4Rnmzf2EXtknzAAhYRxo=
Received: from [IPV6:2003:dd:f29:d200:aa1:36ff:fe8c:79db] (p200300dd0f29d2000aa136fffe8c79db.dip0.t-ipconnect.de [IPv6:2003:dd:f29:d200:aa1:36ff:fe8c:79db])
	by mxbox1.masterlogin.de (Postfix) with ESMTPSA id DBA384006C;
	Sat, 10 Oct 2026 02:25:33 +0000 (UTC)
Message-ID: <0bd012e7-4115-4401-b067-1ab616918729@0pe.de>
Date: Sat, 10 Oct 2026 04:25:33 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ath12k: spurious beacon-loss disconnects on WCN7850 (regression
 in 7.2.6)
Content-Language: en-US
From: Izzet Beltir <ath12k-bug-list-09192026@0pe.de>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, regressions@lists.linux.dev
References: <3e2b5994-cd7d-4d44-a821-f34cbd06e7e0@0pe.de>
In-Reply-To: <3e2b5994-cd7d-4d44-a821-f34cbd06e7e0@0pe.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mail-ID: e61ef95d-8f20-459e-9cc4-73a74f90328e

#regzbot invalid: not a kernel regression - the beacons really are 
missing, and a second client with a different vendor's chipset and 
driver misses them at the same instants

Hi,

I have to retract my report. I am sorry for the noise - my bisection was 
confounded and my conclusion was wrong. Please disregard the regression 
claim; there is no evidence that anything in ath12k changed for the worse.

What I got wrong

I reported that ath12k stops accounting received beacons while the link 
is alive, and that this started with kernel 7.2.6 because 7.2.4 had run 
for 11 days without a single event. I missed that the machine was 
powered off from 2026-09-22 to 2026-10-05. Kernel 7.2.4 therefore never 
ran while the actual trigger was present. The per-day counts I sent are 
real, but the kernel is not what distinguishes them.

What it actually is

A second client on the same AP misses beacons at the same instants: an 
older laptop with an Intel chipset running iwlwifi on an older kernel. 
Cluster boundaries from both machines' journals:

                    old client (iwlwifi)    current client (ath12k)
   cluster 1        16:08:15 - 16:14:42     16:08:27 - 16:13:04
   cluster 2        20:25:46 - 20:36:37     20:26:30 - 20:31:53
   cluster 3        00:41:41 - 00:48:20     00:42:02 - 00:47:14

Two vendors, two drivers, two kernels, same seconds. The iwlwifi side 
logs exactly the condition I measured on the ath12k side:

   iwlwifi 0000:04:00.0: missed beacons exceeds threshold, but receiving 
data.
                         Stay connected, Expect bugs.
   iwlwifi 0000:04:00.0: missed_beacons:19, missed_beacons_since_rx:1

So the beacons genuinely are not arriving, for both clients, and my 
measurement that unicast data keeps flowing at normal latency throughout 
still stands - it just means the AP (or something in the environment) 
stops delivering beacons while continuing to serve data. The clusters 
recur on a free-running ~4h17m period whose phase survives reboots and 
power-off, which also points away from anything on the client. I am now 
investigating the AP, an AVM FRITZ!Box 5690 Pro.

The one thing that may still be of interest

iwlwifi has explicit tolerance for this situation and stays associated 
when beacons are missing but data is being received. ath12k has no such 
tolerance and tears the connection down after the mac80211 timeout, 
costing about 10 s of connectivity each time - in my case 20-28 times a 
day while the environment misbehaves.

I am not reporting that as a bug, and I am not asking for it on the 
strength of one site. But if a similar relaxation is considered 
reasonable for ath12k, it would have turned a visible outage into a 
logged warning here. Happy to test anything in that direction.

Again, sorry for the misdirected report. The measurements in it are 
sound; the conclusion was not.

Regards,
Izzet Beltir
