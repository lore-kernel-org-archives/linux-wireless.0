Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:48233 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab3K0PnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 10:43:04 -0500
Message-ID: <529612E8.4010602@open-mesh.com> (sfid-20131127_164327_955014_1F13209D)
Date: Wed, 27 Nov 2013 16:42:32 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k pending patches
References: <1385547828-4330-1-git-send-email-sujith@msujith.org>	<21141.51790.303263.385517@gargle.gargle.HOWL>	<5295E60D.90600@open-mesh.com> <21142.3512.516720.706589@gargle.gargle.HOWL>
In-Reply-To: <21142.3512.516720.706589@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 27/11/13 16:20, Sujith Manoharan wrote:
> Antonio Quartulli wrote:
>> What patch is addressing this change? And can could please
>> explain a bit more about what is needed to address the key cache
>> corruption problem?
>> 
>> Right now I am working on a "reactive behavior" which tries to
>> detect a cache corruption event and subsequently re-install all
>> the keys one by one to ensure they are back to a proper state.
>> 
>> What does this ALWAYS_PERFORM_KEY_SEARCH bit do? Is it set within
>> the initvalues?
> 
> Normally, key search for decryption is done by the HW only for the
> first frame in an aggregate. Enabling ALWAYS_PERFORM_KEY_SEARCH
> makes the HW do a key lookup for each sub-frame in aggregate.
> 
> This is one step in addressing the key cache corruption problem,
> but it comes at a cost. The HW MAC is stressed more when this bit
> is enabled, especially when the number of associated clients is
> high.
> 
> This issue was first seen in AR9300 and I don't think it has been 
> fixed in any later chip since the workaround of enabling
> ALWAYS_PERFORM_KEY_SEARCH works fine in actual usage.
> 

I understand, thanks for the explanation.

> But, in some high-interference environments, the key cache gets
> corrupted and large number of decrypt errors are seen. The root
> cause is not known and the workaround is to set all the keys in the
> HW again, when this happens.
> 
> Still, this is not sufficient and sometimes decrypt errors are not
> received at all from the HW, since the flags in the RX descriptor
> are mangled, so just monitoring the RX path in the driver is not
> enough and a periodic timer comparing the HW keys with the driver
> is needed. If any mismatch is seen, the keys are programmed again
> in the HW.
> 


If we are lucky enough the cache may also end up with a correct RX key
and a broken TX one (talking about TKIP). In this case I see no way to
fix it other than a periodic worker.


> So, if ALWAYS_PERFORM_KEY_SEARCH is enabled, we need to see how the
> driver/HW performs with 16 associated clients or more. Internally,
> it was enabled on a per-project basis, but it has been enabled by
> default recently. But, I think this should be tested properly.
> 
> As for the RX-path/timer workaround, it's just a nasty hack. :-)
> 


Eheh, I'll send a patch as soon as I come up with a clean version of
this "hack".


Thanks a lot for all the information!!


Cheers,


- -- 
Antonio Quartulli
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSlhLoAAoJEADl0hg6qKeOQJEP/RBXP1Yji1TdwU+LjXc7Vihq
fEA/VvRazgAjNwNOxOUF7WcgH+iRsyLwKt83ztwnpcdzI/1aXFUXcSSP1CkyOWGb
K9d6KZfMO+LFyO277a/PZfZ4SniEHJeHyJ+5HFbqmm3jvZi8FRvNNMnwCt/inMam
rE3uGR6XC/UIKQNKhFH69fGVJIdYE6aTxdm3QNYf0WGdaSuL/9Q6qBoGQ6SAP4FT
sh7pZcWFjZzD2/CV24zvSiu6ZDjw6yUkyKYPAQNJpx3mGg9NLXY3CLmsedjJuyU2
QvtBZNKZLIub9+9EbaXTwH2qH6ccSpucPb1EzED+mpybBPeF0CBcCZK78D2LtuEt
49xmqmw+V9KzttFIEUyO5D3/6/9e67pEFO2Ucn7Hh1w7aYooyhtKD7yltUP5hrIY
sDnziTvm4o4JoM5CVdJg5lNbLAFRM8xA7ppII8gD3r+Z8KDELv8ZTK2QyVt8zNyX
LO6/X1s8CMCFvmm83v3xl+QylyKTYAV1FG5aO+OhKWdNEUuD3ol1MGtG2mjJGSl0
pLsKoE3c709k4hksKTkvQiZ19CZOee3IQWwMUTEKzcU12JhpeHOH876QwaonjDli
Rh5RlukEVXXDOkluoS1uTkNW6dwoH6HeyBHHVQK2tLvTakXth1j6LY3st5IdQVI6
gyfWbi/yeiUg3gF8YfNC
=I+Oe
-----END PGP SIGNATURE-----
