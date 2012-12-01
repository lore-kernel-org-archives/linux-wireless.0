Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:45632 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531Ab2LAXxN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Dec 2012 18:53:13 -0500
Date: Sat, 1 Dec 2012 18:53:07 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Tejun Heo <tj@kernel.org>
cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"John W. Linville" <linville@tuxdriver.com>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Wireless regression in workqueue: use mod_delayed_work() instead
 of __cancel + queue
In-Reply-To: <20121201143926.GB2685@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1212011852100.25064@dr-wily.mit.edu> (sfid-20121202_005338_741876_F2C9DCCB)
References: <alpine.DEB.2.00.1211280953350.26602@dr-wily.mit.edu> <alpine.DEB.2.00.1211281016320.26602@dr-wily.mit.edu> <20121130211435.GJ3873@htj.dyndns.org> <20121130225619.GD6021@htj.dyndns.org> <alpine.DEB.2.00.1211302234410.25064@dr-wily.mit.edu>
 <20121201143926.GB2685@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 1 Dec 2012, Tejun Heo wrote:
> Can you please test this one too?  Thanks!
> 
> […]
> +	if (!delay) {
> +		__queue_work(cpu, wq, &dwork->work);
> +		return;
> +	}
> +
> […]
> -	if (!delay)
> -		return queue_work_on(cpu, wq, &dwork->work);
> -

Yes, this one fixes the bug too (on v3.7.0-rc7).

Anders
