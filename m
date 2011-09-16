Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46203 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1IPRCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 13:02:12 -0400
Received: by eya28 with SMTP id 28so932529eya.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 10:02:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316178229.4130.33.camel@jlt3.sipsolutions.net>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
 <1316082334-7664-6-git-send-email-arik@wizery.com> <1316178229.4130.33.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 16 Sep 2011 20:01:56 +0300
Message-ID: <CA+XVXfcCgr2bPD-sGR5x3G=aK8yzxxfUiaWzD6ksWUQdHo-yRQ@mail.gmail.com> (sfid-20110916_190220_538879_54553723)
Subject: Re: [RFC 5/5] mac80211: send data directly to TDLS peers
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 16, 2011 at 16:03, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:

>>       case NL80211_IFTYPE_STATION:
>> -             memcpy(hdr.addr1, sdata->u.mgd.bssid, ETH_ALEN);
>> -             if (sdata->u.mgd.use_4addr &&
>> -                 cpu_to_be16(ethertype) != sdata->control_port_protocol) {
>> -                     fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
>> +             if (local->hw.flags & IEEE80211_HW_SUPPORTS_TDLS) {
>> +                     rcu_read_lock();
>> +                     sta = sta_info_get(sdata, skb->data);
>> +                     tdls_link = (sta && sta->tdls_link_enabled);
>
> Why don't you test WLAN_STA_TDLS_PEER and add the station only when the
> session is set up?
>
> That would avoid the problem here when setting up the session.

Will do (like I wrote in a previous email). Thanks.

>
>> --- a/net/wireless/util.c
>> +++ b/net/wireless/util.c
>> @@ -392,8 +392,9 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
>>               }
>>               break;
>>       case cpu_to_le16(0):
>> -             if (iftype != NL80211_IFTYPE_ADHOC)
>> -                     return -1;
>> +             if (iftype != NL80211_IFTYPE_ADHOC &&
>> +                 iftype != NL80211_IFTYPE_STATION)
>> +                             return -1;
>>               break;
>>       }
>>
>
> It seems there needs to be a check somewhere that this packet was
> received from a TDLS peer? OTOH, if somebody is spoofing it crypto will
> reject it or you're vulnerable anyway...

My thoughts exactly. It's not like a rouge STA can't fake the
frame_control and bssid fields..
I didn't want to encumber the Rx path with redundant checks.

Arik
