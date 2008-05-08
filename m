Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:26833 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbYEHStu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 14:49:50 -0400
Received: by fk-out-0910.google.com with SMTP id 18so925499fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2008 11:49:48 -0700 (PDT)
Message-ID: <8704f27d0805081149wa91072en32ce8912ba1a14ff@mail.gmail.com> (sfid-20080508_204851_997602_89CCF9AA)
Date: Thu, 8 May 2008 21:49:43 +0300
From: "Emmanuel Grumbach" <egrumbach@gmail.com>
To: "Volker Braun" <vbraun@physics.upenn.edu>
Subject: Re: dynamic wep with mulitple keys
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <1210271472.30724.43.camel@carrot.hep.upenn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1208969544.3312.5.camel@localhost.localdomain>
	 <1ba2fa240804231015r41e7d7f5ocf7d78af72fb4622@mail.gmail.com>
	 <8704f27d0805050735s647ac4aaq469630bde6bc341e@mail.gmail.com>
	 <1210003121.11809.10.camel@carrot.hep.upenn.edu>
	 <8704f27d0805052346u24954211l6f55513c78205586@mail.gmail.com>
	 <1210271472.30724.43.camel@carrot.hep.upenn.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 8, 2008 at 9:31 PM, Volker Braun <vbraun@physics.upenn.edu> wrote:
> Here is more data on my problem with dynamic wep.
>
Thanks for that !

> compat-wireless-2008-05-07 + iwl4965 + swcrypto=1: Associates and
> obtains dhcp lease, works fine.
>
> So it really is about the HW accelleration. I tried your patch (without
> swcrypto=1). First, output of wpa_supplicant:
>

Yep...

> Your patch yields:
>
> May  8 14:03:54 localhost kernel: iwl4965: enable hwcrypto key sta=31 alg=0,keyid=1 static_key=1
> May  8 14:03:54 localhost kernel: iwl4965: enable hwcrypto key sta=0 alg=0,keyid=3 static_key=0
>

sta_id 31 is the broadcast station => key_idx = 1 for bcast station
This really proves what Tomas said: you get the unicast key after the
groupkey. Quite strange, we thought it couldn't happen, and actually,
we hadn't any use case that led to this scenario. I am not sure I will
be able to reproduce the bug here, in any case, I understand what the
issue is and will try to send a patch shortly (next week)

> Should static_key not be the other way round (key_idx 3 is unicast)? In
> any case, after a while the broadcast key gets updated: wpa_supplicant
> says
>

{...}

This is likely because your AP is configured to rekey the groupkey
every ... minutes. So the groupkey is updated.

> May  8 14:05:10 localhost kernel: iwl4965: enable hwcrypto key sta=31 alg=0,keyid=2 static_key=0

Yep, the idx of the group key is now 2 (it was 1 before)

> May  8 14:10:30 localhost kernel: iwl4965: disable hwcrypto key sta=31 alg=0,keyid=1 static_key=1
> May  8 14:10:30 localhost kernel: iwl4965: enable hwcrypto key sta=31 alg=0,keyid=1 static_key=0

See ? now the group key idx and 1 again. This is normal, this the way
the AP switches between the keys:

1, 2, 1, 2, ....
wpa_supp first install 1, then 2, then removes one (the disable
hwcrypto line) and updates the "new" 1 etc....


thanks

-- 
Emmanuel Grumbach
egrumbach@gmail.com
