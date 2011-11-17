Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43972 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab1KQXFP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 18:05:15 -0500
Message-ID: <4EC59321.5000806@hauke-m.de> (sfid-20111118_000519_624624_FD18189A)
Date: Fri, 18 Nov 2011 00:05:05 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: mcgrof@gmail.com, mcgrof@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] compat: backport kfree_rcu()
References: <1321564991-7249-1-git-send-email-hauke@hauke-m.de>	 <1321564991-7249-2-git-send-email-hauke@hauke-m.de> <1321568836.3997.53.camel@jlt3.sipsolutions.net>
In-Reply-To: <1321568836.3997.53.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2011 11:27 PM, Johannes Berg wrote:
> On Thu, 2011-11-17 at 22:23 +0100, Hauke Mehrtens wrote:
> 
>> +#undef module_exit
>> +#define module_exit(exitfn)						\
> 
>> +	static inline exitcall_t __exittest(void)			\
>> +	{ return exitfn; }						\
> 
> This is not necessary since the exitfn() below will already create a
> compile error if you try module_exit(no_such_function).
This check is not needed, I will remove it. We get the code from the
kernel and it should compile. Most of the tests this function does are
also done by our real function.
> 
>> +	void __exit __exit_compat(void)					\
>> +	{								\
> 
> Shouldn't that be static?
Yes it also works when it is static I changed that.
> 
> johannes
> 
> 

Hauke

