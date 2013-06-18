Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:37637 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3FRIOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 04:14:37 -0400
Received: by mail-bk0-f52.google.com with SMTP id d7so1582977bkh.39
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jun 2013 01:14:36 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 18 Jun 2013 16:14:36 +0800
Message-ID: <CAEFj9864ioXkUy3Sg24k6vFTNR8ZfWj=to54J2VS=dvte+ExNA@mail.gmail.com> (sfid-20130618_101505_421320_5FBA2416)
Subject: Re: [PATCH] mac80211: allow key deletion for mesh interface
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the ieee80211_free_sta_keys, the key idx 4 is not deleted, since it
is limited by NUM_DEFAULT_KEYS.

----
Chun-Yeow

On Tue, Jun 18, 2013 at 3:56 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> In authsae, we have a GTK with key index 4 as follow:
> install_key(&nlcfg, peer, CIPHER_AES_CMAC, NL80211_KEYTYPE_GROUP, 4, peer_mgtk);
>
> We may need to delete this key while doing re-authentication for the
> same peer mesh STA due to accidental reboot. Otherwise, this GTK key
> is not deleted.
>
> ---
> Chun-Yeow
>
> On Tue, Jun 18, 2013 at 3:31 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2013-06-18 at 12:07 +0800, Chun-Yeow Yeoh wrote:
>>> This is to support key deletion for mesh interface, especially
>>> to be used for key which is not deleted even with the deletion
>>> of peer mesh station.
>>
>> Can you explain which keys in mesh aren't deleted? It seems the
>> per-station keys would be deleted when the station is deleted, and
>> something like "GTK" would be deleted when leaving the mesh?
>>
>> johannes
>>
