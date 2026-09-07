Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9862C3914E5
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 16:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788799134; cv=none; b=GJMJuSOOFMz6x+JqxICJXhTezs9IT/+qF9tj35q/1ZpSKxPLRo5pud2sDvZERjtllJBBJnP8L4uc5Lt7gEQzqd8v65GLkODczXizyxqBeEZy2accxFOM5hAM5kqX70PpkLfhnCP2CPpwd4jS7fz9UnlcUbCgqG9aYGC25DSWp0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788799134; c=relaxed/simple;
	bh=5LqMRlch5+/GZfJ7sEWpuRoO8UgPtc1QbDoLUNsJtE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jeA8NT89k2q5suFayo/e1fw9BBOi3CmSt0/0eS7/3DdiPvMOdfINrSeRGCyYS7sD/esuv5Jg46YbUggxbqFILlDw3tVN3A8RWXi/01AfQ7ZHXkoida9Pvl1TN5XPgEynKAAts78gCwcrYFy0x2jYM0WdYxoPMZvJ0mnDUaAjtJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=Swuw94Ho; arc=none smtp.client-ip=148.163.129.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="Swuw94Ho"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EA4C02C22BD
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 16:38:51 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id DE5BB780067;
	Mon,  7 Sep 2026 16:38:43 +0000 (UTC)
Received: from [192.168.3.187] (unknown [98.97.32.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 54E4913C2B0;
	Mon,  7 Sep 2026 09:38:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 54E4913C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1788799123;
	bh=5LqMRlch5+/GZfJ7sEWpuRoO8UgPtc1QbDoLUNsJtE8=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Swuw94HouUn3rHjGHZjaTM6SWoS/RPeX8PTyibTbwLKa6iVcQyHOi2021HE5hnvq/
	 bHks+Dnl1v6f4AxS9PUrYGOtBpBXNSTkdTXtusuYPaf/qZv5VzcYsoAE/knTO3CUSO
	 IrNXxwEFXsoAMWoRzJ+fxjI+Su1gCQMDRhpuxLCw=
Message-ID: <81a437a9-4ffd-4d6d-84c9-c093af5c46a5@candelatech.com>
Date: Mon, 7 Sep 2026 09:38:42 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: cfg80211: avoid holding rtnl_mutex across all
 cfg80211_leave() calls
To: =?UTF-8?Q?=C3=96mer_Mete_Kaya?= <omermetekaya0@gmail.com>,
 linux-wireless@vger.kernel.org
References: <20260903151542.486376-2-omermetekaya0@gmail.com>
 <20260906002657.620076-1-omermetekaya0@gmail.com>
 <20260906002657.620076-2-omermetekaya0@gmail.com>
Content-Language: en-MW
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <20260906002657.620076-2-omermetekaya0@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-MDID: 1788799124-KOa7Nc3i9Jw6
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1788799124;KOa7Nc3i9Jw6;<greearb@candelatech.com>;de889796e53c34c4d532d20f77e1c862
X-PPE-TRUSTED: V=1;DIR=OUT;

On 9/5/26 5:25 PM, Ömer Mete Kaya wrote:
> reg_check_chans_work() holds rtnl_mutex for the entire duration of
> iterating over all registered devices and calling cfg80211_leave() on
> each invalid wdev. cfg80211_leave() can be slow (disconnect, stop AP,
> leave mesh), causing rtnl_mutex starvation when many wireless interfaces
> are present. This results in tasks waiting for rtnl_mutex for longer
> than hung_task_timeout_secs:
> 
>    INFO: task hung in inet_rtm_newaddr
>    INFO: task hung in inet6_rtm_newaddr
>    INFO: task hung in nsim_destroy
>    INFO: task hung in tun_chr_close
>    INFO: task hung in switchdev_deferred_process_work

Hello Omer,

Considering that maybe something has mis-diagnosed the problem, could you share details of the stack traces of
the hung processes and lockdep output to see if the hang is actually elsewhere?  What kernel version are you
testing?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
