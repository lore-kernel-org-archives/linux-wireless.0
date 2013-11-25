Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:55202 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3KYKPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 05:15:49 -0500
Received: by mail-ob0-f175.google.com with SMTP id uz6so3939802obc.20
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 02:15:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385318128.23961.0.camel@jlt4.sipsolutions.net>
References: <1385312211-3119-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1385312211-3119-2-git-send-email-lorenzo.bianconi83@gmail.com>
	<1385318128.23961.0.camel@jlt4.sipsolutions.net>
Date: Mon, 25 Nov 2013 11:15:48 +0100
Message-ID: <CAA2SeNJYAs4XGiQCnWkpekMtOEc5h4y41he3vQpxNxZiJ9ygCg@mail.gmail.com> (sfid-20131125_111552_588012_22F5E05C)
Subject: Re: [PATCH 1/3] mac80211: implement ieee80211_get_vif_by_addr
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>, sujith@msujith.org,
	rmanohar@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Sun, 2013-11-24 at 17:56 +0100, Lorenzo Bianconi wrote:
>> ieee80211_get_vif_by_addr allows low level drivers to get a reference to
>> vif data structure which is not added to the driver as monitor interface.
>> ieee80211_get_vif_by_addr will be used in ath9k tx99 code
>
> Is that really better than having the driver use the iteration
> functions?

first two patches are not really necessary since I was using an old
version of iw which does not allow to set monitor interface in active
mode

>
>> + */
>> +struct ieee80211_vif *ieee80211_get_vif_by_addr(struct ieee80211_hw *hw,
>> +                                             const u8 *mac)
>> +{
>> +     struct ieee80211_vif *vif = NULL;
>> +     struct ieee80211_local *local = hw_to_local(hw);
>> +     struct ieee80211_sub_if_data *sdata;
>> +
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(sdata, &local->interfaces, list) {
>> +             if (!compare_ether_addr(sdata->vif.addr, mac)) {
>> +                     vif = &sdata->vif;
>> +                     break;
>> +             }
>> +     }
>> +     rcu_read_unlock();
>> +
>> +     return vif;
>
> In any case, this is completely broken wrt. locking, so I'm not taking
> it.
>

sorry, I was wrong

> johannes
>



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
