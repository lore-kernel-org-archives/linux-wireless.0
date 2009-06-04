Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:39277 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZFDRmZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 13:42:25 -0400
Received: by yw-out-2324.google.com with SMTP id 5so539375ywb.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2009 10:42:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0906031259u1a9c4b0dh977cade85bded168@mail.gmail.com>
References: <661650.46971.qm@web55304.mail.re4.yahoo.com>
	 <45e8e6c40906020958x3de155acx1011452051c9e96@mail.gmail.com>
	 <40f31dec0906031121xfb76641h3137f53ed5c8a792@mail.gmail.com>
	 <45e8e6c40906031252x7f22a1c1mf4fb4a9612eb5ce0@mail.gmail.com>
	 <40f31dec0906031259u1a9c4b0dh977cade85bded168@mail.gmail.com>
Date: Thu, 4 Jun 2009 10:42:27 -0700
Message-ID: <45e8e6c40906041042p7e9986fauf993fed27e95e2c5@mail.gmail.com>
Subject: Re: ath9k/ath5k + 80211s crash
From: Andrey Yurovsky <andrey@cozybit.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: austinxxh-ath9k@yahoo.com, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 3, 2009 at 12:59 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2009/6/3 Andrey Yurovsky <andrey@cozybit.com>:
>> On Wed, Jun 3, 2009 at 11:21 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>>> 2009/6/2 Andrey Yurovsky <andrey@cozybit.com>:
>>>> With wireless-testing from a couple of days ago, an X86 system, and this patch:
>>>> http://osdir.com/ml/linux-wireless/2009-05/msg01241.html
>>>> ath9k can bring up a mesh point interface and doesn't crash for me,
>>>> but there are no mesh beacons, so mesh isn't working.  On ath5k, there
>>>> are also no beacons and mesh doesn't work, but there's no crash.
>>>>
>>>
>>>
>>> Hmm, try adding NL80211_IFTYPE_MESH_POINT here ->
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/pcu.c;h=ec35503f6a40e6b6a1cc4323287b31e7cdd3a428;hb=HEAD#l733
>>
>> It's already there, in ath5k_hw_set_opmode.  We'll need to trace
>> what's going on and see why we don't get beacons.  Last night I had an
>> ath5k MP suddenly start beaconing but I haven't been able to reproduce
>> that yet.
>
> 736         /* When in AP mode zero timer0 to start TSF */
> 737         if (ah->ah_op_mode == NL80211_IFTYPE_AP)
> 738                 ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
>
> We need to do this for NL80211_IFTYPE_MESH_POINT or DBA won't fire up
> and beacon queue wont start...

Thanks Nik, that gets beaconing going but only after a issuing a scan
(we have the same problem on rt2x00).

> --
> GPG ID: 0xD21DB2DB
> As you read this post global entropy rises. Have Fun ;-)
> Nick
>
