Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:3680 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab1G2Pzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 11:55:45 -0400
Message-ID: <4E32D7FE.9030402@gnu.org> (sfid-20110729_175548_001844_B3CD6667)
Date: Fri, 29 Jul 2011 11:55:42 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] lib80211: call try_module_get() in lib80211_get_crypto_ops()
References: <20110729025007.7889.19879.stgit@mj.roinet.com> <4E3222B6.1010904@gnu.org> <CAGRGNgWo=jgOwffbvCL5SDA6TD=cKUheObSM=23+ZTNCqH+-GQ@mail.gmail.com>
In-Reply-To: <CAGRGNgWo=jgOwffbvCL5SDA6TD=cKUheObSM=23+ZTNCqH+-GQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/28/2011 11:27 PM, Julian Calaby wrote:

> If I recall correctly, lib80211 is the last remainder of the
> pre-mac80211 wireless stack. It should be annihilated with extreme
> prejudice, but the intel centrino 2xxx drivers are so interwoven with
> it that extracting them would be a pain in the ass - and given that
> nobody who has those parts really cares, this hasn't happened.

Basically, lib80211 has no consistent API.  The callers (hostap and 
ipw2x00) get all the internals and do way too much with them.

Module refcounting is (presumably) done by the "key objects", i.e. the 
structures consisting of the keys and the operations that apply to them. 
  Something is done wrong, as there are more module puts than module gets.

But the caller also gets the ops, that is the set of encryption 
functions from a particular encryption module.  There is no locking for 
the ops.  There is no lib80211_put_crypto_ops(), that is, the caller 
never says it's not using the ops anymore.

Possible fixes are:

1) Rewrite the whole API.  Hide ops from the callers.  Enforce 
refcounting by the keys.  The keys should hold the ops, the ops should 
hold the modules.  That may be a lot of work, but the result will be 
nice.  Maybe even mac80211 could use it.

2) Fix key object based refcounting.  Ignore the fact that a crypto 
module can be unloaded at a wrong time while the caller is using the 
ops.  That may be a simple fix, but it won't be complete.  At least no 
new bugs would be introduced.

3) Same as above, but add ops-based refcounting to protect against 
crypto module unloading.  The problem is that it's hard to find the 
places where the callers stop using the ops.  The result would work 
correctly, and the changes won't be too radical.  But it's hard to get 
right.

4) Merge lib80211 and lib80211_crypt_* into one module.  That solves the 
problem completely.  Some memory would be wasted for those who use only 
one algorithm.

5) Make lib80211_crypt_* modules permanent (not unloadable).  Some 
sysadmins may be unhappy that the modules cannot be replaced without reboot.

-- 
Regards,
Pavel Roskin
