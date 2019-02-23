Return-Path: <SRS0=o7U+=Q6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D720C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 21:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5D462086A
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 21:12:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="UOXQGkDf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbfBWVMD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:12:03 -0500
Received: from 19.mo4.mail-out.ovh.net ([87.98.179.66]:56544 "EHLO
        19.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729188AbfBWVMC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Feb 2019 16:12:02 -0500
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Feb 2019 16:11:59 EST
Received: from player795.ha.ovh.net (unknown [10.109.159.139])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 137331D5E8A
        for <linux-wireless@vger.kernel.org>; Sat, 23 Feb 2019 22:02:57 +0100 (CET)
Received: from awhome.eu (p57B7E5A0.dip0.t-ipconnect.de [87.183.229.160])
        (Authenticated sender: postmaster@awhome.eu)
        by player795.ha.ovh.net (Postfix) with ESMTPSA id 99CFB2F5F62B;
        Sat, 23 Feb 2019 21:02:56 +0000 (UTC)
Subject: Re: [RFC PATCH v3 03/12] mac80211: IEEE 802.11 Extended Key ID
 support
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1550955774;
        bh=4PqiA+Ngcr8ZgxFCYye2FO8sCUC69NK83OdBMpeLd0Y=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=UOXQGkDfu2JKeCRvYygQnW3un0N4M1IRy1y14ePVOmJ1j4FseQ6qpj7IzQmYC6rWt
         tskr+wmpIg+9GGoeh8KdMe1PLulHiq/QmzJUQYbKTqO1TjZxnTUj83cNXdNDB3Ju9z
         43723WbcWfalGZ8fdL1ySK5T2etTz4/Xnpthsm60=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-4-alexander@wetzel-home.de>
 <f4d8db23bc3804fdc98f2ce7a702215bd82fd4e3.camel@sipsolutions.net>
 <e27bffe8-4c75-34d9-b326-39ffb05b73eb@wetzel-home.de>
 <171d2db4-7639-4738-2a6d-c899f0247aee@wetzel-home.de>
 <767ada740d984e180d0ac799487722293a50367c.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <440ae537-52d9-aa36-8b6b-17c2616fb4f9@wetzel-home.de>
Date:   Sat, 23 Feb 2019 22:02:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <767ada740d984e180d0ac799487722293a50367c.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 13042705999655148743
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddruddvgddugeejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


>>>>> +    key->flags &= ~KEY_FLAG_RX_ONLY;
> [snip]
>>>>> +    if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
>>>>> +        ret = drv_set_key(local, EXT_KEY_RX_TX, sdata,
>>>>> +                  &sta->sta, &key->conf);
>>>>> +        if (ret) {
>>>>> +            sdata_err(sdata,
>>>>> +                  "failed to activate key for Tx (%d, %pM)\n",
>>>>> +                  key->conf.keyidx, sta->sta.addr);
>>>>> +            return ret;
>>>>
>>>> You've already cleared the RX_ONLY flag, which gets you inconsistent
>>>> data now.
>>>>
>>>
>>> I don't think so, it looks ok for me. But the delay_tailroom logic took
>>> a surprisingly large chunk of time and I should explain how the updated
>>> logic is intended to work. Maybe I've messed it up somehow and just do
>>> not see it:
> 
> My comment wasn't related to tailroom accounting at all. I've snipped
> more code above to hopefully make it clearer.
> 
> If you fail to activate the key in the driver, then the key is not
> actually enabled for TX, and thus you should not have cleared the
> KEY_FLAG_RX_ONLY? You'll be returning this error all the way to
> userspace, I assume.
> 
> (Maybe, btw, the driver should be allowed to return something like
> "oops, I now want to use TX software crypto" like it can do for other
> operations?)

Yes, an error here will get passed through to the userspace.

I think I mentioned already that tailroom update really got tricky with 
Rx only keys and I'll also add some comments to help understanding better:-)

Here a more verbose version to verify the logic:

An error here will abort the key install and at the end that will 
disconnect the sta. But don't forget that the key at that moment was 
already installed successfully to the driver as a Rx only key and in 
most cases the driver is already "ready" to use Tx with that key. 
Mac80211 is just not handing over any MPDUs for that key.

A "normal" key install would already have increased the tailroom needed 
count at that time, we just skipped that since a Rx only key never can 
have use for a tailroom and it's now time to update the count if needed 
for Tx.

If that call to the driver here fails mac80211 may have a different 
understanding of the key RX/TX status than the driver for cards similar 
to ath10k we do not care about that. While we still may be able to 
transport some packets if the driver still can handle them with the old 
Tx key the userspace will have to tear down at least the encryption and 
probably the complete association to start over. The connection is 
basically already dead and we only care about our mac80211 housekeeping, 
so in that case our delay tailroom needed count.

Allowing SW crypto fallback makes no sense, there is no way mac80211 can 
rescue the situation: Only drivers like ath10k handling the key 
selection with PN assignment themselves should need this call, all 
others just have to return 0. So for any driver needing this call 
mac80211 can't fix whatever went wrong in the driver.

Here the comments I've now add to the code for the next revision of the 
pacth: (The code itself is unchanged)

+       key->flags &= ~KEY_FLAG_RX_ONLY;
+
+       /* Dropping the KEY_FLAG_RX_ONLY flag forces us to update tailroom,
+        * do that first.
+        */
+       if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) ||
+           key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+                              IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
+                              IEEE80211_KEY_FLAG_RESERVE_TAILROOM))
+               increment_tailroom_need_count(sdata);
+
+       if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
+               ret = drv_set_key(local, EXT_KEY_RX_TX, sdata,
+                                 &sta->sta, &key->conf);
+               if (ret) {
+                       /* This is a not recoverable error, so we don't set
+                        * KEY_FLAG_RX_ONLY again or fix the tailroom needed
+                        * count here. By skipping both 
ieee80211_remove_key()
+                        * will do that for us.
+                        */
+                       sdata_err(sdata,
+                                 "failed to activate key for Tx (%d, 
%pM)\n",
+                                 key->conf.keyidx, sta->sta.addr);
+                       return ret;
+               }
+       }



Alexander
