Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53520 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1BOHnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 02:43:13 -0500
Received: by wwa36 with SMTP id 36so5779746wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 23:43:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19802.10321.400306.871734@gargle.gargle.HOWL>
References: <1297750589-15465-1-git-send-email-vnatarajan@atheros.com>
	<19802.10321.400306.871734@gargle.gargle.HOWL>
Date: Tue, 15 Feb 2011 13:13:11 +0530
Message-ID: <AANLkTimz-M91fbgKqhpx3nhx6QWuyRak21wN_qY71tv6@mail.gmail.com>
Subject: Re: [RFC v2 1/2] mac80211: Fix a race on enabling power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.net, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 12:46 PM, Sujith <m.sujith@gmail.com> wrote:
> Vivek Natarajan wrote:
>>  void ieee80211_dynamic_ps_timer(unsigned long data)
>> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
>> index 010a559..51caa0d 100644
>> --- a/net/mac80211/status.c
>> +++ b/net/mac80211/status.c
>> @@ -315,7 +315,10 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>>           (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
>>           !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
>>           local->ps_sdata && !(local->scanning)) {
>> -             if (info->flags & IEEE80211_TX_STAT_ACK) {
>> +             if ((info->flags & IEEE80211_TX_STAT_ACK) &&
>> +                (local->ps_sdata->u.mgd.flags & IEEE80211_STA_PS_PENDING)) {
>> +                     ieee80211_stop_queues_by_reason(&local->hw,
>> +                                                     IEEE80211_QUEUE_STOP_REASON_PS);
>
> I am not too familiar with the PS code, but why are the queues being stopped
> after the nullfunc frame has been sent out and acked ? And it is a bit unclear why
> the new flag IEEE80211_STA_PS_PENDING is required at all... Can't IEEE80211_STA_NULLFUNC_ACKED
> be used to fix this race ?

The new flag is required to prevent mac80211 to go into power save if
a frame is sent during the interval of sending nullfunc frame and
receiving ack for that. The queues are stopped to avoid sending any
frame between the interval of receiving ack and setting CONF_PS and it
mainly addresses the race that Johannes pointed out in the previous
version.
Please refer the previous thread too and the comments:
https://patchwork.kernel.org/patch/531711/

Vivek.
