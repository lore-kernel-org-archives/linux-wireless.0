Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbbHaNHt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 09:07:49 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<55E289A3.6030001@lwfinger.net> <wrfjegik8vqy.fsf@redhat.com>
Date: Sun, 30 Aug 2015 17:02:10 -0400
In-Reply-To: <wrfjegik8vqy.fsf@redhat.com> (Jes Sorensen's message of "Sun, 30
	Aug 2015 14:41:09 -0400")
Message-ID: <wrfjegik7anh.fsf@redhat.com> (sfid-20150831_150801_954321_4365C611)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>> +static void rtl8xxxu_tx(struct ieee80211_hw *hw,
>>> +			struct ieee80211_tx_control *control,
>>> +			struct sk_buff *skb)
>>> +{
>>> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>>> +	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
>>> +	struct ieee80211_rate *tx_rate = ieee80211_get_tx_rate(hw, tx_info);
>>> +	struct rtl8xxxu_priv *priv = hw->priv;
>>> +	struct rtl8xxxu_tx_desc *tx_desc;
>>> +	struct ieee80211_sta *sta = NULL;
>>> +	struct rtl8xxxu_sta_priv *sta_priv = NULL;
>>> +	struct device *dev = &priv->udev->dev;
>>> +	struct urb *urb;
>>> +	u32 queue, rate;
>>> +	u16 pktlen = skb->len;
>>> +	u16 seq_number;
>>> +	u16 rate_flag = tx_info->control.rates[0].flags;
>>> +	int ret;
>>> +
>>> +	if (skb_headroom(skb) < sizeof(struct rtl8xxxu_tx_desc)) {
>>> +		dev_warn(dev,
>>> +			 "%s: Not enough headroom (%i) for tx descriptor\n",
>>> +			 __func__, skb_headroom(skb));
>>> +		goto error;
>>> +	}
>>> +
>>> +	if (unlikely(skb->len > (65535 - sizeof(struct rtl8xxxu_tx_desc)))) {
>>> +		dev_warn(dev, "%s: Trying to send over-sized skb (%i)\n",
>>> +			 __func__, skb->len);
>>> +		goto error;
>>> +	}
>>> +
>>> +	urb = usb_alloc_urb(0, GFP_KERNEL);
>>
>> The above statement generated a "scheduling while atomic" splat. The
>> gfp_t argument needs to be GFP_KERNEL.
>
> You are seeing scheduling while atomic in the TX path? That just seems
> wrong to me - Johannes is the mac80211 TX path not meant to allow
> sleeping?

I went and checked include/net/mac80211.h and indeed you are right.
Updated patch fixing these issues, and hopefully mutex issue, coming you
way in a minute.

Cheers,
Jes
