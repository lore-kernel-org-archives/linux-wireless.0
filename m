Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:36056 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757958AbXFFNrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2007 09:47:01 -0400
Message-ID: <4666BAD3.8020903@lwfinger.net>
Date: Wed, 06 Jun 2007 08:46:59 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Joerg Pommnitz <pommnitz@yahoo.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RFC: Regulatory info in mac80211
References: <645600.8486.qm@web51404.mail.re2.yahoo.com>
In-Reply-To: <645600.8486.qm@web51404.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joerg Pommnitz wrote:
> Larry Finger wrote:
> 
> And not all regulatory information is public: as I wrote in a previous message:
> I work for a company that has special regulatory permission to use channels
> outside those freely available with tx power of up to 4W. This is a legitimate
> use case that should not be forbidden by a new regdomain framework (I can always
> hack around this, but that's just a hack, not a clean solution).

As this usage is not allowed by any other user, I think it should be forbidden. Your hack will be to 
alter the database. As I stated earlier, it will be nearly possible to prevent such hacking, there 
will always be a back door for users like you.
> 
> Regarding a user space daemon: keep in mind special use cases like NFSroot over WLAN.

This is a "chicken and egg" problem. That may require limiting such usage to the default/fallback 
configuration.

>> 3. There should be some sort of checking to verify that the database has not been hacked to modify 
>> transmission power, etc. in an illegal manner. Obviously, no foolproof means of enforcing this does 
>> not exist; however, we should prevent the crudest form of modifications.
> 
> Define "illegal manner". For me it is perfectly legal to use channel 14 in Europe with 4W tx power. I admit that this is a
> special interest, but nonetheless perfectly legal.

If I did that, it would be illegal. Similarly, if I were to hack my AP to use channel 14 in the US, 
it would be illegal at any power. These are the kinds of things that should not be easy for just any 
user to change. I certainly hope that the final result of this effort can handle your special needs 
without any kernel changes, unlike with the current version of mac80211.

Larry

