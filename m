Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:41484 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752474Ab2ECR3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 13:29:48 -0400
Message-ID: <1336066186.13866.25.camel@joe2Laptop> (sfid-20120503_192953_180410_162E4589)
Subject: Re: pull request: wireless-next 2012-05-03
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Thu, 03 May 2012 10:29:46 -0700
In-Reply-To: <20120503.131707.112550136096227430.davem@davemloft.net>
References: <20120503152206.GL9285@tuxdriver.com>
	 <20120503.130516.1008806127286088740.davem@davemloft.net>
	 <20120503.131707.112550136096227430.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-03 at 13:17 -0400, David Miller wrote:
>  ...
> -		if (hdev->discovery.type == DISCOV_TYPE_INTERLEAVED) {
> +		if (hdev->discovery.type == DISCOV_TYPE_INTERLEAVED &&
> +				hdev->discovery.state == DISCOVERY_FINDING) {
> 
> Really, we went through this a million times very recently and I'm
> not pulling anything into my tree that has garbage like this in it.

Perhaps the bluetooth folk can adopt using

scripts/checkpatch.pl --strict

or maybe checkpatch could be changed to use
--strict on patches in net and drivers/net
automatically.


