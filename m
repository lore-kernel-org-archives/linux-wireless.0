Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56759 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454Ab2CBVrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:47:14 -0500
Received: by iagz16 with SMTP id z16so2839680iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2012 13:47:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330724598.9652.4.camel@jlt3.sipsolutions.net>
References: <1330722280-28879-1-git-send-email-javier@cozybit.com> <1330724598.9652.4.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 2 Mar 2012 13:46:53 -0800
Message-ID: <CAPjQAd8+dwYV3QjY-j5TSiV1neY_3ZS+fHQTrbEFYommqev51Q@mail.gmail.com> (sfid-20120302_224722_646886_E418092F)
Subject: Re: [PATCHv3 1/2] mac80211_hwsim: Add tsf to beacons, probe responses
 and radiotap header.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 2, 2012 at 1:43 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-03-02 at 13:04 -0800, Javier Cardona wrote:
>
>> @@ -667,6 +679,19 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>>       bool ack;
>>       struct ieee80211_tx_info *txi;
>>       u32 _pid;
>> +     struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>> +     struct mac80211_hwsim_data *data = hw->priv;
>> +     __le64 *tsfpos;
>> +     u16 fc = le16_to_cpu(hdr->frame_control);
>> +     u16 fctypes = fc & (IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE);
>> +
>> +     if (fctypes == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_RESP) ||
>> +         fctypes == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON)) {
>> +             struct ieee80211_hdr_3addr *hdr3 =
>> +                     (struct ieee80211_hdr_3addr *) skb->data;
>> +             tsfpos = (__le64 *) (hdr3 + 1);
>> +             put_unaligned(__mac80211_hwsim_get_tsf(data), tsfpos);
>> +     }
>
> And here, you can do the same with struct ieee80211_mgmt and don't even
> need the struct ieee80211_hdr * variable then.
>
> Also, you should use ieee80211_is_beacon() and ieee80211_is_probe_req().
>
> Sorry for the incoherent review!

No, thank you for your patience and help.  Working on v5 (how many
patch revisions can I make before somebody bans me from the list? :)

j
