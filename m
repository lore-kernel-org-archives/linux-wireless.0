Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="jUYSL/xO"
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F0A131;
	Tue, 28 Nov 2023 07:48:19 -0800 (PST)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id DCCB76C006B;
	Tue, 28 Nov 2023 15:48:15 +0000 (UTC)
Received: from [192.168.100.159] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 38FE813C2B0;
	Tue, 28 Nov 2023 07:48:14 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 38FE813C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1701186494;
	bh=Yixl1xyYwD8kSDiWpTPtI5+afOqah48uBPD+KUU1vdA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jUYSL/xO/6AROAbiVhpkla/xoSlLqxATnKuyWcg8R/tSSCP/kZ8LL1YNZCedeVZ6r
	 RGMtxwGqHshkalpe9iXJHTlHohCElKuoODppOle1FYUg3txO5jRLVQ40ZEHc4NBSiS
	 PC6iQk1Ffgx+Z0ARnrBjZFz9X2i8I/6kBkX+//aY=
Message-ID: <7979003a-6aa2-9af7-a3cf-d946c8e47a15@candelatech.com>
Date: Tue, 28 Nov 2023 07:48:13 -0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 0/6] fixes for debugfs/wireless locking issue
Content-Language: en-US
To: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>
References: <20231124162522.16344-7-johannes@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <20231124162522.16344-7-johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1701186497-o-mBe0zcfep9
X-MDID-O:
 us5;at1;1701186497;o-mBe0zcfep9;<greearb@candelatech.com>;491d5e7d29372e7e6a6a119117ca0c86

On 11/24/23 08:25, Johannes Berg wrote:
> There's a locking issue in wireless where it takes a lock inside
> a debugfs file handler that's also taken around the removal of
> the debugfs file, and this causes a deadlock due to the proxy
> object use. Fixing the debugfs removal is tricky because some
> of the objects represented there fundamentally are deleted with
> the lock held. Not taking the lock in the debugfs file is also
> not really the right thing to do. Therefore, right now, the only
> way to fix this would be to not have the debugfs files entirely,
> but that isn't really helpful either.

I have been running the RFC series and haven't noticed problems, so you
can add:

Tested-by: Ben Greear <greearb@candelatech.com>

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


