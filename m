Return-Path: <SRS0=0lX+=SQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2477FC10F13
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 16:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2FEB20850
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 16:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="B+FAkq4h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfDNQNL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Apr 2019 12:13:11 -0400
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:43120 "EHLO
        3.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfDNQNL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Apr 2019 12:13:11 -0400
Received: from player714.ha.ovh.net (unknown [10.109.159.20])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id A25C82284D4
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2019 18:13:05 +0200 (CEST)
Received: from awhome.eu (p57B7E5B2.dip0.t-ipconnect.de [87.183.229.178])
        (Authenticated sender: postmaster@awhome.eu)
        by player714.ha.ovh.net (Postfix) with ESMTPSA id 0C9B94AD9108;
        Sun, 14 Apr 2019 16:13:03 +0000 (UTC)
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1555258382;
        bh=nimeynsG8khe1Hw6ta/LBc0PpnZvRDeok8x/Y/xqGH4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=B+FAkq4hjffGhxs1NgBVDZVjkFXdj0vtBbtmnh4yLpkWd15uHSHx81UvUx96vEypQ
         CQb2YPSUid0T1Ge65xtrbNF5GICc8aZzU6VZzf5anZ0D3owNjbYZ55uAEserSu11+w
         OmsMXivdKNkhOCBBvDL4GZJZMMRnmkx7FHGj8QLs=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-8-alexander@wetzel-home.de>
 <1a3b6e515c73a2c185e8dad84ab2ebfd8982a6ce.camel@sipsolutions.net>
 <e84c30de-28d6-7d1b-0fa3-d1ca466e257b@wetzel-home.de>
 <69e6577f90d99289acaa9853fe236e6f15f9e774.camel@sipsolutions.net>
 <14c9d8f7-7cf6-d7e1-a1c0-9f1a10920d4e@wetzel-home.de>
 <ed6e95dad39ef0ac98c62e3acd3f78fd7b3a6d2b.camel@sipsolutions.net>
 <185ea9a2-f3c6-04a5-000b-44191da5a0ee@wetzel-home.de>
 <0de9d60ffef574b34e9a76ad2cea68fab49aac0f.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <45ae97d6-3357-64ac-0a40-9ae3ea4a8ed2@wetzel-home.de>
Date:   Sun, 14 Apr 2019 18:12:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <0de9d60ffef574b34e9a76ad2cea68fab49aac0f.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 6634083728261455047
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrvdejgddutdduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> I'll take a look, but a trace-cmd recording would be more interesting
> than the monitor interface, as it also tells us when what key was
> installed etc.

I've just uploaded better captures also including traces to the same 
location. Everything relevant for this mail is in the folder
iwlwifi-debug here:
https://www.awhome.eu/index.php/s/AJJXBLsZmzHdxpX

The old traces have been moved to top dir "old", if you still are 
interested in them, but I think the new ones should be better.

1) Both AP and the STA are now running wt-2019-04-10 *without* the not 
merged patches from the Extended Key ID series. (I've only enabled 
Ext_Key_ID for mvm and dvm on top and added some printk's. The patches 
for that are also available via the link above but really boring...

2) the files with the same prefix (in the format HH:MM) show the same 
communication.
The AP files are of course from the AP, STA from the client station and 
Sniff from my Netgear 7800 used as a OTA sniffer. With the AP literally 
sitting on top of it.
The "Sniff" files can be decoded with the WPA Password "ExtKeyTestAP".

My "Hack" patch to wireshark to allow it to decode keyID 1 is also 
uploaded. (The hack just allows decoding of keyID 1 at the price of no 
longer decoding frames encrypted with gtk keyid 1.)

3) the AP is using a AC 3168NGW and the STA a AC 8265. The two devices 
are roughly 2m apart with a direct line of sight on a channel with next 
to no other traffic on it. (You see what's there in the Sniff captures, 
these are all totally unfiltered.)

4) I also tried running a trace on the STA. But I could not reproduce 
the issue when a trace was running on the STA. (That's probably 
coincidence, through, I just gave it three tries and the first without a 
trace on the STA worked.)

5) The files in the "broken" folder are showing the issue and the ones 
in "working" (seem) to be ok at a first glance.

I can run more tests and also try catch the problem with a STA trace, 
too, if you want. But that may not be necessary:

It looks like we only have a problem when we get frames with the "new" 
keyID and then again some with the "old" keyID. Of course we also could 
have multiple problems, too... But in that case I would say let's first 
look at this one.
The problematic frames are encrypted with the correct "old" key, 
according to wireshark.

But on the STA they are scrambled and therefor probably have been 
decrypted with the - in this case - wrong new key.

And as it happens there is also a really good looking first suspect why 
this may have happened:
According to the STA captures the broken frames came in one A-MPDU which 
started with keyID 1 and then "appended" the older keyID 0 frames at the 
end. (The OTA sniffer seems to be miss the A-MPDU details, see the STA 
capture...)

Now it really looks like the mvm cards are trusting the standard and 
decode all MPDUs within one A-MPDU with the same key while at the same 
time allow mixing different keyIDs in a-MPDU.

The so far mostly theoretical question how far mac80211 should support 
the driver (e.g. key ID border signal) or if we want to let the 
drivers/card handle that would become much more pressing...

Ideally the card/firmware would be able to detect that and start a new 
A-MPDU. But for my understanding the driver could also set A-MPDU to 
only one frame, forcing the firmware to flush all A-MPDUs under 
construction and then set it back to the normal value. (Or that is how 
I've planned to test that in that way with your tips in the past and 
what's documented of the mvm/dvm firmware API.)


> Please do review the privacy notes there at the end of the page if you
> do this, you should probably send the files to me/us directly rather
> than post publicly. They do contain the keys of your (test) network to
> some extent - at least of course the PTK(s)/GTK(s), but usually also the
> KEK/KCK.

Thanks for the reminder.
I'll definitely will remember the option, I was not aware that there was 
a more private way:-)

So far I can accept the risk - as I understand it - or even some short 
term intruders in my test network.

For my understanding  the previous captures (without the PSK in the 
mail) only allows brute forcing the PSK due to the 4-way handshakes.
Providing a valid handshake allows anyone to crack the PSK, without the 
challenge to capture it himself.

But risk of providing eapol frames of your network changed last year, 
the handshake is no longer required to crack the password. Anyone able 
to talk to the AP can get equivalent information by a simple query. So I 
assume sharing captures with the eapol handshakes is not impacting the 
security of my (test) Wlan in any relevant way. So I'm only giving 
everyone a small peak in my normally encrypted wlan, correct?

Here a link to the vulnerability discovered last year:
https://blog.avira.com/cracking-your-wpa2-wi-fi-password-just-became-easier/

But I've changed the PSK already for my test Wlan again from the ones 
used in the provided captures. The "real" Wlan is using EAP-TLS, the one 
I had the ptk rekey freezes some years ago:-)

Alexander
