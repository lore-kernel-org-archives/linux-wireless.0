Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1JLIWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 04:22:23 -0400
Subject: Re: [RFC 03/07] compat-wireless: Enable changing regulatory domain
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: "linux-wireless.vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>,
	Johan Lilje <johan.lilje@stericsson.com>
In-Reply-To: <op.v27rusy7ya27un@edmitar> (sfid-20111012_030250_401722_D3C10EDB)
References: <op.v27rusy7ya27un@edmitar>
	 (sfid-20111012_030250_401722_D3C10EDB)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 10:22:20 +0200
Message-ID: <1318407740.3933.19.camel@jlt3.sipsolutions.net> (sfid-20111012_102227_572668_E401EBF1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-12 at 03:02 +0200, Dmitry Tarnyagin wrote:
> From: Johan Lilje <johan.lilje@stericsson.com>
> Date: Tue, 2 Aug 2011 09:21:49 +0200
> 
> If compat-wireless code is compiled into the kernel,
> first request regulatory hint fails to return since
> userspace is not ready yet.
> Added timeout mechanism to remove old pending requests.

Completely wrong description. Make your patches apply to the kernel, not
compat-wireless.

> + * @timestamp: stores the time when this request calls crda, to enable
> + *	timeout mechanism.
>    * @list: used to insert into the reg_requests_list linked list
>    */
>   struct regulatory_request {
> @@ -70,6 +72,7 @@ struct regulatory_request {
>   	bool intersect;
>   	bool processed;
>   	enum environment_cap country_ie_env;
> +	struct timespec timestamp;

Seriously? You've gotta be kidding. WAAYY overkill to use timespec. Just
use jiffies.

johannes

