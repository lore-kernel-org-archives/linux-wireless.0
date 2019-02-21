Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F62DC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCE912083B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:55:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="JrWCboxl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfBUTzv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 14:55:51 -0500
Received: from 2.mo68.mail-out.ovh.net ([46.105.52.162]:37287 "EHLO
        2.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbfBUTzv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 14:55:51 -0500
Received: from player716.ha.ovh.net (unknown [10.109.143.225])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id 30285116C4A
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 20:47:29 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player716.ha.ovh.net (Postfix) with ESMTPSA id C69432E5C8BD;
        Thu, 21 Feb 2019 19:47:27 +0000 (UTC)
Subject: Re: [RFC PATCH v3 03/12] mac80211: IEEE 802.11 Extended Key ID
 support
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1550778446;
        bh=Gya9LfLLRIqoVbXYVu/sIJ4zGLqn9s8ZPeRkQGB4orI=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To;
        b=JrWCboxl0PXDYLvcSE8fK+miJGiSX8XFTdO3CwKOwfGDAL9MInCISDwLZsZgz64d8
         U6S79Qe2iSVg+PaHJsNf5A+8swIUu25ZOBlOl27XEgFThM/qD+ihQuNI9En/ZiM1nm
         CVMEr1pOLyjvD6GQx1itOje3pO0hlGlnp3jc3SQY=
From:   Alexander Wetzel <alexander@wetzel-home.de>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-4-alexander@wetzel-home.de>
 <f4d8db23bc3804fdc98f2ce7a702215bd82fd4e3.camel@sipsolutions.net>
 <e27bffe8-4c75-34d9-b326-39ffb05b73eb@wetzel-home.de>
Message-ID: <171d2db4-7639-4738-2a6d-c899f0247aee@wetzel-home.de>
Date:   Thu, 21 Feb 2019 20:47:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <e27bffe8-4c75-34d9-b326-39ffb05b73eb@wetzel-home.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 22517999408192711
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrtdekgddufedvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


>>>
>>>   - Enforce cipher does not change when replacing a key.
>>
>> is that actually required somehow?
> 
> The code is silently assuming a rekey is using the same cipher. Someone 
> e.g. switching from WEP to CCMP with a rekey would pass all sanity 
> checks and allow to use the code in a way never intended or tested.
> With the current handling the userspace e.g. should be able to install a 
> WEB key using keyid 3 and then rekey it with a CCMP key, claiming keyid 
> 0 bit mac80211 will copy the keyid from the old and use keyid 3. 
> Something not possible otherwise.
> 
> That said I do not see how this could be exploited, I simply try to 
> enforce all assumptions to be on the safe side. (I did not dig deeper 
> into potential exploits after finding out how keyids are used during 
> rekey.)
> 
> 
>>> + * @EXT_SET_KEY: a new key must be set but is only valid for decryption
>>> + * @EXT_KEY_RX_TX: a key installed with @EXT_SET_KEY is becoming the
>>> + *    designated Rx/Tx key for the station
>>
>> Not sure I like the EXT_SET_KEY. There's also no "designated Rx key", is
>> there? It's always selected by key ID.
>>
>> How about SET_KEY_RXONLY and SET_KEY_TX or something like that?
>>
> 
> First, you are of course right about the designated Rx key. I'll update 
> that.
> 
> Second, I spend quite some time finding good names for the calls and one 
> of the last tweaks to this patch was replacing SET_KEY_RX_ONLY to 
> EXT_SET_KEY...
> 
> So here the reasoning for why I named them as they are and why I  prefer 
> the names used in the patch.
> First, many drivers will handle SET_KEY and SET_KEY_RX_ONLY with the 
> same code and not differentiate between those at all. Using EXT_as a 
> prefix for the "normal" command is therefore a nice way to imply the 
> command can only be used with Extended Key ID and still link it to the 
> original command.
> But more important for me was the clash between what the command spells 
> and what it does in the COMPAT mode: SET_KEY_RX_ONLY would then be used 
> to install a TX only key which never can be used by the card for Rx.
> So I decided to rename it to EXT_SET_KEY, just indicating that this 
> command adds a new key to the card for Extended Key ID and drop the 
> confusing reference to Rx.
> 
> I also had a comparable problem with SET_KEY_TX:
> Most cards will already have done what must be done to use a key for Tx 
> with the first command. Only ath10k (assuming it could support Extended 
> Key ID at all) would really switch Tx with this command.
> All other drivers seem to lookup the hw key ID and use whatever key is 
> referenced there. In fact I think most NATIVE drivers won't have to do 
> anything here and just can return 0.
> Now COMPAT drivers (normally) will normally need a new special command 
> to enable Rx crypto offload for the new key. So we either would have to 
> add a new command for COMPAT drivers or accept that SET_KEY_TX is used 
> for that, again putting quite some stain an the name.
> 
> Using EXT_SET_KEY instead just implies that we are adding a new key for 
> Extended Key IDs and it's our first contact with this key.
> EXT_KEY_RX_TX is then the second contact and has to do whatever is 
> necessary to switch the added but not yet fully activated key to fully 
> activated. That COPMPAT drivers will enable Rx with it while native 
> drivers do nothing or really switch Tx with the command.
> 
> Long story short: Using SET_KEY_RXONLY and SET_KEY_TX is not wrong, but 
> I would rate them more confusing.
> 
>>> +static int ieee80211_set_tx_key(struct ieee80211_sub_if_data *sdata,
>>> +                const u8 *mac_addr, u8 key_idx)
>>> +{
>>> +    struct ieee80211_local *local = sdata->local;
>>> +    struct ieee80211_key *key;
>>> +    struct sta_info *sta;
>>> +    int ret;
>>> +
>>> +    if (!wiphy_ext_feature_isset(local->hw.wiphy,
>>> +                     NL80211_EXT_FEATURE_EXT_KEY_ID))
>>> +        return -EINVAL;
>>
>> You set this, wouldn't it make more sense to check EXT_KEY_ID_NATIVE?
>>
>> Or maybe this is because of the next patch?
> 
> Exactly. Assuming we merge NATIVE and drop COMPAT that would move down 
> to the driver.

My first answer for that on makes no sense, so let me try again:

Exactly. With COMPAT we would have to check for EXT_KEY_ID_NATIVE and 
EXT_KEY_ID_COMPAT. Since we have already done that and set 
NL80211_EXT_FEATURE_EXT_KEY_ID I check that here.
Assuming we merge NATIVE and drop COMPAT it may make sense to keep the 
check here and drop EXT_KEY_ID_NATIVE altogether.
The drivers than can set NL80211_EXT_FEATURE_EXT_KEY_ID directly.

> 
>>
>>> +    sta = sta_info_get_bss(sdata, mac_addr);
>>> +
>>> +    if (!sta)
>>> +        return -EINVAL;
>>> +
>>> +    if (sta->ptk_idx == key_idx)
>>> +        return 0;
>>> +
>>> +    mutex_lock(&local->key_mtx);
>>> +    key = key_mtx_dereference(local, sta->ptk[key_idx]);
>>> +
>>> +    if (key && key->flags & KEY_FLAG_RX_ONLY)
>>
>> do you even need the flag? Isn't it equivalent to checking
>>     sta->ptk_idx != key->idx
>> or so?
>>
>> Less data to maintain would be better.
> 
> I have to look at that again. It will change some assumptions for sure 
> but still could work out with some slight differences. I'll have to look 
> deeper into that since I remember two moments where I was sure needing 
> the flag. That may well be outdated, but at a first glance it would at 
> least open the door to first install two key in legacy mode and then 
> switch between them. (Which should be no problem, of course)
> I'll follow up on that separately, but that may take some time. When it 
> works you'll get a new RFC.
> 
>>
>>> +    bool ext_native = ieee80211_hw_check(&local->hw, 
>>> EXT_KEY_ID_NATIVE);
>>
>> you sort of only need this in the next patch, but I guess it doesn't
>> matter that much
>>
> Ups, yes. Forgot that when I split it in two patches some weeks ago,
> 
>>> +int ieee80211_key_activate_tx(struct ieee80211_key *key)
>>> +{
>>> +    struct ieee80211_sub_if_data *sdata = key->sdata;
>>> +    struct sta_info *sta = key->sta;
>>> +    struct ieee80211_local *local = key->local;
>>> +    struct ieee80211_key *old;
>>> +    int ret;
>>> +
>>> +    assert_key_lock(local);
>>> +
>>> +    key->flags &= ~KEY_FLAG_RX_ONLY;
>>> +
>>> +    if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) ||
>>> +        key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
>>> +                   IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
>>> +                   IEEE80211_KEY_FLAG_RESERVE_TAILROOM))
>>> +        increment_tailroom_need_count(sdata);
>>> +
>>> +    if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
>>> +        ret = drv_set_key(local, EXT_KEY_RX_TX, sdata,
>>> +                  &sta->sta, &key->conf);
>>> +        if (ret) {
>>> +            sdata_err(sdata,
>>> +                  "failed to activate key for Tx (%d, %pM)\n",
>>> +                  key->conf.keyidx, sta->sta.addr);
>>> +            return ret;
>>
>> You've already cleared the RX_ONLY flag, which gets you inconsistent
>> data now.
>>
> 
> I don't think so, it looks ok for me. But the delay_tailroom logic took 
> a surprisingly large chunk of time and I should explain how the updated 
> logic is intended to work. Maybe I've messed it up somehow and just do 
> not see it:
> 
> I decided to handle that exact, no shortcuts. Only keys which can be 
> used for Tx will be counted for delay tailroom. So when installing a Rx 
> only key tailroom_needed will never be increased.
> Prior to enabling Tx with a key the code above drops the RX_ONLY flag 
> and then evaluates if we have to call increment_tailroom_need_count. The 
> key is then activated for Tx a few lines below, the old key is set to 
> RX_ONLY and - assuming the old key also increased the tailroom needed 
> counter - decrements it for the old key.
> (And I'm not sure if I should get that working without a dedicated key 
> flag, but let's wait and see how that would look like and then discuss it.)
> 
> The obvious simplification would be to just skip both steps and neither 
> increment nor decrement tailroom needed. Problem with that is, that the 
> HW offload decides during key install if the driver can support HW 
> offload or not. So it could be that e.g. the old key did use HW 
> encryption but the new will not. Handling that would further complicated 
> by the fact that a key install also could failand then would have to 
> clean up that again.
> So I just update tailroom_needed as soon as possible, allowing to abort 
> any time and not worry about all that.
> 
>>> +        }
>>> +    }
>>> +
>>> +    old = key_mtx_dereference(local, sta->ptk[sta->ptk_idx]);
>>> +    sta->ptk_idx = key->conf.keyidx;
>>
>> but you set this only here.
>>
>>> -        /* Stop TX till we are on the new key */
>>> +        /* Stop Tx till we are on the new key */
>>
>> Uh, I had to read that three times ... please don't make changes like
>> that? :)
> 
> Noted, will drop all of those changes.
> 
>>
>>>           old_key->flags |= KEY_FLAG_TAINTED;
>>>           ieee80211_clear_fast_xmit(sta);
>>> -        /* Aggregation sessions during rekey are complicated due to the
>>> +        /* Aggregation sessions during rekey are complicated by the
>>
>> similarly here, please don't make drive-by comment wording issues (also,
>> I'm not sure I agree - the old version just treats "complicated" as an
>> adjective, you treat it as a verb, but ultimately doesn't really matter?
>>
>>>   #define NUM_DEFAULT_KEYS 4
>>>   #define NUM_DEFAULT_MGMT_KEYS 2
>>> +#define INVALID_PTK_KEYIDX 2 /* Existing key slot never used by PTK 
>>> keys */
>>
>> We could also use something obviously wrong like 0xff?
> 
> No, not without some undesired modifications. We actually fetch the 
> referenced key and the key slot must exist and be NULL. We (mostly) 
> discussed that in the previous RFC, I just decided to use a define 
> instead the numeric value. (Mostly due the fact that A-MPDU also needs 
> an "invalid" ID and using the same looks like a good idea.
> 
> Here how we use this #define in sta_info.c
> 
> /* Extended Key ID can install keys for keyid 0 and 1 as Rx only.
>   * Tx starts uses a key as soon as a key is installed in the slot
>   * ptk_idx references to. To avoid using the initial Rx key prematurely
>   * for Tx we initialize ptk_idx to a value never used, making sure the
>   * referenced key is always NULL till ptk_idx is set to a valid value.
>   */
>   BUILD_BUG_ON(ARRAY_SIZE(sta->ptk) <= INVALID_PTK_KEYIDX);
>   sta->ptk_idx = INVALID_PTK_KEYIDX;
>   sta->ptk_idx_next = INVALID_PTK_KEYIDX;
> 
>>
>>> +++ b/net/mac80211/tx.c
>>> @@ -3000,23 +3000,15 @@ void ieee80211_check_fast_xmit(struct 
>>> sta_info *sta)
>>>           switch (build.key->conf.cipher) {
>>>           case WLAN_CIPHER_SUITE_CCMP:
>>>           case WLAN_CIPHER_SUITE_CCMP_256:
>>> -            /* add fixed key ID */
>>> -            if (gen_iv) {
>>> -                (build.hdr + build.hdr_len)[3] =
>>> -                    0x20 | (build.key->conf.keyidx << 6);
>>> +            if (gen_iv)
>>>                   build.pn_offs = build.hdr_len;
>>> -            }
>>>               if (gen_iv || iv_spc)
>>>                   build.hdr_len += IEEE80211_CCMP_HDR_LEN;
>>>               break;
>>>           case WLAN_CIPHER_SUITE_GCMP:
>>>           case WLAN_CIPHER_SUITE_GCMP_256:
>>> -            /* add fixed key ID */
>>> -            if (gen_iv) {
>>> -                (build.hdr + build.hdr_len)[3] =
>>> -                    0x20 | (build.key->conf.keyidx << 6);
>>> +            if (gen_iv)
>>>                   build.pn_offs = build.hdr_len;
>>> -            }
>>>               if (gen_iv || iv_spc)
>>>                   build.hdr_len += IEEE80211_GCMP_HDR_LEN;
>>>               break;
>>> @@ -3383,6 +3375,7 @@ static void ieee80211_xmit_fast_finish(struct 
>>> ieee80211_sub_if_data *sdata,
>>>               pn = atomic64_inc_return(&key->conf.tx_pn);
>>>               crypto_hdr[0] = pn;
>>>               crypto_hdr[1] = pn >> 8;
>>> +            crypto_hdr[3] = 0x20 | (key->conf.keyidx << 6);
>>>               crypto_hdr[4] = pn >> 16;
>>>               crypto_hdr[5] = pn >> 24;
>>>               crypto_hdr[6] = pn >> 32;
>>
>> This shouldn't be needed, you do update the fast TX cache when changing
>> the key?
> 
> That's only right for the push path but can send out wrong packets when 
> the driver is using the pull path:
> 
> 1) ieee80211_xmit_fast() will use fast_tx structure to fill in the 
> "cached" keyid and queue the packet. (let's say 0)
> 
> 2) ieee80211_check_fast_xmit is called due to a rekey (and keyid change 
> from 0 -> 1)
> 
> 3) ieee80211_tx_dequeue() will then dequeue the prepared skb from 1), 
> refresh the key information but keep keyid 0 in the skb and instruct the 
> driver to encrypt it for keyid 1 -> WRONG
> 
> 4) The remote sta tries to decrypt the packet using the key 0, as 
> referenced by the keyid. Which will of course not work.
> 
> With Extended Key ID (and some debugging) I added a simple rule: When 
> you assign the pn you also set the matching keyid.
> 
> Alexander
