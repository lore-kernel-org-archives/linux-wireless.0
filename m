Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:57092 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3FRJHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 05:07:19 -0400
Received: by mail-bk0-f47.google.com with SMTP id jg1so1620607bkc.20
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jun 2013 02:07:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj9864ioXkUy3Sg24k6vFTNR8ZfWj=to54J2VS=dvte+ExNA@mail.gmail.com>
References: <CAEFj9864ioXkUy3Sg24k6vFTNR8ZfWj=to54J2VS=dvte+ExNA@mail.gmail.com>
Date: Tue, 18 Jun 2013 17:07:17 +0800
Message-ID: <CAEFj987DCjNuv+W3oSq6ubHwjnkmKgKvcDThhP8s9ZXBsKmcjg@mail.gmail.com> (sfid-20130618_110734_636745_A9797FBC)
Subject: Re: [PATCH] mac80211: allow key deletion for mesh interface
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In sta_info_get_bss, should it be:

if ((sta->sdata == sdata &&
                     (sta->sdata->bss && sta->sdata->bss == sdata->bss))

in stead of

if ((sta->sdata == sdata ||
                     (sta->sdata->bss && sta->sdata->bss == sdata->bss))

Otherwise, it seems that we still manage to get sta pointer even the
bss is NULL.

---
Chun-Yeow

On Tue, Jun 18, 2013 at 4:14 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> In the ieee80211_free_sta_keys, the key idx 4 is not deleted, since it
> is limited by NUM_DEFAULT_KEYS.
>
> ----
> Chun-Yeow
>
> On Tue, Jun 18, 2013 at 3:56 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>> In authsae, we have a GTK with key index 4 as follow:
>> install_key(&nlcfg, peer, CIPHER_AES_CMAC, NL80211_KEYTYPE_GROUP, 4, peer_mgtk);
>>
>> We may need to delete this key while doing re-authentication for the
>> same peer mesh STA due to accidental reboot. Otherwise, this GTK key
>> is not deleted.
>>
>> ---
>> Chun-Yeow
>>
>> On Tue, Jun 18, 2013 at 3:31 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> On Tue, 2013-06-18 at 12:07 +0800, Chun-Yeow Yeoh wrote:
>>>> This is to support key deletion for mesh interface, especially
>>>> to be used for key which is not deleted even with the deletion
>>>> of peer mesh station.
>>>
>>> Can you explain which keys in mesh aren't deleted? It seems the
>>> per-station keys would be deleted when the station is deleted, and
>>> something like "GTK" would be deleted when leaving the mesh?
>>>
>>> johannes
>>>
