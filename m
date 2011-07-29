Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16149 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab1G2DCQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 23:02:16 -0400
Message-ID: <4E3222B6.1010904@gnu.org> (sfid-20110729_050224_217380_ED8FC73F)
Date: Thu, 28 Jul 2011 23:02:14 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] lib80211: call try_module_get() in lib80211_get_crypto_ops()
References: <20110729025007.7889.19879.stgit@mj.roinet.com>
In-Reply-To: <20110729025007.7889.19879.stgit@mj.roinet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/28/2011 10:50 PM, Pavel Roskin wrote:
> Doing it by the caller is racy.  Some callers neglected to do so.  Fix
> callers not to call try_module_get() after lib80211_get_crypto_ops().
>
> When ops is copied, move lib80211_crypt_delayed_deinit() after
> try_module_get() to avoid the risk that the module would be unloaded
> between those calls.
>
> Signed-off-by: Pavel Roskin<proski@gnu.org>

Sorry, please ignore this patch!  I didn't mean to send it.  It's not 
complete, and I don't think I'll have time to fix it :(

lib80211 has a terrible API, and the module referencing is split between 
lib80211 and the callers.  Everything is too complicated.  Keys may be 
freed asynchronously.  Module referencing is tied to the keys and not to 
the ops.  I've seen the reference count for lib80211_crypt_ccmp to 
underflow and become 4294967295 or something.

Considering that lib80211 is only used by old modules, I'm even thinking 
of making lib80211_crypt_* modules not unloadable.  It's too much work 
to fix.

What I actually intended to send is "lib80211: remove exports for 
functions not called by other modules".  That "simplifies" the API a 
little bit.

-- 
Regards,
Pavel Roskin
