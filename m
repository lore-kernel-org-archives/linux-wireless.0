Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A67D52123E;
	Thu, 15 Oct 2026 13:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792070017; cv=pass; b=ePdGihZ2E0JGQE8AM7DY74xZEX2A7vkLJpVYCyohMnxk4xN9WIScaVcvXN4hH0fAEUB9v+n32WENF9/vbkLo93Y2zxyS1JxhrxxFrh3yfD35VWa/7knB+md9YYIKUlRqy+tmgHjpzpirF4+iehxVeqownwySKG66vehvCsJPLgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792070017; c=relaxed/simple;
	bh=c08mBnKV3/i60Vh//ZrjZSKzlhtxP0l+7hJOJ1D8H9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=um8D/ZwMCgZxTF/bIqBRKsVJqy9HOgv0IVMyWsuvAYLhbonPqbqZokuyQd3zk5hLSYx5TDEA+X35Bn225m4efsqeA9Gv60hpEudthlZrNRtVZPvBD5biqihtsj+t7S5HwW5Nj8GCo8R5fEXxG2Z3+c4we9+POARx/Fz8ON8vAOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net; spf=fail smtp.mailfrom=hartkopp.net; dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=JJJSVCko; dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=dYjKGlZ+; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="JJJSVCko";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="dYjKGlZ+"
ARC-Seal: i=1; a=rsa-sha256; t=1792070007; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=N5foxcyrMRO81Go3flA77mFiad602Azwjmsx6lMOhWkRC+xAoGAoQPzY1Hu8JiuXHO
    0gI+flvq7vHSAurkcOjfnHYXefhqhaBIvna9Fx4zFa69Qvxh7Fc72voss2wOUViBBYg3
    LBB5yJqz6wsz9FIU2aOKEim8SnRu0nTmtl8pp8NczzhjZtgj5qKMXY5MYHO+rqUfMFG0
    aIWC5Rrd1VDUiSbGfUh1yy57cRW5dKuu04NSlfwpoBi+r3YWussskm8++p0F4e/dGCPg
    c2cUBj6LsPsckc+rG97ZfKEAfGuHwXv0gMrpFvvKQEwoYOKl1A1SdtEp9VMOIeawKzSD
    /EpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1792070007;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5x98H03MmDqMwJs1jkMDbGaMEvUbrWs72k5aOTht/54=;
    b=Lju/uPiFjLzHhSMc5B446xJepyvl9ys42oLVUzlSWxUdzScUsmmh1UnWzKOrFOH6/E
    mUZcEioQdgdr05FKDnq5oPzIp+O1rZjxEmnkFx1eqCgFPNTCBFUchs3Tv8v1w9hRk9Uz
    zW29Gl0Fn35b6Qx4luG89rxOHXcYnFtTq3qi6+2U0ez+6GZdA9bA7oOS/+g6xgow/avi
    5DAVIzjAZz/fkoeEA+dQr8HwV/M6Z1pg3U3+BEhPPkknZpdubwbMmMsQOwaaSnBAXVbU
    RgJTTbZO6Weu9ELbjma6rEwEpIbITC1g5btxTkeO451J4aT00V1vAHNuCQtXL+kBAP2q
    Edng==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792070006;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5x98H03MmDqMwJs1jkMDbGaMEvUbrWs72k5aOTht/54=;
    b=JJJSVCkoO3e1XSstdT8TkAVPCFLGQJCEYbsTtIcayJvNerb96Vn7YxnSHArxCiY7MK
    4T0OmmRZ8/OgQq26Wp31zZL2IiET+I77o1Y9h4TBm53+gdPJy1iCd3iN1V9hztpQrKf5
    AFG7gyAhSM/Pd6u3eVbVBGdcs6C/4eNnFZCQZ+7rDv1NFsNwy0MGBz8P/KaW8Lw9QD9i
    w5SyJ7+7/bTYuSpLp1Kw5viBROiCoCposBzqKrO8xwT49PxbBmW2/bk55wEqvmVuuN9E
    cOBW1PeRiZJ2+VYJoP+4YfRsTPAIaKS9e/8hpv1ghBTuJpspxqwN0rQa2Cm6B9oABfnm
    ZK6A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792070006;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5x98H03MmDqMwJs1jkMDbGaMEvUbrWs72k5aOTht/54=;
    b=dYjKGlZ+CibCctN11qnTc9t6arEa5hJjO7gZs+yuZ1X02NAy7HQ7QyZB9pObXZJNhe
    wJEPJihBD41uN2kO8LCA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjH4JKvMdQv2tRkI16oOSW1Ti/f4Kp38="
Received: from [192.168.20.237]
    by smtp.strato.de (RZmta 55.6.3 SBL|AUTH)
    with ESMTPSA id Kfdf2a29FDDQIIv
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 15 Oct 2026 15:13:26 +0200 (CEST)
Message-ID: <88644694-66b0-499d-99ee-d0c18b53b00c@hartkopp.net>
Date: Thu, 15 Oct 2026 15:13:26 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] wireless-next-2026-10-07
To: Johannes Berg <johannes@sipsolutions.net>,
 Kuniyuki Iwashima <kuniyu@google.com>, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20261007205827.467974-3-johannes@sipsolutions.net>
 <20261007163616.1088d364@kernel.org>
 <CAAVpQUATko2Oig53r1+VHe+4Y3fFeX1xOw5RAnXtUAGwvQoB5A@mail.gmail.com>
 <44cb773984f61ae85b8c42904ef1ce7a62e85e4e.camel@sipsolutions.net>
 <51e3f9ce-fa8c-4cdb-b5bf-d05f53cb52ac@hartkopp.net>
 <7e95ff419f81425b9fa18c74f3a77208764751bb.camel@sipsolutions.net>
Content-Language: en-US
From: Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <7e95ff419f81425b9fa18c74f3a77208764751bb.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 15.10.26 14:54, Johannes Berg wrote:
> On Thu, 2026-10-15 at 14:43 +0200, Oliver Hartkopp wrote:
>>
>> On 15.10.26 14:27, Johannes Berg wrote:
>>> On Wed, 2026-10-07 at 19:05 -0700, Kuniyuki Iwashima wrote:
>>>>
>>>> Also,
>>>> I hope we could remove the long comment in __rtnl_unlock().
>>>
>>> So I sent my next PR, and we could therefore do that now. I also checked
>>> across the other places in the tree, and isotp_release() was the only
>>> one that seems to do something similar, keeping a socket pinned around
>>> rtnl_unlock(), but I don't think that could cause a similar problem.
>>
>> If I got your claim correctly, I think we are solving this in this
>> net-next PR too:
>>
>> https://lore.kernel.org/linux-can/20261015015336.816543-8-mkl@pengutronix.de/
> 
> I _think_ that's unrelated, but I might well not understand it
> correctly. I was looking at the rtnl_unlock() portion, where that could
> run a netdev todo item. Even with that change, you have
> 
> 	rtnl_lock()
> 	lock_sock()
> 	...
> 	rtnl_unlock()
> 	...
> 	release_sock()
> 
> which looks sufficiently similar to
> 
> 	rtnl_lock()
> 	wiphy_lock()
> 	rtnl_unlock()
> 	...
> 	wiphy_unlock()
> 
> that my search flagged it, but isn't really the same anyway. But I'm not
> sure I understand the socket lock semantics and the socket notifier etc.
> well enough that I should be commenting on this at all :)

Right. It really seems to be unrelated. Sorry for the noise.

Btw. the locking scheme is ok for the isotp case because after 
rtnl_unlock(), the remaining operations only affect the socket itself 
and no longer interact with any netdevices.

Best regards,
Oliver

