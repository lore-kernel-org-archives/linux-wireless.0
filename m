Received: from mail.ionic.de (ionic.de [145.239.234.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD59E1E7C18;
	Sat, 19 Sep 2026 15:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.234.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789833331; cv=none; b=iCvDWmdHFUT5EW/mVj4YuWk+HaiuyooRlVuMqkR7omSLk4b8EDtC/xEUH6Qd1W0OIVQ4m19s8aT17e5ieEFHZ2zcYP4FG52Ufag8Wi9vpHa5kcLIOgWOEvZMIV/AQC7c/IVX4YidWqgcacT9ljsZTHq6GTzvp/KS+0DC72Zykvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789833331; c=relaxed/simple;
	bh=adUDFqO22StJ6ilTA57a3K94u917eEMrpj1AlJLZDrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eUO6W6OI6DynnuUi5t+eUxUE4liFyXPVSBxpLEsO3jhfXWFaJCUP++8ssa0yMNgAob83ra4vi3yplBpcVfTbircQgueWrkRv5aq+vcxONtYp7ijCKnbkiv1ZBpLC97YuDDC79ZjPCllMKRtQwfl5k0M4Db/A5MPFt1WmAZV1Mw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ionic.de; spf=pass smtp.mailfrom=ionic.de; dkim=pass (1024-bit key) header.d=ionic.de header.i=@ionic.de header.b=MHqaz3MO; arc=none smtp.client-ip=145.239.234.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ionic.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionic.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ionic.de header.i=@ionic.de header.b="MHqaz3MO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ionic.de; s=default;
	t=1789832738; bh=adUDFqO22StJ6ilTA57a3K94u917eEMrpj1AlJLZDrE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MHqaz3MOS0UJVLgEDnlQ0sUPeaydyOSC8WzdXtCWrEQwlUAL+C/I2KMthIoGENSOP
	 uDwWLSddV34njdRoxXiBUGoL9/opSYuroBEXHhtRpncCZfFnjSyeTz0O174TcqzQkp
	 CwlaGNYfCSVyjJ39li9HkDfARb8gaw4hY49OdNIE=
Received: from [172.24.215.49] (unknown [185.102.219.57])
	by mail.ionic.de (Postfix) with ESMTPSA id 9FBCC1480E15;
	Sat, 19 Sep 2026 17:45:38 +0200 (CEST)
Message-ID: <a13e783a-1c55-4e9d-92e0-634f8fbb10d1@ionic.de>
Date: Sat, 19 Sep 2026 17:45:37 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] wifi: ath12k: Connect to the QMI server belonging to
 the device owned by this driver
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
 Manivannan Sadhasivam <mani@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Jeff Johnson <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, ath12k@lists.infradead.org,
 Bjorn Andersson <andersson@kernel.org>,
 Chris Lew <christopher.lew@oss.qualcomm.com>,
 Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
 Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
 Jeff Hugo <jeff.hugo@oss.qualcomm.com>, david@3adesign.co.uk,
 nakonechnij.sergsj@gmail.com
References: <20260918-qrtr-multi-ep-v1-0-8a06caa368d3@oss.qualcomm.com>
 <20260918-qrtr-multi-ep-v1-4-8a06caa368d3@oss.qualcomm.com>
 <cb6766f8-54b9-435f-a69a-e712727dabdb@app.fastmail.com>
Content-Language: en-US
From: Mihai Moldovan <ionic@ionic.de>
Autocrypt: addr=ionic@ionic.de; keydata=
 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
 tS48DBVD
In-Reply-To: <cb6766f8-54b9-435f-a69a-e712727dabdb@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

* On 9/18/26 18:51, Juha-Matti Tilli wrote:
>> But now, QRTR provides each MHI endpoint a unique node id which is
>> different from the node id announced by the device. So use the same id to
>> pick the correct server. Add a get_qrtr_node_id() HIF callback that returns
>> the node id derived from the MHI controller index and zero for transports
>> that do not assign one. In the new_server callback, skip any service whose
>> node id does not match. A node id of zero disables the check, so transports
>> that do not assign one keep their current behavior.
>>
>> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> CC'ing Mihai. He is known to have a platform with two ath12k cards,
> but he said he's been busy recently, so his testing input is uncertain.

I probably could change the setup to use 2 x ath12k modules, yes, but really I 
have always been testing with one module using ath11k and the other module using 
ath12k. Never tested two ath11k or ath12k at a time. There might be even more 
obstacles to getting that to work correctly.

My "test setup" is in the new flat where I don't have a proper networking setup, 
though, so... meh. Don't count on me testing it this year still.

The proposed code looks simple enough, though, and generally makes sense. It 
also does away with aux data on the qrtr socket, and if both endpoints can 
access the same MHI data, it probably makes sense to let them both determine the 
node ID via the shared MHI controller index (the important part here is that the 
node ID knowledge is not stored or passed through anywhere in a common qrtr data 
structure, but essentially becomes a "shared secret" that both end points 
determine individually, but also in a deterministic, matching way).

Since this changes the endpoint ID completely, this might even make the 
user-space qrtr tools work transparently with multiple devices, i.e., not 
requiring any changes to that part. That would be my hope at least. Definitely 
needs testing, though. It would be great if the user-space tools could directly 
communicate with the servers on the modules, but I'm not quite sure how the 
user-space tools would come to the correct node ID conclusion. This might be one 
drawback of the "shared knowledge" architecture - it might be difficult to make 
it work outside of the driver realm.


Indeed a cleaner and more simple approach, though.



Mihai
