Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA7C37702E
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 20:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787518467; cv=none; b=nSQb03pRObRsGaUtk1nNEOnSBHiWC3AP3lb56/e1cRJtHQ1lzKW750aDlQvUBc4zBn887Om6SJaD9fccFnSD1nGyaFzdwj1mULaloRxpIv38UDzrOYHuIWjmJzMTfA+8k4FHRHT1yOoT7k0htEAadXaaSRyJ9Etolr7n8jIOAwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787518467; c=relaxed/simple;
	bh=93otZq6rAAbYQaN9i6pqq9XhgNIwlnrAPez4BtWjpb4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=OfUn5DpzNIL9TE8kIi/Ya1l8MVQjfAv5zQBgkdN+JHMDOwFnw+aN0IC5fIu5K9frBg/RvzixtDy59NrwZh/w+JBxkd/Fv0awA6mLHbv85SRVa1js57OjG0vANjk2eUXxQvHsQDZXHwcqy4Fs1eETM/7QIbo9TRLg59sa9eUghhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=CaGzEFyL; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="CaGzEFyL"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 18BF5240103
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 22:54:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de;
	s=1984.8680eb; t=1787518457;
	bh=rg0ATgfTep0oLRoMcT09QDRoNkBUbJEgpcpcR4SXS5s=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:Content-Type:
	 Content-Transfer-Encoding:From;
	b=CaGzEFyLT5mMFaYN9FrnBjs3KiKat9n2SZFFBsub4DAkxJX9aLCcUlIaKJ+fkFBCD
	 R2H42hGavSwOmTKCcPqp31biBJrqwUJUNE6ETw4EGNYNdbFeG93L83r/hxB9W6VUmQ
	 X888/Axv/xBOf5u7v2TY4KpZTFWKFBXuGNJeQcLrD8IVwoVUfZHz96pgiVxfWMtSm/
	 2h/zzgqYMeD/SL0V2BRdFStrbW5ZLohTTRgtipmVjujCxMQcDS2GWuOVmEmO5ALjRY
	 iKKRGZBMhRnhD2BmzfDMq0HY2rRFpp5CbQQkoe/WoTeVTDddZU5P9JjRbFmbBH9HzE
	 putnIpnwWZbVg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4hSmVv6dPXz9rxL;
	Sun, 23 Aug 2026 22:54:15 +0200 (CEST)
Message-ID: <c64f5fa6-4c61-45b6-a513-b971e59d7723@posteo.de>
Date: Sun, 23 Aug 2026 20:54:16 +0000
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [REGRESSION] mt7925: MLO connectivity silently stalls with 6GHz
 link active
From: Jonas Hort <jonas.hort@posteo.de>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>,
 regressions@lists.linux.dev, linux-wireless@vger.kernel.org,
 Felix Fietkau <nbd@nbd.name>, lorenzo.bianconi83@gmail.com
References: <503eb10e-80cf-493e-95fd-04fc0f94ce01@posteo.de>
 <e4bc5ce3-9a6f-4365-9d36-f6440ded0865@posteo.de>
Content-Language: en-US, de-DE
In-Reply-To: <e4bc5ce3-9a6f-4365-9d36-f6440ded0865@posteo.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Bisect is done. First bad commit:

ff643b81bc38eaff6c0ab783a62e4ba9e10d2476
wifi: mt76: mt7925: pass mlink and mconf to sta_mld_tlv()
Sean Wang, 2026-03-06
https://patch.msgid.link/20260306232238.2039675-4-sean.wang@kernel.org

Bisected on vanilla, path-restricted to
drivers/net/wireless/mediatek/mt76/mt7925/, using v7.0 as good and
v7.1 as bad. Each step was booted and tested with MLO active
(5GHz+6GHz, FritzBox 5690 Pro), and every "bad" verdict was confirmed
by the WFDMA0 signature (tail frozen while head keeps advancing),
not just by the connection dropping.

   ea757740dd87  pass WCID indices to bss_basic_tlv()      good (45 min 
clean)
   ff643b81bc38  pass mlink and mconf to sta_mld_tlv()     bad (freeze 
after ~4 min)
   dc019e3294c7  pass mlink to mcu_sta_update()            bad (freeze 
after ~3 min)
   9e4d518a4707  pass mlink to mac_link_sta_remove()       bad (freeze 
after ~4 min)
   cf9db836b1e0  pass mlink to set_link_key()              bad (freeze 
after ~4 min)

git bisect log and the incident logs for each step are available if
useful - happy to attach them to the bugzilla ticket or send them
here.

Let me know if you want anything else tested.

Thanks,
Jonas

Am 22.08.26 um 22:18 schrieb Jonas Hort:
> Quick update: v7.0 vanilla has been running clean for over 2 hours now 
> with MLO active (5GHz+6GHz, same FritzBox 5690 Pro), no freeze at all.
>
> Am 19.08.26 um 11:03 schrieb Jonas Hort:
>> Thanks for the detailed breakdown.
>>
>> I'll build v7.0 vanilla and test it, as suggested. Fair warning
>> though: I'm on vacation this week, so I'll pick this up next week.
>> I've also never compiled a kernel before, so it'll likely take me a
>> bit of trial and error the first time around - please bear with me
>> if it takes a little longer than expected.
>>
>> Will report back once I have results.
>>
>> Thanks again,
>> Jonas
>>
>> 19.08.2026 03:18:34 Devin Wittmayer <lucid_duck@justthetip.ca>:
>>
>>> Thank you very much, that answers both things.
>>>
>>> The ROC tracing is the more useful of the two even though it came back
>>> negative. Two of the three freezes have no ROC activity in them at 
>>> all, so a
>>> link switch that never finished cannot be what starts this. The 
>>> middle one
>>> does have rocabort, mloroc and rocwork in it, but one out of three 
>>> makes
>>> that look like the exception rather than the pattern. So the area I 
>>> sent you
>>> looking at is out, and that is worth knowing before you spend nights on
>>> builds.
>>>
>>> One other thing worth saying first. There is a five patch mt76 
>>> series on the
>>> list at the moment and two of the patches look like they were 
>>> written for
>>> exactly this bug. I do not think they were, and it is your own 
>>> numbers that
>>> show it. The failure 4/5 fixes stops mt76_txq_schedule_list from 
>>> servicing
>>> the queue, and the one 5/5 fixes stops mt76_txq_send_burst once the 
>>> non-AQL
>>> count reaches its cap. Both of those keep frames from ever reaching the
>>> hardware, so if either were your problem head would be sitting still
>>> alongside tail. Yours does the opposite. Head climbs 390 to 408 
>>> while tail
>>> stays at 260, so the frames are getting into the ring and nothing is
>>> finishing them, which is the far end of the same path. 2/5 is a use 
>>> after
>>> free when an interface goes away, so it does not fit either. I would 
>>> not
>>> expect that series to change what you see.
>>>
>>> On the bisect I would build v7.0 next. There are 32 mt7925 commits 
>>> between
>>> 7.0 and 7.1 and 19 of them are one run of work from Sean Wang, 
>>> reworking how
>>> the driver tracks the per link mlink and WCID for an MLO station. 
>>> That is
>>> the kind of change that fits a bug only showing up with two links 
>>> up. If
>>> v7.0 comes back clean, that series is where I would look. If v7.0 is 
>>> already
>>> broken then it is off the hook and 6.19 becomes the next split. The 
>>> mt76
>>> core and mac80211 both moved in the same window, so mt7925 is where 
>>> I would
>>> look first rather than the only place worth looking.
>>>
>>> Devin
>>>
>>> Am 17.08.26 um 23:34 schrieb Jonas Hort:
>>>
>>>> Quick follow-up: managed to confirm 6.18 as a clean baseline on my
>>>> own hardware now (not just secondhand from others in the forum
>>>> thread) - running Linux 6.18.42-1-cachyos-lts with MLO active
>>>> (5GHz+6GHz, same FritzBox 5690 Pro) for 3 hours straight, no freeze
>>>> at all.
>>> Am 17.08.26 um 16:25 schrieb Jonas Hort:
>>>
>>>> One correction to how I described this earlier: the connection does
>>>> NOT reliably self-heal on its own. I have manually intervened every
>>>> single time to restore connectivity [...]
>>>>
>>>> Update on the ROC tracing: three real freezes captured now with the
>>>> kprobes active (all confirmed via the WFDMA0 tail-frozen signature).
>>>>
>>>> - Freeze #1 (15:37): no ROC activity in the trace.
>>>> - Freeze #2 (15:43): [...] The trace shows several ROC events
>>>>    (rocabort, mloroc, rocwork) clustered together.
>>>> - Freeze #3 (16:15): no ROC activity again.
>>>>
>>>> Uploaded all three logs to the bugzilla ticket if useful:
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=221884
