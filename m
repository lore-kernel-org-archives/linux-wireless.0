Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:32686 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZFCTwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 15:52:19 -0400
Received: by wf-out-1314.google.com with SMTP id 26so136523wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2009 12:52:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0906031121xfb76641h3137f53ed5c8a792@mail.gmail.com>
References: <661650.46971.qm@web55304.mail.re4.yahoo.com>
	 <45e8e6c40906020958x3de155acx1011452051c9e96@mail.gmail.com>
	 <40f31dec0906031121xfb76641h3137f53ed5c8a792@mail.gmail.com>
Date: Wed, 3 Jun 2009 12:52:20 -0700
Message-ID: <45e8e6c40906031252x7f22a1c1mf4fb4a9612eb5ce0@mail.gmail.com>
Subject: Re: ath9k/ath5k + 80211s crash
From: Andrey Yurovsky <andrey@cozybit.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: austinxxh-ath9k@yahoo.com, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 3, 2009 at 11:21 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2009/6/2 Andrey Yurovsky <andrey@cozybit.com>:
>> With wireless-testing from a couple of days ago, an X86 system, and this patch:
>> http://osdir.com/ml/linux-wireless/2009-05/msg01241.html
>> ath9k can bring up a mesh point interface and doesn't crash for me,
>> but there are no mesh beacons, so mesh isn't working.  On ath5k, there
>> are also no beacons and mesh doesn't work, but there's no crash.
>>
>
>
> Hmm, try adding NL80211_IFTYPE_MESH_POINT here ->
>
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/pcu.c;h=ec35503f6a40e6b6a1cc4323287b31e7cdd3a428;hb=HEAD#l733

It's already there, in ath5k_hw_set_opmode.  We'll need to trace
what's going on and see why we don't get beacons.  Last night I had an
ath5k MP suddenly start beaconing but I haven't been able to reproduce
that yet.

Xiao -- to test beaconing, I set up a second network interface in
monitor mode and capture frames with wireshark, in my case that's on a
separate PC.
